try {   
    # assuming module is installed from PSGallery
    # Import-Module Get-WLANs

    # assuming module is local
    Import-Module .\Get-WLANs

    # run scan, sort by RSSI, and display as a Format-Table
    # Get-WLANs -Verbose
    Get-WLANs -Verbose | Sort-Object -Property RSSI -Descending | Format-Table

    # export to CSV example
    # Get-WLANs | Select-Object * | Export-Csv -Path .\Get-WLANs.csv -NoTypeInformation
}
finally {
    # remove module after we're done with it
    Remove-Module Get-WLANs
}