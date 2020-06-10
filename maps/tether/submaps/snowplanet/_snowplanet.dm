#include "submaps/virgo5.dm"

// -- Overmap Sector Info -- //
/obj/effect/overmap/visitable/sector/virgo5 // All of this info is placeholder until I get lore info to update it
	name = "Virgo 5"
	desc = "Virgo 5's Decayed Orbital Array and the associated winter mining complexes... not all of which are legal."
	scanner_desc = @{"[i]Stellar Body[/i]: Virgo 5
[i]Class[/i]: R-Class Planet
[i]Habitability[/i]: Low (Extremely Low Temperature, Toxic Atmosphere)
[b]Notice[/b]: Planetary environment not suitable for life. Landing may be hazardous."}
	icon_state = "globe"
	color = "#67189c" // Dark Purple
	initial_generic_waypoints = list("array_west","array_east","array_south","array_northwest","array_northeast")
	extra_z_levels = list(Z_LEVEL_SNOWPLANET_SURFACE)
	
// -- Datums -- //

/datum/shuttle/autodock/ferry/snowplanet
	name = "Damaged Array Ferry"
	shuttle_area = /area/shuttle/snowplanet
	warmup_time = 10	//want some warmup time so people can cancel.
	landmark_station = "array_east"
	landmark_offsite = "snowplanet_surface"

/datum/random_map/noise/ore/virgo5
	descriptor = "virgo 5 ore distribution map"
	deep_val = 0.2
	rare_val = 0.1

/datum/random_map/noise/ore/virgo5/check_map_sanity()
	return 1 //Totally random, but probably beneficial.
	
// -- Objs -- //
/obj/machinery/computer/shuttle_control/snowplanet_shuttle
	name = "snowplanet ferry control console"
	shuttle_tag = "Damaged Array Ferry"

// -- Turfs -- //

//Atmosphere properties
#define VIRGO5_ONE_ATMOSPHERE	312.1 //kPa
#define VIRGO5_AVG_TEMP			612 //kelvin

#define VIRGO5_PER_N2		0.13 //percent
#define VIRGO5_PER_O2		0.00
#define VIRGO5_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO5_PER_CO2		0.77
#define VIRGO5_PER_PHORON	0.10

//Math only beyond this point
#define VIRGO5_MOL_PER_TURF		(VIRGO5_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO5_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO5_MOL_N2			(VIRGO5_MOL_PER_TURF * VIRGO5_PER_N2)
#define VIRGO5_MOL_O2			(VIRGO5_MOL_PER_TURF * VIRGO5_PER_O2)
#define VIRGO5_MOL_N2O			(VIRGO5_MOL_PER_TURF * VIRGO5_PER_N2O)
#define VIRGO5_MOL_CO2			(VIRGO5_MOL_PER_TURF * VIRGO5_PER_CO2)
#define VIRGO5_MOL_PHORON		(VIRGO5_MOL_PER_TURF * VIRGO5_PER_PHORON)

// Turfmakers
#define VIRGO5_SET_ATMOS	nitrogen=VIRGO5_MOL_N2;oxygen=VIRGO5_MOL_O2;carbon_dioxide=VIRGO5_MOL_CO2;phoron=VIRGO5_MOL_PHORON;temperature=VIRGO5_AVG_TEMP
#define VIRGO5_TURF_CREATE(x)	x/virgo5/nitrogen=VIRGO5_MOL_N2;x/virgo5/oxygen=VIRGO5_MOL_O2;x/virgo5/carbon_dioxide=VIRGO5_MOL_CO2;x/virgo5/phoron=VIRGO5_MOL_PHORON;x/virgo5/temperature=VIRGO5_AVG_TEMP;x/virgo5/color="#5c4368"

/turf/unsimulated/floor/sky/virgo5_sky
	name = "virgo 5 atmosphere"
	desc = "Be careful where you step!"
	color = "#67189c"
	VIRGO5_SET_ATMOS

/turf/unsimulated/floor/sky/virgo5_sky/Initialize()
	skyfall_levels = list(z+1)
	. = ..()

VIRGO5_TURF_CREATE(/turf/unsimulated/wall/planetary)

VIRGO5_TURF_CREATE(/turf/simulated/wall)
VIRGO5_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO5_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO5_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)
VIRGO5_TURF_CREATE(/turf/simulated/floor/outdoors/snow)

/turf/simulated/floor/outdoors/snow/virgo5
	var/ignore_mapgen = 1

VIRGO5_TURF_CREATE(/turf/simulated/mineral)
/turf/simulated/mineral/virgo5/make_ore()
	if(mineral || ignore_mapgen)
		return

	var/mineral_name = pickweight(list("phoron" = 30, "marble" = 5, "uranium" = 5, "platinum" = 10, "hematite" = 5, "carbon" = 10, "diamond" = 10, "gold" = 10, "silver" = 10, "lead" = 5, "verdantium" = 5, "rutile" = 10))

	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

VIRGO5_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO5_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO5_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

// -- Areas -- //

// The Array shuttle
/area/shuttle/snowplanet
	name = "\improper Damaged Array Shuttle"

// The array itself
/area/tether_away/snowplanet
	name = "\improper Away Mission - Damaged Array Outside"
	icon_state = "away"
	base_turf = /turf/unsimulated/floor/sky/virgo5_sky
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/tether_away/snowplanet/inside
	name = "\improper Away Mission - Damaged Array Interior"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo5
	requires_power = TRUE
	dynamic_lighting = TRUE
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/tether_away/snowplanet/solars
	name = "\improper Away Mission - Damaged Array Solar Arrays"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo5
	dynamic_lighting = TRUE

/area/tether_away/snowplanet/reactor_core
	name = "\improper Away Mission - Damaged Array Reactor Core"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo5
	dynamic_lighting = TRUE

// The Planet Surface + related areas.
/area/tether_away/snowplanet/surface
	flags = RAD_SHIELDED
	forced_ambience = list('sound/ambience/snow/howling-arctic-blizzard.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/floor/outdoors/snow/virgo5
	dynamic_lighting = TRUE

/area/tether_away/snowplanet/surface/mine
	name = "Away Mission - Virgo 5 Surface (Mining Area)"
	icon_state = "unexplored"

/area/tether_away/snowplanet/surface/explored
	name = "Away Mission - Virgo 5 Surface (E)"
	icon_state = "explored"

/area/tether_away/snowplanet/surface/unexplored
	name = "Away Mission - Virgo 5 Surface (UE)"
	icon_state = "unexplored"