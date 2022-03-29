#if !defined(USING_MAP_DATUM)

	#include "groundbase_areas.dm"
	#include "groundbase_defines.dm"
//	#include "stellar_delight_shuttle_defs.dm"
//	#include "stellar_delight_telecomms.dm"
//	#include "stellar_delight_things.dm"
	#include "..\offmap_vr\common_offmaps.dm"
	#include "..\tether\tether_jobs.dm"
   	#include "..\stellardelight\stellar_delight_areas.dm"

	#if !AWAY_MISSION_TEST //Don't include these for just testing away missions
		#include "gb-z1.dmm"
		#include "gb-z2.dmm"
		#include "gb-z3.dmm"
	#endif

	#define USING_MAP_DATUM /datum/map/groundbase

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Groundbase

#endif