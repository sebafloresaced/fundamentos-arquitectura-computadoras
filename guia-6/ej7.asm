; typedef struct _lista {
;     int valor;
;     struct _lista* anterior;
;     struct _lista* siguiente;
; } lista;

NODO_SIZE EQU 12
VAL EQU 0
ANT EQU 4
SIG EQU 8

; int eliminarRepetidos(lista** L) {
;     if (*L == NULL)
;         return 0;
;     lista* act = *L;
;     lista* aux;
;     lista* siguiente;
;     int eliminados = 0;
;     do {
;         aux = act->siguiente;
;         while (aux != *L) {
;             siguiente = aux->siguiente;
;             if (aux->valor == act->valor) {
;                 aux->anterior->siguiente = aux->siguiente;
;                 aux->siguiente->anterior = aux->anterior;
;                 eliminados++;
;             }
;             aux = siguiente;
;         }
;         act = act->siguiente;
;     } while (act != *L);
;     return eliminados;
; }

; ELIMINAR_REPETIDOS:
; PUSH << -> PRIMERO >>
; CALL ELIMINAR_REPETIDOS
; ADD SP, 4
; DEVUELVE EN EAX LA CANTIDAD DE NODOS ELIMINADOS

ELIMINAR_REPETIDOS: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EFX, [BP + 8]
    MOV EFX, [EFX]; primero = *L

    MOV EAX, 0; eliminados = 0

    CMP EFX, NULL
    JZ ELIMINAR_FIN

    MOV EBX, EFX; act = primero

ELIMINAR_OTRO: MOV ECX, [EBX + SIG]; aux = act->siguiente

ELIMINAR_COMPARAR: CMP ECX, EFX
    JZ ELIMINAR_SIGUIENTE

    MOV EDX, [ECX + SIG]    ; siguiente = aux->siguiente

    ; Comparar aux->valor con act->valor
    MOV EX, [EBX + VAL]
    CMP EX, [ECX + VAL]
    JNZ ELIMINAR_AVANZAR

    ; aux->anterior->siguiente = aux->siguiente
    MOV EEX, [ECX + ANT]
    MOV [EEX + SIG], EDX

    ; aux->siguiente->anterior = aux->anterior
    MOV EEX, [ECX + SIG]
    MOV EEX, EDX
    MOV EDX, [ECX + ANT]
    MOV [EEX + ANT], EDX

    ; eliminados++
    ADD EAX, 1

    ; Recuperar el siguiente nodo
    MOV EDX, [ECX + SIG]

ELIMINAR_AVANZAR: MOV ECX, EDX
    JMP ELIMINAR_COMPARAR

ELIMINAR_SIGUIENTE: MOV EBX, [EBX + SIG]; act = act->siguiente
    CMP EBX, EFX
    JNZ ELIMINAR_OTRO

ELIMINAR_FIN: POP EFX
    POP EEX
    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET