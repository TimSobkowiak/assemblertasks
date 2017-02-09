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
	ausgabe1Msg db "Die Potenz a^b lautet: ", 0
	ausgabe2Msg db "Die Potenz b^a lautet: ", 0



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
	mov ebx, eax		; und speichere im Register ebx

	mov eax, eingabe2Msg	; gebe eingabe2Msg aus
	call print_string
	call read_int		; lese b ein
	mov ecx, eax		; und speichere im Register ecx


	; Berechnung von a^b mittels Unterprogramm potenz und Ausgabe
	push ebx		; lege Parameter a auf den Stack
	push ecx		; lege Parameter b auf den Stack
	call potenz		; rufe Unterprogramm potenz auf
	mov edx, eax		; sichere Ergebnis aus dem eax-Register ins edx
	mov eax, ausgabe1Msg	; lade ausgabe1Msg
	call print_string	; und gebe aus
	mov eax, edx		; lade Ergebnis a^b
	call print_int 		; und gebe aus
	pop ecx			; nehme Parameter b vom Stack
	pop ebx			; nehme Parameter a vom Stack
	call print_nl


	; Berechnung von b^a mittels Unterprogramm potenz und Ausgabe
	push ecx		; lege Parameter b auf den Stack
	push ebx		; lege Parameter a auf den Stack
	call potenz		; rufe Unterprogramm potenz auf
	mov edx, eax		; sichere Ergebnis aus dem eax-Register ins edx
	mov eax, ausgabe2Msg	; lade ausgabe2Msg
	call print_string	; und gebe aus
	mov eax, edx		; lade Ergebnis b^a
	call print_int 		; und gebe aus
	pop ebx			; nehme Parameter a vom Stack
	pop ecx			; nehme Parameter b vom Stack
	call print_nl
	

	popa
	mov eax, 0
	leave 
	ret




; Unterprogramm potenz
potenz:	
	push ebp		; ebp-Inhalt wird auf Stack gesichert
	mov ebp, esp		; ebp zeigt auf esp-Inhalt im Stack

	
	; hole übergebene Parameter vom Stack
	mov eax, [ebp+12]	; hole a vom Stack
	mov ebx, eax		; und speichere im Register ebx
	
	mov eax, [ebp+8]	; hole b vom Stack
	mov ecx, eax		; und speichere im Register ecx
	

	; Berechnung der Potenz a^b (das Ergebnis wird in eax gespeichert)
	mov eax,1		; schreibe eine 1 ins Ergebnis-Register 

Schleife: 
  	cmp ecx,0		; vgl. ob Schleifenzaehler bzw b = 0
	je SchleifeBeenden	; wenn b = 0, dann beende Schleife
	mul ebx			; sonst multipliziere mit a
	sub ecx,1		; Zaehlvariable (der Schleife) dekrementieren
	jmp Schleife		; und nächste Iteration

SchleifeBeenden:
	mov esp, ebp
	pop ebp
	ret


