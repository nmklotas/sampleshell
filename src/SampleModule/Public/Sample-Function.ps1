#Stop execution on first unhandled exception
$ErrorActionPreference = "Stop"

<#
	Somefunction1.ps1
#>

function Sample-Function([string]$arg)
{
	<# 
	.SYNOPSIS 
		Example of a public function
 
	.PARAMETER arg 
		Sample parameter for function
	#>
	Write-Host "Test function"
}