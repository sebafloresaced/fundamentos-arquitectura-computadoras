; typedef struct nodo_arbol {
;     struct arbol *arbol;
;     struct nodo_arbol *siguiente;
; } nodo_arbol;

; typedef struct arbol {
;     int valor;
;     nodo_arbol *hijos;
; } arbol;

; typedef struct lista {
;     arbol *arbol;
;     struct lista *siguiente;
; } lista;

; ARBOL
VALOR EQU 0
HIJOS EQU 4

; NODO_ARBOL
HIJO_ARBOL EQU 0
HIJO_SIG EQU 4

; LISTA
LISTA_ARBOL EQU 0
LISTA_SIG EQU 4

; ELIMINAR_ARBOL
; PUSH << VALOR >>
; PUSH << ARBOL** >>
; CALL ELIMINAR_ARBOL
; ADD SP, 8
;
; Devuelve en EAX la cantidad de nodos
; del arbol eliminados.
;
; int eliminar_arbol(arbol** A, int valor) {
;     int eliminados = 0;
;     if (*A == NULL)
;         return 0;
;
;     nodo_arbol** actual = &(*A)->hijos;
;
;     while (*actual != NULL) {
;         eliminados +=
;             eliminar_arbol(&(*actual)->arbol, valor);
;
;         if ((*actual)->arbol == NULL)
;             *actual = (*actual)->siguiente;
;         else
;             actual = &(*actual)->siguiente;
;     }
;
;     if ((*A)->valor == valor) {
;         arbol* borrar = *A;
;         nodo_arbol* primero = borrar->hijos;
;         eliminados++;
;
;         if (primero == NULL) {
;             *A = NULL;
;         } else {
;             arbol* reemplazo = primero->arbol;
;             nodo_arbol* restantes = primero->siguiente;
;             *A = reemplazo;
;
;             nodo_arbol** ultimo = &reemplazo->hijos;
;             while (*ultimo != NULL)
;                 ultimo = &(*ultimo)->siguiente;
;
;             *ultimo = restantes;
;         }
;     }
;
;     return eliminados;
; }

; REGISTROS:
; EAX = resultado de llamadas y retorno
; EBX = puntero al enlace actual de hijos
; ECX = cantidad acumulada
; EDX = A (arbol**)
; EEX = *A (arbol*)
; EFX = auxiliar

ELIMINAR_ARBOL: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 8]; A
    MOV EEX, [EDX]; *A
    MOV ECX, 0; eliminados = 0

    CMP EEX, NULL
    JZ ELIMINAR_ARBOL_FIN

    ; actual = &(*A)->hijos
    MOV EBX, EEX
    ADD EBX, HIJOS

ELIMINAR_HIJOS: MOV EFX, [EBX]
    CMP EFX, NULL
    JZ COMPROBAR_RAIZ

    ; eliminar_arbol(&(*actual)->arbol, valor)
    ; HIJO_ARBOL = 0
    PUSH [BP + 12]
    PUSH EFX
    CALL ELIMINAR_ARBOL
    ADD SP, 8

    ADD ECX, EAX

    ; Comprobar si el subarbol quedo vacio
    MOV EFX, [EBX]
    CMP [EFX + HIJO_ARBOL], NULL
    JZ ELIMINAR_HIJO_VACIO

    ; actual = &(*actual)->siguiente
    MOV EBX, EFX
    ADD EBX, HIJO_SIG
    JMP ELIMINAR_HIJOS

ELIMINAR_HIJO_VACIO: MOV EAX, [EFX + HIJO_SIG]
    MOV [EBX], EAX

    ; No avanzar actual porque ahora apunta al siguiente elemento de la lista
    JMP ELIMINAR_HIJOS

COMPROBAR_RAIZ: MOV EEX, [EDX]
    CMP EEX, NULL
    JZ ELIMINAR_ARBOL_FIN

    ; if ((*A)->valor == valor)
    MOV EFX, [BP + 12]
    CMP [EEX + VALOR], EFX
    JNZ ELIMINAR_ARBOL_FIN

    ; Eliminamos el nodo actual
    ADD ECX, 1

    ; primero = (*A)->hijos
    MOV EBX, [EEX + HIJOS]
    CMP EBX, NULL
    JZ ARBOL_SIN_HIJOS

    ; reemplazo = primero->arbol
    ; restantes = primero->siguiente
    MOV EFX, [EBX + HIJO_ARBOL]
    MOV EAX, [EBX + HIJO_SIG]

    ; *A = reemplazo
    MOV [EDX], EFX

    ; Buscar el ultimo enlace de la lista de hijos del nodo promovido
    MOV EDX, EFX
    ADD EDX, HIJOS

BUSCAR_ULTIMO_HIJO: CMP [EDX], NULL
    JZ UNIR_HIJOS

    MOV EDX, [EDX]
    ADD EDX, HIJO_SIG
    JMP BUSCAR_ULTIMO_HIJO

UNIR_HIJOS: MOV [EDX], EAX
    JMP ELIMINAR_ARBOL_FIN

ARBOL_SIN_HIJOS: MOV [EDX], NULL

ELIMINAR_ARBOL_FIN: MOV EAX, ECX
    POP EFX
    POP EEX
    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET


; ELIMINAR_LISTA
; PUSH << VALOR >>
; PUSH << LISTA** >>
; CALL ELIMINAR_LISTA
; ADD SP, 8
;
; Devuelve en EAX la cantidad de nodos
; de arbol eliminados.
;
; int eliminar_lista(lista** L, int valor) {
;     int eliminados = 0;
;
;     while (*L != NULL) {
;         lista* act = *L;
;
;         eliminados +=
;             eliminar_arbol(&act->arbol, valor);
;
;         if (act->arbol == NULL)
;             *L = act->siguiente;
;         else
;             L = &act->siguiente;
;     }
;
;     return eliminados;
; }

; REGISTROS:
; EAX = retorno de ELIMINAR_ARBOL
; EBX = L (lista**)
; ECX = contador de eliminados
; EDX = act (lista*)
; EEX = auxiliar

ELIMINAR_LISTA: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX

    MOV EBX, [BP + 8]; L
    MOV ECX, 0; eliminados = 0

ELIMINAR_LISTA_OTRO: MOV EDX, [EBX]
    CMP EDX, NULL
    JZ ELIMINAR_LISTA_FIN

    ; eliminar_arbol(&act->arbol, valor)
    ; LISTA_ARBOL = 0
    PUSH [BP + 12]
    PUSH EDX
    CALL ELIMINAR_ARBOL
    ADD SP, 8

    ADD ECX, EAX

    ; if (act->arbol == NULL)
    MOV EDX, [EBX]
    CMP [EDX + LISTA_ARBOL], NULL
    JZ ELIMINAR_LISTA_ACTUAL

    ; L = &act->siguiente
    MOV EBX, EDX
    ADD EBX, LISTA_SIG
    JMP ELIMINAR_LISTA_OTRO

ELIMINAR_LISTA_ACTUAL: MOV EEX, [EDX + LISTA_SIG]
    MOV [EBX], EEX

    ; Mantener L en el enlace actual
    ; porque ahora apunta al siguiente nodo

    JMP ELIMINAR_LISTA_OTRO

ELIMINAR_LISTA_FIN: MOV EAX, ECX
    POP EEX
    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET
