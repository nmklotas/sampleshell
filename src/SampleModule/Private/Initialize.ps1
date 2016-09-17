<#
	Initialize.ps1

	.Synopsis
		Script to process by the module manifest. 
		Perfect place to create types, execute some one time initialization code.
#>

# Check if the enum exists, if it doesn't, create it.
if(!("SomeEnum" -as [Type])){
Add-Type -TypeDefinition @'	
	using System;
	namespace SampleModule
	{
		public enum SomeEnum {
			Option1,
			Option2,
		}
	}
'@
}

Write-Verbose -Message "SampleModule module has been initialized."