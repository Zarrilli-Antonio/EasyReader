import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// receive_sharing_intent chiede compileSdk 37 (intero) nel proprio
// build.gradle, ma su questa toolchain è installata solo la variante
// "37.0" (Android 17 usa livelli API frazionari): AGP non trova un target
// "android-37" esatto e la build fallisce. Lo si forza qui su un SDK già
// presente e sufficiente per un plugin di questo tipo — da rimuovere
// quando il plugin aggiornerà la propria configurazione.
subprojects {
    if (project.name == "receive_sharing_intent") {
        afterEvaluate {
            extensions.findByType(BaseExtension::class.java)?.compileSdkVersion(36)
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
