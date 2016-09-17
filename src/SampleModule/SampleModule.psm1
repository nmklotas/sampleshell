#Stop execution on first unhandled exception
$ErrorActionPreference = "Stop"

Import-Module $PSScriptRoot\Private\Helpers.psm1 -DisableNameChecking

function New-SqlServer-Db
{
	<# 
	.SYNOPSIS 
		Creates new SqlServer database if it does not exists
 
	.PARAMETER database
		Name of the database

	.PARAMETER instance
		Name of SqlServer instance. By default instance name from Powershell profile is taken.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$database,
		[string]$instance=$(Get-Setting sqlServerInstance)
	)
	
	$srv = New-Object Microsoft.SqlServer.Management.Smo.Server($instance)
	$db = $srv.Databases[$database]
	if($db)
	{
		Write-Host $database already exists
		return
	}
	
	#Create a new database
	$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -argumentlist $srv, `
		$database -ErrorAction Stop

	$db.Create()
	Write-Host Database $database created
}

