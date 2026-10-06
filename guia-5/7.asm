; [BP - 4] = a
; [BP - 8] = b
; [BP - 12] = c

; a. proce(a, b, c);
; PUSH [BP - 12]
; PUSH [BP - 8]
; PUSH [BP - 4]
; CALL proce
; ADD SP, 12

; b. c = func(*a, b);
; MOV EAX, [BP - 4]
; PUSH [BP - 8]
; PUSH [EAX]; PUSH *a
; CALL func
; ADD SP, 8
; DEVUELVE EN EAX EL RESULTADO
; MOV [BP - 12], EAX

; c. proce(&a, *b, *c);
; MOV EAX, BP
; SUB EAX, 4; EAX = &a
; MOV EBX, [BP - 8]
; MOV ECX, [BP - 12]
; PUSH [ECX]
; PUSH [EBX]
; PUSH EAX
; CALL proce
; ADD SP, 12

; d. *c = func(a + b);
; MOV EAX, [BP - 4]
; ADD EAX, [BP - 8]
; PUSH EAX
; CALL func
; DEVUELVE EN EAX EL RESULTADO
; ADD SP, 4
; MOV ECX, [BP - 12]
; MOV [ECX], EAX
