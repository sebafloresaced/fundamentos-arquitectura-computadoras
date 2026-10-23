; typedef struct _ln {
;     short int valor;
;     void* dato;
;     struct _ln* sig;
; } ln;

VALOR EQU 0
DATO EQU 2
SIG EQU 6

; void** buscar (ln* lista, short int valor) {
;     register void** ret = NULL;     
;     if (lista != NULL)
;         if (lista->valor == valor)
;             ret = &(lista->dato);
;         else
;             ret = buscar(lista->sig, valor);    
;     return ret;
; }

; BUSCAR:
; PUSH << VALOR >>
; PUSH << LISTA* >>
; CALL BUSCAR
; ADD SP, 8
; DEVUELVE EN EAX

BUSCAR: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH EDX

    MOV BX, w[BP + 14]; EBX = valor
    MOV EDX, [BP + 8]; EDX = lista
    MOV EAX, NULL; EAX = ret

    ; if (lista != NULL)
    CMP EDX, NULL
    JZ FIN_BUSCAR

    ; if (lista->valor == valor)
    CMP w[EDX + VALOR], BX; 
    JNZ BUSCAR_ELSE

    ; ret = &(lista->dato);
    MOV EAX, EDX
    ADD EAX, DATO
    JMP FIN_BUSCAR

; ret = buscar(lista->sig, valor);
BUSCAR_ELSE: PUSH EBX
    PUSH [EDX + SIG]
    CALL BUSCAR
    ADD SP, 8
    JMP FIN_BUSCAR

FIN_BUSCAR: POP EDX
    POP EBX
    MOV SP, BP
    POP BP
    RET