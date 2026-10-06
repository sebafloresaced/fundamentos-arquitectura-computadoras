; int vec[9];
;
; void main(){
;   int i = 2;
;   vec[i] = 501;
;   vec[0] = 0xF0F0 & vec[i];
;   proce(i, vec);
; }
;
; void proce(int x, int w[]){
;   w[x-1] = w[x] | w[0];
; }

main: PUSH BP
MOV BP, SP
SUB SP, 4
MOV [BP - 4], 2; i = 2

; vec[i] = 501
MOV EAX, [BP - 4]
MUL EAX, 4
MOV EBX, DS
ADD EBX, EAX; EBX = &vec[i]
MOV [EBX], 501

; vec[0] = 0xF0F0 & vec[i]
MOV EAX, 0xF0F0
AND EAX, [EBX]
MOV [0], EAX

; proce(i, vec)
PUSH DS; vec
PUSH [BP - 4]; i
CALL PROCE
ADD SP, 8

ADD SP, 4; libero i
POP BP
RET

PROCE: PUSH BP
MOV BP, SP
PUSH EAX
PUSH EBX
PUSH ECX
PUSH EDX

MOV EAX, [BP + 8]; EAX = x
MOV EBX, [BP + 12]; EBX = w

; EDX = w[x] | w[0]
MOV ECX, EAX
MUL ECX, 4
ADD ECX, EBX; ECX = &w[x]

MOV EDX, [ECX]
OR EDX, [EBX]

; &w[x-1]
SUB EAX, 1
MUL EAX, 4
ADD EBX, EAX

MOV [EBX], EDX; w[x-1] = resultado

POP EDX
POP ECX
POP EBX
POP EAX
POP BP
RET