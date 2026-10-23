; typedef struct _btn {
;     short int clave;
;     struct _btn *izq, *der;
; } btn;

CLAVE EQU 0
IZQ EQU 2
DER EQU 6

; void btn_list (btn** arbol, ln* lista) {
;     void **p_valor;
;     btn *a = *arbol;
;     if (a != NULL) {
;         // llamado recursivo
;         btn_list(&(a->izq),lista);
;         btn_list(&(a->der),lista);
;         p_valor = buscar(lista, a->clave);
;         if (p_valor != NULL) { // existe un nodo en la lista con el valor de la clave
;             *p_valor = a;
;             *arbol = NULL;
;         }
;     }
; }

; BTN_LIST:
; PUSH << LISTA* >>
; PUSH << ARBOL** >>
; CALL BTN_LIST
; ADD SP, 8

BTN_LIST: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EFX

    MOV EDX, [BP + 8]; EDX = arbol
    MOV ECX, [EDX]; ECX = a
    MOV EBX, [BP + 12]; EBX = lista

    CMP ECX, NULL
    JZ FIN_BTN_LIST

    PUSH EBX
    MOV EFX, ECX
    ADD EFX, IZQ; EFX = &(a->izq)
    PUSH EFX
    CALL BTN_LIST
    ADD SP, 8

    PUSH EBX
    MOV EFX, ECX
    ADD EFX, DER; EFX = &(a->der)
    PUSH EFX
    CALL BTN_LIST
    ADD SP, 8

    PUSH w[ECX + CLAVE]
    PUSH EBX
    CALL BUSCAR
    ADD SP, 8
    ; EAX = p_valor

    CMP EAX, NULL
    JZ FIN_BTN_LIST

    MOV [EAX], ECX
    MOV [EDX], NULL

FIN_BTN_LIST: POP EFX
    POP EDX
    POP ECX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET
