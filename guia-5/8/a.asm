; int j=3;
;
; void main(){
;   int arr[5];
;   arr[0] = 1020;
;   arr[1] = arr[0] | 0x3FF;
;   calculo(j, arr);
; }
;
; void calculo(int x, int vec[]){
;   vec[x] = vec[x-1] & vec[0];
; }

main: PUSH BP
MOV BP, SP
SUB SP, 20; int arr[5]

MOV [0], 3; j = 3
MOV [BP - 20], 1020; arr[0] = 1020

MOV EAX, [BP - 20]; EAX = arr[0]
OR EAX, 0x3FF; EAX |= 0x3FF
MOV [BP - 16], EAX; arr[1] = 1023

; calculo(j, arr)
MOV EAX, BP
SUB EAX, 20; EAX = &arr[0]

PUSH EAX; vec
PUSH [0]; x
CALL CALCULO
ADD SP, 8

ADD SP, 20
POP BP
RET

CALCULO: PUSH BP
MOV BP, SP

PUSH EAX
PUSH EBX
PUSH ECX
PUSH EDX

MOV EAX, [BP + 8]; EAX = x
MOV EBX, [BP + 12]; EBX = vec

MOV ECX, EAX
SUB ECX, 1
MUL ECX, 4
ADD ECX, EBX; ECX = &vec[x-1]

MOV EDX, [ECX]
AND EDX, [EBX]; vec[x-1] & vec[0]

MUL EAX, 4
ADD EBX, EAX; EBX = &vec[x]

MOV [EBX], EDX; vec[x] = vec[x-1] & vec[0];

POP EDX
POP ECX
POP EBX
POP EAX
POP BP
RET