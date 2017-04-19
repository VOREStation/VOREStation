#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_turfs.dm"
	#include "tether_things.dm"
	#include "tether_areas.dm"
	#include "tether_virgo3b.dm"

	#include "tether-1.dmm"
	#include "tether-2.dmm"
	#include "tether-3.dmm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif