; EJERCICIO 1:

\\ EXTRA 1024

NULL EQU -1

HEAP_INIT: MOV [ES], ES
    ADD [ES], 4
    RET

; ALLOC:
; PUSH << CANT BYTES >>
; CALL ALLOC
; ADD SP, 4
; DEVUELVE EN EAX LA DIR

ALLOC: PUSH BP
    MOV BP, SP
    PUSH BX
    MOV EAX, NULL
    MOV BX, [ES]
    ADD BX, [BP + 8]
    CMP BX, 1024
    JP ALLOC_FIN
    MOV EAX, [ES]
    ADD [ES], [BP + 8]

ALLOC_FIN: POP BX
    MOV SP, BP
    POP BP
    RET

; typedef struct _nnom {
;    char inicial;
;    char* nombre;
;    struct _nnom* sig;   
; } nnom;

INICIAL EQU 0
NNOM_NOMBRE EQU 1
NNOM_SIG EQU 5

; nnom* nnom_create (char* nombre) {
;   register nnom* r = alloc(9);
;   if (r != NULL) {
;       r->inicial = *nombre;
;       r->nombre = nombre;
;       r->sig = NULL; 
;   }   
;   return r;
; }

; NNOM_CREATE: 
; PUSH << NOMBRE* >>
; CALL NNOM_CREATE
; ADD SP, 4
; DEVUELVE EN EAX EL NODO CREADO

NNOM_CREATE: PUSH BP
    MOV BP, SP
    PUSH EBX

    MOV EBX, [BP + 8]; EBX = nombre

    PUSH 9
    CALL ALLOC
    ADD SP, 4
    ; EAX = r

    CMP EAX, NULL
    JZ NNOM_C_FIN

    MOV b[EAX + INICIAL], b[EBX]
    MOV [EAX + NNOM_NOMBRE], EBX
    MOV [EAX + NNOM_SIG], NULL

NNOM_C_FIN: POP EBX
    MOV SP, BP
    POP BP
    RET

; void nnom_add (nnom** header, nnom* nuevo) {
;   if (nuevo == NULL) return;
;   register nnom** n = header;
;   while (*n != NULL && (*n)->inicial < nuevo->inicial)
;       n = &(*n)->sig;
;   nuevo->sig = *n;
;   *n = nuevo;
; }

; NNOM_ADD:
; PUSH << NUEVO* >>
; PUSH << HEADER** >>
; CALL NNOM_ADD
; ADD SP, 8

NNOM_ADD: PUSH BP
    MOV BP, SP

    PUSH EAX;
    PUSH EBX;
    PUSH ECX;
    PUSH EDX;

    MOV EDX, [BP + 8]; EDX = header
    MOV ECX, [BP + 12]; ECX = nuevo

    CMP ECX, NULL
    JZ NNOM_A_FIN

    MOV EAX, EDX; EAX = n

NNOM_A_OTRO: MOV EBX, [EAX]; EBX = *n
    CMP EBX, NULL
    JZ FIN_OTRO
    CMP b[EBX + INICIAL], b[ECX + INICIAL]
    JNN FIN_OTRO

    MOV EAX, EBX; n = *n
    ADD EAX, SIG; n = &(*n) -> sig

    JMP NNOM_A_OTRO

FIN_OTRO: MOV [ECX + SIG], [EAX]
    MOV [EAX], ECX

NNOM_A_FIN: POP EDX
    POP ECX
    POP EBX
    POP EAX
    MOV SP, BP
    POP BP
    RET

_start: CALL HEAP_INIT
    ; resto del programa
    STOP

; EJERCICIO 2:

; typedef struct {
;     short anio;
;     unsigned char mes;
;     unsigned char dia;
; } Fecha;

ANIO EQU 0
MES EQU 2
DIA EQU 3

; typedef struct {
;     short id;
;     char dni[10];
;     char nombre[21];
;     Fecha nacimiento;
; } Persona;

ID EQU 0
DNI EQU 2
P_NOMBRE EQU 12
NACIMIENTO EQU 33

; typedef struct _nodo_persona {
;     Persona* persona;
;     struct _nodo_persona* siguiente;
; } NodoPersona;

PERSONA EQU 0
LISTA_SIG EQU 4

; nnom* get_mayores(Fecha fecha, NodoPersona* lista) {
;     nnom* resultado = NULL;
;     while (lista != NULL) {
;         Persona* p = lista->persona;
;         int edad = fecha.anio - p->nacimiento.anio;
;         if (edad >= 18) {
;             nnom* nuevo = nnom_create(p->nombre);
;             nnom_add(&resultado, nuevo);
;         }
;         lista = lista->siguiente;
;     }
;     return resultado;
; }

; GET_MAYORES:
; PUSH << LISTA* >>
; PUSH << FECHA >>
; CALL GET_MAYORES
; ADD SP, 8
; DEVUELVE EN EAX EL RESULTADO 

GET_MAYORES: PUSH BP
    MOV BP, SP
    SUB SP, 4; [BP - 4] = resultado
    MOV [BP - 4], NULL; resultado = NULL

    PUSH EBX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 12]; EDX = lista 
    MOV EFX, [BP + 8]; EFX = fecha

GET_M_OTRO: CMP EDX, NULL
    JZ GET_M_FIN

    MOV EAX, [EDX + PERSONA]; EAX = p
    
    // EEX = FECHA.ANIO
    MOV EEX, EFX; 
    SHR EEX, 16;

    // EBX = P->NACIMIENTO.ANIO
    MOV EBX, [EAX + NACIMIENTO]
    SHR EBX, 16

    SUB EX, BX

    CMP EX, 18
    JN GET_M_IFFIN

    MOV EBX, EAX
    ADD EBX, P_NOMBRE
    PUSH EBX
    CALL NNOM_CREATE
    ADD SP, 4
    ; EAX = nuevo

    MOV EBX, BP
    SUB EBX, 4

    PUSH EAX
    PUSH EBX
    CALL NNOM_ADD
    ADD SP, 8

GET_M_IFFIN: MOV EDX, [EDX + LISTA_SIG]
    JMP GET_M_OTRO

GET_M_FIN: MOV EAX, [BP - 4]
    POP EFX
    POP EEX
    POP EDX
    POP EBX
    ADD SP, 4
    MOV SP, BP
    POP BP
    RET