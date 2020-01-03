# assuming module is in same directory as script
Import-Module (Join-Path (Split-Path $MyInvocation.MyCommand.Path) get-wlans.psm1)

# run scan, sort by RSSI, and display as a Format-Table
Get-WLANs | Sort-Object -Property RSSI -Descending | Format-Table

# remove module after we're done with it
Remove-Module Get-WLANs