#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_turfs.dm"
	#include "tether_things.dm"
	#include "tether_areas.dm"
	#include "tether_areas2.dm"
	#include "tether_virgo3b.dm"

	#include "tether-1.dmm"
	#include "tether-2.dmm"
	#include "tether-3.dmm"
	#include "tether-4-colony.dmm"
	#include "tether-5-misc.dmm"
	#include "tether-6-ships.dmm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif