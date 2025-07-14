#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .C calls */
extern void dbc2dbf(void *, void *);

static const R_CMethodDef CEntries[] = {
    {"dbc2dbf", (DL_FUNC) &dbc2dbf, 2},
    {NULL, NULL, 0}
};

void R_init_read_dbc(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
