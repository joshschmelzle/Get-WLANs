# assuming module is in same directory as script
Import-Module (Join-Path (Split-Path $MyInvocation.MyCommand.Path) get-wlans.psm1)

Get-WLANs | Select-Object * | Export-Csv -Path .\Get-WLANs.csv -NoTypeInformation

# remove module after we're done with it
Remove-Module Get-WLANs