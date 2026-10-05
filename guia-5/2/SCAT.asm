; recibe dos punteros a strings y concatena al primero el segundo 
; (es responsabilidad del programador que a continuación del primer string no se pisen datos).

; PUSH <<PUNTERO 1>>
; PUSH <<PUNTERO 2>>
; CALL SCAT
; ADD SP, 8

SCAT: PUSH BP
MOV BP, SP
PUSH EAX
PUSH EBX
MOV EAX, [BP + 12]; EAX = PUNTERO 1
MOV EBX, [BP + 8]; EBX = PUNTERO 2
ITERACION1: CMP b[EAX], 0
JZ FIN_STR1
ADD EAX, 1
JMP ITERACION1
ITERACION2: MOV b[EAX], b[EBX]
ADD EAX, 1
ADD EBX, 1
CMP b[EBX], 0
JP ITERACION2
FIN_SCAT: POP EBX
POP EAX
POP BP
RET