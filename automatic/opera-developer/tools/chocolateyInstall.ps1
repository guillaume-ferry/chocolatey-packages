﻿$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/73.0.3827.0/win/Opera_Developer_73.0.3827.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/73.0.3827.0/win/Opera_Developer_73.0.3827.0_Setup_x64.exe'
  checksum       = '61d5cb6aea2902517e40b16db6f70ffe0309cdc128ef124939a6d3128d54c7ca'
  checksum64     = '1681fa3350af39405bd049760dee9a03f7ce21a80e546a6e39ebaa76d45d05ae'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3827.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
