# Deployment Instructions

Notes before you start:

- Every time you deploy, the version number in the manifest will need to increment. 

## SOP

1. Run `Test-ModuleManifest` to verify module manifest passes tests.

2. `cd` into the root repository directory `.\Get-WLANs`

3. Test module with `Publish-Module -Path ".\Get-WLANs" -NugetAPIKey "GUID" -WhatIf -Verbose`

4. Publish module with `Publish-Module -Path ".\Get-WLANs" -NuGetApiKey <apiKey>`