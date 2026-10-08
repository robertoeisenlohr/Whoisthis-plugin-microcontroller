pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        // WhoIsThis capture contract (online.whoisthis:capture-contract).
        maven { url = uri("https://whoisthis.online/maven") }
        mavenLocal { content { includeGroup("online.whoisthis") } }
    }
}
rootProject.name = "whoisthis-plugin-microcontroller"
include(":app")
