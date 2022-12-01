function Get-WLANs {
    [CmdletBinding()]
    param([String]$requestedinterface)

    $wlanapi = Get-Content -Path (Join-Path $PSScriptRoot "wlanapi.cs") -Raw
    Add-Type -TypeDefinition "$wlanapi"

    $phytypehash = @{
        0  = "UNKNOWN";
        1  = "FHSS";
        2  = "DSSS";
        3  = "IRBASEBAND";
        4  = "OFDM";
        5  = "HR-DSSS";
        6  = "ERP";
        7  = "HT";
        8  = "VHT";
        9  = "DMG";
        10 = "HE";
    }

    $freqchannelhash = @{
        2412 = "1";
        2417 = "2";
        2422 = "3";
        2427 = "4";
        2432 = "5";
        2437 = "6";
        2442 = "7";
        2447 = "8";
        2452 = "9";
        2457 = "10";
        2462 = "11";
        2467 = "12";
        2472 = "13";
        2484 = "14";
        5160 = "32";
        5170 = "34";
        5180 = "36";
        5190 = "38";
        5200 = "40";
        5210 = "42";
        5220 = "44";
        5230 = "46";
        5240 = "48";
        5250 = "50";
        5260 = "52";
        5270 = "54";
        5280 = "56";
        5290 = "58";
        5300 = "60";
        5310 = "62";
        5320 = "64";
        5340 = "68";
        5480 = "96";
        5500 = "100";
        5510 = "102";
        5520 = "104";
        5530 = "106";
        5540 = "108";
        5550 = "110";
        5560 = "112";
        5570 = "114";
        5580 = "116";
        5590 = "118";
        5600 = "120";
        5610 = "122";
        5620 = "124";
        5630 = "126";
        5640 = "128";
        5660 = "132";
        5670 = "134";
        5680 = "136";
        5700 = "140";
        5710 = "142";
        5720 = "144";
        5745 = "149";
        5755 = "151";
        5765 = "153";
        5775 = "155";
        5785 = "157";
        5795 = "159";
        5805 = "161";
        5825 = "165";
        5845 = "169";
        5865 = "173";
        5885 = "177";
        5905 = "181";
        5955 = "1";
        5975 = "5";
        5995 = "9";
        6015 = "13";
        6035 = "17";
        6055 = "21";
        6075 = "25";
        6095 = "29";
        6115 = "33";
        6135 = "37";
        6155 = "41";
        6175 = "45";
        6195 = "49";
        6215 = "53";
        6235 = "57";
        6255 = "61";
        6275 = "65";
        6295 = "69";
        6315 = "73";
        6335 = "77";
        6355 = "81";
        6375 = "85";
        6395 = "89";
        6415 = "93";
        6435 = "97";
        6455 = "101";
        6475 = "105";
        6495 = "109";
        6515 = "113";
        6535 = "117";
        6555 = "121";
        6575 = "125";
        6595 = "129";
        6615 = "133";
        6635 = "137";
        6655 = "141";
        6675 = "145";
        6695 = "149";
        6715 = "153";
        6735 = "157";
        6755 = "161";
        6775 = "165";
        6795 = "169";
        6815 = "173";
        6835 = "177";
        6855 = "181";
        6875 = "185";
        6895 = "189";
        6915 = "193";
        6935 = "197";
        6955 = "201";
        6975 = "205";
        6995 = "209";
        7015 = "213";
        7035 = "217";
        7055 = "221";
        7075 = "225";
        7095 = "229";
        7115 = "233";
    }

    function Convert-dot11SSID {
        [CmdletBinding()] Param (
            [Parameter(Mandatory = $True, ValueFromPipeline = $True)] $ssid
        )
        [System.Text.Encoding]::UTF8.GetString($ssid) -replace '\x00'
    }

    function Convert-dot11BSSID {
        [CmdletBinding()] Param (
            [Parameter(Mandatory = $True, ValueFromPipeline = $True)] $bssid
        )
        $bssid = [System.BitConverter]::ToString($bssid).Replace("-", ":")
        $bssid
    }

    
    function Test-dot11BSSIDConecction {
        [CmdletBinding()] Param (
            [Parameter(Mandatory = $True, ValueFromPipeline = $True)] $bssid
        )
        $bssid = [System.BitConverter]::ToString($bssid).Replace("-", ":")
        if ($connectedbssid -eq $bssid) {
            $True
        }
        else {
            $False
        }
    }

    $wlanClient = New-Object NativeWifi.WlanClient
  
    $connectedbssid = $wlanClient.Interfaces | 
    ForEach-Object {
        $_.CurrentConnection.wlanAssociationAttributes._dot11Bssid  
    }

    if ($connectedbssid) {
        $connectedbssid = [System.BitConverter]::ToString($connectedbssid).Replace("-", ":")
    }
    
    if ($requestedinterface) {
        $iface = $wlanClient.Interfaces | Where-Object { $_.InterfaceName -eq $requestedinterface }
        $ifaces = ($wlanClient.Interfaces | Select-Object -ExpandProperty 'InterfaceName') -join ', '
        if (-Not $iface) {
            Write-Warning "$($requestedinterface) not found. did you mean one of these? $($ifaces)"
            Break
        }
    }
    else {
        $iface = $wlanClient.Interfaces[0]
    }

    function ParseNetworkBssList {
        [CmdletBinding()] Param (
            [Parameter(Mandatory = $True, ValueFromPipeline = $True)] $NetworkBssList
        )
        $NetworkBssList | Select-Object `
        @{Name = "SSID"; Expression = { (Convert-dot11SSID -ssid $_.dot11ssid.SSID) } }, `
        @{Name = "BSSID"; Expression = { (Convert-dot11BSSID -bssid $_.dot11bssid) } }, `
        @{Name = "RSSI"; Expression = { $_.rssi } }, `
        @{Name = "QUALITY"; Expression = { $_.linkQuality } }, `
        @{Name = "FREQ"; Expression = { $_.chCenterFrequency / 1000 } }, `
        @{Name = "CHANNEL"; Expression = { $freqchannelhash[[int]($_.chCenterFrequency / 1000)] } }, `
        @{Name = "PHY"; Expression = { $phytypehash[[int]$_.dot11BssPhyType] } }, `
        @{Name = "CAPABILITY"; Expression = { '0x{0:x4}' -f $_.capabilityInformation } }, `
        @{Name = "IESIZE"; Expression = { $_.ieSize } }, `
        @{Name = "CONNECTED"; Expression = { Test-dot11BSSIDConecction -bssid $_.dot11bssid } }
    }
    
    # if ($PSBoundParameters['Verbose']) {
    # }

    $ifacemac = Get-NetAdapter | Where-Object { $_.InterfaceGuid -eq "{$($iface.InterfaceGuid)}" } | Select-Object MacAddress -ExpandProperty MacAddress 
        
    Write-Verbose "Starting scan() on $($iface.InterfaceName) (MAC Address: $($ifacemac))"
    $iface.Scan()
    
    # function global:NotifyAction {
    #     [CmdletBinding()]
    #     Param(
    #         [Parameter(Mandatory = $True)] [Object[]] $event
    #     )
    #     Write-Output ParseNetworkBssList($iface.GetNetworkBssList())
    # }
    # $Notify = { 
    #     NotifyAction($event)
    # }
    # $pso = new-object psobject -property @{if = $iface; }
    # Register-ObjectEvent -InputObject $iface -EventName WlanNotification -SourceIdentifier WiphyNotify -MessageData $pso -Action $Notify
    # Get-EventSubscriber
    # Unregister-Event -SourceIdentifier "WiphyNotify"

    Start-Sleep -s 4

    ParseNetworkBssList($iface.GetNetworkBssList())
}

