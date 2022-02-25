# Install environment for windows
#   Usage: set-envvars [source root directory path]

# set environment value
function Set-UserEnvironmentVariable($name, $value) {
  [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::User)
}

function Set-SystemEnvironmentVariable($name, $value) {
  [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Machine)
}

$srcRootDir = $Args[0]
if (-not (Test-Path $srcRootDir)) {
  Write-Error ("Invalid source root directory path. [" + $srcRootDir + "]")
  exit 1
}

Write-Output "Start - install environment for windows ..."

# Setting parameters
$homeDir = Convert-Path "~/"
Write-Output ("[Home directory path] - " + $homeDir)

$configsDir = Join-Path $srcRootDir "configs"

###########################################################
# Load config file
###########################################################
$configPath = Join-Path $configsDir "install.json"
if (!(Test-Path $configPath)) {
  Write-Error ($configPath + " is not exists.")
  exit 1
}

try {
  $config = ConvertFrom-JSON -InputObject (Get-Content $configPath -Raw)
} catch {
  Write-Error $_.Exception.Message
  exit 1
}

# Combine config
$linkFiles = @()

if ($config.common) {
  $linkFiles += $config.common.linkFiles
}

if ($config.windows) {
  $linkFiles += $config.windows.linkFiles
}

###########################################################
# Set environment values
###########################################################
Write-Output "Set environment values ..."

# Get Neovim path
$nvimCommand = "nvim"
if (-not (Get-Command $nvimCommand -ea SilentlyContinue)) {
  Write-Error ($nvimCommand + " command not found. Please check the setting of the `$PATH")
  exit 1
}

$nvimPath = (Get-Command $nvimCommand).Source
# The root directory is two levels higher
$nvimRootPath = Split-Path -Parent (Split-Path -Parent $nvimPath)


# Set VIMRUNTIME path
$nvimRuntimePath = Join-Path $nvimRootPath "share\nvim\runtime"
if (-not (Test-Path $nvimRuntimePath)) {
  Write-Error ("Not exists Neovim runtime path. (" + $nvimRuntimePath + ")")
  exit 1
}

$envName = "VIMRUNTIME"
Set-SystemEnvironmentVariable $envName $runtimePath
Write-Output ("[Set system environment] - " + $envName + " : " + $nvimRuntimePath)

# Set XDG_CONFIG_HOME path
$envName = "XDG_CONFIG_HOME"
Set-SystemEnvironmentVariable $envName $runtimePath
Set-UserEnvironmentVariable $envName $homeDir
Write-Output ("[Set user environment] - " + $envName + " : " + $homeDir)

###########################################################
# Create symbolic links
###########################################################
Write-Output ""
Write-Output "Create link files ..."

foreach ($linkFile in $linkFiles) {
  $targetPath = Join-Path $srcRootDir $linkFile.target
  foreach ($link in $linkFile.link) {
    $linkPath = Join-Path $homeDir $link
    if (Test-Path $linkPath) {
      Remove-Item -Path $linkPath
    }

    if (-not (Test-Path $targetPath)) {
      Write-Error ($targetPath + " is not exists")
      exit 1
    }

    New-Item -ItemType SymbolicLink -Path $linkPath -Value $targetPath | Out-Null
    Write-Output ("[Create link] - " + $linkPath + " => " + $targetPath)
  }
}
