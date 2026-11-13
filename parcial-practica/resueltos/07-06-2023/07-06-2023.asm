; EJERCICIO 1

\\ INCLUDE ALLOC
; ALLOC:
; PUSH << CANT BYTES >>
; CALL ALLOC
; DEVUELVE EN EAX EL PUNTERO AL NODO

; typedef struct _nodo {
;   char* nombre;
;   struct _nodo* siguiente;
; } nodo;

N_NOMBRE EQU 0
N_SIGUIENTE EQU 4
N_SIZE EQU 8

; nodo* crear_nodo (char* s) {
;   register nodo* r = alloc(sizeof(nodo));
;   r->nombre = s;
;   return r;    
; }

; CREAR_NODO:
; PUSH << S* >>
; CALL CREAR_NODO
; ADD SP, 4
; DEVUELVE EN EAX EL PUNTERO AL NODO

CREAR_NODO: PUSH BP
    MOV BP, SP
    PUSH EBX
    MOV EBX, [BP + 8]; EBX = s
    PUSH N_SIZE
    CALL ALLOC
    ADD SP, 4
    MOV [EAX + N_NOMBRE], EBX
    POP EBX
    MOV SP, BP
    POP BP
    RET

; void insert_nodo (nodo** head, nodo* n) {
;     n->siguiente = *head;
;     *head = n;
; }

; INSERT_NODO:
; PUSH << N* >>
; PUSH << HEAD** >>
; CALL INSERT_NODO
; ADD SP, 8

INSERT_NODO: PUSH BP
    MOV BP, SP
    PUSH EAX
    PUSH EDX

    MOV EDX, [BP + 8]; EDX = head
    MOV EAX, [BP + 12]; EAX = n 

    MOV [EAX + N_SIGUIENTE], [EDX]
    MOV [EDX], EAX

    POP EDX
    POP EAX
    MOV SP, BP
    POP BP
    RET

; char* nom = "Pedro"
NOM EQU "PEDRO"

; void main() {
;   nodo* a[31];
;   for (int i = 0; i < 31; i++)
;       a[i] = NULL;
;   insert_nodo(&a[2], crear_nodo(nom));
; }

MAIN: PUSH BP
    MOV BP, SP

    SUB SP, 124; a: arreglo de 31 punteros
    PUSH EAX
    PUSH ECX
    PUSH EDX

    MOV ECX, 0; ECX = i

MAIN_OTRO: CMP ECX, 31
    JNN MAIN_O_FIN

    ; EDX = a[i]
    MOV EDX, ECX
    MUL EDX, 4
    ADD EDX, BP
    SUB EDX, 124

    MOV [EDX], NULL; a[i] = NULL
    ADD ECX, 1
    JMP MAIN_OTRO

MAIN_O_FIN: PUSH NOM
    CALL CREAR_NODO
    ADD SP, 4
    PUSH EAX

    MOV EDX, BP
    SUB EDX, 124
    ADD EDX, 8; EDX = &a[2]
    PUSH EDX

    CALL INSERT_NODO
    ADD SP, 8

    POP EDX
    POP ECX
    POP EAX
    ADD SP, 4
    ADD SP, 124
    MOV SP, BP
    POP BP
    RET


; EJERCICIO 2:

; typedef struct _persona {
;     int id;
;     char* titulo;
;     char* nombre;
;     unsigned short fecha;
;     int cantidad_hijos;
;     struct _persona* hijos[];
; } Persona;

P_ID EQU 0
P_TITULO EQU 4
P_NOMBRE EQU 8
P_FECHA EQU 12
P_CANT_HIJOS EQU 14
P_HIJOS EQU 18

; fecha ocupa 16 bits:
; [ año: 7 bits ][ mes: 4 bits ][ día: 5 bits ]

; void cumplesxdia(Persona* arbol, int mes, nodo** a) {
;     if (arbol == NULL)
;         return;
;
;     int mes_nacimiento = (arbol->fecha >> 5) & 15;
;
;     if (mes_nacimiento == mes) {
;         int dia = arbol->fecha & 31;
;         nodo* nuevo = crear_nodo(arbol->nombre);
;         insert_nodo(&a[dia - 1], nuevo);
;     }
;
;     for (int i = 0; i < arbol->cantidad_hijos; i++) {
;         cumplesxdia(arbol->hijos[i], mes, a);
;     }
; }

; CUMPLESXDIA:
; PUSH << A* >>
; PUSH << MES >>
; PUSH << ARBOL* >>
; CALL CUMPLESXDIA
; ADD SP, 12
; Completa el arreglo recibido.
; No devuelve un valor.

CUMPLESXDIA: PUSH BP
    MOV BP, SP

    PUSH EAX
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 8]; EDX = arbol
    MOV EEX, [BP + 12]; EEX = mes
    MOV EFX, [BP + 16]; EFX = a

    CMP EDX, NULL
    JZ CUM_FIN

    MOV ECX, w[EDX + P_FECHA]
    SHR ECX, 5
    AND ECX, 15; ECX = mes de nacimiento

    CMP ECX, EEX
    JNZ CUM_HIJOS

    MOV EBX, w[EDX + P_FECHA]
    AND EBX, 31; EBX = día

    SUB EBX, 1
    MUL EBX, 4
    ADD EBX, EFX; EBX = &a[dia - 1]

    PUSH [EDX + P_NOMBRE]; nombre es un puntero
    CALL CREAR_NODO
    ADD SP, 4; EAX = nuevo

    PUSH EAX
    PUSH EBX
    CALL INSERT_NODO
    ADD SP, 8

CUM_HIJOS: MOV EBX, 0; i = 0

CUM_OTRO: CMP EBX, [EDX + P_CANT_HIJOS]
    JNN CUM_FIN

    MOV ECX, EBX
    MUL ECX, 4
    ADD ECX, EDX
    ADD ECX, P_HIJOS; ECX = &arbol->hijos[i]

    PUSH EFX; a
    PUSH EEX; mes
    PUSH [ECX]; arbol->hijos[i]
    CALL CUMPLESXDIA
    ADD SP, 12

    ADD EBX, 1
    JMP CUM_OTRO

CUM_FIN: POP EFX
    POP EEX
    POP EDX
    POP ECX
    POP EBX
    POP EAX

    MOV SP, BP
    POP BP
    RET