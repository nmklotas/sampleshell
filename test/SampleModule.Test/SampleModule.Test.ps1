<#
	SampleModule.Test.ps1

	Tests for SampleModule

	It's recomended to run these tests not directly from PowershellTools until the following error is fixed:
	https://github.com/adamdriscoll/poshtools/issues/410

	Use command:
	Invoke-Pester .\SG-PS.Tests.ps1
#>

#Stop execution on first unhandled exception
$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\..\..\src\SampleModule\SampleModule.psd1"

Describe "New-SQLServer-Db should create new database" {
	InModuleScope SampleModule {
		Context "Create SQL Server database" {
			#arrange
			Mock Inner-Create-Database -Verifiable { return; }
			$dbName = [System.IO.Path]::GetRandomFileName()

			#act
			New-SqlServer-Db -database $dbName

			#assert
			It "Create database executed" {
				Assert-VerifiableMocks
			}
		}
	}
}