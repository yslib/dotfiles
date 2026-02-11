<#
.SYNOPSIS
    Minimal Windows bootstrapper.
    Installs Git for Windows (if missing), then hands off to bootstrap.sh
    running inside Git Bash.

.USAGE
    powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
#>
$ErrorActionPreference = "Stop"

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
} else {
    Write-Host ">> Git already installed." -ForegroundColor Green
}

# ── 3. Locate bash from Git for Windows ───────────────────────────
$gitDir = Split-Path -Parent (Get-Command git).Source
# git.exe is typically in Git/cmd/ or Git/bin/, bash is in Git/bin/bash.exe
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

# ── 4. Hand off to bootstrap.sh ───────────────────────────────────
$dotfilesRoot = $PSScriptRoot
if (-not $dotfilesRoot) { $dotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition }

# Convert Windows path to Unix path for Git Bash
$unixPath = & $bashExe -c "cygpath '$dotfilesRoot'" 2>$null
if (-not $unixPath) { $unixPath = $dotfilesRoot -replace '\\','/' -replace '^([A-Za-z]):','/$1' }

Write-Host ">> Launching bootstrap.sh in Git Bash..." -ForegroundColor Cyan
& $bashExe --login -c "cd '$unixPath' && ./bootstrap.sh"

$exitCode = $LASTEXITCODE
if ($exitCode -eq 0) {
    Write-Host "`n>> Bootstrap complete! Please restart your terminal." -ForegroundColor Green
} else {
    Write-Error "bootstrap.sh exited with code $exitCode"
}
