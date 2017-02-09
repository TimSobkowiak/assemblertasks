;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                      ;
;        Assembler Programm zur Berechnung von i Fakultät              ;
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

        push ebp
        mov ebp, esp
        ; sub esp, 4 dieser mit den letzten beiden Befehlen zusammen
        ; entspricht enter, 4,0 - hierbei wird Platz fuer eine
        ; lokale Variable reserviert. Da wir diesen Platz nicht
        ; benoetigen kommentieren wir die Zeile aus.
        
        pusha
        
        
        ; Ausgabe der Eingabeaufforderung und einlesen von i
        mov     eax, eingabe
        call    print_string
        call    read_int
        mov     ebx, eax        ; i in ebx zwischenspeichern

        ; Damit das Ergebnis der Funktion in n gespeichert werden kann
        ; muss die Adresse von n auf den Stack gelegt werden.
        ; Außerdem wird i ueber den Stack uebergeben
        push    dword n                 
        push    eax

        call    produkt         ; Funktionsaufruf
        add     esp, 8          ; Parameter vom Stack nehmen

        ; Ergebnis ausgeben
        mov     eax, ebx
        call    print_int
        mov     eax, ausgabe
        call    print_string
        
        ; Ergebnis aus n nach eax kopieren
        mov     eax, [n]
        call    print_int
        call    print_nl
        
        ; Rückkehr zu C
        popa
        mov     eax, 0
        leave
        ret

produkt:
        push    ebp\texttt{\textbackslash usepackage\{multirow\}}
        mov     ebp, esp
        ; wir benoetigen keinen Platz fuer lokale Variablen, s.o.
        ; sub     esp, 4 
        
        ; sichern der Register
        ; alternativ: push ebx
        pusha
        
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
    
        ; wiederherstellen der Register
        ; alternativ: pop ebx
        popa
        mov     eax, 0
        mov     esp, ebp
        pop     ebp

        ret
        
