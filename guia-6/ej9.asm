; typedef struct _arbol {
;   short int dato;
;   struct _arbol *izq, *der;
; } arbol;

DATO EQU 0
IZQ EQU 2
DER EQU 6

; int suma_hijos(arbol* A) {
;   register int res = 1;
;   if (A != NULL && (A->izq != NULL || A->der != NULL)){
;       short int suma = 0;
;       if (A->izq != NULL)
;           suma += A->izq->dato;
;       if (A->der != NULL)
;           suma += A->der->dato;
;       res = A->dato == suma && suma_hijos(A->izq) && suma_hijos(A->der);
;   }
;   return res;
; }

; SUMA_HIJOS:
; PUSH << ARBOL* >>
; CALL SUMA_HIJOS
; DEVUELVE UN BOOLEANO EN EAX

SUMA_HIJOS: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX; CX = SUMA
    PUSH EDX;

    MOV EDX, [BP + 8]; EDX = A
    MOV EAX, 1; RES = 1

    CMP EDX, NULL
    JZ FIN_SUMA

    CMP [EDX + IZQ], NULL
    JNZ HACER_SUMA

    CMP [EDX + DER], NULL
    JNZ HACER_SUMA

    JMP FIN_SUMA

HACER_SUMA: MOV CX, 0; SUMA = 0

    CMP [EDX + IZQ], NULL
    JZ VER_DER

    MOV EBX, [EDX + IZQ]
    ADD CX, w[EBX + DATO]

VER_DER: CMP [EDX + DER], NULL
    JZ COMPARAR_SUMA
    MOV EBX, [EDX + DER]
    ADD CX, w[EBX + DATO]

    ; A->dato == suma
COMPARAR_SUMA: CMP w[EDX + DATO], CX
    JNZ NO_CUMPLE

    ; suma_hijos(A->izq)
    MOV EBX, [EDX + IZQ]
    PUSH EBX
    CALL SUMA_HIJOS
    ADD SP, 4
    CMP EAX, 1
    JNZ NO_CUMPLE

    ; suma_hijos(A->der)
    MOV EBX, [EDX + DER]
    PUSH EBX
    CALL SUMA_HIJOS
    ADD SP, 4
    CMP EAX, 1
    JNZ NO_CUMPLE

SI_CUMPLE: MOV EAX, 1
    JMP FIN_SUMA

NO_CUMPLE: MOV EAX, 0

FIN_SUMA: POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET

; arbol** maximo(arbol** A) {
;   register arbol** max = A;
;   if (*A != NULL) {
;       arbol** izq = maximo(&(*A)->izq);
;       arbol** der = maximo(&(*A)->der);
;       if (*izq != NULL && (*izq)->dato > (*max)->dato)
;           max = izq;
;       if (*der != NULL && (*der)->dato > (*max)->dato)
;           max = der;
;   }
;   return max;
; }

; MAXIMO:
; PUSH << ARBOL** >>
; CALL MAXIMO
; DEVUELVE EN EAX UN PUNTERO DOBLE AL NODO MAXIMO

MAXIMO: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 8]; EDX = A
    MOV EBX, [EDX]; EBX = *A
    MOV EAX, EDX; EAX = MAX = A
    
    CMP [EDX], NULL
    JZ FIN_MAXIMO

    ; EEX = &(*A)->izq
    MOV EEX, EBX
    ADD EEX, IZQ
    PUSH EEX
    CALL MAXIMO
    ADD SP, 4
    MOV EEX, EAX ; EEX = IZQ

    ; EFX = &(*A)->der
    MOV EFX, EBX
    ADD EFX, DER
    PUSH EFX
    CALL MAXIMO
    ADD SP, 4
    MOV EFX, EAX ; EFX = DER

MAXIMO_IZQ: CMP [EEX], NULL
    JZ MAXIMO_DER

    MOV EBX, [EEX]; EBX = *izq
    MOV EDX, [EAX]; EDX = *max
    CMP w[EBX + DATO], w[EDX + DATO]
    JNP MAXIMO_DER

    MOV EAX, EEX 

MAXIMO_DER: CMP [EFX], NULL
    JZ FIN_MAXIMO

    MOV EBX, [EFX]; EBX = *der
    MOV EDX, [EAX]; EDX = *max
    CMP w[EBX + DATO], w[EDX + DATO]
    JNP FIN_MAXIMO

    MOV EAX, EFX

FIN_MAXIMO: POP EFX
    POP EEX
    POP EDX
    POP EBX
    MOV SP, BP
    POP BP
    RET