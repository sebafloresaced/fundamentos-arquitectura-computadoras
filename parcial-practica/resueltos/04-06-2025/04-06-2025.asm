; typedef struct _lnode {
;   short int id;
;   char* nombre;
;   struct _lnode* next;    
; } lnode;

L_ID EQU 0
L_NOMBRE EQU 2
L_NEXT EQU 6
L_SIZE EQU 10

; UTILIZAR Y NO DESARROLAR:
; PUSH << CANT BYTES >>
; CALL MALLOC
; ADD SP, 4
; DEVUELVE EN EAX LA DIR DE MEMORIA

; lnode* lnode_new (short int id, char* nombre) {
;   register lnode* r = malloc(sizeof(lnode));
;   if (r != NULL) {
;       r->id = id;
;       r->nombre = nombre;
;       r->next = NULL;
;   }
;   return r;    
; }

NULL EQU -1

; LNODE_NEW:
; PUSH << NOMBRE* >>
; PUSH << ID >>
; CALL LNODE_NEW
; ADD SP, 8
; DEVUELVE EN EAX EL PUNTERO AL NODO

LNODE_NEW: PUSH BP
    MOV BP, SP
    
    PUSH L_SIZE
    CALL MALLOC
    ADD SP, 4

    CMP EAX, NULL
    JZ LNODE_N_FIN

    MOV w[EAX + L_ID], [BP + 8]
    MOV [EAX + L_NOMBRE], [BP + 12]
    MOV [EAX + L_NEXT], NULL

LNODE_N_FIN: MOV SP, BP
    POP BP
    RET

; void list_insert_sorted (lnode** h, lnode* n) {
;   if (n != NULL) {
;       while (*h != NULL && (*h)->id < n->id)
;           h = &(*h)->next;
;       n->next = *h;
;       *h = n;
;   }
; }

; LIST_INSERT_SORTED:
; PUSH << N* >>
; PUSH << H** >>
; CALL LIST_INSERT_SORTED
; ADD SP, 8

LIST_INSERT_SORTED: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = h 
    MOV EAX, [BP + 12]; EAX = n 

    CMP EAX, NULL
    JZ LIST_I_S_FIN

LIST_I_S_OTRO: MOV EBX, [EDX]; EBX = *h 
    CMP EBX, NULL
    JZ LIST_I_S_OTRO_FIN
    CMP w[EBX + L_ID], w[EAX + L_ID]
    JNN LIST_I_S_OTRO_FIN

    ; h = &(*h)->next
    MOV EDX, EBX
    ADD EDX, L_NEXT

    JMP LIST_I_S_OTRO

LIST_I_S_OTRO_FIN: MOV [EAX + L_NEXT], EBX
    MOV [EDX], EAX

LIST_I_S_FIN: POP EDX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET

; EJERCICIO 2:

; typedef struct _archivo {
;     short int id;
;     unsigned short atributos;
;     char* nombre;
;     void* datos;
;     short int cantidad_hijos;
;     struct _archivo** hijos;
; } Archivo;

A_ID EQU 0
A_ATRIBUTOS EQU 2
A_NOMBRE EQU 4
A_DATOS EQU 8
A_CANT_HIJOS EQU 12
A_HIJOS EQU 14

; void agregar_read_only(Archivo* arbol, lnode** resultado) {
;     if (arbol == NULL)
;         return;
;     if ((arbol->atributos & 0x0207) == 4) { // compruebo que sea archivo y que sea solo de lectura para Otro
;         lnode* nuevo = lnode_new(arbol->id, arbol->nombre);
;         list_insert_sorted(resultado, nuevo);
;     }
;     for (int i = 0; i < arbol->cantidad_hijos; i++) {
;         agregar_read_only(arbol->hijos[i], resultado);
;     }
; }

; AGREGAR_READ_ONLY:
; PUSH << RESULTADO** >>
; PUSH << ARBOL* >>
; CALL AGREGAR_READ_ONLY
; ADD SP, 8

AGREGAR_READ_ONLY: PUSH BP
    MOV BP, SP

    PUSH EAX
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX

    MOV EDX, [BP + 8]; EDX = arbol
    MOV EEX, [BP + 12]; EEX = resultado

    CMP EDX, NULL
    JZ ARO_FIN

    MOV ECX, w[EDX + A_ATRIBUTOS]
    AND ECX, 0x0207; conserva carpeta y permisos Otro
    CMP ECX, 4; archivo y Otro = 100
    JNZ ARO_HIJOS

    PUSH [EDX + A_NOMBRE]; segundo argumento: nombre
    PUSH w[EDX + A_ID]; primer argumento: id
    CALL LNODE_NEW
    ADD SP, 8; EAX = nuevo

    PUSH EAX
    PUSH EEX
    CALL LIST_INSERT_SORTED
    ADD SP, 8

ARO_HIJOS: MOV EBX, 0; i = 0
ARO_OTRO: CMP EBX, w[EDX + A_CANT_HIJOS]
    JNN ARO_FIN

    MOV ECX, EBX
    MUL ECX, 4
    ADD ECX, [EDX + A_HIJOS]; ECX = &arbol->hijos[i]

    PUSH EEX; resultado: misma cabecera compartida
    PUSH [ECX]; arbol->hijos[i]
    CALL AGREGAR_READ_ONLY
    ADD SP, 8

    ADD EBX, 1
    JMP ARO_OTRO

ARO_FIN: POP EEX
    POP EDX
    POP ECX
    POP EBX
    POP EAX

    MOV SP, BP
    POP BP
    RET

; lnode* files_read_only(Archivo* arbol) {
;     lnode* resultado = NULL;
;     agregar_read_only(arbol, &resultado);
;     return resultado;
; }

; FILES_READ_ONLY:
; PUSH << ARBOL* >>
; CALL FILES_READ_ONLY
; ADD SP, 4
; Devuelve en EAX la cabecera de la lista.

FILES_READ_ONLY: PUSH BP
    MOV BP, SP
    SUB SP, 4
    PUSH EBX

    MOV [BP - 4], NULL; resultado = NULL

    MOV EBX, BP
    SUB EBX, 4; EBX = &resultado

    PUSH EBX
    PUSH [BP + 8]
    CALL AGREGAR_READ_ONLY
    ADD SP, 8

    MOV EAX, [BP - 4]; return resultado

    POP EBX
    MOV SP, BP
    POP BP
    RET