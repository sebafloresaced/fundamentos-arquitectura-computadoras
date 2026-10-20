; void recorrer_postorden(nodo *a) {
;     if (*a != null) {
;         postorden(a->izq);
;         postorden(a->der);
;         printf(a->valor);
;     }
; }

; PUSH << NODO* >>
; CALL RECORRER_POSTORDEN
; ADD SP, 4

RECORRER_POSTORDEN: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH ECX
    PUSH EDX

    MOV EDX, [BP + 8]
    CMP EDX, NULL
    JZ FIN_POSTORDEN 

    MOV EAX, 0x01
    LDL ECX, 1
    LDL ECX, 4
    SYS 2

    MOV EAX, EDX
    ADD EAX, IZQ
    PUSH EAX
    CALL RECORRER_POSTORDEN
    ADD SP, 4

    MOV EAX, EDX
    ADD EAX, DER
    PUSH EAX
    CALL RECORRER_POSTORDEN
    ADD SP, 4

FIN_POSTORDEN: POP EDX
    POP ECX
    POP EAX
    MOV SP, BP
    POP BP
    RET