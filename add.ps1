$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

try {
    # Check if the group exists
    if (-not (Get-LocalGroup -Name 'docker-users' -ErrorAction SilentlyContinue)) {
        New-LocalGroup -Name 'docker-users' -Verbose -ErrorAction Stop
    }

    # Add the user to the group
    Add-LocalGroupMember -Group 'docker-users' -Member $CurrentUser -Verbose -ErrorAction Stop

    # Check if the user is a member of the group
    $IsMember = Get-LocalGroupMember -Group 'docker-users' -Member $CurrentUser -ErrorAction Stop

    if ($IsMember) {
        Start-Sleep -Seconds 5
        exit 0  # Success
    } else {
        exit 1  # User not in the group
    }
} catch {
    exit 99  # Unexpected error
}
