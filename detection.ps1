$Group = "docker-users"
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

try {
    # Check if the group exists
    $GroupExists = Get-LocalGroup -Name $Group -ErrorAction Stop

    # Check if the current user is a member of the group
    $IsMember = Get-LocalGroupMember -Group $Group -Member $CurrentUser -ErrorAction Stop

    if ($IsMember) {
        Write-Host "User '$CurrentUser' is already in the '$Group' group."
        exit 0  # User is in the group
    } else {
        Write-Host "User '$CurrentUser' is not in the '$Group' group."
        exit 1  # User is not in the group
    }
} catch {
    if ($_.Exception.Message -like "*Cannot find a local group*") {
        Write-Host "Group '$Group' does not exist."
        exit 2  # Group doesn't exist
    } else {
        Write-Host "An unexpected error occurred: $($_.Exception.Message)"
        exit 99  # Unexpected error
    }
}
