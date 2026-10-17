NODO_SIZE EQU 6
DATO EQU 0
SIG EQU 2

; Creando una nueva lista.
; lista* intercalar(lista* L1, lista* L2) {
;     lista* resultado = NULL;
;     lista** ultimo = &resultado;
;     lista* nuevo;
;     short int valor;
;     while (L1 != NULL || L2 != NULL) {
;         if (L2 == NULL || (L1 != NULL && L1->dato <= L2->dato)) {
;             valor = L1->dato;
;             L1 = L1->sig;
;         } else {
;             valor = L2->dato;
;             L2 = L2->sig;
;         }
;         nuevo = crear_nodo(valor);
;         if (nuevo == NULL)
;             return NULL;
;         *ultimo = nuevo;
;         ultimo = &nuevo->sig;
;     }
;
;     return resultado;
; }

; INTERCALAR:
; PUSH << -> L2 >>
; PUSH << -> L1 >>
; CALL INTERCALAR
; ADD SP, 8
; DEVUELVE EN EAX LA DIRECCION DE LA NUEVA LISTA

INTERCALAR: PUSH BP
    MOV BP, SP
    SUB SP, 4; [BP - 4] = resultado

    ; EAX = nodo creado / resultado
    PUSH EBX; nodo actual de L1
    PUSH ECX; nodo actual de L2
    PUSH EDX; Direccion del enlace donde insertar

    MOV [BP - 4], NULL; resultado = NULL
    MOV EBX, [BP + 8]; L1
    MOV ECX, [BP + 12]; L2

    MOV EDX, BP
    SUB EDX, 4; ultimo = &resultado

INTERCALAR_OTRO: CMP EBX, NULL
    JZ TOMAR_L2

    CMP ECX, NULL
    JZ TOMAR_L1

    ; Comparar L1->dato y L2->dato
    MOV AX, w[EBX + DATO]
    CMP AX, w[ECX + DATO]
    JP TOMAR_L2

; Crear nodo con L1->dato
TOMAR_L1: MOV AX, w[EBX + DATO]
    PUSH AX
    CALL CREAR_NODO
    ADD SP, 2

    MOV EBX, [EBX + SIG]
    JMP AGREGAR_NODO

TOMAR_L2: CMP ECX, NULL
    JZ INTERCALAR_FIN

    MOV AX, w[ECX + DATO]
    PUSH AX
    CALL CREAR_NODO
    ADD SP, 2

    MOV ECX, [ECX + SIG]

AGREGAR_NODO: CMP EAX, NULL
    JZ INTERCALAR_FIN

    MOV [EDX], EAX; *ultimo = nuevo

    MOV EDX, EAX
    ADD EDX, SIG; ultimo = &nuevo->sig

    JMP INTERCALAR_OTRO

INTERCALAR_FIN: MOV EAX, [BP - 4]; return resultado
    POP EDX
    POP ECX
    POP EBX
    ADD SP, 4
    MOV SP, BP
    POP BP
    RET


; Reutilizando los mismos nodos (modificando las listas originales).
; lista* intercalar(lista* L1, lista* L2) {
;     lista* resultado = NULL;
;     lista** ultimo = &resultado;
;     lista* actual;
;     while (L1 != NULL || L2 != NULL) {
;         if (L2 == NULL || (L1 != NULL && L1->dato <= L2->dato)) {
;             actual = L1;
;             L1 = L1->sig;
;         } else {
;             actual = L2;
;             L2 = L2->sig;
;         }
;         *ultimo = actual;
;         ultimo = &actual->sig;
;     }
;     return resultado;
; }

; INTERCALAR:
; PUSH << -> L2 >>
; PUSH << -> L1 >>
; CALL INTERCALAR
; ADD SP, 8
; DEVUELVE EN EAX LA DIRECCION DE LA LISTA RESULTANTE

INTERCALAR: PUSH BP
    MOV BP, SP
    SUB SP, 4; [BP - 4] = resultado

    PUSH EBX
    PUSH ECX
    PUSH EDX

    MOV [BP - 4], NULL; resultado = NULL
    MOV EBX, [BP + 8]; L1
    MOV ECX, [BP + 12]; L2

    MOV EDX, BP
    SUB EDX, 4; ultimo = &resultado

INTERCALAR_OTRO: CMP EBX, NULL
    JZ TOMAR_L2

    CMP ECX, NULL
    JZ TOMAR_L1

    ; Comparar los valores de ambas listas

    MOV AX, w[EBX + DATO]
    CMP AX, w[ECX + DATO]
    JP TOMAR_L2

TOMAR_L1: MOV EAX, EBX; actual = L1
    MOV EBX, [EBX + SIG]; L1 = L1->sig
    JMP AGREGAR_NODO

TOMAR_L2: CMP ECX, NULL
    JZ INTERCALAR_FIN

    MOV EAX, ECX; actual = L2
    MOV ECX, [ECX + SIG]; L2 = L2->sig

AGREGAR_NODO: MOV [EDX], EAX; *ultimo = actual

    MOV EDX, EAX
    ADD EDX, SIG; ultimo = &actual->sig

    JMP INTERCALAR_OTRO

INTERCALAR_FIN: MOV [EDX], NULL; Terminar la lista con NULL
    MOV EAX, [BP - 4]; return resultado
    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET