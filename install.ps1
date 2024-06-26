# Install environment for windows
#=============================================================================

# Confirmation of administrative privileges.
#-----------------------------------------------------------------------------
$wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
$admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if (!$prp.IsInRole($admin)) {
  "This program must be run with administrative privileges."
  pause
  exit 1
}

Write-Output "***** Start installation. *****"

$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# set environment value
function Set-UserEnvironmentVariable($name, $value) {
  [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::User)
}

function Set-SystemEnvironmentVariable($name, $value) {
  [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Machine)
}

# create link file
function Link($targetPath, $linkPath) {
  if (Test-Path -Path $linkPath) {
    Remove-Item -Path $linkPath
  }
  New-Item -ItemType SymbolicLink -Path $linkPath -Value $targetPath | Out-Null
  "[Link] - " + $linkPath + " => " + $targetPath
}

Write-Output "Start - install environment for windows ..."

# Setting parameters
$homeDir = Convert-Path "~/"
Write-Output ("[Home directory path] - " + $homeDir)

# Set environment values
#-----------------------------------------------------------------------------
"Set environment values ..."

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
"[Set system environment] - " + $envName + " : " + $nvimRuntimePath

# Set XDG_CONFIG_HOME path
$envName = "XDG_CONFIG_HOME"
Set-SystemEnvironmentVariable $envName $runtimePath
Set-UserEnvironmentVariable $envName $homeDir
"[Set user environment] - " + $envName + " : " + $homeDir

# tmux
#-----------------------------------------------------------------------------
$tmuxDir = Join-Path $homeDir ".tmux"
$tpmDir = Join-Path $tmuxDir "plugins/tpm"
if (-not (Test-Path -Path $tmuxDir)) {
  # Install .tmux and tpm
  git clone https://github.com/gpakosz/.tmux.git $tmuxDir
  git clone https://github.com/tmux-plugins/tpm $tpmDir
}
Link (Join-Path $tmuxDir ".tmux.conf") (Join-Path $homeDir ".tmux.conf")
Link (Join-Path $currentDir "tmux/.tmux.conf") (Join-Path $homeDir ".tmux.conf.local")

# Create symbolic links
#-----------------------------------------------------------------------------
""
"Create link files ..."

$linkFiles = @(
  @{"target" = "vimrc"; "link" = @(".vim"; "nvim")}
  @{"target" = "vimrc/vimrc"; "link" = @(".vimrc")}
  @{"target" = "theme.omp.json"; "link" = @(".theme.omp.json")}
  @{"target" = "ps/terminal-settings.json"; "link" = @("AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json")}
)

foreach ($linkFile in $linkFiles) {
  $targetPath = Join-Path $currentDir $linkFile.target
  foreach ($link in $linkFile.link) {
    if (-not (Test-Path $targetPath)) {
      Write-Error ($targetPath + " is not exists")
      exit 1
    }

    $linkPath = Join-Path $homeDir $link
    $destDir = [System.IO.Path]::GetDirectoryName($linkPath)
    if (-not (Test-Path -Path $destDir)) {
      New-Item -Path $destDir -ItemType Directory -Force | Out-Null
    }

    Link $targetPath $linkPath
  }
}

# Create profile and theme.
#-----------------------------------------------------------------------------
""
"Copy profile ..."
$profilePath = Join-Path $currentDir "ps/Profile.ps1"
$destDir = [System.IO.Path]::GetDirectoryName($PROFILE)
if (-not (Test-Path -Path $destDir)) {
  New-Item -Path $destDir -ItemType Directory -Force | Out-Null
}
Copy-Item -Path $profilePath -Destination $PROFILE -Force | Out-Null
"[Copied] - " + $profilePath + " -> " + $PROFILE

""
"Done."
