
;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------

%include "asm_io.inc"

;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------
segment .data		
	eingabetext1 db "Geben Sie die untere Grenze a ein: ", 0
	eingabetext2 db "Geben Sie die obere Grenze b ein: ", 0
	fehlermeldungA db "Achtung: a<0 nicht erlaubt!", 0
	fehlermeldungB db "Achtung: b<0 nicht erlaubt! ", 0
	fehlermeldungAB db "Achtung: b<a nicht erlaubt! ", 0
	ausgabetext db "Das Ergebnis s lautet: ", 0


;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------

segment .text
	global asm_main

asm_main:
	enter 0,0			; erzeuge stack frame (0 lokale Variablen)
	pusha				; alle Register auf dem Stack speichern


	mov eax, eingabetext1		; gebe eingabetext1 aus
	call print_string
	call read_int			; lese unteren Grenze a ein
	mov ebx, eax			; und speichere im Register ebx


	cmp ebx,0			; ueberpruefe ob a<0
	jl falseParameterA		; dann Fehlermeldung


	mov eax, eingabetext2		; gebe eingabetext2 aus
	call print_string
	call read_int			; lese obere Grenze b ein
	mov ecx, eax			; und speichere im Register ecx


	cmp ecx,0			; ueberpruefen ob b<0
	jl falseParameterB		; dann Fehlermeldung


	cmp ecx, ebx			; ueberpruefe ob b<a
	jl falseParameterAB		; dann Fehlermeldung


	mov edx, 0			; Register edx ist die Summe
					; und wird initialisiert mit 0
while:					; ebx ist ab jetzt die Variable i
	cmp ebx, ecx			; wenn i (in ebx gespeichert) gleich b ist
	je whileEnd			; dann beende while-Schleife und springe zu whileEnd
	mov eax, ebx		
	imul eax, ebx			; sonst quadriere i und speichere Quadrat in eax
	add edx, eax			; addiere Quadrat zur Summe
	inc ebx				; inkrementiere i
	jmp while			; und springe zum Anfang der while-Schleife

whileEnd:	
	mov eax, ebx		
	imul eax, ebx			; quadriere i und speichere Quadrat in eax
	add edx, eax			; addiere Quadratzahl zur Summe
	
	; gebe Ergebnis aus und Ende
	mov eax, ausgabetext		; gebe ausgabetext aus
	call print_string
	mov eax, edx			; gebe Ergebnis (in edx) aus
	call print_int
	jmp end


falseParameterA:
	mov eax, fehlermeldungA		; gebe fehlermeldungA aus
	call print_string
	jmp end


falseParameterB:
	mov eax, fehlermeldungB		; gebe fehlermeldungB aus
	call print_string
	jmp end


falseParameterAB:
	mov eax, fehlermeldungAB	; gebe fehlermeldungAB aus
	call print_string
	jmp end

	
end:
	call print_nl
	
	popa
	mov eax, 0
	leave 
	ret
