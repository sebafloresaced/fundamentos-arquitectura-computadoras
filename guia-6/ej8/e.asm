; int buscar_nodo(nodo *a, int valor) {
;     if (*a == null)
;         return 0;
;     else {
;         return (a->valor == valor) || buscar_nodo(a->izq,valor) || buscar_nodo(a->der,valor);
;     }
; }

; PUSH << VALOR >>
; PUSH << RAIZ* >>
; CALL BUSCAR_NODO
; ADD SP, 8
; DEVUELVE EN EAX 1 SI LO ENCONTRO O 0 SI NO

BUSCAR_NODO: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = RAIZ
    MOV EBX, [BP + 12]; EBX = VALOR

    CMP EDX, NULL
    JZ NO_ESTA

    CMP [EDX + VALOR], EBX
    JZ SI_ESTA

    ; BUSCO EN HIJOS
    PUSH EBX
    PUSH [EDX + IZQ]
    CALL BUSCAR_NODO
    ADD SP, 8
    CMP EAX, 1
    JZ FIN_BUSCAR

    PUSH EBX
    PUSH [EDX + DER]
    CALL BUSCAR_NODO
    ADD SP, 8
    JMP FIN_BUSCAR

NO_ESTA: MOV EAX, 0
    JMP FIN_BUSCAR

SI_ESTA: MOV EAX, 1

FIN_BUSCAR: POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET