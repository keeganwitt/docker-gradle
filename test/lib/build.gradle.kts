
plugins {
    `java-library` // <1>
}

repositories {
    mavenCentral() // <2>
}

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.7.2") // <3>

    api("org.apache.commons:commons-math3:3.6.1") // <4>

    implementation("com.google.guava:guava:30.1.1-jre") // <5>
}

tasks.named<Test>("test") {
    useJUnitPlatform() // <6>
}
