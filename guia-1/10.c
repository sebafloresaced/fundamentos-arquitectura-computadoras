#include <stdio.h>
#include <stdint.h>

int main() {
    int16_t n = 0x02A3;
    printf("a) %04X\n", (n >> 8) & 0x00FF);
    printf("b) %04X\n", n & 0x00FF);
    printf("c) %04X\n", n & 0x0001);
    printf("d) %04X\n", n >> 15);
    printf("e) %04X\n", (n >> 4) & 0x0FFF);
    printf("f) %04X\n", n & 0x000F);
    return 0;
}
