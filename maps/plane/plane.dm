#if !defined(USING_MAP_DATUM)

	#include "plane-1.dmm"
	#include "plane-2.dmm"

	#include "plane_defines.dm"
	#include "plane_areas.dm"


	#define USING_MAP_DATUM /datum/map/plane

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Plane

#endif