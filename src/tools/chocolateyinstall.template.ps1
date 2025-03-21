$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    PackageName    = 'kubernetes-helmfile'
    Url            = 'https://github.com/helmfile/helmfile/releases/download/v%%VERSION%%/helmfile_%%VERSION%%_windows_386.tar.gz'
    Checksum       = '%%CHECKSUM%%'
    ChecksumType   = 'sha256'
    Url64bit       = 'https://github.com/helmfile/helmfile/releases/download/v%%VERSION%%/helmfile_%%VERSION%%_windows_amd64.tar.gz'
    Checksum64     = '%%CHECKSUM64%%'
    ChecksumType64 = 'sha256'
    UnzipLocation = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
$tarFile = Get-ChildItem -File -Path $toolsDir -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $tarFile.FullName -destination $toolsDir
Remove-Item $tarFile.FullName
