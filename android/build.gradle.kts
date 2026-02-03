allprojects {
    repositories {
        google()
        mavenCentral()
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

// Defer evaluation to avoid NDK license errors during configuration phase
afterEvaluate {
    // subprojects evaluation happens after all projects are configured
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
