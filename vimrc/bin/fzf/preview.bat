@echo off

set FILE="%1"

if not exist %FILE% (
  echo File not found %FILE%
  exit 1
)

cmd /c where /q bat
if ERRORLEVEL 1 (
  cmd /c type %FILE%
) else (
  rem TODO
  cmd /c bat --style=numbers,changes --color=always --line-range :100 --theme="Solarized (dark)" %FILE%
)
