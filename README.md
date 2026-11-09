# تطبيق LL3X لنظام iOS

مشروع SwiftUI يعرض `https://ll3x.com/` داخل `WKWebView`، مع أزرار للصفحة الرئيسية والرجوع والتقدّم والتحديث. تبقى روابط `ll3x.com` ونطاقاته الفرعية داخل التطبيق، وتُفتح الروابط الخارجية في المتصفح الافتراضي. يتطلب التطبيق اتصالًا بالإنترنت.

## البناء المجاني

يعمل `Build iOS app` على `macos-latest` عند كل push أو pull request، ويمكن تشغيله يدويًا من تبويب **Actions**. من دون أسرار توقيع، ينتج أثرًا يحتوي `.app` غير موقّع للتحقق من نجاح البناء؛ هذا الملف ليس IPA قابلًا للتثبيت على iPhone.

## إخراج IPA موقّع

لإنتاج IPA، أضف أسرار التوقيع إلى **Settings → Secrets and variables → Actions** في المستودع، ثم شغّل **Actions → Build iOS app → Run workflow**:

- `IOS_P12_BASE64`: شهادة Apple بصيغة `.p12` مرمّزة Base64.
- `IOS_P12_PASSWORD`: كلمة مرور ملف `.p12`.
- `IOS_PROVISIONING_PROFILE_BASE64`: ملف provisioning profile المتوافق مع التطبيق.
- `IOS_TEAM_ID`: معرّف فريق Apple Developer.

اختر طريقة التصدير المطابقة لملف التزويد: `development` لجهاز تطوير مسجل، أو `ad-hoc` لأجهزة اختبار مسجلة، أو `app-store-connect` لـTestFlight/App Store Connect. عند نجاح التوقيع والتصدير، يظهر ملف `.ipa` ضمن **Artifacts** في تنفيذ workflow. لا ترفع الشهادة أو ملف التزويد أو كلمات المرور إلى Git؛ تحفظ الأسرار في إعدادات GitHub فقط.

معرّف الحزمة الحالي `com.ll3x.portal`. يجب أن يكون متاحًا ضمن فريق Apple Developer وأن يطابق معرّف التطبيق في ملف التزويد. إذا لم يكن متاحًا، غيّره في Xcode وأنشئ ملف تزويد مطابقًا. لا يتضمن المشروع رفع التطبيق إلى App Store أو شراء خدمة.

## البناء محليًا على Mac

افتح `LL3X-iOS/LL3X.xcodeproj` في Xcode، واختر فريق Apple ضمن **Signing & Capabilities**، ثم اختر **Any iOS Device (arm64)** واستخدم **Product → Archive** لإخراج IPA عبر Organizer.
