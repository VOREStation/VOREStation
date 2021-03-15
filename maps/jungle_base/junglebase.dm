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
		#include "jungle_base-01-groundbase.dmm"
		#include "jungle_base-02-civplatform.dmm"
		#include "jungle_base-03-researchplatform.dmm"
		#include "jungle_base-04-shuttlepad.dmm"
		#include "jungle_base-05-undermine.dmm"
		#include "jungle_base-06-engine.dmm"
	#endif

	#include "submaps/_junglebase_submaps.dm"

	#define USING_MAP_DATUM /datum/map/junglebase

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Jungle Base

#endif