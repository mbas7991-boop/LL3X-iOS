import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var model = SiteWebViewModel()

    var body: some View {
        VStack(spacing: 0) {
            SiteWebView(model: model)

            Group {
                if model.isLoading {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .tint(Color(red: 0.16, green: 0.55, blue: 0.96))
                } else {
                    Color.clear
                }
            }
            .frame(height: 2)

            HStack(spacing: 0) {
                ToolbarAction(symbol: "house.fill", title: "الرئيسية") {
                    model.goHome()
                }
                Spacer(minLength: 0)
                ToolbarAction(symbol: "chevron.backward", title: "رجوع", isEnabled: model.canGoBack) {
                    model.webView?.goBack()
                }
                Spacer(minLength: 0)
                ToolbarAction(symbol: "chevron.forward", title: "تقدّم", isEnabled: model.canGoForward) {
                    model.webView?.goForward()
                }
                Spacer(minLength: 0)
                ToolbarAction(symbol: "arrow.clockwise", title: "تحديث") {
                    model.webView?.reload()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(.regularMaterial)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

private struct ToolbarAction: View {
    let symbol: String
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(isEnabled ? Color.accentColor : Color.secondary.opacity(0.4))
        .disabled(!isEnabled)
        .accessibilityLabel(title)
    }
}
