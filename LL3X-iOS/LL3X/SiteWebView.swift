import Combine
import SwiftUI
import UIKit
import WebKit

enum LL3XSite {
    static let homeURL = URL(string: "https://ll3x.com/")!

    static func contains(host: String?) -> Bool {
        guard let host = host?.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ".")), !host.isEmpty else {
            return false
        }
        return host == "ll3x.com" || host.hasSuffix(".ll3x.com")
    }
}

final class SiteWebViewModel: ObservableObject {
    @Published private(set) var canGoBack = false
    @Published private(set) var canGoForward = false
    @Published private(set) var isLoading = true

    weak var webView: WKWebView?

    func update(from webView: WKWebView) {
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
        isLoading = webView.isLoading
    }

    func goHome() {
        webView?.load(URLRequest(url: LL3XSite.homeURL))
    }
}

struct SiteWebView: UIViewRepresentable {
    let model: SiteWebViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(model: model)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = true
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        model.webView = webView
        webView.load(URLRequest(url: LL3XSite.homeURL))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        model.webView = uiView
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        private let model: SiteWebViewModel

        init(model: SiteWebViewModel) {
            self.model = model
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let targetFrame = navigationAction.targetFrame, !targetFrame.isMainFrame {
                decisionHandler(.allow)
                return
            }

            guard let url = navigationAction.request.url,
                  let scheme = url.scheme?.lowercased() else {
                decisionHandler(.cancel)
                return
            }

            if scheme == "http" || scheme == "https" {
                guard LL3XSite.contains(host: url.host) else {
                    decisionHandler(.cancel)
                    openOutsideApp(url)
                    return
                }

                if navigationAction.targetFrame == nil {
                    decisionHandler(.cancel)
                    webView.load(URLRequest(url: url))
                    return
                }

                decisionHandler(.allow)
                return
            }

            if ["about", "blob", "data", "javascript"].contains(scheme) {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
                openOutsideApp(url)
            }
        }

        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            guard let url = navigationAction.request.url else { return nil }
            if LL3XSite.contains(host: url.host) {
                webView.load(URLRequest(url: url))
            } else {
                openOutsideApp(url)
            }
            return nil
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            model.update(from: webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            model.update(from: webView)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            model.update(from: webView)
        }

        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            model.update(from: webView)
        }

        private func openOutsideApp(_ url: URL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
