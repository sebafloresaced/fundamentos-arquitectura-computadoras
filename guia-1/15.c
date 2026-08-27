#include <stdio.h>

void imprimirFecha(unsigned short int fecha) {
    int dia, mes, anio;
    dia = (fecha >> 11) & 0x1F;   // 5 bits
    mes = (fecha >> 7) & 0x0F;    // 4 bits
    anio = fecha & 0x7F;          // 7 bits
    if (anio > 50)
        anio += 1900;
    else
        anio += 2000;
    printf("%04d-%02d-%02d\n", anio, mes, dia);
}
