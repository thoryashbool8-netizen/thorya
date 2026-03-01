import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// قراءة key.properties إذا موجود (للتوقيع)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystoreProps = keystorePropertiesFile.exists()
if (hasKeystoreProps) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.tourism_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.tourism_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // تفعيل توقيع release (إذا key.properties موجود)
    signingConfigs {
        if (hasKeystoreProps) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // لو عندك توقيع release استخدمه
            if (hasKeystoreProps) {
                signingConfig = signingConfigs.getByName("release")
            }

            // تحسينات بناء (ممكن تخليهم false إذا بدك أقل تعقيد)
            isMinifyEnabled = false
            isShrinkResources = false
        }

        debug {
            // الافتراضي
        }
    }
}

flutter {
    source = "../.."
}