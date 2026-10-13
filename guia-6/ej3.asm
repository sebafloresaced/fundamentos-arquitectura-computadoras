; typedef struct _lista {
;   short int dato;
;   struct _lista* sig;
; } lista;

; int ascendente(lista* L) {
;   if (L == NULL) return 1;
;   register lista* ant;
;   do {
;       ant = L;
;       L = L->sig;
;   } while (L != NULL && ant->dato <= L->dato);
;   return L == NULL;
; }

; lista** maximo(lista** L) {
;   if (*L != NULL) {
;       register list** max = maximo(&(*L)->sig);
;       if (*max != NULL && (*L)->dato < (*max)->dato)
;       L = max;
;   }
;   return L;
; }

\\ INCLUDE ej1.asm

NODO_SIZE EQU 6
DATO EQU 0
SIG EQU 2

; ASCENDENTE:
; PUSH << -> LISTA >>
; CALL ASCENDENTE
; DEVUELVE EN EAX 1 SI ES ASCENDENTE Y 0 SI NO LO ES

ASCENDENTE: PUSH BP
    MOV BP, SP
    PUSH EBX

    MOV EAX, [BP + 8]; EAX = L
    MOV EBX, NULL; EBX = ant

    CMP EAX, NULL
    JZ ES_ASCENDENTE

ASCENDENTE_OTRO: MOV EBX, EAX
    MOV EAX, [EAX + SIG]

    CMP EAX, NULL
    JZ ES_ASCENDENTE

    CMP w[EBX + DATO], w[EAX + DATO] 
    JP NO_ES_ASCENDENTE

    JMP ASCENDENTE_OTRO

ES_ASCENDENTE: MOV EAX, 1
    JMP FIN_ASCENDENTE

NO_ES_ASCENDENTE: MOV EAX, 0

FIN_ASCENDENTE: POP EBX
    POP BP
    RET

; MAXIMO:
; PUSH << -> -> LISTA >>
; CALL MAXIMO
; ADD SP, 4
; DEVUELVE EN EAX UN PUNTERO AL PUNTERO QUE APUNTA AL NODO MAXIMO

MAXIMO: PUSH BP
    MOV BP, SP
    PUSH EBX ; L
    PUSH ECX ; MAX
    PUSH EDX ; AUX

    MOV EBX, [BP + 8]; EBX = L
    MOV EAX, [EBX]; EAX = *L

    CMP EAX, NULL
    JZ MAXIMO_FIN

    ; max = maximo(&(*L)->sig)

    ADD EAX, SIG; EAX = &(*L)->sig
    PUSH EAX
    CALL MAXIMO
    ADD SP, 4

    MOV ECX, EAX; ECX = max

    ; if (*max != NULL)

    MOV EDX, [ECX]; EDX = *max
    CMP EDX, NULL
    JZ MAXIMO_FIN

    ; if ((*L)->dato < (*max)->dato)

    MOV EBX, [EBX]; EBX = *L
    MOV EBX, w[EBX + DATO]; EBX = (*L)->dato

    MOV EDX, w[EDX + DATO]; EDX = (*max)->dato

    CMP EBX, EDX
    JNN MAXIMO_FIN ; Si EBX >= EDX, no cambia L

    MOV [BP + 8], ECX; L = max

MAXIMO_FIN:
    MOV EAX, [BP + 8]; return L

    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET