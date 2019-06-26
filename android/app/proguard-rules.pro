#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Kotlin
-keep class kotlin.Metadata { *; }
-dontnote kotlin.internal.PlatformImplementationsKt
-dontnote kotlin.reflect.jvm.internal.**