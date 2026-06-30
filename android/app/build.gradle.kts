import java.util.Properties
import java.io.FileInputStream
import java.util.Base64 

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { stream ->
        localProperties.load(stream)
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.0"

val dartEnvironmentVariables = mutableMapOf<String, String>()
if (project.hasProperty("dart-defines")) {
    val dartDefines = project.property("dart-defines") as String
    dartDefines.split(",").forEach {
        try {
            val decoded = String(Base64.getDecoder().decode(it))
            val parts = decoded.split("=")
            if (parts.size == 2) {
                dartEnvironmentVariables[parts[0]] = parts[1]
            }
        } catch (e: Exception) {}
    }
}

val envName = dartEnvironmentVariables["ENV_NAME"] ?: "DEV"
// NAMA APLIKASI SAAT DIINSTAL 
val appLauncherName = if (envName == "PROD") "UTD - 20123011" else "DEV - Purnama"
val appIdSuffix = if (envName == "PROD") "" else ".dev" 

android {
    namespace = "com.example.offline_first"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.offline_first$appIdSuffix"
        minSdk = 21 
        targetSdk = 34
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        
        resValue("string", "app_name", appLauncherName)
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}