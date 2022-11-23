# Get-WLANs

Get-WLANs is a PSGallery module to retrieve information about nearby Wi-Fi networks. Get-WLANs is built for Windows and leverages Native Wifi ([wlanapi.h](https://docs.microsoft.com/en-us/windows/win32/api/wlanapi/) header).

## Installing from PowerShell Gallery

You can install [Get-WLANs from the PowerShell Gallery](https://www.powershellgallery.com/packages/Get-WLANs) (PSGallery).

```bash
Install-Module -Name Get-WLANs
Import-Module Get-WLANs
Get-WLANs
```

![install example](docs/WindowsTerminal_jgCkTPJBx4.png)

## Basic Module Example

You can sort and format the output of `Get-WLANs` like this:

```bash
# assuming module was installed from PSGallery.
Import-Module Get-WLANs

# run scan, sort by RSSI, and display as a Format-Table
Get-WLANs | Sort-Object -Property RSSI -Descending | Format-Table

# remove module after we're done with it
Remove-Module Get-WLANs
```

![usage example](docs/1-nic-scan-examplev2.png)

## Updating

```bash
# if the module is in use
Remove-Module Get-WLANs

# update module with
Update-Module Get-WLANs

# get current version with
Import-Module Get-WLANs
Get-Module Get-WLANs
```

## Known Issues

[Some known issues documented here](KNOWN_ISSUES.md)

## License

Project [license can be found here](LICENSE)
