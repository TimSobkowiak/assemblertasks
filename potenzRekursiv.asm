;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------


%include "asm_io.inc"


;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------


segment .data		
	eingabe1Msg db "Geben Sie ein a>=0 ein: ", 0
	eingabe2Msg db "Geben Sie ein b>=0 ein: ", 0
	ausgabeMsg db "a^b = ", 0


;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------


segment .text
	global asm_main

asm_main:
	enter 0,0		; erzeuge stack frame (0 lokale Variablen)
	pusha			; alle Register auf dem Stack speichern
	

	; Interaktives Einlesen der Zahlen a und b
	mov eax, eingabe1Msg	; gebe eingabe1Msg aus
	call print_string
	call read_int		; lese a ein
	push eax		; lege a auf den Stack

	mov eax, eingabe2Msg	; gebe eingabe2Msg aus
	call print_string
	call read_int		; lese b ein
	push eax		; lege b auf den Stack


	; Berechnung von a^b mittels Unterprogramm potenz und Ausgabe
	call potenz		; potenz(a,b) aufrufen
				; Eingabeparameter sind auf dem Stack:
				; a unter der Adresse ebp+12
				; b unter der Adresse ebp+8
				; Ausgabeparameter in eax
	pop ecx			; bereinige Stack, entferne b
	pop edx			; bereinige Stack, entferne a
	mov ebx,eax		; Speichern des Ergebnisses in ebx


	; Ausgeben des Ergebnisses a^b und Ende
	mov eax, ausgabeMsg	; gebe ausgabeMsg aus
	call print_string
	mov eax, ebx		; gebe Ergebnis aus
	call print_int
	call print_nl

	popa			; Register vom Stack nehmen
	mov eax, 0		; Erfolg, d.h. Rueckgabewert=0
	leave			; zerstoere Stack Frame
	ret			; return, EIP vom Stack holen



; Unterprogramm
potenz:	
	push ebp		; ebp-Inhalt wird auf Stack gesichert
	mov ebp, esp		; ebp zeigt auf ebp-Inhalt im Stack
	
	mov eax, [ebp+8]	; hole b vom Stack
	
	cmp eax, 0		; ist b=0?
	je b0			; wenn ja, eax = 1 (springe zu b0)
	dec eax			; sonst b = b-1

	mov ebx, eax		; speichere b im ebx
	mov eax, [ebp+12]	; hole a vom Stack
	
	push eax		; lege a auf Stack
	push ebx		; lege b auf Stack

	call potenz		; rekursiver Aufruf potenz(a,b-1)

	mov esp, ebp		; bereinige Stack, entferne a,b

	imul eax, [ebp+12]	; eax * a = potenz(a,b-1)*a
	jmp potenzEnde		; springe zum Ende

b0:	
	mov eax, 1
	jmp potenzEnde

potenzEnde:
	mov esp, ebp
	pop ebp

	ret
	