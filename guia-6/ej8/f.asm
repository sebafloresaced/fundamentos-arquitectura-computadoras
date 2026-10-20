; int altura(nodo *a) {
;     if (a == NULL)
;         return 0;
;     int alturaIzq = altura(a->izq);
;     int alturaDer = altura(a->der);
;     if (alturaIzq > alturaDer)
;         return alturaIzq + 1;
;     else
;         return alturaDer + 1;
; }

; PUSH << RAIZ* >>
; CALL ALTURA
; ADD SP, 4
; DEVUELVE EN EAX LA ALTURA DEL ARBOL

ALTURA: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH EDX

    MOV EAX, 0
    MOV EDX, [BP + 8]
    CMP EDX, NULL
    JZ FIN_ALTURA

    PUSH [EDX + IZQ]
    CALL ALTURA
    ADD SP, 4
    MOV EBX, EAX; EBX = alturaIzq

    PUSH [EDX + DER]
    CALL ALTURA
    ADD SP, 4
    
    CMP EBX, EAX
    JNP ALTURA_DER
    MOV EAX, EBX

ALTURA_DER: ADD EAX, 1

FIN_ALTURA: POP EDX
    POP EBX
    MOV SP, BP
    POP BP
    RET