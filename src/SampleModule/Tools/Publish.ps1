<#
	Script to publish SampleModule module

	.SYNOPSIS
		Packages and publishes currently installed Sample module with version $moduleVersion to package repository.

		WARNING first SampleModule module returned from Get-Module -ListAvailable 
		will be published.
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true)]
	[version]$moduleVersion,
	[string]$releaseNotes = ""
)

$ErrorActionPreference = "Stop"

if($moduleVersion.MajorRevision -ge 0 -and `
	$moduleVersion.Minor -ge 0 -and `
	$moduleVersion.MajorRevision -ge 0)
{
	Write-Error "Use 3 digits for moduleversion!"
	return
}

$nugetApiKey = "23026BB4-48CF-427B-8CA8-68EE56B53779"
$moduleName = "SampleModule"

Publish-Module -Name $moduleName `
	-NuGetApiKey $nugetApiKey `
	-RequiredVersion $moduleVersion `
	-Repository "SampleRepository" `
	-ReleaseNotes $releaseNotes `
	-Tags "SampleTag1", "SampleTag2"

Write-Host "Succesfully published package $moduleName $moduleVersion" -ForegroundColor Green
