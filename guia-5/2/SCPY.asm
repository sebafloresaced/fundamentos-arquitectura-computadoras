; recibe dos punteros y permite copiar una cadena de caracteres de una posición de memoria a otra.

; PUSH <<PUNTERO 1>>
; PUSH <<PUNTERO 2>>
; CALL SCPY
; ADD SP, 8

SCPY: PUSH BP
MOV BP, SP
PUSH EAX
PUSH EBX
MOV EAX, [BP + 12]; EAX = PUNTERO 1
MOV EBX, [BP + 8]; EBX = PUNTERO 2
ITERACION: MOV b[EAX], b[EBX]
CMP b[EAX], 0
JZ FIN_SCPY
ADD EAX, 1
ADD EBX, 1
JMP ITERACION
FIN_SCPY: POP EBX
POP EAX
POP BP
RET