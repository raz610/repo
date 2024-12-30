$Group = 'docker-users'
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

try {
    # Check if the group exists
    if (-not (Get-LocalGroup -Name $Group -ErrorAction SilentlyContinue)) {
        Write-Host "The group '$Group' does not exist. Creating it now..."
        New-LocalGroup -Name $Group -Verbose -ErrorAction Stop
    }

    # Add the user to the group
    Add-LocalGroupMember -Group $Group -Member $CurrentUser -Verbose -ErrorAction Stop

    # Check if the user is a member of the group
    $IsMember = Get-LocalGroupMember -Group $Group -Member $CurrentUser -ErrorAction Stop

    if ($IsMember) {
        Write-Host "The current user '$CurrentUser' was successfully added to the group '$Group'."
        Start-Sleep -Seconds 5
        exit 0  # Success
    } else {
        Write-Host "Failed to add the current user '$CurrentUser' to the group '$Group'."
        exit 1  # User not in the group
    }
} catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
    exit 99  # Unexpected error
}
