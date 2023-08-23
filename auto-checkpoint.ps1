$vmName = "homeassistant"
$versionFilePath = "\\192.168.0.102\config\.HA_VERSION"
$snapshotName = ""

if (Test-Path $versionFilePath) {
    $versionNumber = (Get-Content -Path $versionFilePath).Trim()
    $snapshotName = "hassagent auto - {0:dd.MM.yyyy - HH:mm:ss} - ha core v.{1}" -f (Get-Date), $versionNumber
} else {
    $snapshotName = "hassagent auto - {0:dd.MM.yyyy - HH:mm:ss}" -f (Get-Date)
}

Get-VM -Name $vmName | Checkpoint-VM -SnapshotName $snapshotName

