void pasarMayusculas(char s[]) {
    int i;
    for (i = 0; s[i] != '\0'; i++) {
        if (s[i] >= 'a' && s[i] <= 'z') {
            s[i] = s[i] & ~' ';
        }
    }
}
