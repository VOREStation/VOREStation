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
	initial_generic_waypoints = list("aerostat_n_w", "aerostat_n_n","aerostat_n_e","aerostat_s_w","aerostat_s_s","aerostat_s_e","aerostat_west","aerostat_east")
	extra_z_levels = list(Z_LEVEL_AEROSTAT_SURFACE)
	known = TRUE
	icon_state = "chlorine"

	skybox_icon = 'icons/skybox/virgo2.dmi'
	skybox_icon_state = "v2"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

/obj/effect/overmap/visitable/sector/virgo2/Initialize()
	for(var/obj/effect/overmap/visitable/ship/stellar_delight/sd in world)
		docking_codes = sd.docking_codes
	. = ..()

// -- Datums -- //

/datum/shuttle/autodock/ferry/aerostat
	name = "Aerostat Ferry"
	shuttle_area = /area/shuttle/aerostat
	docking_controller_tag = "aerostat_shuttle_airlock"
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
	ai_control = TRUE

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
	prob_fall = 50
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
/////Copied from Virgo3b's ore generation, since there was concern about not being able to get the ore they need on V2
/turf/simulated/mineral/virgo2/make_ore(var/rare_ore)
	if(mineral)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 3,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 20,
			"diamond" = 1,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18,
			"lead" = 2,
			"verdantium" = 1))
	else
		mineral_name = pickweight(list(
			"marble" = 2,
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"carbon" = 35,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25,
			"lead" = 1))

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
/area/offmap/aerostat
	name = "\improper Away Mission - Aerostat Outside"
	icon_state = "away"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/offmap/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	requires_power = TRUE
	dynamic_lighting = TRUE
//	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/offmap/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	dynamic_lighting = FALSE

/area/offmap/aerostat/surface
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

/area/offmap/aerostat/surface/explored
	name = "Away Mission - Aerostat Surface (E)"
	icon_state = "explored"

/area/offmap/aerostat/surface/unexplored
	name = "Away Mission - Aerostat Surface (UE)"
	icon_state = "unexplored"

VIRGO2_TURF_CREATE(/turf/simulated/floor/hull)
/area/offmap/aerostat/surface/outpost
	requires_power = TRUE
	dynamic_lighting = TRUE
	ambience = list()

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

/area/offmap/aerostat/inside
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "blublasqu"

/area/offmap/aerostat/inside/toxins
	name = "Toxins Lab"
	icon_state = "purwhisqu"

/area/offmap/aerostat/inside/xenoarch
	name = "Xenoarchaeolegy Lab"
	icon_state = "yelwhisqu"
/area/offmap/aerostat/inside/xenoarch/chamber
	name = "Xenoarchaeolegy Vent Chamber"

/area/offmap/aerostat/inside/genetics
	name = "Genetics Lab"
	icon_state = "grewhisqu"

/area/offmap/aerostat/inside/telesci
	name = "Telescience Lab"
	icon_state = "bluwhisqu"

/area/offmap/aerostat/inside/atmos
	name = "Atmospherics"
	icon_state = "orawhisqu"

/area/offmap/aerostat/inside/firingrange
	name = "Firing Range"
	icon_state = "orawhisqu"

/area/offmap/aerostat/inside/miscstorage
	name = "Miscellaneous Storage"
	icon_state = "orawhisqu"

/area/offmap/aerostat/inside/virology
	name = "Virology Lab"
	icon_state = "yelwhicir"

/area/offmap/aerostat/inside/south
	name = "Miscellaneous Labs A"
	icon_state = "blublasqu"

/area/offmap/aerostat/inside/south/b
	name = "Miscellaneous Labs B"
	icon_state = "blublasqu"


/area/offmap/aerostat/inside/powercontrol
	name = "Power Control"
	icon_state = "orawhicir"

/area/offmap/aerostat/inside/westhall
	name = "West Hall"
	icon_state = "orablacir"
/area/offmap/aerostat/inside/easthall
	name = "East Hall"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/northchamb
	name = "North Chamber"
	icon_state = "orablacir"
/area/offmap/aerostat/inside/southchamb
	name = "South Chamber"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/drillstorage
	name = "Drill Storage"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/zorrenoffice
	name = "Zorren Reception"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/lobby
	name = "Lobby"
	icon_state = "orablacir"
/area/offmap/aerostat/inside/xenobiolab
	name = "Xenobiology Lab"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/airlock
	name = "Airlock"
	icon_state = "redwhicir"
/area/offmap/aerostat/inside/airlock/north
	name = "North Airlock"
/area/offmap/aerostat/inside/airlock/east
	name = "East Airlock"
/area/offmap/aerostat/inside/airlock/west
	name = "West Airlock"
/area/offmap/aerostat/inside/airlock/south
	name = "South Airlock"

/area/offmap/aerostat/inside/arm/ne
	name = "North-East Solar Arm"
/area/offmap/aerostat/inside/arm/nw
	name = "North-West Solar Arm"
/area/offmap/aerostat/inside/arm/se
	name = "South-East Solar Arm"
/area/offmap/aerostat/inside/arm/sw
	name = "South-West Solar Arm"

/area/offmap/aerostat/glassgetsitsownarea
	name = "Aerostat Glass"
	icon_state = "crew_quarters"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky
	dynamic_lighting = FALSE

/area/offmap/aerostat/surface/shuttleconsole
	name = "Away Mission - Aerostat Surface Console"
	icon_state = "explored"
	dynamic_lighting = FALSE
	requires_power = FALSE
