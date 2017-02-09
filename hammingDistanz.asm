;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------


%include "asm_io.inc"


;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------


segment .data		
	codewort1 dd 11001111b
	codewort2 dd 11110011b
		     
	outputMsg db "Ergebnis: ", 0


;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------


segment .text
	global asm_main

asm_main:
	enter 0,0		; erzeuge stack frame (0 lokale Variablen)
	pusha			; alle Register auf dem Stack speichern

	mov ebx, [codewort1] 	; speichere codewort1 ins ebx-Register
	mov ecx, [codewort2]	; speichere codewort2 ins ecx-Register

	xor ebx, ecx		; "xor-e" beide Codewörter, 
				; wir erhalten eine Binärzahl in ebx; 
				; die Bitstellen der Binärzahl, 
				; die mit 1 belegt sind, sind die Positionen  
				; an denen sich die Codewörter in der Bitbelegung unterscheiden

	; wir schieben 32 mal jeweils ein Bit aus der Binärzahl, die in ebx ist, ins Carryflag
	; falls eine 1 herausgeschoben wird, so zählen wir diese;
	; die Gesamtanzahl der 1en ist die Hamming-Distanz beider Codewörter

	mov edx, 0	; edx ist Einsenzähler (Hamming-Distanz), wird zunächst mit 0 initialisiert
	mov ecx, 32	; ecx ist Schleifenzähler, wird mit 32 initialisiert

loopBegin:
	shl ebx, 1	; schiebe Bit ins Carryflag (CF)
	jnc skipInc	; wenn CF=0, dann springe zu skipInc
	inc edx		; sonst (wenn CF=1) dann inkrementiere edx (also registriere die Eins)
	
skipInc:
	loop loopBegin	; springe zum Schleifenanfang


	mov eax, outputMsg	; gebe outputMsg aus
	call print_string

	mov eax, edx		; gebe Ergebnis aus
	call print_int
	call print_nl

	popa
	mov eax, 0
	leave 
	ret


