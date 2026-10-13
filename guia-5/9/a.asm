; void main() {
;     int* vec = malloc(sizeof(int) * 100);
;     short int* z;
;     z = malloc(sizeof(short int));
;     *z = 100;
;     func(vec, *z);
; }

; MAIN:
; CALL MAIN

MAIN: PUSH BP
MOV BP, SP
SUB SP, 8
; [BP - 4] = vec
; [BP - 8] = Z

; static int s = 0
MOV [DS], 0

PUSH 400
CALL ALLOC
ADD SP, 4
MOV [BP - 4], EAX

PUSH 2
CALL ALLOC
ADD SP, 4
MOV [BP - 8], EAX
MOV w[EAX], 100

PUSH w[EAX]
PUSH [BP - 4]
CALL FUNC
ADD SP, 8

ADD SP, 8
POP BP
RET



; int sum(int vec[], short int* n) {
;     static int s = 0;
;     register int i;
;     for (i = 0; i < *n; i++)
;         s = s + vec[i];
;     return s;
; }

; SUM:
; PUSH << -> N >> 
; PUSH << -> VEC >>
; CALL SUM
; ADD SP 8
; DEVUELVE EL RESULTADO EN EAX

SUM: PUSH BP
MOV BP, SP
PUSH EBX
PUSH ECX
PUSH EDX
PUSH EEX

MOV ECX, [BP + 8]; ECX = vec
MOV EBX, [BP + 12]; EBX = &n

MOV EEX, 0; EEX = i
FOR_SUM: CMP EEX, w[EBX]
JNN FIN_SUM

MOV EDX, EEX
MUL EDX, 4
ADD EDX, ECX

ADD [DS], [EDX]
ADD EEX, 1
JMP FOR_SUM

FIN_SUM: MOV EAX, [DS]
POP EEX
POP EDX
POP ECX
POP EBX
POP BP
RET


; void func(int vec[], short int z) {
;     int s;
;     short int i;
;     vec[0] = 1;
;     for (i = 1; i < z; i++)
;         vec[i] = vec[i-1] * i;
;     s = sum(vec, &z);
;     print_int(s);
; }

; FUNC:
; PUSH << Z >> 
; PUSH << -> VEC >>
; ADD SP 8
; CALL FUNC

FUNC: PUSH BP
MOV BP, SP
SUB SP, 4
PUSH EAX
PUSH EBX
PUSH ECX
PUSH EDX
PUSH EEX
PUSH EFX

MOV BX, w[BP + 14]; BX = z
MOV ECX, [BP + 8]; ECX = vec
; EAX = s
; DX = i
; EEX = aux punt
; EFX = aux val

MOV [ECX], 1; vec[0] = 1
MOV DX, 1; i = 1

FOR_FUNC: CMP DX, BX
JNN FIN_FOR_FUNC

MOV EEX, DX
SUB EEX, 1
MUL EEX, 4
ADD EEX, ECX
MOV EFX, [EEX] 
MUL EFX, DX

MOV EEX, DX
MUL EEX, 4
ADD EEX, ECX
MOV [EEX], EFX

ADD DX, 1
JMP FOR_FUNC

FIN_FOR_FUNC: MOV EAX, BP
ADD EAX, 14
PUSH EAX; EAX = &z
PUSH ECX
CALL SUM
ADD SP 8
; EAX = res

MOV [BP - 4], EAX
MOV EDX, BP
SUB EDX, 4; EDX = &s
MOV EAX, 0x01       
LDH ECX, 4           
LDL ECX, 1           
SYS 2

POP EFX
POP EEX
POP EDX
POP ECX
POP EBX
POP EAX
ADD SP, 4
POP BP
RET