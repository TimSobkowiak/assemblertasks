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
	enter 0,0
	pusha


	mov eax, eingabetext1
	call print_string
	call read_int
	mov ebx, eax


	cmp ebx,0
	jl falseParameterA


	mov eax, eingabetext2
	call print_string
	call read_int
	mov ecx, eax


	cmp ecx,0
	jl falseParameterB


	cmp ecx, ebx
	jl falseParameterAB


	mov edx, 0

while:
	cmp ebx, ecx
	je whileEnd
	mov eax, ebx
	imul eax, ebx
	add edx, eax
	inc ebx
	jmp while

whileEnd:	
	mov eax, ebx
	imul eax, ebx
	add edx, eax
	
	
	mov eax, ausgabetext
	call print_string
	mov eax, edx
	call print_int
	jmp end


falseParameterA:
	mov eax, fehlermeldungA
	call print_string
	jmp end


falseParameterB:
	mov eax, fehlermeldungB
	call print_string
	jmp end


falseParameterAB:
	mov eax, fehlermeldungAB
	call print_string
	jmp end

	
end:
	call print_nl
	
	popa
	mov eax, 0
	leave 
	ret
