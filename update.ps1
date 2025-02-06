$gradleVersion = $((Invoke-WebRequest "https://services.gradle.org/versions/current" | ConvertFrom-Json).version)
$sha = $(Invoke-RestMethod -Uri "https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256")

$wc = [System.Net.WebClient]::new()
$graal17Version = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-17" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$graal17amd64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-x64_bin.tar.gz"))).Hash.ToLower()
$graal17aarch64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-aarch64_bin.tar.gz"))).Hash.ToLower()

$graal21Version = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-21" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$graal21amd64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-x64_bin.tar.gz"))).Hash.ToLower()
$graal21aarch64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-aarch64_bin.tar.gz"))).Hash.ToLower()

$graal23Version = $(((Invoke-WebRequest "https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1" | ConvertFrom-Json).tag_name | Select-String -Pattern "jdk-23" | Select-Object -First 1).ToString().Replace("jdk-", ""))
$graal23amd64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal23Version}/graalvm-community-jdk-${graal23Version}_linux-x64_bin.tar.gz"))).Hash.ToLower()
$graal23aarch64Hash = (Get-FileHash -Algorithm SHA256 -InputStream ($wc.OpenRead("https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal23Version}/graalvm-community-jdk-${graal23Version}_linux-aarch64_bin.tar.gz"))).Hash.ToLower()

Write-Host "Latest Gradle version is $gradleVersion"
Write-Host "Latest Graal 17 version is $graal17Version"
Write-Host "Latest Graal 21 version is $graal21Version"
Write-Host "Latest Graal 23 version is $graal23Version"

Write-Host "Graal 17 AMD64 hash is $graal17amd64Hash"
Write-Host "Graal 17 AARCH64 hash is $graal17aarch64Hash"
Write-Host "Graal 21 AMD64 hash is $graal21amd64Hash"
Write-Host "Graal 21 AARCH64 hash is $graal21aarch64Hash"
Write-Host "Graal 23 AMD64 hash is $graal23amd64Hash"
Write-Host "Graal 23 AARCH64 hash is $graal23aarch64Hash"

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GRADLE_VERSION=.+$", "ENV GRADLE_VERSION=${gradleVersion}" | Set-Content $_.FullName
    (Get-Content -Path $_.FullName) -replace "GRADLE_DOWNLOAD_SHA256=.+$", "GRADLE_DOWNLOAD_SHA256=${sha}" | Set-Content $_.FullName
    if ($((Get-Item $_.FullName).Directory.Name) -eq "jdk17-noble-graal" -Or $((Get-Item $_.FullName).Directory.Name) -eq "jdk17-jammy-graal" -Or $((Get-Item $_.FullName).Directory.Name) -eq "jdk17-focal-graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${graal17Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AMD64_DOWNLOAD_SHA256=${graal17amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal17aarch64Hash}" | Set-Content $_.FullName
    }
    elseif ($((Get-Item $_.FullName).Directory.Name) -eq "jdk21-noble-graal" -Or $((Get-Item $_.FullName).Directory.Name) -eq "jdk21-jammy-graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${graal21Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AMD64_DOWNLOAD_SHA256=${graal21amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal21aarch64Hash}" | Set-Content $_.FullName
    }
    elseif ($((Get-Item $_.FullName).Directory.Name) -eq "jdk23-noble-graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_VERSION=[^ ]+", "JAVA_VERSION=${graal23Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AMD64_DOWNLOAD_SHA256=${graal23amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal23aarch64Hash}" | Set-Content $_.FullName
    }
    elseif ($((Get-Item $_.FullName).Directory.Name) -eq "jdk-lts-and-current-graal")
    {
        (Get-Content -Path $_.FullName) -replace "JAVA_21_VERSION=[^ ]+", "JAVA_21_VERSION=${graal21Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_21_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_21_AMD64_DOWNLOAD_SHA256=${graal21amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_21_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_21_AARCH64_DOWNLOAD_SHA256=${graal21aarch64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "JAVA_23_VERSION=[^ ]+", "JAVA_23_VERSION=${graal23Version}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_23_AMD64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_23_AMD64_DOWNLOAD_SHA256=${graal23amd64Hash}" | Set-Content $_.FullName
        (Get-Content -Path $_.FullName) -replace "GRAALVM_23_AARCH64_DOWNLOAD_SHA256=[^ ]+", "GRAALVM_23_AARCH64_DOWNLOAD_SHA256=${graal23aarch64Hash}" | Set-Content $_.FullName
    }
}

(Get-Content -Path .github/workflows/ci.yaml) -replace "expectedGradleVersion: .+", "expectedGradleVersion: `"${gradleVersion}`"" | Set-Content .github/workflows/ci.yaml
