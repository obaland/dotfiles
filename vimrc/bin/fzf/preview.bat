@rem Script for FZF preview
@echo off

set TARGET=%1
for /f "tokens=1,2 delims=:" %%a in (%TARGET%) do (
  set FILE=%%~dpa%%~nxa
  set CENTER=%%b
)

if not exist %FILE% (
  echo File not found %FILE%
  exit 1
)

if "%CENTER%" == "" (
  set CENTER=0
)

cmd /c where /q bat
if ERRORLEVEL 1 (
  cmd /c type %FILE%
) else (
  cmd /c bat --style=numbers,changes --color=always --pager=never --highlight-line=%CENTER% -- %FILE%
)
