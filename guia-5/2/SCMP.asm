; recibe dos punteros a strings, y resta carácter a carácter (sin alterar los strings)
; hasta que exista una diferencia devolviendola en EAX o 0 si los strings son iguales.

; PUSH <<PUNTERO 1>>
; PUSH <<PUNTERO 2>>
; CALL SCMP
; ADD SP, 8

SCMP: PUSH BP
MOV BP, SP
PUSH EBX
PUSH ECX
MOV ECX, [BP + 12]; ECX = PUNTERO 1
MOV EBX, [BP + 8]; EBX = PUNTERO 2
ITERACION: MOV EAX, b[ECX]
SUB EAX, b[EBX]
CMP EAX, 0
JNZ FIN_SCMP
CMP b[ECX], 0
JZ FIN_SCMP
ADD ECX, 1
ADD EBX, 1
JMP ITERACION
FIN_SCMP: POP ECX
POP EBX
POP BP
RET