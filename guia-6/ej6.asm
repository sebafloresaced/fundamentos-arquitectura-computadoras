; void invertir(lista** L) {
;     lista* ant = NULL;
;     lista* act = *L;
;     lista* sig;
;     while (act != NULL) {
;         sig = act->sig;
;         act->sig = ant;
;         ant = act;
;         act = sig;
;     }
;     *L = ant;
; }

; INVERTIR:
; PUSH << -> HEAD >>
; CALL INVERTIR
; ADD SP, 4
; MODIFICA DIRECTAMENTE HEAD

INVERTIR: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EBX
    PUSH ECX
    PUSH EDX
    MOV EDX, [BP + 8]; EDX = L
    MOV EBX, [EDX]; EBX = *L (act)
    MOV EAX, NULL; ant = NULL

INVERTIR_OTRO: CMP EBX, NULL
    JZ INVERTIR_FIN
    MOV ECX, [EBX + SIG]; sig = act->sig
    MOV [EBX + SIG], EAX; act->sig = ant
    MOV EAX, EBX; ant = act
    MOV EBX, ECX; act = sig
    JMP INVERTIR_OTRO

INVERTIR_FIN: MOV [EDX], EAX; *L = ant
    POP EDX
    POP ECX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET