; typedef struct _lista {
;     int valor;
;     struct _lista *sig;
; } lista;

VALOR_LISTA EQU 0
SIG EQU 4

; void eliminar_en_arbol(lista** L, arbol* A) {
;     lista* act;
;     while (*L != NULL) {
;         act = *L;
;         if (buscar_nodo(A, act->valor)) {
;             *L = act->sig;
;         } else {
;             L = &act->sig; // no modifica la cabeza, modifica que nodo es la cabeza
;         }
;     }
; }

; ELIMINAR_EN_ARBOL:
; PUSH << ARBOL* >>
; PUSH << LISTA** >>
; CALL ELIMINAR_EN_ARBOL
; ADD SP, 8

ELIMINAR_EN_ARBOL: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX

    MOV EBX, [BP + 8]; EBX = L

ELIMINAR_OTRO: MOV ECX, [EBX]; ECX = *L (act)

    CMP ECX, NULL
    JZ ELIMINAR_FIN

    ; buscar_nodo(A, act->valor)
    MOV EDX, [ECX + VALOR_LISTA]
    PUSH EDX; valor
    PUSH [BP + 12]; arbol*
    CALL BUSCAR_NODO
    ADD SP, 8

    CMP EAX, 1
    JZ ELIMINAR_ACTUAL

    ; El valor no existe en el arbol
    ; L = &act->sig
    MOV EBX, ECX
    ADD EBX, SIG
    JMP ELIMINAR_OTRO

; *L = act->sig
ELIMINAR_ACTUAL: MOV EDX, [ECX + SIG]
    MOV [EBX], EDX
    JMP ELIMINAR_OTRO

ELIMINAR_FIN: POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET