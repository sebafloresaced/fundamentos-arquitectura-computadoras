int stringAEntero(char s[]) {
    int i = 0;
    int nro = 0;
    while (s[i] != '\0') {
        nro = nro * 10 + (s[i] - '0');
        i++;
    }
    return nro;
}
