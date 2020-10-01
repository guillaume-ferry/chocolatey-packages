$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.jetbrains.com/python/pycharm-edu-2020.2.2.exe' 
$checksum     = '914389489a677e32cbd1b7210cc0fe5bf2ddc14e3743fc4534139e8fdd265ad5'
$checksumType = 'sha256'

# Workaround for https://youtrack.jetbrains.com/issue/IDEA-202935
$programfiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
New-Item -ItemType Directory -Force -Path $programfiles\JetBrains
 
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName   = "*PyCharm Edu*"
  fileType      = 'exe'
  silentArgs    = "/S /CONFIG=$toolsDir\silent.config "
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination    = $toolsDir
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -gt 0) {
    Get-Process PyCharm* | ForEach-Object { $_.CloseMainWindow() }
  $key | ForEach-Object {
    $packageArgs['file'] = "$($_.UninstallString)"
    Uninstall-ChocolateyPackage @packageArgs
  }
} else {
  Write-Warning "$packageName has already been uninstalled by other means."
}

 Install-ChocolateyPackage @packageArgs	
