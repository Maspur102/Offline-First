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

// --- SUNTIKAN KODE PENYELAMAT UNTUK ISAR (NAMESPACE FIX) ---
// WAJIB diletakkan di SINI, SEBELUM project.evaluationDependsOn(":app")
subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                // Menggunakan reflection untuk membaca & menulis namespace secara aman
                val getNamespaceMethod = androidExt.javaClass.getMethod("getNamespace")
                val currentNamespace = getNamespaceMethod.invoke(androidExt)
                if (currentNamespace == null) {
                    val setNamespaceMethod = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespaceMethod.invoke(androidExt, project.group.toString())
                }
            } catch (e: Exception) {
                // Abaikan dengan aman jika package tersebut tidak relevan
            }
        }
    }
}

// Baris yang menutup evaluasi proyek (Suntikan kita harus di atas ini)
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
