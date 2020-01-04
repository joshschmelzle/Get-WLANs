#
# Module manifest for module 'get-wlans'
#
@{

RootModule = 'Get-WLANs.psm1'
ModuleVersion = '0.0.3'
GUID = '997ccb39-6038-4f66-a015-c39cf95c438f'
Author = 'Josh Schmelzle'
Copyright = '(c) Josh Schmelzle. All rights reserved.'
Description = 'Get information about nearby Wi-Fi networks'
PowerShellVersion = '3.0'
FunctionsToExport = @('Get-WLANs')
CmdletsToExport = @('Get-WLANs')
FileList = @('wlanapi.cs')

PrivateData = @{
    PSData = @{
        Tags = @('wlan', 'wifi', 'wi-fi', 'rlan', 'wireless')
        ProjectUri = 'https://github.com/joshschmelzle/Get-WLANs'
    } 
} 

}