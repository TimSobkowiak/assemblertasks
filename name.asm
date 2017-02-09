; Loesungsvorschlag Blatt 3, Aufgabe 5

; Using Linux and gcc:
; nasm -f elf name.asm
; gcc -o name name.o driver.c asm_io.o

%include "asm_io.inc"

segment .data                  ;fuer initialisierte Variablen

; Labels fuer die Ausgabe
name db    "Informatik 2", 0   ;diese Zeichenkette in den Namen aendern

segment .bss                   ;wird nicht benoetigt

;
; .text fuer den eigentlichen Programmcode
;
segment .text
        global  asm_main
asm_main:
        enter   0,0            ; Anfangsroutine
        pusha

        mov     eax, name      ; Lade Adresse des Strings in eax
        call    print_string   ; und gebe diesen aus

        popa
        mov     eax, 0         ; Ruecksprung zu C
        leave                     
        ret


