; typedef struct _arbol {
;     int valor;
;     struct _arbol** hijos;
; } T_Arbol;

A_VALOR EQU 0
A_HIJOS EQU 4
A_SIZE EQU 8

; typedef struct _nodo_lista {
;     int valor;
;     int nivel;
;     struct _nodo_lista* siguiente;
; } T_NodoLista;

N_VALOR EQU 0
N_NIVEL EQU 4
N_SIGUIENTE EQU 8
N_SIZE EQU 12

; typedef struct _lista {
;     T_NodoLista* primero;
; } T_Lista;

L_PRIMERO EQU 0
L_SIZE EQU 4

; hijos apunta a un arreglo de punteros terminado en NULL.
; Si el nodo no tiene hijos, hijos[0] es NULL.
; La lista tiene una cabecera que apunta al primer nodo.
; Si está vacía, primero es NULL.

; void insertar_por_nivel(T_Lista* lista, int valor, int nivel) {
;     T_NodoLista* nuevo = malloc(sizeof(T_NodoLista));
;     T_NodoLista** enlace = &lista->primero;
;     nuevo->valor = valor;
;     nuevo->nivel = nivel;
;     while (*enlace != NULL && (*enlace)->nivel <= nivel) {
;         enlace = &(*enlace)->siguiente;
;     }
;     nuevo->siguiente = *enlace;
;     *enlace = nuevo;
; }

; INSERTAR_POR_NIVEL: 
; PUSH << NIVEL >>
; PUSH << VALOR >>
; PUSH << LISTA* >>
; CALL INSERTAR_POR_NIVEL
; ADD SP, 12

INSERTAR_POR_NIVEL: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 8]; EDX = lista
    MOV EBX, [BP + 16]; EBX = nivel

    PUSH N_SIZE
    CALL ALLOC
    ADD SP, 4
    ; EAX = nuevo

    MOV EEX, EDX
    ADD EEX, L_PRIMERO; EEX = enlace

    MOV [EAX + N_VALOR], [BP + 12]
    MOV [EAX + N_NIVEL], EBX

INSERTAR_POR_NIVEL_OTRO: MOV EFX, [EEX]; EFX = *enlace
    CMP EFX, NULL
    JZ INSERTAR_POR_NIVEL_OTRO_FIN
    CMP [EFX + N_NIVEL], EBX
    JP INSERTAR_POR_NIVEL_OTRO_FIN

    MOV EEX, EFX
    ADD EEX, N_SIGUIENTE
    JMP INSERTAR_POR_NIVEL_OTRO

INSERTAR_POR_NIVEL_OTRO_FIN: MOV [EAX + N_SIGUIENTE],  EFX
    MOV [EEX], EAX

INSERTAR_POR_NIVEL_FIN: POP EFX
    POP EEX
    POP EDX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET

; void recorrer(T_Arbol* raiz, int nivel, T_Lista* lista) {
;     if (raiz == NULL)
;         return;
;     insertar_por_nivel(lista, raiz->valor, nivel);
;     for (int i = 0; raiz->hijos[i] != NULL; i++) {
;         recorrer(raiz->hijos[i], nivel + 1, lista);
;     }
; }

; RECORRER:
; PUSH << LISTA* >>
; PUSH << NIVEL >>
; PUSH << RAIZ* >>
; CALL RECORRER
; ADD SP, 12

RECORRER: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 16]; EDX = lista 
    MOV EEX, [BP + 12]; EEX = nivel
    MOV EFX, [BP + 8]; EFX = raiz 

    CMP EFX, NULL
    JZ RECORRER_FIN

    PUSH EEX
    PUSH [EFX + A_VALOR]
    PUSH EDX
    CALL INSERTAR_POR_NIVEL
    ADD SP, 12

    MOV ECX, 0; ECX = i 
RECORRER_OTRO: MOV EBX, ECX
    MUL EBX, 4
    ADD EBX, [EFX + A_HIJOS]
    MOV EBX, [EBX]
    ; EBX = raiz->hijos[i]

    CMP EBX, NULL
    JZ RECORRER_FIN

    PUSH EDX
    MOV EAX, EEX
    ADD EAX, 1
    PUSH EAX
    PUSH EBX
    CALL RECORRER
    ADD SP, 12

    ADD ECX, 1
    JMP RECORRER_OTRO

RECORRER_FIN: POP EFX
    POP EEX
    POP EDX
    POP ECX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET

; T_Lista* crear_lista_pornivel(T_Arbol* root) {
;     T_Lista* lista = malloc(sizeof(T_Lista));
;     lista->primero = NULL;
;     recorrer(root, 0, lista);
;     return lista;
; }

; CREAR_LISTA_PORNIVEL: 
; PUSH << ROOT* >>
; CALL CREAR_LISTA_PORNIVEL
; ADD SP, 4
; DEVUELVE EN EAX LA LISTA

CREAR_LISTA_PORNIVEL: PUSH BP
    MOV BP, SP
    PUSH L_SIZE
    CALL ALLOC
    ADD SP, 4
    ; EAX = lista 
    MOV [EAX + L_PRIMERO], NULL
    PUSH EAX
    PUSH 0
    PUSH [BP + 8]
    CALL RECORRER
    ADD SP, 12
    MOV SP, BP
    POP BP
    RET