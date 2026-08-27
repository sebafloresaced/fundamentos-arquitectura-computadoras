short int codificarFecha(int dia, int mes, int anio) {
    short int fecha;
    if (anio >= 2000)
        anio -= 2000;
    else
        anio -= 1900;
    fecha = (dia << 11) | (mes << 7) | anio;
    return fecha;
}
