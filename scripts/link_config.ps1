<#
.SYNOPSIS
    Create symlinks for configuration files in this repo.

.DESCRIPTION
    This script is a declarative link runner. Add new entries to $Links
    with Source/Target plus optional Candidates/When to create symlinks
    in a consistent and safe way.

.USAGE
    .\link_config.ps1 -DotfilesDir "C:\path\to\dotfiles"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$DotfilesDir
)

$ErrorActionPreference = "Stop"

Write-Host "`n>> Linking configuration files..." -ForegroundColor Cyan

$ConfigHome = Join-Path $DotfilesDir "home"
$DocsDir = [Environment]::GetFolderPath('MyDocuments')

$Links = @(
    # nvim: %LOCALAPPDATA%\nvim
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\nvim"
        Target = Join-Path $env:LOCALAPPDATA "nvim"
        Type = "Directory"
        EnsureParent = "Create"
    }

    # yazi: %APPDATA%\yazi\config
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\yazi"
        Target = Join-Path $env:APPDATA "yazi\config"
        Type = "Directory"
        EnsureParent = "Create"
    }

    # lazygit: %LOCALAPPDATA%\lazygit
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\lazygit"
        Target = Join-Path $env:LOCALAPPDATA "lazygit"
        Type = "Directory"
        EnsureParent = "Create"
    }

    # alacritty: %APPDATA%\alacritty
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\alacritty"
        Target = Join-Path $env:APPDATA "alacritty"
        Type = "Directory"
        EnsureParent = "Create"
    }

    # gitconfig: ~\.gitconfig
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".gitconfig"
        Target = Join-Path $env:USERPROFILE ".gitconfig"
        Type = "File"
        EnsureParent = "Create"
    }

    # starship: ~\.config\starship.toml
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\starship.toml"
        Target = Join-Path $env:USERPROFILE ".config\starship.toml"
        Type = "File"
        EnsureParent = "Create"
    }

    # powershell profile: <Documents>\PowerShell\profile.ps1
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\powershell\profile.ps1"
        Target = Join-Path $DocsDir "PowerShell\profile.ps1"
        Type = "File"
        EnsureParent = "Create"
    }

    # windows-terminal: detect installed versions and link settings.json
    [pscustomobject]@{
        Source = Join-Path $ConfigHome ".config\windows-terminal\settings.json"
        Candidates = @(
            Join-Path $env:LOCALAPPDATA "Microsoft\Windows Terminal\settings.json"
            Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
            Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
            Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminalCanary_8wekyb3d8bbwe\LocalState\settings.json"
        )
        Type = "File"
        EnsureParent = "ExistingOnly"
    }
)

function Invoke-DotfilesLink {
    param(
        [pscustomobject]$Link
    )

    if ($Link.When -is [scriptblock]) {
        if (-not (& $Link.When)) { return }
    }

    if (-not $Link.Source) {
        Write-Host "   [WARN] Missing source, skipping." -ForegroundColor Yellow
        return
    }

    $source = if ($Link.Source -is [scriptblock]) { & $Link.Source } else { $Link.Source }
    if (-not $source) {
        Write-Host "   [WARN] Source resolved to empty, skipping." -ForegroundColor Yellow
        return
    }

    if (-not (Test-Path $source)) {
        Write-Host "   [WARN] Source not found, skipping: $source" -ForegroundColor Yellow
        return
    }

    $linkType = $Link.Type
    if ($linkType -ne "File" -and $linkType -ne "Directory") {
        Write-Host "   [WARN] Invalid link type, skipping: $linkType" -ForegroundColor Yellow
        return
    }

    if ($linkType -eq "File" -and -not (Test-Path $source -PathType Leaf)) {
        Write-Host "   [WARN] Source is not a file, skipping: $source" -ForegroundColor Yellow
        return
    }

    if ($linkType -eq "Directory" -and -not (Test-Path $source -PathType Container)) {
        Write-Host "   [WARN] Source is not a directory, skipping: $source" -ForegroundColor Yellow
        return
    }

    $targets = @()
    if ($Link.Candidates) {
        $targets = $Link.Candidates
    } elseif ($Link.Target) {
        $targets = @($Link.Target)
    } else {
        Write-Host "   [WARN] Missing target, skipping." -ForegroundColor Yellow
        return
    }

    foreach ($targetEntry in $targets) {
        $target = if ($targetEntry -is [scriptblock]) { & $targetEntry } else { $targetEntry }
        if (-not $target) { continue }

        $parent = Split-Path -Parent $target
        $ensureParent = if ($Link.EnsureParent) { $Link.EnsureParent } else { "Create" }

        if ($ensureParent -eq "Create") {
            if (-not (Test-Path $parent)) {
                New-Item -ItemType Directory -Path $parent -Force | Out-Null
            }
        } elseif ($ensureParent -eq "ExistingOnly") {
            if (-not (Test-Path $parent)) {
                Write-Host "   [SKIP] Parent not found, skipping: $parent" -ForegroundColor Yellow
                continue
            }
        } else {
            Write-Host "   [WARN] Unknown EnsureParent, skipping: $ensureParent" -ForegroundColor Yellow
            continue
        }

        if (Test-Path $target) {
            $item = Get-Item $target -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                $item.Delete()
            } else {
                Remove-Item $target -Recurse -Force
            }
        }

        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
        Write-Host "   [LINK] $target -> $source" -ForegroundColor Green
    }
}

$Links | ForEach-Object { Invoke-DotfilesLink $_ }
