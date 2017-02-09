%include "asm_io.inc"

segment .data		
    codewort1 dd 11001111b
    codewort2 dd 11110011b 
    outputMsg db "Ergebnis: ", 0
segment .bss
segment .text
    global asm_main

asm_main:
    enter 0,0		
    pusha	

    mov ebx, [codewort1] 
    mov ecx, [codewort2]

    xor ebx, ecx

    mov edx, 0	
    mov ecx, 32
	
loopBegin:
    shl ebx, 1	
    jnc skipInc	
    inc edx

skipInc:
    loop loopBegin

    mov eax, outputMsg
    call print_string

    mov eax, edx
    call print_int
    call print_nl
    
    popa
    mov eax, 0
    leave 
    ret
