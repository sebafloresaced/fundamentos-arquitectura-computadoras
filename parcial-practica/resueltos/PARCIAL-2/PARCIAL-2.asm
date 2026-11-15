; typedef struct _nodoA {
;   int valor;
;   struct _nodoA *izq;
;   struct _nodoA *der;
; } nodoA;

A_VALOR EQU 0
A_IZQ EQU 4
A_DER EQU 8

; devuelve -1 si se encuentra el valor o 0 si no se encuentra
; int buscar_b (nodoA* raiz, int valor) {
;   if (raiz == NULL) return 0;
;   if (raiz->valor == valor) return -1;
;   if (raiz->valor < valor) return buscar_b(raiz->der, valor);
;   return buscar_b(raiz->izq, valor);
; }

; BUSCAR_B: 
; PUSH << VALOR >>
; PUSH << RAIZ* >>
; CALL BUSCAR_B
; ADD SP, 8
; DEVUELVE EN EAX -1 O 0

BUSCAR_B: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = raiz 
    MOV EBX, [BP + 12]; EBX = valor 

    CMP EDX, NULL
    JZ NO_ESTA

    CMP [EDX + A_VALOR], EBX
    JZ SI_ESTA
    JN BUSCAR_DER

    PUSH EBX
    PUSH [EDX + A_DER]
    CALL BUSCAR_B
    ADD SP, 8
    JMP BUSCAR_FIN

NO_ESTA: MOV EAX, 0
    JMP BUSCAR_FIN

SI_ESTA: MOV EAX, -1
    JMP BUSCAR_FIN

BUSCAR_DER: PUSH EBX
    PUSH [EDX + A_IZQ]
    CALL BUSCAR_B
    ADD SP, 8

BUSCAR_FIN: POP EDX
    POP EBX
    MOV SP, BP
    POP BP
    RET


; EJERCICIO 2

; typedef struct _nodoL {
;     int valor;
;     struct _nodoL* siguiente;
; } nodoL;

; typedef struct _lista {
;     nodoL* primero;
; } T_Lista;

; void eliminar_b(T_Lista* lista, nodoA* raiz) {
;     nodoL** enlace = &lista->primero;
;     while (*enlace != NULL) {
;         nodoL* actual = *enlace;
;         if (buscar_b(raiz, actual->valor) != 0) {
;             *enlace = actual->siguiente;
;             free(actual);
;         } else {
;             enlace = &actual->siguiente;
;         }
;     }
; }

L_PRIMERO EQU 0
N_VALOR EQU 0
N_SIGUIENTE EQU 4

; FREE provista por el enunciado:
; PUSH << NODO* >>
; CALL FREE
; ADD SP, 4

; ELIMINAR_B:
; PUSH << RAIZ* >>
; PUSH << LISTA* >>
; CALL ELIMINAR_B
; ADD SP, 8

ELIMINAR_B: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH EDX
    PUSH EEX

    MOV EDX, [BP + 12]; EDX = raiz
    MOV EEX, [BP + 8]; EEX = lista
    ADD EEX, L_PRIMERO; EEX = &lista->primero = enlace

ELIMINAR_B_OTRO: MOV EBX, [EEX]; EBX = actual = *enlace
    CMP EBX, NULL
    JZ ELIMINAR_B_FIN

    PUSH [EBX + N_VALOR]
    PUSH EDX
    CALL BUSCAR_B
    ADD SP, 8

    CMP EAX, 0
    JZ ELIMINAR_B_AVANZAR

    ; El valor está en el árbol: desenlazar y liberar.
    MOV [EEX], [EBX + N_SIGUIENTE]

    PUSH EBX
    CALL FREE
    ADD SP, 4

    ; El mismo enlace ahora contiene el siguiente nodo.
    JMP ELIMINAR_B_OTRO

ELIMINAR_B_AVANZAR: MOV EEX, EBX
    ADD EEX, N_SIGUIENTE; enlace = &actual->siguiente
    JMP ELIMINAR_B_OTRO

ELIMINAR_B_FIN: POP EEX
    POP EDX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET