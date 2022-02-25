# Install packages for windows
#   use Chocolatey (The Package Manager for Windows: https://chocolatey.org/)

Write-Output "Check chocolatey command."
if (-not (Get-Command "choco" -ea SilentlyContinue)) {
  Write-Output "Not installed chocolatey command. Installing..."

  # Install command.
  Set-ExecutionPolicy Bypass -Scope Process -Force; `
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
  Write-Output "Installed chocolatey command."
}

$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageFile = Join-Path $currentDir "chocolatey-package.config"

choco install $packageFile --yes
