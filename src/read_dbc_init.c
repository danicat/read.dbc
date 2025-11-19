#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void dbc2dbf(void *, void *, void *, void *);

/* .Call calls */
extern SEXP dbf2dbc(SEXP, SEXP);

static const R_CMethodDef CEntries[] = {
    {"dbc2dbf", (DL_FUNC) &dbc2dbf, 4},
    {NULL, NULL, 0}
};

static const R_CallMethodDef CallEntries[] = {
    {"dbf2dbc", (DL_FUNC) &dbf2dbc, 2},
    {NULL, NULL, 0}
};

void R_init_read_dbc(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
