void ImprimeDiasActivos(char c) {
   int i;
   char *Dias[] = {"Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado"};
   for (i=0;i<7;i++) {
     if (c & 1) {
       printf("%s\n",Dias[i]);
     }
     c = c >> 1;
   }
}
