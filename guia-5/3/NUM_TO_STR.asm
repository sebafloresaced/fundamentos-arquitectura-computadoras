; Convertir un número entero a su representación en string.

; recibe un número y un puntero a una zona de memoria donde escribir el string
; PUSH <<NUMERO>>
; PUSH <<PUNTERO STRING>>
; CALL NUM_TO_STR
; ADD SP, 8

NUM_TO_STR: PUSH BP
MOV BP, SP
PUSH EAX
PUSH EBX
PUSH ECX
PUSH EDX
PUSH AC

MOV EAX, [BP + 12]; EAX = NUMERO
MOV EDX, [BP + 8]; EDX = PUNTERO STRING
MOV ECX, 0; ECX = cantidad de dígitos

; caso especial: numero = 0
CMP EAX, 0
JNZ DIVIDIR
MOV b[EDX], '0'
ADD EDX, 1
MOV b[EDX], 0
JMP FIN_NUM_TO_STR

DIVIDIR:
DIV EAX, 10; EAX = cociente, AC = resto
PUSH AC; guardo el dígito
ADD ECX, 1
CMP EAX, 0
JNZ DIVIDIR

ESCRIBIR: POP EBX; saco un dígito
ADD EBX, '0'; 1 -> '1', 2 -> '2'
MOV b[EDX], EBX
ADD EDX, 1
SUB ECX, 1
CMP ECX, 0
JNZ ESCRIBIR
MOV b[EDX], 0; terminador

FIN_NUM_TO_STR: POP AC
POP EDX
POP ECX
POP EBX
POP EAX
POP BP
RET