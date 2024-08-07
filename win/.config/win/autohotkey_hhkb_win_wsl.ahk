; HHKB keyboard - AutoHotkey version 1 script

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; remap left ctrl to esc on tap, ctrl when used with other key
~LCtrl Up::
if (A_PriorKey = "LControl") {
  Send {Esc}
}

; see: https://gist.github.com/sedm0784/4443120 for inspiration
; g_LastCtrlKeyDownTime := 0
; g_AbortSendEsc := false
; g_ControlRepeatDetected := false

; *Ctrl::
; if (g_ControlRepeatDetected)
; {
;   return
; }
; send,{Ctrl down}
; g_LastCtrlKeyDownTime := A_TickCount
; g_AbortSendEsc := false
; g_ControlRepeatDetected := true
; return

; *Ctrl Up::
; send,{Ctrl up}
; g_ControlRepeatDetected := false
; if (g_AbortSendEsc)
; {
;   return
; }
; current_time := A_TickCount
;   time_elapsed := current_time - g_LastCtrlKeyDownTime
; if (time_elapsed <= 250)
; {
;   SendInput {Esc}
; }
; return

~*^a::
~*^b::
~*^c::
~*^d::
~*^e::
~*^f::
~*^g::
~*^h::
~*^i::
~*^j::
~*^k::
~*^l::
~*^m::
~*^n::
~*^o::
~*^p::
~*^q::
~*^r::
~*^s::
~*^t::
~*^u::
~*^v::
~*^w::
~*^x::
~*^y::
~*^z::
~*^1::
~*^2::
~*^3::
~*^4::
~*^5::
~*^6::
~*^7::
~*^8::
~*^9::
~*^0::
~*^Space::
~*^Backspace::
~*^Delete::
~*^Insert::
~*^Home::
~*^End::
~*^PgUp::
~*^PgDn::
~*^Tab::
~*^Return::
~*^,::
~*^.::
~*^/::
~*^;::
~*^'::
~*^[::
~*^]::
~*^\::
~*^-::
~*^=::
~*^`::
~*^F1::
~*^F2::
~*^F3::
~*^F4::
~*^F5::
~*^F6::
~*^F7::
~*^F8::
~*^F9::
~*^F10::
~*^F11::
~*^F12::
; uncomment line below for other type of ctrl/esc key mapping
; g_AbortSendEsc := true
return


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
