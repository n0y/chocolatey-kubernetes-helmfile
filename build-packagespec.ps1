$Props = convertfrom-stringdata (get-content versions.properties | Select-String -pattern "^#" -NotMatch)
$HelmfileVersion = $Props.UPSTREAM_VERSION
"Building Upstream Version: $HelmfileVersion"
""

$ChecksumResponse = (Invoke-WebRequest -Uri "https://github.com/helmfile/helmfile/releases/download/v$HelmfileVersion/helmfile_${HelmfileVersion}_checksums.txt").tostring()
$Checksum = (($ChecksumResponse -split "[`r`n]" | Select-String "helmfile_${HelmfileVersion}_windows_386.tar.gz" | select -First 1) -split " ")[0].ToUpper()
$Checksum64 = (($ChecksumResponse -split "[`r`n]" | Select-String "helmfile_${HelmfileVersion}_windows_amd64.tar.gz" | select -First 1) -split " ")[0].ToUpper()

"Checksums:"
"  386: $Checksum"
"  x64: $Checksum64"

if (Test-Path -LiteralPath .\target) {
    Remove-Item -LiteralPath .\target -Recurse
}
New-Item -ItemType Directory -Force -Path .\target\tools | Out-Null

(Get-Content .\src\tools\chocolateyinstall.template.ps1) `
    -replace '%%VERSION%%', $HelmfileVersion `
    -replace '%%CHECKSUM%%', $Checksum `
    -replace '%%CHECKSUM64%%', $Checksum64 |
        Out-File -Encoding utf8 ".\target\tools\chocolateyinstall.ps1"
(Get-Content .\src\kubernetes-helmfile.template.nuspec) -replace '%%VERSION%%', $HelmfileVersion | Out-File -Encoding utf8 ".\target\kubernetes-helmfile.nuspec"

