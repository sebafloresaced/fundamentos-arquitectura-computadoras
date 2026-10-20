; void recorrer_inorden(nodo *a) {
;     if (*a != null) {
;         inorden(a->izq);
;         printf(a->valor);
;         inorden(a->der);
;     }
; }

; PUSH << NODO* >>
; CALL RECORRER_INORDEN
; ADD SP, 4

RECORRER_INORDEN: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH ECX
    PUSH EDX

    MOV EDX, [BP + 8]
    CMP [EDX], NULL
    JZ FIN_INORDEN

    MOV EAX, EDX
    ADD EAX, IZQ
    PUSH EAX
    CALL RECORRER_INORDEN
    ADD SP, 4

    MOV EAX, 0x01
    LDL ECX, 1
    LDL ECX, 4
    SYS 2

    MOV EAX, EDX
    ADD EAX, DER
    PUSH EAX
    CALL RECORRER_INORDEN
    ADD SP, 4

FIN_INORDEN: POP EDX
    POP ECX
    POP EAX
    MOV SP, BP
    POP BP
    RET