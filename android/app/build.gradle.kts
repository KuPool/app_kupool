plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kupool.nexus"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kupool.nexus"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        maybeCreate("debug").apply {
            storeFile = file(findProperty("MYAPP_RELEASE_STORE_FILE") ?: "./kupool.jks")
            storePassword = findProperty("MYAPP_RELEASE_STORE_PASSWORD") as? String ?: "kupool"
            keyAlias = findProperty("MYAPP_RELEASE_KEY_ALIAS") as? String ?: "kupool"
            keyPassword = findProperty("MYAPP_RELEASE_KEY_PASSWORD") as? String ?: "kupool"
        }
        maybeCreate("release").apply {
            storeFile = file(findProperty("MYAPP_RELEASE_STORE_FILE") ?: "./kupool.jks")
            storePassword = findProperty("MYAPP_RELEASE_STORE_PASSWORD") as? String ?: "kupool"
            keyAlias = findProperty("MYAPP_RELEASE_KEY_ALIAS") as? String ?: "kupool"
            keyPassword = findProperty("MYAPP_RELEASE_KEY_PASSWORD") as? String ?: "kupool"
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
