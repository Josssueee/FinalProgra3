plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.finalprogra"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // ¡Corregido! Ahora la sintaxis es correcta

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8" // ¡Corregido! Usa comillas dobles para el string '1.8'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.finalprogra"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug { // ¡Agregado el bloque debug!
            signingConfig = signingConfigs.getByName("debug")
            coreLibraryDesugaringEnabled = true // ¡Agregado para el desugaring!
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            coreLibraryDesugaringEnabled = true // ¡Agregado para el desugaring!
        }
    }
}

flutter {
    source = "../.."
}

dependencies { // ¡Agregado el bloque de dependencias!
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4") // Dependencia para desugaring
}