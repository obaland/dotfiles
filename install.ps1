# Install environment for windows

Write-Output "***** Start installation. *****"

$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptDir = Join-Path (Join-Path $currentDir "scripts") "ps"

# Install packages
$scriptPath = Join-Path $scriptDir "install-packages.ps1"
& $scriptPath

# Set environment variables
$scriptPath = Join-Path $scriptDir "set-envvars.ps1"
& $scriptPath $currentDir

Write-Output ""
Write-Output "Done."
