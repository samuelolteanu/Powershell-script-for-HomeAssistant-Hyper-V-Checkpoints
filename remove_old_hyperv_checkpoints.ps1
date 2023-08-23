# Set the VM name
$VMName = "HomeAssistant"

# Get all snapshots for the specified VM
$Snapshots = Get-VM -Name $VMName | Get-VMSnapshot

# Sort the snapshots by creation time in ascending order
$Snapshots = $Snapshots | Sort-Object CreationTime

# Find the oldest snapshot that doesn't contain "protected" in its name
$OldestSnapshot = $Snapshots | Where-Object { $_.Name -notlike "*protected*" } | Select-Object -First 1

if ($OldestSnapshot) {
    # Display a warning message with a countdown
    $countdown = 5
    Write-Host "Warning: The oldest snapshot '$($OldestSnapshot.Name)' will be deleted in $countdown seconds. Press CTRL+C to cancel."
    while ($countdown -gt 0) {
        Write-Host "Countdown: $countdown"
        Start-Sleep -Seconds 1
        $countdown--
    }

    # Remove the oldest snapshot
    $OldestSnapshot | Remove-VMSnapshot -Confirm:$false
    Write-Host "Oldest snapshot '$($OldestSnapshot.Name)' has been deleted."
    Start-Sleep -Seconds 2
} else {
    Write-Host "No unprotected snapshot found to delete."
    Start-Sleep -Seconds 5
}

# Verify that the snapshots have been successfully deleted
Get-VM -Name $VMName | Get-VMSnapshot
