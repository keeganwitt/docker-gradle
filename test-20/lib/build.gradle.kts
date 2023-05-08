
plugins {
    `java-library`
    id("org.jetbrains.kotlin.jvm") version "1.8.20"
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.7.2")

    api("org.apache.commons:commons-math3:3.6.1")

    implementation("com.google.guava:guava:30.1.1-jre")
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(20))
    }
}

kotlin {
    jvmToolchain {
        languageVersion.set(JavaLanguageVersion.of(20))
    }
}

tasks.named<Test>("test") {
    useJUnitPlatform()
}
