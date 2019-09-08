#if !defined(USING_MAP_DATUM)

	#include "anur_defines.dm"
	#include "tether_turfs.dm"
	#include "anur_things.dm"
	#include "anur_phoronlock.dm"
	#include "anur_areas.dm"
	#include "anur_areas2.dm"
	#include "anur_shuttle_defs.dm"
	#include "anur_shuttles.dm"
	#include "anur_telecomms.dm"
	#include "anur_virgo3b.dm"

	#include "anur-01-surface.dmm"
	#include "anur-02-underground.dmm"
	#include "anur-03-upper_floors.dmm"
	#include "anur-04-rooftops.dmm"

	#include "submaps/_anur_submaps.dm"

	#define USING_MAP_DATUM /datum/map/anur

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Anur Spaceport

#endif