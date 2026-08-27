void representacionBinaria(int nro, char s[]) {
    int bit;
    int cantBits = sizeof(int) * 8;
    unsigned int mascara = 1u << (cantBits - 1);
    for (bit = 0; bit < cantBits; bit++) {
        if (nro & mascara)
            s[bit] = '1';
        else
            s[bit] = '0';
        mascara >>= 1;
    }
    s[cantBits] = '\0';
}
