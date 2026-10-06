; #include <stdio.h>
; 
; typedef int op(short int, short int);
; 
; op ops[] = {add, sub, mul, div};
; 
; char* nom[] = {"ADD", "SUB", "MUL", "DIV"};
; 
; void main() {
;     short int x, y;
;     scanf("%d %d", &x, &y);
;     for (int i = 0; i < 4; i++) {
;         printf("%s =", nom[i]);
;         printf("%d\n", ops[i](a, b));
;     }
; }
; 
; int add(short int a, short int b) {
;     return a + b;
; }
; 
; int sub(short int a, short int b) {
;     return a - b;
; }
; 
; int mul(short int a, short int b) {
;     return a * b;
; }
; 
; int div(short int a, short int b) {
;     return a / b;
; }
