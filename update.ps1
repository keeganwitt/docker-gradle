$gradleVersion = $((Invoke-WebRequest "https://services.gradle.org/versions/current" | ConvertFrom-Json).version)
$sha = $(Invoke-RestMethod -Uri "https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256")

$wc = [System.Net.WebClient]::new()
$graal17Version = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-17" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$graal17amd64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-x64_bin.tar.gz"))).Hash.ToLower()
$graal17aarch64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-aarch64_bin.tar.gz"))).Hash.ToLower()
#
$graal21Version = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-21" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$graal21amd64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-x64_bin.tar.gz"))).Hash.ToLower()
$graal21aarch64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-aarch64_bin.tar.gz"))).Hash.ToLower()

$graal22Version = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-22" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$graal22amd64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal22Version}/graalvm-community-jdk-${graal22Version}_linux-x64_bin.tar.gz"))).Hash.ToLower()
$graal22aarch64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal22Version}/graalvm-community-jdk-${graal22Version}_linux-aarch64_bin.tar.gz"))).Hash.ToLower()

Write-Host "Latest Gradle version is $gradleVersion"
Write-Host "Latest Graal 17 version is $graal17Version"
Write-Host "Latest Graal 21 version is $graal21Version"
Write-Host "Latest Graal 22 version is $graal22Version"

Write-Host "Graal 17 AMD64 hash is $graal17amd64Hash"
Write-Host "Graal 17 AARCH64 hash is $graal17aarch64Hash"
Write-Host "Graal 21 AMD64 hash is $graal21amd64Hash"
Write-Host "Graal 21 AARCH64 hash is $graal21aarch64Hash"
Write-Host "Graal 22 AMD64 hash is $graal22amd64Hash"
Write-Host "Graal 22 AARCH64 hash is $graal22aarch64Hash"

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GRADLE_VERSION .+$", "ENV GRADLE_VERSION ${gradleVersion}" | Set-Content $_.FullName
    (Get-Content -Path $_.FullName) -replace "GRADLE_DOWNLOAD_SHA256=.+$", "GRADLE_DOWNLOAD_SHA256=${sha}" | Set-Content $_.FullName
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk17.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${graal17Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AMD64_DOWNLOAD_SHA256=${graal17amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal17aarch64Hash}" | Set-Content $_.FullName
    }
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk21.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${graal21Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AMD64_DOWNLOAD_SHA256=${graal21amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal21aarch64Hash}" | Set-Content $_.FullName
    }
    if ($((Get-Item $_.FullName).Directory.Name) -match "jdk22.+graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${graal22Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AMD64_DOWNLOAD_SHA256=${graal22amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal22aarch64Hash}" | Set-Content $_.FullName
    }
}

(Get-Content -Path .github/workflows/ci.yaml) -replace "expectedGradleVersion: .+", "expectedGradleVersion: `"${gradleVersion}`"" | Set-Content .github/workflows/ci.yaml
