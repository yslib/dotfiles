<#
.SYNOPSIS
    Minimal Windows bootstrapper.
    Installs Scoop + Git, clones the dotfiles repo, then hands off to
    bootstrap.sh running inside Git Bash.

.DESCRIPTION
    This script is self-contained — no prerequisites needed.
    You can run it directly via a one-liner (see README).

.USAGE
    irm https://raw.githubusercontent.com/yslib/dotfiles/master/bootstrap.ps1 | iex
#>
$ErrorActionPreference = "Stop"

$DotfilesRepo = "https://github.com/yslib/dotfiles.git"
$DotfilesDir  = Join-Path $env:USERPROFILE "dotfiles"

# ── 1. Install Scoop (needed to install git) ──────────────────────
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host ">> Installing Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + `
                [System.Environment]::GetEnvironmentVariable("Path", "Machine")
} else {
    Write-Host ">> Scoop already installed." -ForegroundColor Green
}

# ── 2. Install Git for Windows (provides bash) ────────────────────
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host ">> Installing Git for Windows via Scoop..." -ForegroundColor Cyan
    scoop install git
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + `
                [System.Environment]::GetEnvironmentVariable("Path", "Machine")
} else {
    Write-Host ">> Git already installed." -ForegroundColor Green
}

# ── 3. Clone dotfiles repo ────────────────────────────────────────
if (Test-Path (Join-Path $DotfilesDir ".git")) {
    Write-Host ">> Dotfiles repo already exists at $DotfilesDir, pulling latest..." -ForegroundColor Green
    git -C $DotfilesDir pull --rebase
} else {
    Write-Host ">> Cloning dotfiles repo to $DotfilesDir..." -ForegroundColor Cyan
    git clone $DotfilesRepo $DotfilesDir
}

# ── 4. Locate bash from Git for Windows ───────────────────────────
$gitDir = Split-Path -Parent (Get-Command git).Source
$bashCandidates = @(
    (Join-Path (Split-Path $gitDir) "bin\bash.exe"),
    (Join-Path $gitDir "bash.exe"),
    (Join-Path (Split-Path $gitDir) "usr\bin\bash.exe")
)
$bashExe = $bashCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $bashExe) {
    Write-Error "Could not find bash.exe from Git for Windows installation."
}

Write-Host ">> Found bash at: $bashExe" -ForegroundColor Green

# ── 5. Hand off to bootstrap.sh ───────────────────────────────────
$unixPath = & $bashExe -c "cygpath '$DotfilesDir'" 2>$null
if (-not $unixPath) { $unixPath = $DotfilesDir -replace '\\','/' -replace '^([A-Za-z]):','/$1' }

Write-Host ">> Launching bootstrap.sh in Git Bash..." -ForegroundColor Cyan
& $bashExe --login -c "cd '$unixPath' && ./bootstrap.sh"

$exitCode = $LASTEXITCODE
if ($exitCode -eq 0) {
    Write-Host "`n>> Bootstrap complete! Please restart your terminal." -ForegroundColor Green
} else {
    Write-Error "bootstrap.sh exited with code $exitCode"
}
