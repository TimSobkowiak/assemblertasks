;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------


%include "asm_io.inc"


;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------


segment .data		

	; Variablen mit Ausgabetext
	inputMsg db "Zur iterativen Berechnung von S_n bitte n mit n>=0 eingeben: ", 0
	output1Msg db "S_", 0
	output2Msg db " = ", 0

	;(Hilfs-)Variablen mit Wert
	S_0 dd 0	; S_0 = 0
	S_1 dd 1	; S_1 = 1
	S_2 dd 2	; S_2 = 2
	i dd 0		; Schleifenzaehler


segment .bss

	; Variablen zum Speichern der eingelesen und berechneten Werte
	n   resd 1	; n
	S_i resd 1	; berechnetes Folgenglied S_i


;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------


segment .text
	global asm_main

asm_main:
	enter 0,0			; erzeuge stack frame (0 lokale Variablen)
	pusha				; alle Register auf dem Stack speichern


	; gebe inputMsg aus (Eingabeaufforderung)
	mov     eax, inputMsg     	
        call    print_string


	; lese n ein und speichere unter [n]
        call    read_int          	
        mov     [n], eax     	 


        ; speichere/sichere die ersten drei Folgenglieder S_0 bis S_2 für die Berechnung von S_3
	mov ebx, [S_2]
	mov ecx, [S_1]
	mov edx, [S_0]
      
	
while:	; Schleife
	; falls i > n, dann wurden alle Folgenglieder S_i bis einschließlich S_n berechnet und beende die Schleife!
	mov eax, [i]
	cmp eax, [n]	; vergleiche i mit n
	jg theEnd	; wenn i>n, dann springe zu theEnd
	
	; sonst
	; falls i = 0, dann gebe S_0 direkt aus
	cmp eax, 0	; vergleiche i mit 0
	je iIs0		; wenn i=0, dann springe zu iIs0

	; falls i = 1, dann gebe S_1 direkt aus
	cmp eax, 1	; vergleiche i mit 1
	je iIs1		; wenn i=1, dann springe zu iIs1

	; falls i = 2, dann gebe S_2 direkt aus
	cmp eax, 2	; vergleiche i mit 2
	je iIs2		; wenn i=2, dann springe zu iIs2

	; falls i > 2 (aber < n), dann berechne S_i = 3*S_(i-1) + S_(i-3) im Register eax
	mov eax, ebx	; S_i = S_(i-1)
	imul eax, 3	; S_i = (S_i)*3
	add eax, edx	; S_i = S_i + S_(i-3)

	; speichere Ergebnis S_i (im Register eax) in [S_i] und gebe aus
	mov [S_i], eax	
	call printSi	; rufe Funktion printSi auf

	; verschiebe die gesicherten Werte, so dass letzter Wert rausfällt, d.h.
	; Vorbereitung auf die Berechnung des nächsten S_i im nächsten Schleifendurchlauf
	mov edx, ecx	; S_(i-3) = S_(i-2)
	mov ecx, ebx	; S_(i-2) = S_(i-1)
	mov ebx, eax	; S_(i-1) = S_i

	inc dword [i]	; inkrementiere Schleifenzähler
	jmp while	; wiederhole das Ganze für neues i, also Sprung zum Anfang der Schleife
	

iIs0:	; gebe S_0 aus
	mov [S_i], edx	; hole Wert von S_0 aus edx und lade in [S_i]
	call printSi	; rufe Funktion printSi auf zur Ausgabe des Wertes von S_i
	inc dword [i]	; inkrementiere i für nächsten Schleifendurchlauf
	jmp while	; wiederhole das Ganze für neues i, also Sprung zum Anfang der Schleife

iIs1:	; gebe S_1 aus
	mov [S_i], ecx	; hole Wert von S_1 aus ecx und lade in [S_i]
	call printSi	; rufe Funktion printSi auf zur Ausgabe des Wertes von S_i
	inc dword [i]	; inkrementiere i für nächsten Schleifendurchlauf
	jmp while	; wiederhole das Ganze für neues i, also Sprung zum Anfang der Schleife

iIs2:	; gebe S_2 aus
	mov [S_i], ebx	; hole Wert von S_2 aus ebx und lade in [S_i]
	call printSi	; rufe Funktion printSi auf zur Ausgabe des Wertes von S_i
	inc dword [i]	; inkrementiere i für nächsten Schleifendurchlauf
	jmp while	; wiederhole das Ganze für neues i, also Sprung zum Anfang der Schleife

theEnd:
        popa
        mov     eax, 0       
        leave                     
        ret


; Funktion zum Ausgeben des Ergebnisses S_i
printSi:
	enter 0,0

	; gebe erste output Nachricht aus
	mov     eax, output1Msg		; "S_"
        call    print_string   

	; gebe aktuelles i aus
	mov eax, [i]			; "[i]"
	call print_int

	; gebe zweite output Nachricht aus
	mov eax, output2Msg		; " = "
	call print_string

	; gebe aktuelles S_i aus
        mov     eax, [S_i]     		; "[S_i]"
        call    print_int        
        call    print_nl 

	leave 
	ret
