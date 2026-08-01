import java.io.FileInputStream
import java.util.Properties

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
keystoreProperties.load(FileInputStream(keystorePropertiesFile))

plugins {
  id("com.android.application")
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "com.carapacik.wordly"
  compileSdk = 37
  ndkVersion = "29.0.14206865"

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
  }

  defaultConfig {
    applicationId = "com.carapacik.wordly"
    minSdk = 28
    targetSdk = 37
    versionCode = flutter.versionCode
    versionName = flutter.versionName
  }

  signingConfigs {
    create("release") {
      keyAlias = keystoreProperties["keyAlias"] as String
      keyPassword = keystoreProperties["keyPassword"] as String
      storeFile = file(keystoreProperties["storeFile"] as String)
      storePassword = keystoreProperties["storePassword"] as String
    }
  }

  buildTypes {
    release {
      signingConfig = signingConfigs.getByName("release")
    }
  }
}

kotlin {
  compilerOptions {
    jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21
  }
}

flutter {
  source = "../.."
}
