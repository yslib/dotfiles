$ErrorActionPreference = "Stop"

$dotRelease = "https://github.com/yslib/dot/releases/latest/download/dot-windows-x86_64.exe"
$dotBinDir = Join-Path $HOME ".local\bin"
$dotExe = Join-Path $dotBinDir "dot.exe"
$dotfilesRepo = "https://github.com/yslib/dotfiles.git"
$dotfilesDir = Join-Path $HOME ".dotfiles"

foreach ($program in @("scoop", "git")) {
    if (-not (Get-Command $program -ErrorAction SilentlyContinue)) {
        throw "dot bootstrap: $program is required"
    }
}

$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
if ($architecture -ne [System.Runtime.InteropServices.Architecture]::X64) {
    throw "dot bootstrap: unsupported Windows architecture: $architecture"
}

if (Test-Path $dotfilesDir) {
    throw "dot bootstrap: $dotfilesDir already exists"
}

New-Item -ItemType Directory -Path $dotBinDir -Force | Out-Null
Invoke-WebRequest -UseBasicParsing -Uri $dotRelease -OutFile $dotExe

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$userPathEntries = @($userPath -split ";" | Where-Object { $_ })
if ($userPathEntries -notcontains $dotBinDir) {
    [Environment]::SetEnvironmentVariable(
        "Path",
        (@($dotBinDir) + $userPathEntries) -join ";",
        "User"
    )
}
$env:Path = "$dotBinDir;$env:Path"

& git clone $dotfilesRepo $dotfilesDir
if ($LASTEXITCODE -ne 0) {
    throw "dot bootstrap: failed to clone $dotfilesRepo"
}

& $dotExe --config (Join-Path $dotfilesDir "dot.toml")
if ($LASTEXITCODE -ne 0) {
    throw "dot bootstrap: dot exited with code $LASTEXITCODE"
}
