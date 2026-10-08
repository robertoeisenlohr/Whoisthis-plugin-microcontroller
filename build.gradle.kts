plugins {
    id("com.android.application") version "9.1.0" apply false
    // Same toolchain as whoisthis-plugin-xg-glasses so the two plugins build identically in CI.
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
}
