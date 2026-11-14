; typedef struct _ting {
;   int id_ingrediente;
;   char mask;
;   char* descrip;
;   int limite;   
; } ting;

TI_ID EQU 0
TI_MASK EQU 4
TI_DESCRIP EQU 5
TI_LIMITE EQU 9

; typedef struct _nodoabb {
;   ting* ing;
;   struct _nodoabb* izq;
;   struct _nodoabb* der;
; } nodoabb;

NODO_ING EQU 0
NODO_IZQ EQU 4
NODO_DER EQU 8

; ting* busca_abb (nodoabb* root, int id) {
;   register ting* r = NULL;
;   if (root != NULL) {
;       if (root->ing->id_ingrediente == id) {
;           r = root->ing;
;       } else if (root->ing->id_ingrediente > id) {
;           r = busca_abb(root->izq, id);
;       } else { // id_ingrediente < id
;           r = busca_abb(root->der, id);
;       }
;   }
;   return r;
; }

; BUSCA_ABB:
; PUSH << ID >>
; PUSH << ROOT* >>
; CALL BUSCA_ABB
; ADD SP, 8
; DEVUELVE EN EAX

NULL EQU -1

BUSCA_ABB: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH EDX

    MOV EBX, [BP + 12]; EBX = id
    MOV EDX, [BP + 8]; EDX = root
    MOV EAX, NULL; EAX = r = NULL

    CMP EDX, NULL
    JZ BUSCA_ABB_FIN

    MOV EAX, [EDX + NODO_ING]; EAX = root->ing 

    CMP [EAX + TI_ID], EBX
    JZ BUSCA_ABB_ENCONTRE
    JP BUSCA_ABB_IZQ
    
    PUSH EBX
    PUSH [EDX + NODO_DER]
    CALL BUSCA_ABB
    ADD SP, 8
    JMP BUSCA_ABB_FIN

BUSCA_ABB_ENCONTRE: JMP BUSCA_ABB_FIN; r = root->ing 

BUSCA_ABB_IZQ: PUSH EBX
    PUSH [EDX + NODO_IZQ]
    CALL BUSCA_ABB
    ADD SP, 8
    
BUSCA_ABB_FIN: POP EDX
    POP EBX
    MOV SP, BP
    POP BP
    RET

; EJERCICIO 2:

; typedef struct _ingredientes {
;   int id_ingrediente;
;   short int cantidad;
;   struct _ingredientes* sig;
; } ingredientes;

ING_ID EQU 0
ING_CANTIDAD EQU 4
ING_SIG EQU 6

; typedef struct producto {
;   int id_producto;
;   char* nombre;
;   char sellos;
;   ingredientes* lista_ingredientes;
; } producto;

PRODUCTO_ID EQU 0
PRODUCTO_NOMBRE EQU 4
PRODUCTO_SELLOS EQU 8
PRODUCTO_LISTA_INGREDIENTES EQU 9

; Se marca el sello cuando la CANTIDAD del ingrediente de productos supera 
; el LIMITE aceptable indicado en el abb

; void completasellos (nodoabb* h, producto* p) {
;   register lista_ingredientes* l_ing;   
;   if (p != NULL) {
;       l_ing = p->lista_ingredientes;
;       while (l_ing != NULL) {
;           ing = busca_abb(h, l_ing->id_ingrediente);
;           if (ing != NULL && l_ing->cantidad > ing->limite) {
;               // Marcar sello
;               p->sellos |= ing->mask;
;           }
;           l_ing = l_ing->sig;
;       }
;   }  
; }

; COMPLETASELLOS:
; PUSH << P* >>
; PUSH << H* >>
; CALL COMPLETASELLOS
; ADD SP, 8

COMPLETASELLOS: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH ECX
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = h 
    MOV ECX, [BP + 12]; ECX = p 

    CMP ECX, NULL
    JZ COMPLETASELLOS_FIN

    MOV EBX, [ECX + PRODUCTO_LISTA_INGREDIENTES]; EBX = l_ing = p->lista_ingredientes

COMPLETASELLOS_OTRO: CMP EBX, NULL
    JZ COMPLETASELLOS_FIN

    PUSH [EBX + ING_ID]
    PUSH EDX
    CALL BUSCA_ABB
    ADD SP, 8
    ; EAX = ing

    CMP EAX, NULL
    JZ COMPLETASELLOS_NO_MARCAR

    CMP w[EBX + ING_CANTIDAD], [EAX + TI_LIMITE]
    JNP COMPLETASELLOS_NO_MARCAR

    ;MARCAR SELLO
    OR b[ECX + PRODUCTO_SELLOS], b[EAX + TI_MASK]

COMPLETASELLOS_NO_MARCAR: MOV EBX, [EBX + ING_SIG]
    JMP COMPLETASELLOS_OTRO

COMPLETASELLOS_FIN: POP EDX
    POP ECX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET