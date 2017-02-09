;------------------------------------------------------------------------------
; Binde I/O Routinen ein
;------------------------------------------------------------------------------

%include "asm_io.inc"

;------------------------------------------------------------------------------
; Definiere initialisierte Daten / reserviere Speicherplatz
;------------------------------------------------------------------------------
segment .data		
	inputMsg db "Geben Sie die Aufenthaltsdauer (in Stunden) ein: ", 0
	errorMsg db "Schwimmbadkarte nicht lesbar, bitte wenden Sie sich an das Personal an der Infothek.", 0
	outputMsg db "Zu bezahlender Betrag: ", 0
	outputMsg2 db " Cent",0

;------------------------------------------------------------------------------
; Assembler-Code
;------------------------------------------------------------------------------

segment .text
	global asm_main

asm_main:
	enter 0,0		; erzeuge stack frame (0 lokale Variablen)
	pusha			; alle Register auf dem Stack speichern


	; Eingabe ----------------------------------------------------------


	; gebe inputMsg aus für die Eingabeaufforderung
	mov eax, inputMsg
	call print_string


	; lese Aufenthaltsdauer d ein und speichere im Register ebx
	call read_int
	mov ebx, eax


	; überpüfe eingelesene Aufenthaltsdauer d auf gültigen Wert
	cmp ebx, 0		; überprüfe, ob eingegebene Aufenthaltsdauer d <= 0 ist
	jle printError		; falls d <= 0, springe zu printError
	cmp ebx, 13		; überprüfe, ob eingegebene Aufenthaltsdauer d >= 13 ist
	jge printError		; falls d >= 13, springe zu printError
	

	; bereite Berechnung vor
	mov ecx, ebx		; schreibe d (jetzt in ebx) ins ecx (für die Schleife)
	mov edx, 0		; initialisiere edx als zu bezahlender betrag b mit 0
	

	; Berechnung (des zu bezahlenden Betrags b)-----------------------------


repeat:
	cmp ecx,2		; falls aktuelle Stunde (ecx) <2, also 1. Stunde
	jl fee300Cent		; dann setze Gebühr auf 300 Cent
	cmp ecx,4		; falls aktuelle Stunde (ecx) <4, also 2. oder 3. Stunde
	jl fee100Cent		; dann setze Gebühr auf 100 Cent
	cmp ecx,8		; falls aktuelle Stunde (ecx) <8, also ab 4. Stunde bis einschließlich 7. Stunde
	jl fee50Cent		; dann setze Gebühr auf 50 Cent
	jmp dayticket		; aktuelle Stunde ist >=8, wir haben den Preis einer Tageskarte erreicht 
	

calculate:
	add edx, ebx		; addiere Gebühr zum zu bezahlenden Betrag b
	loop repeat		; wiederhole Schleife, falls ecx>0
	jmp returnResult 	; sonst gebe Ergebnis aus
	

	; lege Gebühren pro Stunde fest (Gebühr wird in ebx gespeichert)
fee300Cent:
	mov ebx,300
	jmp calculate

fee100Cent:
	mov ebx,100
	jmp calculate

fee50Cent:
	mov ebx,50
	jmp calculate

	; Preis für eine Tageskarte, anschließend direkt Sprung zur Ausgabe
dayticket:
	mov edx, 750
	jmp returnResult
	

	; Ausgabe ---------------------------------------------------------------
    
	; gebe errorMsg aus und Ende
printError:
	mov eax, errorMsg
	call print_string
	jmp theEnd


	; gebe Ergebnis (zu bezahlenden Betrag b) aus und Ende
returnResult:
	mov eax, outputMsg	; gebe Ausgabetext (vor Ergebnis) aus
	call print_string
    
	mov eax, edx		; gebe Ergebnis (b) aus
	call print_int

	mov eax, outputMsg2	; gebe Ausgabetext (nach Ergebnis) aus
	call print_string

	; Ende
theEnd:	
	call print_nl
	
	popa
	mov eax, 0
	leave 
	ret


