; void recorrer_preorden(nodo *a) {
;     if (*a != null) {
;         printf(a->valor);
;         preorden(a->izq);
;         preorden(a->der);
;     }
; }

; PUSH << NODO* >>
; CALL RECORRER_PREORDEN
; ADD SP, 4

RECORRER_PREORDEN: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH ECX
    PUSH EDX

    MOV EDX, [BP + 8]
    CMP [EDX], NULL
    JZ FIN_PREORDEN

    MOV EAX, 0x01
    LDL ECX, 1
    LDL ECX, 4
    SYS 2

    MOV EAX, EDX
    ADD EAX, IZQ
    PUSH EAX
    CALL RECORRER_PREORDEN
    ADD SP, 4

    MOV EAX, EDX
    ADD EAX, DER
    PUSH EAX
    CALL RECORRER_PREORDEN
    ADD SP, 4

FIN_PREORDEN: POP EDX
    POP ECX
    POP EAX
    MOV SP, BP
    POP BP
    RET