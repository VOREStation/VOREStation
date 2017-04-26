#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_turfs.dm"
	#include "tether_things.dm"
	#include "tether_areas.dm"
	#include "tether_areas2.dm"
	#include "tether_virgo3b.dm"

	#include "tether-1-surface.dmm"
	#include "tether-2-transit.dmm"
	#include "tether-3-station.dmm"
	#include "tether-5-colony.dmm"
	#include "tether-6-misc.dmm"
	#include "tether-7-ships.dmm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif