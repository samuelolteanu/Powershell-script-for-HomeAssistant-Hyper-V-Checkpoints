# Set the VM name
$VMName = "HomeAssistant"
$VersionFilePath = "\\192.168.0.102\config\.HA_VERSION"
$Keyword = "hassagent"  # Change this keyword to your desired value
$SnapshotName = ""

if (Test-Path $VersionFilePath) {
    $VersionNumber = (Get-Content -Path $VersionFilePath).Trim()
    $SnapshotName = "HomeAssistant - {0:dd.MM.yyyy - HH:mm:ss} - ha core v.{1} before_restoring" -f (Get-Date), $VersionNumber
} else {
    $SnapshotName = "HomeAssistant - {0:dd.MM.yyyy - HH:mm:ss} before_restoring" -f (Get-Date)
}

# Get all snapshots for the specified VM
$Snapshots = Get-VM -Name $VMName | Get-VMSnapshot

# Filter snapshots with the specified keyword in the name
$KeywordSnapshots = $Snapshots | Where-Object { $_.Name -like "*$Keyword*" }

if ($KeywordSnapshots.Count -gt 0) {
    # Sort the snapshots by creation time in descending order
    $LatestKeywordSnapshot = $KeywordSnapshots | Sort-Object CreationTime -Descending | Select-Object -First 1

    # Create a checkpoint with dynamically generated snapshot name before restoring without confirmation
    Write-Host "Creating a checkpoint $($SnapshotName) before restoring: $($LatestKeywordSnapshot.Name)"
    $VM = Get-VM -Name $VMName
    $VM | Checkpoint-VM -SnapshotName $SnapshotName -Confirm:$false

    # Apply/load the latest snapshot with the specified keyword without confirmation
    Write-Host "Applying the latest snapshot with keyword '$Keyword': $($LatestKeywordSnapshot.Name)"
    $LatestKeywordSnapshot | Restore-VMSnapshot -Confirm:$false

    Write-Host "Latest snapshot with keyword '$Keyword' ('$($LatestKeywordSnapshot.Name)') has been applied."
} else {
    Write-Host "No snapshot with keyword '$Keyword' found to apply."
}
