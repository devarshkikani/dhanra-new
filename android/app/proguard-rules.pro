# Flutter Wrapper ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Deferred Components / Play Core ProGuard warnings suppression
-dontwarn com.google.android.play.core.**

# Firebase ProGuard rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Facebook SDK
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**

# Telephony SMS Receiver
-keep class com.shounakmulay.telephony.** { *; }
