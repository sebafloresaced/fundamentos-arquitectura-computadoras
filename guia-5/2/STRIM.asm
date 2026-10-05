; recibe un puntero a string como parámetro variable, y devuelve el string quitando
; los “espacios” (white spaces) del comienzo y del final.

; recibe la DIRECCION de una variable que contiene un puntero a string
; PUSH <<DIRECCION VARIABLE PUNTERO>>
; CALL TRIM
; ADD SP, 4

TRIM: PUSH BP
MOV BP, SP
PUSH EAX
PUSH EBX
PUSH ECX

MOV EAX, [BP + 8]; EAX = dirección de la variable puntero
MOV EBX, [EAX]; EBX = puntero al string

SACAR_INICIO: CMP b[EBX], ' '
JNZ FIN_INICIO
ADD EBX, 1
JMP SACAR_INICIO

FIN_INICIO: MOV [EAX], EBX; actualizo el puntero original
MOV ECX, EBX

BUSCAR_FIN: CMP b[ECX], 0 
JZ ENCONTRO_FIN
ADD ECX, 1
JMP BUSCAR_FIN

ENCONTRO_FIN: CMP ECX, EBX ; si quedó vacío, no puedo retroceder
JZ FIN_TRIM
SUB ECX, 1

QUITAR_FINAL: CMP b[ECX], ' '
JNZ FIN_ESPACIOS
SUB ECX, 1
JMP QUITAR_FINAL

FIN_ESPACIOS:
ADD ECX, 1
MOV b[ECX], 0

FIN_TRIM: POP ECX
POP EBX
POP EAX
POP BP
RET