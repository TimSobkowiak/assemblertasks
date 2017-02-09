;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                      ;
;        Assembler Programm zur Berechnung von i Fakultaet              ;
;                                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "asm_io.inc"

segment .data

eingabe db      "Geben Sie eine positive ganze Zahl i ein. ", 0
ausgabe db      "! = ", 0

segment .bss

n       resd    1

segment .text

        global asm_main

asm_main:

        push    ebp
        mov     ebp, esp
        sub     esp, 4
        pusha
        
        ; Ausgabe der Eingabeaufforderung und einlesen von i
        mov     eax, eingabe
        call    print_string
        call    read_int
        mov     ebx, eax        ; i in ebx zwischenspeichern

        ; Damit das Ergebnis der Funktion in n gespeichert werden kann,
        ; muss die Adresse von n auf den Stack gelegt werden.
        ; Ausserdem wird i ueber den Stack uebergeben.
        push    dword n                 
        push    eax

        call    produkt         ; Funktionsaufruf

        ; Ergebnis ausgeben
        mov     eax, ebx
        call    print_int
        mov     eax, ausgabe
        call    print_string
        
        ; Ergebnis aus n nach eax kopieren
        mov     eax, [n]
        call    print_int
        call    print_nl
        
        ; Rueckkehr zu C
        popa
        mov     eax, 0
        leave
        ret

produkt:
        ; Funktionseintritt
        push    ebp
        mov     ebp, esp
        sub     esp, 4 
        
        mov     ebx, [ebp+8]            ; i in ebx speichern
        mov     eax, 1                  ; fakultaet mit 1 initialisieren
        
        ; Berechne i! in einer Schleife
    while:
        cmp     ebx, 1                  ; wenn ecx 1 ist sind wir fertig
        je      end_while
        
        imul    eax, ebx                ; sonst eax *= ebx
        dec     ebx                     ; ebx fuer den naechsten Schritt dekrementieren
        jmp     while                   ; Sprung zum Schleifenanfang
    
    end_while:
        ; kopiere Ergebnis an uebergebene Adresse (Adresse von n)
        mov     ebx, [ebp+12]
        mov     [ebx], eax
    
        ; Rueckkehr zum Aufrufer
        mov     eax, 0
        mov     esp, ebp
        pop     ebp
        ret
        
