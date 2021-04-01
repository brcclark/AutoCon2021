/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: RandLib
 * File: RandValue.c
 * Author: manentiv
 * Created: December 20, 2011
 ********************************************************************
 * Implementation of library RandLib
 ********************************************************************/

#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif

	#include "RandLib.h"
	#include <stdlib.h>

#ifdef __cplusplus
	};
#endif

/* TODO: Add your comment here */
REAL RandValueREAL(REAL min, REAL max)
{
	REAL x;
	REAL diff;
	x = rand();
	x= x / max;
	diff = max-min;
	x = x*diff;
	
	return x;
}
