
plugins {
    `java-library` // <1>
}

repositories {
    mavenCentral() // <2>
}

dependencies {
    testImplementation("junit:junit:4.13.1") // <3>

    api("org.apache.commons:commons-math3:3.6.1") // <4>

    implementation("com.google.guava:guava:30.0-jre") // <5>
}
