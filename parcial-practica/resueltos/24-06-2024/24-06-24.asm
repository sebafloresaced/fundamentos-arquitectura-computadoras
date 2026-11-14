; typedef struct _node {
;   int value;
;   struct _node* next;
; } node;

NODE_VALUE EQU 0
NODE_NEXT EQU 4

; UTILIZAR Y NO DESARROLLAR:
; PUSH << VALOR INT >>
; CALL NEW_NODE
; ADD SP, 4
; DEVUELVE EN EAX LA DIRECCION DE MEMORIA DEL NUEVO NODO

; node* clone (node** header) {
;   if (*header == NULL) return NULL;
;   register node* n = new_node((*header)->value);
;   n->next = clone(&(*header)->next);
;   return n;
; }

; PUSH << HEADER** >>
; CALL CLONE
; ADD SP, 4
; RETORNA EN EAX LA DIRECCION DE MEMORIA DEL PRIMER NODO DE LA LISTA

CLONE: PUSH BP
    MOV BP, SP
    PUSH EDX
    PUSH EEX
    
    MOV EDX, [BP + 8]; EDX = header 
    MOV EAX, [EDX]; EAX = *header

    CMP EAX, NULL
    JZ CLONE_FIN

    PUSH [EAX + NODE_VALUE]
    CALL NEW_NODE
    ADD SP, 4
    ; EAX = n 

    MOV EEX, [EDX]
    ADD EEX, NODE_NEXT
    PUSH EEX

    MOV EEX, EAX; EEX = n 

    CALL CLONE
    ADD SP, 4
    MOV [EEX + NODE_NEXT], EAX
    MOV EAX, EEX

CLONE_FIN: POP EEX
    POP EDX
    MOV SP, BP
    POP BP
    RET

; EJERCICIO 2:

; exists devuelve 1 si el nodo buscado petenece a la lista y 0 en otro caso
; int exists (node* header, node* buscado) {
;   if (header == NULL || buscado == NULL) return 0;
;   if (buscado == header) return 1;
;   return exists(header->next, buscado);
; }

; EXISTS: 
; PUSH << BUSCADO* >>
; PUSH << HEADER* >>
; CALL EXISTS
; ADD SP, 8
; DEVUELVE EN EAX 1 O 0

EXISTS: PUSH BP
    MOV BP, SP
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = header 
    MOV EAX, [BP + 12]; EAX = buscado 

    CMP EDX, NULL
    JZ NO_PERTENECE

    CMP EAX, NULL
    JZ NO_PERTENECE

    CMP EAX, EDX
    JZ SI_PERTENECE

    PUSH EAX
    PUSH [EDX + NODE_NEXT]
    CALL EXISTS
    ADD SP, 8
    JMP EXISTS_FIN

NO_PERTENECE: MOV EAX, 0
    JMP EXISTS_FIN

SI_PERTENECE: MOV EAX, 1

EXISTS_FIN: POP EDX
    MOV SP, BP
    POP BP
    RET

; void split(node** header_a, node** header_b) {
;     node** enlaceB = header_b;
;     while (*enlaceB != NULL && !exists(*header_a, *enlaceB)) {
;         enlaceB = &(*enlaceB)->next;
;     }
;     if (*enlaceB != NULL) {
;         *enlaceB = clone(enlaceB);
;     }
; }

; SPLIT:
; PUSH << HEADER_B >>
; PUSH << HEADER_A >>
; CALL SPLIT
; ADD SP, 8

SPLIT: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH EDX
    PUSH EEX

    MOV EDX, [BP + 8]; EDX = header_a 
    MOV EBX, [BP + 12]; EBX = header_b 
    MOV EEX, EBX; EEX = enlaceB 

SPLIT_OTRO: CMP [EEX], NULL
    JZ SPLIT_OTRO_FIN

    PUSH [EEX]
    PUSH [EDX]
    CALL EXISTS
    ADD SP, 8

    CMP EAX, 1
    JZ SPLIT_OTRO_FIN

    ; enlaceB = &(*enlaceB)->next
    MOV EAX, [EEX]
    ADD EAX, NODE_NEXT
    MOV EEX, EAX

    JMP SPLIT_OTRO

SPLIT_OTRO_FIN: CMP [EEX], NULL
    JZ SPLIT_FIN 

    PUSH EEX
    CALL CLONE
    ADD SP, 4
    MOV [EEX], EAX

SPLIT_FIN: POP EEX
    POP EDX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET