#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_turfs.dm"
	#include "tether_things.dm"
	#include "tether_phoronlock.dm"
	#include "tether_areas.dm"
	#include "tether_shuttle_defs.dm"
	#include "tether_shuttles.dm"
	#include "tether_telecomms.dm"
	#include "tether_jobs.dm"
	#include "tether_events.dm"
	#include "../offmap_vr/common_offmaps.dm"

	#ifndef AWAY_MISSION_TEST //Don't include these for just testing away missions
		#include "tether-01-surface1.dmm"
		#include "tether-02-surface2.dmm"
		#include "tether-03-surface3.dmm"
		#include "tether-04-transit.dmm"
		#include "tether-05-station1.dmm"
		#include "tether-06-mining.dmm"
		#include "tether-07-solars.dmm"
	#endif

	#include "submaps/_tether_submaps.dm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif
