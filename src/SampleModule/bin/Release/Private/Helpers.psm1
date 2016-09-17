<#
	Helpers.psm1

	.Synopsis
		Internal (invisible outside the module) module for private helper functions
#>

function Get-Setting {
	<# 
	.SYNOPSIS 
		Retrieves globally scoped variable value from active Powershell profile
 
	.PARAMETER key 
		Global variable name without SG_ prefix in Powershell profile
	#>
	[CmdletBinding()]
	param(
	   [Parameter(Mandatory)]
	   $key
	)

	$variableValue = Get-Variable -Name "SG_$key" -ErrorAction Ignore
	if(!$variableValue)
	{
		$profileDestination = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "WindowsPowershell\Profile.ps1"
		throw [System.ArgumentNullException] "SG_$key value is not set make sure that profile is installed in $profileDestination"
	}

	return $variableValue.Value
}

function Invoke-Python
{
	<# 
	.SYNOPSIS 
		Executes python script file with arguments

	.PARAMETER scriptFile
		Script file to execute
 
	.PARAMETER argument 
		Argument to pass to python script
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$scriptFile,
		[Parameter(Position=1)]
		[string]$argument
	)

	$key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Python.exe'
	$python = Get-ItemProperty -Path $key -ErrorAction Ignore

	if($python)
	{
		Write-Verbose -Message "Resolved python location using registry"
		$python = $python."(Default)"
	}
	else
	{
		$python = "C:\Python27\Python.exe"
		if(!(Test-Path -Path $python))
		{
			throw "Failed to locate python executable"
		}
	}
	
	Write-Verbose -Message "Python location: $python"	
	Push-Location $PSScriptRoot

	#output will be lost if there's no -NoNewWindow
	$python = Start-Process -FilePath $python -ArgumentList @($scriptFile,$argument) -Wait `
		-NoNewWindow -PassThru

	Pop-Location
	if($python.ExitCode -ne 0)
	{
		throw "Python script $scriptFile failed"
	}
}