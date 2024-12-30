$Group = 'docker-users'
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

try {
    # Check if the group exists
    if (-not (Get-LocalGroup -Name $Group -ErrorAction SilentlyContinue)) {
        New-LocalGroup -Name $Group -Verbose -ErrorAction Stop
    }

    # Add the user to the group
    Add-LocalGroupMember -Group $Group -Member $CurrentUser -Verbose -ErrorAction Stop

    # Check if the user is a member of the group
    $IsMember = Get-LocalGroupMember -Group $Group -Member $CurrentUser -ErrorAction Stop

    if ($IsMember) {
        Start-Sleep -Seconds 5
        exit 0  # Success
    } else {
        exit 1  # User not in the group
    }
} catch {
    exit 99  # Unexpected error
}
