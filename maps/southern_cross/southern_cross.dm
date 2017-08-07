// You probably don't want to tick this file yet.

#if !defined(USING_MAP_DATUM)

	#include "southern_cross_areas.dm"
	#include "southern_cross_defines.dm"
	#include "southern_cross_elevator.dm"
	#include "southern_cross_presets.dm"
	#include "southern_cross_shuttles.dm"

	#include "structures/closets/engineering.dm"
	#include "structures/closets/medical.dm"
	#include "structures/closets/misc.dm"
	#include "structures/closets/research.dm"
	#include "structures/closets/security.dm"
	#include "turfs/outdoors.dm"

	#include "southern_cross-1.dmm"
	#include "southern_cross-2.dmm"
	#include "southern_cross-3.dmm"
	#include "southern_cross-4.dmm"
	#include "southern_cross-5.dmm"
	#include "southern_cross-6.dmm"
	#include "southern_cross-7.dmm"

	#define USING_MAP_DATUM /datum/map/southern_cross

	// todo: map.dmm-s here

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Southern Cross

#endif