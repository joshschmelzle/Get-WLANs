# Get-WLANs

This Windows PowerShell module leverages [Native Wifi](https://docs.microsoft.com/en-us/windows/win32/nativewifi/portal)'s [wlanapi.h](https://docs.microsoft.com/en-us/windows/win32/api/wlanapi/) to retrieve information (including RSSI values) about nearby Wi-Fi networks.

# Module Usage Example

```
# assuming module is in same directory as script
Import-Module (Join-Path (Split-Path $MyInvocation.MyCommand.Path) get-wlans.psm1)

# run scan, sort by RSSI, and display as a Format-Table
Get-WLANs | Sort-Object -Property RSSI -Descending | Format-Table

# remove module after we're done with it
Remove-Module Get-WLANs
```

![](docs/1-nic-scan-examplev2.png)

## Known Issues

I've documented a few [known issues here](KNOWN_ISSUES.md)

## License

Project [license can be found here](LICENSE)
