; recibe un puntero a string, un carácter, y un puntero a un array de punteros. Divide el strings en varios strings 
; reemplazando el carácter por el terminator y completa el array de punteros con el puntero al primer carácter de cada string,
; utilizando -1 para marcar el fin.

; PUSH <<PUNTERO STRING>>
; PUSH <<CARACTER>>
; PUSH <<PUNTERO ARRAY>>
; CALL SPLIT
; ADD SP, 12

SPLIT: PUSH BP
MOV BP, SP
PUSH EAX
PUSH EBX
PUSH ECX

MOV EAX, [BP + 16]; EAX = PUNTERO STRING
MOV EBX, [BP + 12]; EBX = CARACTER
MOV ECX, [BP + 8]; ECX = PUNTERO ARRAY

MOV [ECX], EAX
ADD ECX, 4

; itero el string
ITERAR_STRING: CMP b[EAX], 0
JZ FIN_SPLIT
CMP b[EAX], EBX
JZ REEMPLAZAR
ADD EAX, 1
JMP ITERAR_STRING
REEMPLAZAR: MOV b[EAX], 0
ADD EAX, 1
MOV [ECX], EAX
ADD ECX, 4
JMP ITERAR_STRING

FIN_SPLIT: MOV [ECX], -1
POP ECX
POP EBX
POP EAX
POP BP
RET

