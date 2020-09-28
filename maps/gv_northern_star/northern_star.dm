#if !defined(USING_MAP_DATUM)

	#include "polaris-1.dmm"
	#include "polaris-2.dmm"
	#include "polaris-3.dmm"
	#include "polaris-4.dmm"
	#include "polaris-5.dmm"

	#include "northern_star_defines.dm"
	#include "northern_star_areas.dm"
//	#include "northern_star_shuttles.dm"
	#include "northern_star_jobs.dm"
	#include "job/outfits.dm"

	#include "tether_turfs.dm"
//	#include "tether_things.dm"
	#include "tether_phoronlock.dm"
//	#include "tether_areas.dm"
//	#include "tether_shuttle_defs.dm"
//	#include "tether_shuttles.dm"
	#include "northern_star_telecomms.dm"
//	#include "tether_jobs.dm"


	#define USING_MAP_DATUM /datum/map/northern_star

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Northern Star

#endif