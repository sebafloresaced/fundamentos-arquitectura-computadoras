; #include <stdio.h>
; 
; typedef int op(short int, short int);
; 
; op ops[] = {add, sub, mul, div};
; char* nom[] = {"ADD", "SUB", "MUL", "DIV"};
; 
; void main() {
;     short int x, y;
;     scanf("%d %d", &x, &y);
;     for (int i = 0; i < 4; i++) {
;         printf("%s =", nom[i]);
;         printf("%d\n", ops[i](a, b));
;     }
; }
; 
; int add(short int a, short int b) {
;     return a + b;
; }
; 
; int sub(short int a, short int b) {
;     return a - b;
; }
; 
; int mul(short int a, short int b) {
;     return a * b;
; }
; 
; int div(short int a, short int b) {
;     return a / b;
; }

\ DATA 32
IGUAL EQU " ="
SALTO EQU "\n"

main: PUSH BP
MOV BP, SP
SUB SP, 8

MOV [0], OP_ADD
MOV [4], OP_SUB
MOV [8], OP_MUL
MOV [12], OP_DIV

; DS + 0   -> ops[0]
; DS + 4   -> ops[1]
; DS + 8   -> ops[2]
; DS + 12  -> ops[3]

NOM_ADD EQU "ADD"
NOM_SUB EQU "SUB"
NOM_MUL EQU "MUL"
NOM_DIV EQU "DIV"

MOV EAX, KS
ADD EAX, NOM_ADD
MOV [16], EAX

MOV EAX, KS
ADD EAX, NOM_SUB
MOV [20], EAX

MOV EAX, KS
ADD EAX, NOM_MUL
MOV [24], EAX

MOV EAX, KS
ADD EAX, NOM_DIV
MOV [28], EAX

; DS + 16  -> nom[0]
; DS + 20  -> nom[1]
; DS + 24  -> nom[2]
; DS + 28  -> nom[3]


; short int x, y;
; [BP - 4] = x
; [BP - 2] = y

MOV EDX, BP
SUB EDX, 4; EDX = &x
MOV EAX, 0x01; leer decimal
LDL ECX, 2; cantidad = 2 valores
LDH ECX, 2; tamaño = 2 bytes cada uno
SYS 1


MOV [BP - 8], 0       ; i = 0

FOR: CMP [BP - 8], 4
JNN FIN_FOR

; printf("%s =", nom[i])
MOV EAX, [BP - 8]      ; EAX = i
MUL EAX, 4             ; EAX = i * 4

MOV EDX, DS
ADD EDX, 16            ; comienzo de nom[]
ADD EDX, EAX           ; EDX = &nom[i]
MOV EDX, [EDX]         ; EDX = nom[i]
SYS 4

MOV EDX, KS
ADD EDX, IGUAL
SYS 4

; printf("%d\n", ops[i](a, b));

; buscar ops[i]
MOV ECX, [BP - 8]      ; i
MUL ECX, 4
ADD ECX, DS            ; ECX = &ops[i]

; ops[i](x, y)
PUSH w[BP - 2]         ; y
PUSH w[BP - 4]         ; x
CALL [ECX]
ADD SP, 8
; EAX = resultado

; imprimir resultado
PUSH EAX
MOV EDX, SP
MOV EAX, 0x01
LDH ECX, 4
LDL ECX, 1
SYS 2
ADD SP, 4

; imprimir "\n"
MOV EDX, KS
ADD EDX, SALTO
SYS 4

ADD [BP - 8], 1; i++
JMP FOR

FIN_FOR: ADD SP, 8
POP BP
RET


; OPERACIONES:
; PUSH << b >>
; PUSH << a >>
; CALL << OPERACION >>
; ADD SP, 8
; DEVUELVE EL RESULTADO EN EAX

OP_ADD: PUSH BP
MOV BP, SP
MOV EAX, [BP + 8]
ADD EAX, [BP + 12]
POP BP
RET

OP_SUB: PUSH BP
MOV BP, SP
MOV EAX, [BP + 8]
SUB EAX, [BP + 12]
POP BP
RET

OP_MUL: PUSH BP
MOV BP, SP
MOV EAX, [BP + 8]
MUL EAX, [BP + 12]
POP BP
RET

OP_DIV: PUSH BP
MOV BP, SP
MOV EAX, [BP + 8]
DIV EAX, [BP + 12]
POP BP
RET