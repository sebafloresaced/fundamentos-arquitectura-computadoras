; typedef struct nodo {
;     int valor;
;     struct nodo *izq, *der;
; } nodo;

; void agregarNodo(nodo **a, nodo n) {
;     if (*a == null) {
;         *a = n;
;     }
;     else {
;         if (n.clave < a->clave) {
;             agregarNodo(a->izq, n);
;         }
;         else {
;             agregarNodo(a->der, n);
;         }
;     }
; }

VALOR EQU 0
IZQ EQU 4
DER EQU 8

; PUSH << NODO >>
; PUSH << RAIZ** >>
; CALL AGREGAR_NODO
; ADD SP, 8

AGREGAR_NODO: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = &RAIZ
    MOV EBX, [EDX]; EBX = RAIZ
    MOV EAX, [BP + 12]; EAX = NODO

    CMP [EDX], null
    JZ INSERTAR_NODO

    CMP [EAX+VALOR], [EBX + VALOR]
    JN AGREGAR_IZQ

AGREGAR_DER: ADD EBX, DER
    PUSH EAX
    PUSH EBX
    CALL AGREGAR_NODO
    ADD SP, 8
    JMP FIN_AGREGAR

AGREGAR_IZQ: ADD EBX, IZQ
    PUSH EAX
    PUSH EBX
    CALL AGREGAR_NODO
    ADD SP, 8
    JMP FIN_AGREGAR

INSERTAR_NODO: MOV [EDX], EAX

FIN_AGREGAR: POP EDX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET