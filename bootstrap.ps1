<#
.SYNOPSIS
    Minimal Windows bootstrapper.
    Installs Scoop + Git, clones the dotfiles repo, runs bootstrap.sh in
    Git Bash for package installation, then creates symlinks directly in
    PowerShell (which has the admin token).

.USAGE
    irm https://raw.githubusercontent.com/yslib/dotfiles/master/bootstrap.ps1 | iex
#>
$ErrorActionPreference = "Stop"

$DotfilesRepo = "https://github.com/yslib/dotfiles.git"
$DotfilesDir  = Join-Path $env:USERPROFILE "dotfiles"

# ── 0. Self-elevate if not admin ────────────────────────────────────
$isAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host ">> Requesting administrator privileges (needed for symlinks)..." -ForegroundColor Yellow
    $psExe = if ($PSVersionTable.PSVersion.Major -ge 7) { (Get-Process -Id $PID).Path } else { "powershell.exe" }
    Start-Process $psExe -Verb RunAs -ArgumentList @(
        "-ExecutionPolicy", "Bypass",
        "-Command", "irm https://raw.githubusercontent.com/yslib/dotfiles/master/bootstrap.ps1 | iex"
    )
    exit
}

# ── 1. Install Scoop ─────────────────────────────────────────────
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host ">> Installing Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + `
                [System.Environment]::GetEnvironmentVariable("Path", "Machine")
} else {
    Write-Host ">> Scoop already installed." -ForegroundColor Green
}

# ── 2. Install Git for Windows (provides bash) ───────────────────
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host ">> Installing Git for Windows via Scoop..." -ForegroundColor Cyan
    scoop install git
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + `
                [System.Environment]::GetEnvironmentVariable("Path", "Machine")
} else {
    Write-Host ">> Git already installed." -ForegroundColor Green
}

# ── 3. Clone dotfiles repo ───────────────────────────────────────
if (Test-Path (Join-Path $DotfilesDir ".git")) {
    Write-Host ">> Dotfiles repo already exists at $DotfilesDir, pulling latest..." -ForegroundColor Green
    git -C $DotfilesDir pull --rebase
} else {
    Write-Host ">> Cloning dotfiles repo to $DotfilesDir..." -ForegroundColor Cyan
    git clone $DotfilesRepo $DotfilesDir
}

# ── 4. Locate bash and run bootstrap.sh ──────────────────────────
$gitDir = Split-Path -Parent (Get-Command git).Source
$bashCandidates = @(
    (Join-Path (Split-Path $gitDir) "bin\bash.exe"),
    (Join-Path $gitDir "bash.exe"),
    (Join-Path (Split-Path $gitDir) "usr\bin\bash.exe")
)
$bashExe = $bashCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $bashExe) { Write-Error "Could not find bash.exe from Git for Windows." }

Write-Host ">> Found bash at: $bashExe" -ForegroundColor Green

$unixPath = & $bashExe -c "cygpath '$DotfilesDir'" 2>$null
if (-not $unixPath) { $unixPath = $DotfilesDir -replace '\\','/' -replace '^([A-Za-z]):','/$1' }

Write-Host ">> Launching bootstrap.sh in Git Bash (install packages + nvim plugins)..." -ForegroundColor Cyan
& $bashExe --login -c "cd '$unixPath' && ./bootstrap.sh"

if ($LASTEXITCODE -ne 0) {
    Write-Error "bootstrap.sh exited with code $LASTEXITCODE"
}

# ── 5. Create symlinks (PowerShell has admin token) ──────────────
Write-Host "`n>> Linking configuration files..." -ForegroundColor Cyan

$ConfigHome = Join-Path $DotfilesDir "home"

function New-DotfilesLink {
    param(
        [string]$Source,
        [string]$Target
    )
    if (-not (Test-Path $Source)) {
        Write-Host "   [WARN] Source not found, skipping: $Source" -ForegroundColor Yellow
        return
    }
    # Ensure parent dir exists
    $parent = Split-Path -Parent $Target
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }

    # Remove existing target
    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            $item.Delete()
        } else {
            Remove-Item $Target -Recurse -Force
        }
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
    Write-Host "   [LINK] $Target -> $Source" -ForegroundColor Green
}

# nvim: %LOCALAPPDATA%\nvim
New-DotfilesLink -Source (Join-Path $ConfigHome ".config\nvim") `
                 -Target (Join-Path $env:LOCALAPPDATA "nvim")

# yazi: %APPDATA%\yazi\config
New-DotfilesLink -Source (Join-Path $ConfigHome ".config\yazi") `
                 -Target (Join-Path $env:APPDATA "yazi\config")

# lazygit: %LOCALAPPDATA%\lazygit
New-DotfilesLink -Source (Join-Path $ConfigHome ".config\lazygit") `
                 -Target (Join-Path $env:LOCALAPPDATA "lazygit")

# alacritty: %APPDATA%\alacritty
New-DotfilesLink -Source (Join-Path $ConfigHome ".config\alacritty") `
                 -Target (Join-Path $env:APPDATA "alacritty")

# gitconfig: ~\.gitconfig
New-DotfilesLink -Source (Join-Path $ConfigHome ".gitconfig") `
                 -Target (Join-Path $env:USERPROFILE ".gitconfig")

# ── Done ─────────────────────────────────────────────────────────
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  Bootstrap complete!" -ForegroundColor Green
Write-Host "  Please restart your terminal." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
