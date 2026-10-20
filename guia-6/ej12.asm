; typedef struct {; 
;     int V;
;     unsigned char* matriz;
; } grafo;

VERTICES EQU 0
MATRIZ EQU 4

; int contar_caminos(grafo* G, int actual, int destino) {
;     if (actual == destino)
;        return 1;
;     int cantidad = 0;
;     for (int i = 0; i < G->V; i++) {
;         if (G->matriz[actual * G->V + i] == 1) {
;             cantidad += contar_caminos(G, i, destino);
;         }
;     }
;     return cantidad;
; }

; CONTAR_CAMINOS:
; PUSH << DESTINO >>
; PUSH << ACTUAL >>
; PUSH << GRAFO* >>
; CALL CONTAR_CAMINOS
; ADD SP, 12
; DEVUELVE EN EAX LA CANTIDAD DE CAMINOS

CONTAR_CAMINOS: PUSH BP
    MOV BP, SP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH EEX
    PUSH EFX

    MOV EDX, [BP + 8]  ; EDX = G
    MOV EEX, [BP + 12] ; EEX = actual
    MOV EFX, [EDX + VERTICES]

    ; if (actual == destino)
    CMP EEX, [BP + 16]
    JZ CAMINO_ENCONTRADO

    MOV EBX, 0 ; cantidad = 0
    MOV ECX, 0 ; i = 0

CAMINOS_OTRO: CMP ECX, EFX
    JZ CAMINOS_FIN

    ; matriz[actual * V + i]
    MOV EAX, EEX
    MUL EAX, EFX
    ADD EAX, ECX
    ADD EAX, [EDX + MATRIZ]

    CMP b[EAX], 1
    JNZ CAMINOS_SIG

    ; cantidad += contar_caminos(G, i, destino)
    PUSH [BP + 16]
    PUSH ECX
    PUSH EDX
    CALL CONTAR_CAMINOS
    ADD SP, 12
    ADD EBX, EAX

CAMINOS_SIG: ADD ECX, 1
    JMP CAMINOS_OTRO

CAMINOS_ENCONTRADO: MOV EAX, 1
    JMP FIN_CONTAR

CAMINOS_FIN: MOV EAX, EBX

FIN_CONTAR: POP EFX
    POP EEX
    POP EDX
    POP ECX
    POP EBX
    MOV SP, BP
    POP BP
    RET