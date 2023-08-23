$vmName = "homeassistant"
$versionFilePath = "\\192.168.0.102\config\.HA_VERSION"
$snapshotName = ""

if (Test-Path $versionFilePath) {
    $versionNumber = (Get-Content -Path $versionFilePath).Trim()
    $snapshotName = "hassagent manual- {0:dd.MM.yyyy - HH:mm:ss} - ha core v.{1} - protected" -f (Get-Date), $versionNumber
} else {
    $snapshotName = "hassagent manual- {0:dd.MM.yyyy - HH:mm:ss} - protected" -f (Get-Date)
}

Get-VM -Name $vmName | Checkpoint-VM -SnapshotName $snapshotName
