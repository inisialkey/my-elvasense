import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) {
        file.reader(Charsets.UTF_8).use { load(it) }
    }
}
val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.kalbe.myelvasense"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDir("src/main/kotlin")
        }
    }

    lint {
        disable += "InvalidPackage"
    }

    defaultConfig {
        applicationId = "com.kalbe.myelvasense"
        minSdk = 25
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    signingConfigs {
        getByName("debug") {
            // opsional: biarkan kosong, atau setel jika memang ingin override
            // storeFile = file("debug.keystore")
            // storePassword = "android"
            // keyAlias = "androiddebugkey"
            // keyPassword = "android"
        }
        create("release") {
            storeFile = file(System.getenv("MYAPP_RELEASE_STORE_FILE") ?: "debug.keystore")
            storePassword = System.getenv("MYAPP_RELEASE_STORE_PASSWORD") ?: "android"
            keyAlias = System.getenv("MYAPP_RELEASE_KEY_ALIAS") ?: "androiddebugkey"
            keyPassword = System.getenv("MYAPP_RELEASE_KEY_PASSWORD") ?: "android"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += "env"
    productFlavors {
        create("stg") {
            dimension = "env"
            applicationIdSuffix = ".stg"
            resValue("string", "app_name", "My Elvasense STG")
            signingConfig = signingConfigs.getByName("release")
        }
        create("prd") {
            dimension = "env"
            resValue("string", "app_name", "My Elvasense")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.0")
    implementation(enforcedPlatform("com.google.firebase:firebase-bom:33.5.1"))
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.google.firebase:firebase-analytics-ktx")
}
