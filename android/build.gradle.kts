allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// --- SUNTIKAN KODE PENYELAMAT SUPER (NAMESPACE & LSTAR FIX) ---
subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            
            // 1. Penyelamat Namespace Isar (Mencegah Error Pertama)
            try {
                val getNamespaceMethod = androidExt.javaClass.getMethod("getNamespace")
                val currentNamespace = getNamespaceMethod.invoke(androidExt)
                if (currentNamespace == null) {
                    val setNamespaceMethod = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespaceMethod.invoke(androidExt, project.group.toString())
                }
            } catch (e: Exception) { }

            // 2. Penyelamat lStar (Mencegah Error Kedua: Memaksa semua package ke SDK 34)
            try {
                val setCompileSdkMethod = androidExt.javaClass.getMethod("setCompileSdk", Int::class.java)
                setCompileSdkMethod.invoke(androidExt, 34)
            } catch (e: Exception) {
                try {
                    val compileSdkVersionMethod = androidExt.javaClass.getMethod("compileSdkVersion", Int::class.java)
                    compileSdkVersionMethod.invoke(androidExt, 34)
                } catch (e2: Exception) { }
            }
            
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
