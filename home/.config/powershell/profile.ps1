# ── Dotfiles PowerShell profile ──────────────────────────────────
# Windows equivalent of .zshrc — managed by dotfiles repo.

# ── Editor ──────────────────────────────────────────────────────
$env:EDITOR = "nvim"

# ── Aliases ─────────────────────────────────────────────────────
Set-Alias -Name lg  -Value lazygit

# ── Zoxide (cd replacement) ─────────────────────────────────────
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ── Fzf integration (PSFzf) ────────────────────────────────────
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider      'Ctrl+t' `
                    -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ── Yazi: change working directory on exit (like the zsh `y` function) ──
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content $tmp -ErrorAction SilentlyContinue
    if ($cwd -and $cwd -ne $PWD.Path) {
        Set-Location $cwd
    }
    Remove-Item $tmp -ErrorAction SilentlyContinue
}
