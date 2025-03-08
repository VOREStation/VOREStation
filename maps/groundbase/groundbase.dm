#if !defined(USING_MAP_DATUM)

	#include "groundbase_defines.dm"
	#include "groundbase_shuttles.dm"
	#include "groundbase_telecomms.dm"
	#include "groundbase_things.dm"
	#include "groundbase_events.dm"
	#include "groundbase_poi_maps.dm"
	#include "..\~map_system\maps_vr.dm"

	#ifndef AWAY_MISSION_TEST //Don't include these for just testing away missions
		#include "gb-z1.dmm"
		#include "gb-z2.dmm"
		#include "gb-z3.dmm"
	#endif

	#define USING_MAP_DATUM /datum/map/groundbase

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Groundbase

#endif
