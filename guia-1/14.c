void weekday_set(char *c,int n) {
  int mascara = 1u << n;
  *c = (*c) | mascara;
}
void weekday_reset(char *c,int n) {
  int mascara = 1u << n;
  *c = (*c) &~ mascara;
}
