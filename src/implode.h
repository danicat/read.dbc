/* implode.h
 * Copyright (C) 2025 Daniela Petruzalek
 * For conditions of distribution and use, see copyright notice in implode.c
 */

#ifndef IMPLODE_H
#define IMPLODE_H

#include <stddef.h>

/*
 * implode() compresses input data using the PKWare DCL Implode algorithm.
 *
 * infun:   Function to read input data
 * inhow:   Opaque pointer passed to infun
 * outfun:  Function to write output data
 * outhow:  Opaque pointer passed to outfun
 *
 * returns: 0 on success
 *          1 if input read error
 *          2 if output write error
 *          3 if memory allocation error
 */

typedef unsigned (*implode_in)(void *how, unsigned char **buf);
typedef int (*implode_out)(void *how, unsigned char *buf, unsigned len);

int implode(implode_in infun, void *inhow, implode_out outfun, void *outhow);

#endif
