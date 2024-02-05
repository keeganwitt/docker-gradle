$gradleVersion = '7.6.3'
$sha = $(Invoke-RestMethod -Uri https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256)

$latestGraal17 = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-17").ToString().Replace("jdk-", ""))
$latestGraal20 = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-20").ToString().Replace("jdk-", ""))

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GRADLE_VERSION .+$", "ENV GRADLE_VERSION ${gradleVersion}" | Set-Content $_.FullName
    (Get-Content -Path $_.FullName) -replace "GRADLE_DOWNLOAD_SHA256=.+$", "GRADLE_DOWNLOAD_SHA256=${sha}" | Set-Content $_.FullName
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk17.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JDK_VERSION=[^ ]+", "JDK_VERSION=${latestGraal17}" | Set-Content $_.FullName
    }
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk20.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JDK_VERSION=[^ ]+", "JDK_VERSION=${latestGraal20}" | Set-Content $_.FullName
    }
}

(Get-Content -Path .github/workflows/ci.yaml) -replace "expectedGradleVersion: .+", "expectedGradleVersion: `"${gradleVersion}`"" | Set-Content .github/workflows/ci.yaml
