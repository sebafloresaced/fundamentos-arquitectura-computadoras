; typedef struct _lista {
;   short int dato;
;   struct _lista* sig;
; } lista;

\\ INCLUDE ej1.asm

NODO_SIZE EQU 6
DATO EQU 0
SIG EQU 2

int ascendente(lista* L) {
    if (L == NULL || L->sig == NULL)
        return 1;

    if (L->dato > L->sig->dato)
        return 0;

    return ascendente(L->sig);
}

; ASCENDENTE:
; PUSH << -> LISTA >>
; CALL ASCENDENTE
; ADD SP, 4
; DEVUELVE EN EAX 1 SI ES ASCENDENTE Y 0 SI NO

ASCENDENTE: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX

    MOV EBX, [BP + 8]; L

    CMP EBX, NULL
    JZ ES_ASCENDENTE

    MOV ECX, [EBX + SIG]; L->sig

    CMP ECX, NULL
    JZ ES_ASCENDENTE

    MOV AX, w[EBX + DATO]
    CMP AX, w[ECX + DATO]
    JP NO_ES_ASCENDENTE

    ; return ascendente(L->sig)
    PUSH ECX
    CALL ASCENDENTE
    ADD SP, 4

    JMP FIN_ASCENDENTE

ES_ASCENDENTE: MOV EAX, 1
    JMP FIN_ASCENDENTE

NO_ES_ASCENDENTE: MOV EAX, 0

FIN_ASCENDENTE: POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET

; lista** maximo(lista** L) {
;     lista** max = L;
;     while (*L != NULL) {
;         if (*max == NULL || (*max)->dato < (*L)->dato)
;             max = L;
;         L = &(*L)->sig;
;     }
;     return max;
; }

; MAXIMO:
; PUSH << -> -> LISTA >>
; CALL MAXIMO
; ADD SP, 4
; DEVUELVE EN EAX UN PUNTERO AL PUNTERO
; QUE APUNTA AL NODO MAXIMO

MAXIMO: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX

    MOV EBX, [BP + 8]; L
    MOV ECX, EBX; max = L

MAXIMO_OTRO: MOV EDX, [EBX]; EDX = *L

    CMP EDX, NULL
    JZ MAXIMO_FIN

    ; if (*max == NULL)
    MOV EAX, [ECX]; EAX = *max

    CMP EAX, NULL
    JZ MAXIMO_ACTUAL

    ; if ((*max)->dato < (*L)->dato)
    MOV AX, w[EAX + DATO]
    CMP AX, w[EDX + DATO]
    JNN MAXIMO_SIGUIENTE

MAXIMO_ACTUAL: MOV ECX, EBX; max = L

; L = &(*L)->sig
MAXIMO_SIGUIENTE: MOV EBX, EDX
    ADD EBX, SIG

    JMP MAXIMO_OTRO

MAXIMO_FIN: MOV EAX, ECX; return max
    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET