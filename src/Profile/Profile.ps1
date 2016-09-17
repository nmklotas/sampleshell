<#
	Profile.ps1

	If this script is placed in c:\users\[user]\windowspowershell\
	it will be executed when Powershell loads for the current user and all Powershell hosts (Powershell.exe, Powershell ISE etc..)
	
	.SYNOPSIS
		Sets global variables, registers SampleRepository packages repository and installs SampleModule module
		Always updates SampleModule module if never version exists
#>

$ErrorActionPreference = "Stop"

#region Configuration for SampleModule module

Set-Variable -Name gSqlServerInstance -Value 'localhost' -Scope global

#endregion

#region Repository and module auto install

$module = "SampleModule"
$repositoryName = "SampleRepository"
$repository = Get-PSRepository -Name $repositoryName -ErrorAction Ignore
#$repositoryLocation = "\\SampleNetwork\PowershellPackages"
$repositoryLocation = "C:\PowershellPackages\"

if(!$repository)
{
	#register repository
	Write-Host $repositoryName repository not registered. Registering...
	Register-PSRepository -Name $repositoryName -SourceLocation $repositoryLocation
	Write-Host $repositoryName repository successfully registered -ForegroundColor Green

	Set-PSRepository -Name $repositoryName -InstallationPolicy Trusted
	#instal module
	Install-Module -Name $module -Repository $repositoryName -Scope CurrentUser -Force
	Write-Host $module module successfully installed -ForegroundColor Green
}

Update-Module -Name $module -ErrorAction SilentlyContinue

#endregion

#cleanup local variables for Powershell profiles after the load
#to not to polute the current session
'module', 'repositoryName', 'repository', 'repositoryLocation' | Remove-Variable -Name { $_ }