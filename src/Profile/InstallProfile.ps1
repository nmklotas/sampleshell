<#
	InstallProfile.ps1

	.SYNOPSIS
		Installs profile (Profile.ps1) for the current user
#>

$ErrorActionPreference = "Stop"

$powershellFolder = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "WindowsPowershell"
if(!(Test-Path $powershellFolder))
{
	New-Item -Path $powershellFolder -ItemType Directory | Out-Null
}

$profileDestination = Join-Path $powershellFolder "Profile.ps1"
Copy-Item -Path "$PSScriptRoot\Profile.ps1" -Destination $profileDestination -Force
Write-Host "Succesfully installed profile" -ForegroundColor Green