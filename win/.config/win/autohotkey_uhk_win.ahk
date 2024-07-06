#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; useful for UHK keyboard on Windows
; only map Swedish characters and arrow keys

; åäöÅÄÖ via Alt right (US keyboard layout is a system setting)
>!SC01A::Send {U+00E5}
>!SC028::Send {U+00E4}
>!SC027::Send {U+00F6}
>!+SC01A::Send {U+00C5}
>!+SC028::Send {U+00C4}
>!+SC027::Send {U+00D6}

; arrow keys via Alt right and hjkl
>!SC023::SendInput,{Left}
>!SC024::SendInput,{Down}
>!SC025::SendInput,{Up}
>!SC026::SendInput,{Right}
>!+SC023::SendInput,+{Left}
>!+SC024::SendInput,+{Down}
>!+SC025::SendInput,+{Up}
>!+SC026::SendInput,+{Right}
