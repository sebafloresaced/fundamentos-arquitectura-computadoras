; recibe un puntero a un string y devuelve en ECX la cantidad de caracteres (sin incluir el terminator) del string.

; PUSH <<PUNTERO>>
; CALL SLEN
; ADD SP, 4
; DEVUELVE EN ECX LA CANTIDAD DE caracteres

SLEN: PUSH BP
MOV BP, SP
PUSH EAX
MOV EAX, [BP + 8]; EAX = PUNTERO
MOV ECX, 0; ECX = CONT
ITERACION: CMP b[EAX], 0
JZ FIN_SLEN
ADD ECX, 1
ADD EAX, 1
JMP ITERACION
FIN_SLEN: POP EAX
POP BP
RET
