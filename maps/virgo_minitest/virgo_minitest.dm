#if !defined(USING_MAP_DATUM)

	#include "virgo_minitest-1.dmm"

	#include "virgo_minitest_defines.dm"

	#define USING_MAP_DATUM /datum/map/virgo_minitest

	#warning Please uncheck virgo_minitest.dm before committing.

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Virgo_minitest

#endif