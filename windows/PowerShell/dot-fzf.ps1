# Interactively select a dot target, profile, and set of jobs.
#
# Usage:
#   dot-fzf             # preview the selected jobs
#   dot-fzf dry-run     # preview the selected jobs
#   dot-fzf apply       # execute the selected jobs
function global:Invoke-DotFzf {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet("dry-run", "apply")]
        [string] $Mode = "dry-run"
    )

    foreach ($dependency in @("dot", "fzf")) {
        if (-not (Get-Command $dependency -ErrorAction SilentlyContinue)) {
            throw "dot-fzf: required command not found: $dependency"
        }
    }

    $targetFzfArguments = @(
        "--prompt=target> ",
        "--height=60%",
        "--layout=reverse",
        "--border",
        "--header=Select a compatible target"
    )
    $targetRows = @(dot list targets | fzf @targetFzfArguments)
    $targetSelectionSucceeded = $?
    if (-not $targetSelectionSucceeded -or $targetRows.Count -eq 0) {
        return
    }
    $target = ($targetRows[0] -split "`t", 2)[0]

    $profileFzfArguments = @(
        "--prompt=profile> ",
        "--height=60%",
        "--layout=reverse",
        "--border",
        "--header=Select a profile"
    )
    $profileRows = @(dot list profiles --target $target | fzf @profileFzfArguments)
    $profileSelectionSucceeded = $?
    if (-not $profileSelectionSucceeded -or $profileRows.Count -eq 0) {
        return
    }
    $selectedProfile = ($profileRows[0] -split "`t", 2)[0]

    $jobFzfArguments = @(
        "--multi",
        "--prompt=jobs> ",
        "--height=80%",
        "--layout=reverse",
        "--border",
        "--header=Select jobs (Tab: toggle, Ctrl-A: all, Ctrl-D: none)",
        "--bind=ctrl-a:select-all,ctrl-d:deselect-all"
    )
    $jobRows = @(dot list jobs --target $target --profile $selectedProfile | fzf @jobFzfArguments)
    $jobSelectionSucceeded = $?
    if (-not $jobSelectionSucceeded -or $jobRows.Count -eq 0) {
        return
    }

    $dotArguments = @(
        $Mode,
        "--target", $target,
        "--profile", $selectedProfile
    )
    foreach ($row in $jobRows) {
        $selector = ($row -split "`t", 2)[0]
        $dotArguments += @("--job", $selector)
    }

    dot @dotArguments
}

Set-Alias -Name dot-fzf -Value Invoke-DotFzf -Scope Global
