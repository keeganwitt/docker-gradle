$gradleVersion = $((Invoke-WebRequest https://services.gradle.org/versions/current | ConvertFrom-Json).version)
$sha = $(Invoke-RestMethod -Uri https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256)

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GRADLE_VERSION .+", "ENV GRADLE_VERSION ${gradleVersion}" | Set-Content $_.FullName
    (Get-Content -Path $_.FullName) -replace "GRADLE_DOWNLOAD_SHA256=.+$", "GRADLE_DOWNLOAD_SHA256=${sha}" | Set-Content $_.FullName
}
(Get-Content -Path .travis.yml) -replace "run.sh `"\$\{image\}`" `".+`"", "run.sh `"`${image}`" `"${gradleVersion}`"" | Set-Content .travis.yml
