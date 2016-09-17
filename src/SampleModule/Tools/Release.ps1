<#
	This script is executed by custom MSBUILD command when SampleModule.proj builds.
	It also can be executed manually.

	.SYNOPSIS
		bundles all of the module source files in one folder, install the module for the current user.
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true)]
	[version]$moduleVersion = "1.0.0.0"
)

$ErrorActionPreference = "Stop"

$rootPath = Split-Path $PSScriptRoot
$module = "SampleModule"

# Start creating manifest
$manifestFile = "$rootPath\$module.psd1"
if(Test-Path $manifestFile)
{
	Remove-Item $manifestFile -Force
}

Push-Location $rootPath

$nestedModules = @(Get-ChildItem "$rootPath\*", "$rootPath\Public\*" `
	-Include "*.psm1", "*.ps1" `
    | Resolve-Path -Relative)

$innerFiles = @(Get-ChildItem "$rootPath\Files\*", "$rootPath\Private\*" `
    | Resolve-Path -Relative)

New-ModuleManifest -Path $manifestFile `
	-ModuleVersion $moduleVersion `
	-Guid '663A674E-D05E-41CD-B83A-90252E0246D3' `
	-Author 'SampleModule author' `
	-CompanyName 'SampleModule companyName' `
	-Copyright "(c) $((Get-Date).Year). All rights reserved." `
	-Description 'SampleModule description.' `
	-PowerShellVersion '4.0' `
	-DotNetFrameworkVersion '4.5' `
	-ScriptsToProcess 'Private\Initialize.ps1' `
	-NestedModules $nestedModules `
	-Tags 'SampleTag1', 'SampleTag2' `
	-CmdletsToExport 'New-SqlServer-Db' `
    -FileList @($nestedModules + $innerFiles) `
	-FunctionsToExport 'Sample-Function' ` #We export function from Public folder
	#-RequiredAssemblies 'Microsoft.SqlServer.Smo' 

if(!(Test-ModuleManifest -Path $manifestFile))
{
	throw "Manifest is invalid"
}

Pop-Location

# Clean release folder
$releasePath = Join-Path $rootPath 'bin\Release\'
if (Test-Path $releasePath) 
{
	Remove-Item $releasePath -Force -Recurse
}

New-Item $releasePath -ItemType Directory | Out-Null

# Start packaging
Write-Host "Packaging release for $module v$moduleVersion ..."

# Copy the top level source files and Public, Private, Files folders
$topPsFiles = @(Get-ChildItem -Path $rootPath\* -Include "*.psm1", "*.psd1", "*.ps1")
foreach($source in $topPsFiles)
{
	Copy-Item -Path $source -Destination $releasePath
}

$sources = @(
	(Join-Path $rootPath 'Public'),
	(Join-Path $rootPath 'Private'),
	(Join-Path $rootPath 'Files')
)

foreach($source in $sources)
{
	Copy-Item -Path $source -Destination $releasePath -Recurse -Container
}

#Copy items to installDir
$installDir = Join-Path ([Environment]::GetFolderPath("MyDocuments")) `
	"WindowsPowershell\modules\SampleModule\$moduleVersion\"

if (Test-Path $installDir)
{
	Remove-Item $installDir -Recurse -Force
}

New-Item -Path $installDir -ItemType Directory | Out-Null

Copy-Item -Path $releasePath\* -Destination $installDir -Recurse -Force
Write-Host "Successfully installed module $module" -ForegroundColor Green
