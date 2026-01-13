# ========================================
# Multi-GitHub SSH Setup Script for Windows
# ========================================

# --- Step 1: Ensure running as Administrator ---
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltinRole] "Administrator"))
{
    Write-Warning "Please run this script as Administrator."
    exit
}

# --- Step 2: Start ssh-agent service ---
Write-Host "`n[1/4] Starting ssh-agent service..."
Try {
    Set-Service -Name ssh-agent -StartupType Automatic -ErrorAction Stop
    Start-Service ssh-agent -ErrorAction Stop
    Write-Host "ssh-agent is running ✅"
}
Catch {
    Write-Error "Failed to start ssh-agent: $_"
    exit
}

# --- Step 3: Add SSH keys to the agent ---
# List all keys here
$keys = @(
    "$env:USERPROFILE\.ssh\id_ed25519",                 # Default / personal
    "$env:USERPROFILE\.ssh\id_ed25519_radeonxfx",      # RadeonXFX
    "$env:USERPROFILE\.ssh\id_ed25519_work"            # Work (optional)
)

Write-Host "`n[2/4] Adding SSH keys..."
foreach ($key in $keys) {
    if (Test-Path $key) {
        ssh-add $key | Out-Null
        Write-Host "Added: $key"
    } else {
        Write-Warning "Key not found: $key"
    }
}

Write-Host "`n[3/4] Listing all loaded keys:"
ssh-add -l

# --- Step 4: Test SSH connections to GitHub accounts ---
$hosts = @{
    "Personal" = "github-personal"
    "RadeonXFX" = "github-radeonxfx"
    "Work" = "github-work"
}

Write-Host "`n[4/4] Testing SSH connectivity to GitHub accounts..."
foreach ($account in $hosts.Keys) {
    $hostAlias = $hosts[$account]
    if ($hostAlias -ne $null) {
        Write-Host "`nTesting $account account ($hostAlias)..."
        ssh -T $hostAlias
    }
}

Write-Host "`nAll done! You can now clone or switch repos using the host aliases."
Write-Host "Example: git clone git@github-radeonxfx:XXRadeonXFX/Repo.git"
