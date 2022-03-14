/*
  AutoHotkeyScript
  1. In Vim/Neovim, disable IME when transitioning to normal mode.
*/

;-----------------------------------------------------------
; Obtain IME status.
;   Target: AHK v1.0.34+
;   WinTitle : Target window (default: active window)
;   Return 1:ON 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="")
{
    ifEqual WinTitle,,  SetEnv,WinTitle,A
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32¥ImmGetDefaultIMEWnd", Uint,hWnd, Uint)

    ;Message : WM_IME_CONTROL  wParam:IMC_GETOPENSTATUS
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x005,0,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}

;-----------------------------------------------------------
; Set IME status.
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    Target Window
;   戻り値          0:Successed / other:Failed
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")
{
  ControlGet,hwnd,HWND,,,%WinTitle%
  if (WinActive(WinTitle)) {
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
  }

  return DllCall("SendMessage"
        , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
        , UInt, 0x0283  ;Message : WM_IME_CONTROL
        ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
        ,  Int, SetSts) ;lParam  : 0 or 1
}

;---------------------------------------------------------------------
; Disable IME when entering normal mode in Vim/Neovim.

; Application Group
GroupAdd VimEditor, ahk_exe WindowsTerminal.exe
GroupAdd VimEditor, ahk_exe nvim-qt.exe

; ESC to control IME.
#IfWinActive, ahk_group VimEditor
Esc::
^[::
  if (IME_GET()) {
    IME_SET(0)
  }
  Send, {Esc}
  Return
#IfWinActive
