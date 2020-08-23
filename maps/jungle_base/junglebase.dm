#if !defined(USING_MAP_DATUM)

	#include "junglebase_defines.dm"
	#include "junglebase_turfs.dm"
	#include "junglebase_things.dm"
	#include "junglebase_phoronlock.dm"
	#include "junglebase_areas.dm"
	#include "junglebase_shuttle_defs.dm"
	#include "junglebase_shuttles.dm"
	#include "junglebase_telecomms.dm"
	#include "junglebase_jobs.dm"

	#if !AWAY_MISSION_TEST //Don't include these for just testing away missions
		#include "jungle_base-01.dmm"
	#endif

	#include "submaps/_junglebase_submaps.dm"

	#define USING_MAP_DATUM /datum/map/junglebase

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Jungle Base

#endif