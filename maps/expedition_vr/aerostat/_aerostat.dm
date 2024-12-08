#include "../../submaps/pois_vr/aerostat/virgo2.dm"

/obj/effect/overmap/visitable/sector/virgo2
	name = "Virgo 2"
	desc = "Includes the Remmi Aerostat and associated ground mining complexes."
	scanner_desc = @{"[i]Stellar Body[/i]: Virgo 2
[i]Class[/i]: R-Class Planet
[i]Habitability[/i]: Low (High Temperature, Toxic Atmosphere)
[b]Notice[/b]: Planetary environment not suitable for life. Landing may be hazardous."}
	icon_state = "globe"
	in_space = 0
	initial_generic_waypoints = list("aerostat_west","aerostat_east","aerostat_south","aerostat_northwest","aerostat_northeast")
	extra_z_levels = list(Z_LEVEL_AEROSTAT_SURFACE)
	known = TRUE
	icon_state = "chlorine"

	skybox_icon = 'icons/skybox/virgo2.dmi'
	skybox_icon_state = "v2"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

// -- Datums -- //

/datum/shuttle/autodock/ferry/aerostat
	name = "Aerostat Ferry"
	shuttle_area = /area/shuttle/aerostat
	warmup_time = 10	//want some warmup time so people can cancel.
	landmark_station = "aerostat_east"
	landmark_offsite = "aerostat_surface"

/datum/random_map/noise/ore/virgo2
	descriptor = "virgo 2 ore distribution map"
	deep_val = 0.2
	rare_val = 0.1

/datum/random_map/noise/ore/virgo2/check_map_sanity()
	return 1 //Totally random, but probably beneficial.

/datum/random_map/noise/ore/virgo2/apply_to_turf(var/x,var/y)			//Same as normal + Rutile

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process) sleep(-1)
			T.resources = list()
			T.resources[ORE_SAND] = rand(3,5)
			T.resources[ORE_CARBON] = rand(3,5)

			var/current_cell = map[get_map_cell(x,y)]
			if(current_cell < rare_val)      // Surface metals.
				T.resources[ORE_HEMATITE] = rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[ORE_GOLD] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[ORE_SILVER] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[ORE_URANIUM] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[ORE_MARBLE] =   rand(RESOURCE_LOW_MIN, RESOURCE_MID_MAX)
				T.resources[ORE_DIAMOND] =  0
				T.resources[ORE_PHORON] =   0
				T.resources[ORE_PLATINUM] =   0
				T.resources[ORE_MHYDROGEN] = 0
				T.resources[ORE_VERDANTIUM] = 0
				T.resources[ORE_LEAD]     = 0
				//T.resources[ORE_COPPER] =   rand(RESOURCE_MID_MIN, RESOURCE_HIGH_MAX)
				//T.resources[ORE_TIN] =      rand(RESOURCE_LOW_MIN, RESOURCE_MID_MAX)
				//T.resources[ORE_BAUXITE] =  rand(RESOURCE_LOW_MIN, RESOURCE_LOW_MAX)
				T.resources[ORE_RUTILE] =   rand(RESOURCE_LOW_MIN, RESOURCE_LOW_MAX)
				//T.resources[ORE_VOPAL] = 0
				//T.resources[ORE_QUARTZ] = 0
				//T.resources[ORE_PAINITE] = 0
			else if(current_cell < deep_val) // Rare metals.
				T.resources[ORE_GOLD] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[ORE_SILVER] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[ORE_URANIUM] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[ORE_PHORON] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[ORE_PLATINUM] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[ORE_VERDANTIUM] = rand(RESOURCE_LOW_MIN, RESOURCE_LOW_MAX)
				T.resources[ORE_LEAD] =     rand(RESOURCE_LOW_MIN, RESOURCE_MID_MAX)
				T.resources[ORE_MHYDROGEN] = 0
				T.resources[ORE_DIAMOND] =  0
				T.resources[ORE_HEMATITE] = 0
				T.resources[ORE_MARBLE] =   0
				//T.resources[ORE_COPPER] =   0
				//T.resources[ORE_TIN] =      rand(RESOURCE_MID_MIN, RESOURCE_MID_MAX)
				//T.resources[ORE_BAUXITE] =  0
				T.resources[ORE_RUTILE] =   rand(RESOURCE_MID_MIN, RESOURCE_MID_MAX)
				//T.resources[ORE_VOPAL] = 0
				//T.resources[ORE_QUARTZ] = 0
				//T.resources[ORE_PAINITE] = 0
			else                             // Deep metals.
				T.resources[ORE_URANIUM] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[ORE_DIAMOND] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[ORE_VERDANTIUM] = rand(RESOURCE_LOW_MIN, RESOURCE_MID_MAX)
				T.resources[ORE_PHORON] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[ORE_PLATINUM] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[ORE_MHYDROGEN] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[ORE_MARBLE] =   rand(RESOURCE_MID_MIN, RESOURCE_HIGH_MAX)
				T.resources[ORE_LEAD] =     rand(RESOURCE_LOW_MIN, RESOURCE_HIGH_MAX)
				T.resources[ORE_HEMATITE] = 0
				T.resources[ORE_GOLD] =     0
				T.resources[ORE_SILVER] =   0
				//T.resources[ORE_COPPER] =   0
				//T.resources[ORE_TIN] =      0
				//T.resources[ORE_BAUXITE] =  0
				T.resources[ORE_RUTILE] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				//T.resources[ORE_VOPAL] = 0
				//T.resources[ORE_QUARTZ] = 0
				//T.resources[ORE_PAINITE] = 0
	return

// -- Objs -- //

/obj/machinery/computer/shuttle_control/aerostat_shuttle
	name = "aerostat ferry control console"
	shuttle_tag = "Aerostat Ferry"

/obj/tether_away_spawner/aerostat_inside
	name = "Aerostat Indoors Spawner"
	faction = FACTION_AEROSTAT_INSIDE
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic = 3,
		/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion = 1,
		/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser = 3,
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1
	)

/obj/tether_away_spawner/aerostat_surface
	name = "Aerostat Surface Spawner"
	faction = FACTION_AEROSTAT_SURFACE
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 30
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/jelly = 6,
		/mob/living/simple_mob/mechanical/viscerator = 6,
		/mob/living/simple_mob/vore/aggressive/corrupthound = 3,
		/mob/living/simple_mob/vore/oregrub = 2,
		/mob/living/simple_mob/vore/oregrub/lava = 1
	)

/obj/structure/old_roboprinter
	name = "old drone fabricator"
	desc = "Built like a tank, still working after so many years."
	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	anchored = TRUE
	density = TRUE

/obj/structure/metal_edge
	name = "metal underside"
	desc = "A metal wall that extends downwards."
	icon = 'icons/turf/cliff.dmi'
	icon_state = "metal"
	anchored = TRUE
	density = FALSE

// -- Turfs -- //

//Atmosphere properties
#define VIRGO2_ONE_ATMOSPHERE	312.1 //kPa
#define VIRGO2_AVG_TEMP			612 //kelvin

#define VIRGO2_PER_N2		0.10 //percent
#define VIRGO2_PER_O2		0.03
#define VIRGO2_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO2_PER_CO2		0.87
#define VIRGO2_PER_PHORON	0.00

//Math only beyond this point
#define VIRGO2_MOL_PER_TURF		(VIRGO2_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO2_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO2_MOL_N2			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_N2)
#define VIRGO2_MOL_O2			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_O2)
#define VIRGO2_MOL_N2O			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_N2O)
#define VIRGO2_MOL_CO2			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_CO2)
#define VIRGO2_MOL_PHORON		(VIRGO2_MOL_PER_TURF * VIRGO2_PER_PHORON)

//Turfmakers
#define VIRGO2_SET_ATMOS	nitrogen=VIRGO2_MOL_N2;oxygen=VIRGO2_MOL_O2;carbon_dioxide=VIRGO2_MOL_CO2;phoron=VIRGO2_MOL_PHORON;temperature=VIRGO2_AVG_TEMP
#define VIRGO2_TURF_CREATE(x)	x/virgo2/nitrogen=VIRGO2_MOL_N2;x/virgo2/oxygen=VIRGO2_MOL_O2;x/virgo2/carbon_dioxide=VIRGO2_MOL_CO2;x/virgo2/phoron=VIRGO2_MOL_PHORON;x/virgo2/temperature=VIRGO2_AVG_TEMP;x/virgo2/color="#eacd7c"

/turf/unsimulated/floor/sky/virgo2_sky
	name = "virgo 2 atmosphere"
	desc = "Be careful where you step!"
	color = "#eacd7c"
	VIRGO2_SET_ATMOS

/turf/unsimulated/floor/sky/virgo2_sky/Initialize()
	skyfall_levels = list(z+1)
	. = ..()

/turf/simulated/shuttle/wall/voidcraft/green/virgo2
	VIRGO2_SET_ATMOS
	color = "#eacd7c"

/turf/simulated/shuttle/wall/voidcraft/green/virgo2/nocol
	color = null

VIRGO2_TURF_CREATE(/turf/unsimulated/wall/planetary)

VIRGO2_TURF_CREATE(/turf/simulated/wall)
VIRGO2_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO2_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO2_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)

VIRGO2_TURF_CREATE(/turf/simulated/mineral)
/turf/simulated/mineral/virgo2/make_ore()
	if(mineral)
		return

	var/mineral_name = pickweight(list(ORE_MARBLE = 5, ORE_URANIUM = 5, ORE_PLATINUM = 5, ORE_HEMATITE = 5, ORE_CARBON = 5, ORE_DIAMOND = 5, ORE_GOLD = 5, ORE_SILVER = 5, ORE_LEAD = 5, ORE_VERDANTIUM = 5, ORE_RUTILE = 20))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

// -- Areas -- //

// The aerostat shuttle
/area/shuttle/aerostat
	name = "\improper Aerostat Shuttle"

//The aerostat itself
/area/tether_away/aerostat
	name = "\improper Away Mission - Aerostat Outside"
	icon_state = "away"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/tether_away/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	requires_power = TRUE
	dynamic_lighting = TRUE
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/tether_away/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	dynamic_lighting = TRUE

/area/offmap/aerostat/surface
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

/area/offmap/aerostat/surface/explored
	name = "Away Mission - Aerostat Surface (E)"
	icon_state = "explored"
	dynamic_lighting = FALSE

/area/offmap/aerostat/surface/shuttleconsole
	name = "Away Mission - Aerostat Surface Console"
	icon_state = "explored"
	dynamic_lighting = FALSE
	requires_power = FALSE

/area/offmap/aerostat/surface/unexplored
	name = "Away Mission - Aerostat Surface (UE)"
	icon_state = "unexplored"
	dynamic_lighting = FALSE

VIRGO2_TURF_CREATE(/turf/simulated/floor/hull)
/area/offmap/aerostat/surface/outpost
	requires_power = TRUE
	dynamic_lighting = TRUE
	ambience = null

/area/offmap/aerostat/surface/outpost/backroom
	name = "V2 Outpost - Research Area"
/area/offmap/aerostat/surface/outpost/hallway
	name = "V2 Outpost - Hallway"
/area/offmap/aerostat/surface/outpost/cafe
	name = "V2 Outpost - Cafe"
/area/offmap/aerostat/surface/outpost/park
	name = "V2 Outpost - Park"
/area/offmap/aerostat/surface/outpost/officerone
	name = "V2 Outpost - Officer's Quarters 1"
/area/offmap/aerostat/surface/outpost/officertwo
	name = "V2 Outpost - Officer's Quarters 2"
/area/offmap/aerostat/surface/outpost/barracks
	name = "V2 Outpost - Barracks"
/area/offmap/aerostat/surface/outpost/airlock
	name = "V2 Outpost - Airlock"
/area/offmap/aerostat/surface/outpost/powerroom
	name = "V2 Outpost - Power Room"
/area/offmap/aerostat/surface/outpost/guardpost
	name = "V2 Outpost - Guard Post"
