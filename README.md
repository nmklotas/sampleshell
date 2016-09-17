# sampleshell
Powershell module + PowershellGet package management starter code the right way. 

Contents:

## Profile project:
* Contains Powershell profile Profile.ps1
* Profile.ps1 is used to have global configuration for the module and register SampleRepository if its not registered,
install SampleModule newest version if its not installed.

## SampleModule project
* Contains the module and its files
* Contains Release.ps1 script to package, generate manifest & install SampleModule
* Contains Publish.ps1 script to publish SampleModule into SampleRepository

## SampleModule.Test project
* Contains Pester tests for SampleModule

> Note:
If Powershell profile is installed then it is executed every time Powershell host is loaded.
Powershell profile might be not needed for your Powershell module, 
but it can be useful for Powershell modules aimed for internal use in a company.