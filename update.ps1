$gradleVersion = $((Invoke-WebRequest "https://services.gradle.org/versions/current" | ConvertFrom-Json).version)
$sha = $(Invoke-RestMethod -Uri "https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256")

$latestGraal17 = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-17" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$latestGraal21 = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-21" | Select-Object -First 1).ToString().Replace("jdk-", ""))

Write-Host "Latest Gradle version is $gradleVersion"
Write-Host "Latest Graal 17 version is $latestGraal17"
Write-Host "Latest Graal 21 version is $latestGraal21"

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GRADLE_VERSION .+$", "ENV GRADLE_VERSION ${gradleVersion}" | Set-Content $_.FullName
    (Get-Content -Path $_.FullName) -replace "GRADLE_DOWNLOAD_SHA256=.+$", "GRADLE_DOWNLOAD_SHA256=${sha}" | Set-Content $_.FullName
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk17.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${latestGraal17}" | Set-Content $_.FullName
    }
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk21.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${latestGraal21}" | Set-Content $_.FullName
    }
}

(Get-Content -Path .github/workflows/ci.yaml) -replace "expectedGradleVersion: .+", "expectedGradleVersion: `"${gradleVersion}`"" | Set-Content .github/workflows/ci.yaml
