# Set the VM name
$VMName = "HomeAssistant"

# Get all snapshots for the specified VM
$Snapshots = Get-VM -Name $VMName | Get-VMSnapshot

# Sort the snapshots by creation time in ascending order
$Snapshots = $Snapshots | Sort-Object CreationTime

# Find the oldest snapshot that contains "protected" in its name
$OldestProtectedSnapshot = $Snapshots | Where-Object { $_.Name -like "*protected*" } | Select-Object -First 1

if ($OldestProtectedSnapshot) {
    # Remove the oldest protected snapshot
    $OldestProtectedSnapshot | Remove-VMSnapshot -Confirm:$false
    Write-Host "Oldest protected snapshot '$($OldestProtectedSnapshot.Name)' has been deleted."
} else {
    Write-Host "No protected snapshot found to delete."
}

# Verify that the snapshots have been successfully deleted
Get-VM -Name $VMName | Get-VMSnapshot
