#include <stdio.h>
void VerificaComplementoA2() {
  int i,tope = sizeof(int) * 8, n = -1;
  n = n >> tope-1;
  printf("Bit mas significativo de n = -1 : %d", n & 1);
}
int main() {
  VerificaComplementoA2();
  return 0;
}
