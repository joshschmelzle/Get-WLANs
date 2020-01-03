function Get-WLANs {
    $WlanAPICode = Get-Content -Path "wlanapicode.cs" -Raw
    Add-Type -TypeDefinition "$WlanAPICode"

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
        4915 = "183";
        4920 = "184";
        4925 = "185";
        4935 = "187";
        4940 = "188";
        4945 = "189";
        4960 = "192";
        4980 = "196";
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
        if ($connectedbssid -eq $bssid) {
            $bssid = "$($bssid)(*)"
        }
        $bssid
    }

    $WlanClient = New-Object NativeWifi.WlanClient
  
    $connectedbssid = $wlanClient.Interfaces | 
    ForEach-Object {
        $_.CurrentConnection.wlanAssociationAttributes._dot11Bssid  
    }
    if ($connectedbssid) {
        $connectedbssid = [System.BitConverter]::ToString($connectedbssid).Replace("-", ":")
    }
    
    $results = @{}

    $WlanClient.Interfaces | ForEach-Object {
        Write-Host "Starting scan() on $($_.InterfaceName) ($($_.InterfaceGuid))"
        $_.Scan()
        Start-Sleep -s 3
        $_.GetNetworkBssList() | Select-Object `
        @{Name = "SSID"; Expression = { (Convert-dot11SSID -ssid $_.dot11ssid.SSID) } }, `
        @{Name = "BSSID"; Expression = { (Convert-dot11BSSID -bssid $_.dot11bssid) } }, `
        @{Name = "RSSI"; Expression = { $_.rssi } }, `
        @{Name = "FREQ"; Expression = { $_.chCenterFrequency / 1000 } }, `
        @{Name = "CHANNEL"; Expression = { $freqchannelhash[[int]($_.chCenterFrequency / 1000)] } }, `
        @{Name = "PHY"; Expression = { $phytypehash[[int]$_.dot11BssPhyType] } }
    }

    Write-Host $results | Select-Object *
}