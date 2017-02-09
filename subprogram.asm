%include "asm_io.inc"

segment .data		
	x dd 2
	y dd 3

segment .text
	global asm_main

asm_main:
	enter 0,0
	pusha		
	
	mov eax,[x] 
	; Stack und ebp/esp als Beispiel vorgegeben
	push eax 
	; Stack und ebp/esp als Beispiel vorgegeben
	
	mov eax,[y]
	push eax 
	;a) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an

	call subprogram
	
	;g) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an
	pop ecx
	pop edx
	;h) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an

	call print_int
	call print_nl

	popa
	mov eax, 0
	leave
	ret

subprogram:
	;b) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an
	push ebp
	mov ebp,esp
	;c) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an
	
	mov eax,[ebp+12]
	mov ebx,[ebp+8]

	add eax,ebx
	push eax
	;d) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an

	mov esp,ebp
	;e) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an
	pop ebp
	;f) Geben den Zustand des Stacks und der ebp/esp Register zu diesem Zeitpunkt an

	ret
	
