#Requires AutoHotkey v2.0

; -----------------------------------------------------------------------------
; Global Modifiers
; -----------------------------------------------------------------------------
; Map CapsLock to Escape
CapsLock::Esc

; QWERTZ Swap (Swap Y and Z)
$y::Send("z")
$+y::Send("Z")
$z::Send("y")
$+z::Send("Y")

; -----------------------------------------------------------------------------
; Number Row
; -----------------------------------------------------------------------------
; ` / ~ key (Top left)
$`::Send("-")
$+`::Send("~")
+<^>!`::Send("¬")

; 1 key
<^>!1::Send("∧")
+<^>!1::Send("²")

; 2 key
$+2::Send('"')
<^>!2::Send("∨")
+<^>!2::Send("³")

; 3 key
<^>!3::Send("⇒")
+<^>!3::Send("⇔")

; 4 key
<^>!4::Send("€")
+<^>!4::Send("¥")

; 5 key
+<^>!5::Send("°")

; 6 key
<^>!6::Send("±")
+<^>!6::Send("√")

; 7 key
<^>!7::Send("⊤")
+<^>!7::Send("⊥")

; 8 key
<^>!8::Send("∞")
+<^>!8::Send("VIII")

; 9 key
+<^>!9::Send("IX")

; 0 key (Standard base, no AltGr modifiers)

; - / _ key (Next to 0, physical '-' key)
$-::Send("'")
$+-::Send("?")
<^>!-::Send(",")

; = / + key (Next to Backspace)
<^>!=::Send("≈")
+<^>!=::Send("≠")

; -----------------------------------------------------------------------------
; Top Row (QWERTY row)
; -----------------------------------------------------------------------------
<^>!q::Send("\")
+<^>!q::Send("Ω")

<^>!w::Send("|")
+<^>!w::Send("β")

+<^>!r::Send("¶")

<^>!t::Send("™")

; Physical Y key (types 'z' due to QWERTZ swap)
<^>!y::Send("⧖")

; Bracket keys
<^>![::Send("š")
+<^>![::Send("Š")

<^>!]::Send("đ")
+<^>!]::Send("Đ")

; Backslash key
<^>!\::Send("ž")
+<^>!\::Send("Ž")

; -----------------------------------------------------------------------------
; Home Row (ASDF row)
; -----------------------------------------------------------------------------
<^>!a::Send("æ")
+<^>!a::Send("α")

<^>!h::Send("dž")
+<^>!h::Send("Dž")

<^>!j::Send("lj")
+<^>!j::Send("Lj")

; Semicolon key (Base and Shift pass through normally, only AltGr mapped)
<^>!;::Send("č")
+<^>!;::Send("Č")

; Quote key (Base and Shift pass through normally, only AltGr mapped)
<^>!'::Send("ć")
+<^>!'::Send("Ć")

; -----------------------------------------------------------------------------
; Bottom Row (ZXCV row)
; -----------------------------------------------------------------------------
; Physical Z key (types 'y' due to QWERTZ swap)
<^>!z::Send("§")
+<^>!z::Send("»")

+<^>!x::Send("«")

<^>!c::Send("©")

<^>!v::Send("@")
+<^>!v::Send("®")

<^>!b::Send("←")
+<^>!b::Send("→")

<^>!n::Send("nj")
+<^>!n::Send("Nj")

<^>!m::Send("↑")
+<^>!m::Send("↓")

; Comma key
$+,::Send(";")
<^>!,::Send("<")
+<^>!,::Send("×")

; Period key
$+.::Send(":")
<^>!.::Send(">")
+<^>!.::Send("÷")

; Slash key
$+/::Send("-")
<^>!/::Send("_")
