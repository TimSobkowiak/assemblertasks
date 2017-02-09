;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------

%include "asm_io.inc"

;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------
segment .data		
	inputMsg db "Geben Sie die Zahl z ein: ", 0
	inputMsg2 db "Geben Sie die Zahl b mit 0<b<=32 ein: ", 0
	outputMsg db "Die veränderte Zahl z' lautet: ", 0

;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------

segment .text
	global asm_main

asm_main:
	enter 0,0		; erzeuge stack frame (0 lokale Variablen)
	pusha			; alle Register auf dem Stack speichern


	; Eingabe ----------------------------------------------------------


	; gebe inputMsg aus (Eingabeaufforderung für z)
	mov eax, inputMsg
	call print_string


	; lese Zahl z und speichere im Register edx
	call read_int
	mov edx, eax


	; gebe inputMsg2 aus (Eingabeaufforderung für b)
	mov eax, inputMsg2
	call print_string


	; lese Zahl b und speichere im Register ecx
	call read_int 
	mov ecx, eax


	; Berechnung (Invertierung des b-ten Bits in Zahl z) ---------------


	; erstelle eine Bitmaske in ebx
	mov ebx, 1	; initialisiere mit einer 1 (alle Bits bis auf das rechte Bit sind 0),
			; in ecx steht die Bitposition b, die invertiert werden soll,
			; wir verwenden die Bitposition, um die jetzige Bitmaske zu erstellen,
			; indem wir die 1 in der Bitmaske (b-1) mal nach links shiften,
			; d.h. b im ecx muss (einmal) dekrementiert
	dec ecx		; -> dekrementiere ecx
			; und dann zum shiften verwendet werden,
			; shl-Befehl erwartet aber das cl Register als 2. Argument
			; (cl Register ist das untere 8 Bit Register von ecx)
	shl ebx, cl 	; schiebe 1 in ebx um cl Positionen nach links

    
	; Bit-Invertierung an Position b in Zahl z durch "xor-en" mit Bitmaske
	xor edx, ebx	; Bit-Maske in ebx auf edx anwenden


	; Ausgabe  ----------------------------------------------------------


	; gebe Ausgabetext 
	mov eax, outputMsg
	call print_string
    

	; und Ergebnis (veränderte Zahl z') aus und Ende
	mov eax, edx
	call print_int


	call print_nl
	
	popa
	mov eax, 0
	leave 
	ret


