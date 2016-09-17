<#
	Somefunction1.ps1

	.Synopsis
		Sample function contained in the script file.
#>

function Sample-Function([string]$arg)
{
	<# 
	.SYNOPSIS 
		Example of a public function
 
	.PARAMETER arg 
		Parameter for function
	#>
	Write-Host "Test function"
}