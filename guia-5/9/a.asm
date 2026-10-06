; void main() {
;     int* vec = malloc(sizeof(int) * 100);
;     short int* z;
;     z = malloc(sizeof(short int));
;     *z = 100;
;     func(vec, *z);
; }
; 
; int sum(int vec[], short int* n) {
;     static int s = 0;
;     register int i;
;     for (i = 0; i < *n; i++)
;         s = s + vec[i];
;     return s;
; }
; 
; int func(int vec[], short int z) {
;     int s;
;     short int i;
;     vec[0] = 1;
;     for (i = 1; i < z; i++)
;         vec[i] = vec[i-1] * i;
;     s = sum(vec, &z);
;     print_int(s);
; }
