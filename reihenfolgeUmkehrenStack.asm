;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------


%include "asm_io.inc"


;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------


segment .data
	inputMsg1 db "Geben Sie die ", 0
	inputMsg2 db ". Zahl ein: ", 0
	
	outputMsg db "Ihre eingegebenen Zahlen in umgekehrter Einlesereihenfolge: ", 0
	space db " ",0
	
	numberOfNumbers dd 7	; hier wird die Anzahl der einzulesenden Zahlen festgelegt


;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------


segment .text
	global asm_main

asm_main:
	enter 0,0		; erzeuge stack frame (0 lokale Variablen)
	pusha			; alle Register auf dem Stack speichern


	; Einlesen der Zahlen mittels Schleife, wird [numberOfNumbers]-mal wiederholt

	; initialisiere Schleifenzähler mit [numberOfNumbers]
	mov ecx, [numberOfNumbers]

InputLoop:
	; gebe inputMsg1 aus
	mov eax, inputMsg1	
	call print_string

	; gebe in der Eingabeaufforderung an/aus, welche x-te Zahl jetzt eingelesen wird
	; z.B. "Geben Sie die 5. Zahl ein:" (hier x=5)
	; x = [numberOfNumbers]+1-ecx, d.h. x = 7+1-(aktuellerSchleifenzähler)
	mov eax, [numberOfNumbers]
	add eax, 1
	sub eax, ecx
	call print_int

	; gebe inputMsg2 aus
	mov eax, inputMsg2	
	call print_string

	; lese die Zahl ein und speichere auf dem Stack
	call read_int		
	push eax		; auf den Stack "pushen"

	; Sprung zu Label "InputLoop" zwecks nächstem Schleifendurchlauf
	loop InputLoop		
	

	; Ausgabe der Zahlen mittels Schleife, wird [numberOfNumbers]-mal wiederholt

	; gebe outputMsg aus
	mov eax, outputMsg
	call print_string
	call print_nl

	; initialisiere Schleifenzähler mit [numberOfNumbers]
	mov ecx,  [numberOfNumbers]

OutputLoop:
	; hole TOS (Top Of Stack) und Ausgabe
	pop eax			; entnehme TOS, TOS wird in eax gespeichert
	call print_int		; gebe Wert in eax aus

	; gebe ein Leerzeichen aus
	mov eax, space
	call print_string
      
	; Sprung zu Label "OutputLoop" zwecks nächstem Schleifendurchlauf
	loop OutputLoop


	call print_nl
	
	popa
	mov eax, 0
	leave 
	ret
