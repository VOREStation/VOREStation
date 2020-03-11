#include "submaps/virgo2.dm"

/obj/effect/overmap/visitable/sector/virgo2
	name = "Virgo 2"
	desc = "Includes the Remmi Aerostat and associated ground mining complexes."
	icon_state = "globe"
	color = "#dfff3f" //Bright yellow
	initial_generic_waypoints = list("aerostat_west","aerostat_east","aerostat_south","aerostat_northwest","aerostat_northeast")

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

// -- Objs -- //

/obj/machinery/computer/shuttle_control/aerostat_shuttle
	name = "aerostat ferry control console"
	shuttle_tag = "Aerostat Ferry"

/obj/tether_away_spawner/aerostat_inside
	name = "Aerostat Indoors Spawner"
	faction = "aerostat_inside"
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
	faction = "aerostat_surface"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 30
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/jelly = 1,
		/mob/living/simple_mob/mechanical/viscerator = 1,
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1
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

	var/mineral_name = pickweight(list("marble" = 5, "uranium" = 5, "platinum" = 10, "hematite" = 5, "carbon" = 5, "diamond" = 10, "gold" = 20, "silver" = 20, "lead" = 10, "verdantium" = 5))

	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
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

/area/tether_away/aerostat/surface
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

/area/tether_away/aerostat/surface/explored
	name = "Away Mission - Aerostat Surface (E)"
	icon_state = "explored"

/area/tether_away/aerostat/surface/unexplored
	name = "Away Mission - Aerostat Surface (UE)"
	icon_state = "unexplored"
