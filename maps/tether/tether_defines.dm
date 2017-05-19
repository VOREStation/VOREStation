//Atmosphere properties
#define VIRGO3B_ONE_ATMOSPHERE	82.4 //kPa
#define VIRGO3B_AVG_TEMP	234 //kelvin

#define VIRGO3B_PER_N2		0.16 //percent
#define VIRGO3B_PER_O2		0.00
#define VIRGO3B_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO3B_PER_CO2		0.12
#define VIRGO3B_PER_PHORON	0.72

//Math only beyond this point
#define VIRGO3B_MOL_PER_TURF	(VIRGO3B_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO3B_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO3B_MOL_N2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_N2)
#define VIRGO3B_MOL_O2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_O2)
#define VIRGO3B_MOL_N2O			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_N2O)
#define VIRGO3B_MOL_CO2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_CO2)
#define VIRGO3B_MOL_PHORON		(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_PHORON)

//Turfmakers
#define VIRGO3B_SET_ATMOS	nitrogen=VIRGO3B_MOL_N2;oxygen=VIRGO3B_MOL_O2;carbon_dioxide=VIRGO3B_MOL_CO2;phoron=VIRGO3B_MOL_PHORON;temperature=VIRGO3B_AVG_TEMP
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/nitrogen=VIRGO3B_MOL_N2;x/virgo3b/oxygen=VIRGO3B_MOL_O2;x/virgo3b/carbon_dioxide=VIRGO3B_MOL_CO2;x/virgo3b/phoron=VIRGO3B_MOL_PHORON;x/virgo3b/temperature=VIRGO3B_AVG_TEMP;x/virgo3b/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/nitrogen=VIRGO3B_MOL_N2;x/virgo3b/oxygen=VIRGO3B_MOL_O2;x/virgo3b/carbon_dioxide=VIRGO3B_MOL_CO2;x/virgo3b/phoron=VIRGO3B_MOL_PHORON;x/virgo3b/temperature=VIRGO3B_AVG_TEMP

//Normal map defs
#define Z_LEVEL_SURFACE_LOW				1
#define Z_LEVEL_SURFACE_MID				2
#define Z_LEVEL_SURFACE_HIGH			3
#define Z_LEVEL_TRANSIT					4
#define Z_LEVEL_SPACE_LOW				5
#define Z_LEVEL_SPACE_MID				6
#define Z_LEVEL_SPACE_HIGH				7
#define Z_LEVEL_SURFACE_MINE			8
#define Z_LEVEL_SOLARS					9
#define Z_LEVEL_CENTCOM					10
#define Z_LEVEL_MISC					11
#define Z_LEVEL_SHIPS					12
#define Z_LEVEL_EMPTY_SURFACE			13
#define Z_LEVEL_EMPTY_SPACE				14


/datum/map/tether
	name = "Virgo"
	full_name = "NSB Adephagia"
	path = "tether"

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether")

	station_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS
		)

	admin_levels = list(Z_LEVEL_CENTCOM)
	contact_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS
		)

	player_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_EMPTY_SPACE
		)

	sealed_levels = list(Z_LEVEL_TRANSIT)
	empty_levels = list()
	accessible_z_levels = list("5" = 6, "6" = 6, "7" = 6, "14" = 82) // The defines can't be used here sadly.
	base_turf_by_z = list(
		"1" = /turf/simulated/floor/outdoors/rocks/virgo3b,
		"2" = /turf/simulated/open,
		"3" = /turf/simulated/open,
		"5" = /turf/space,
		"6" = /turf/simulated/open,
		"7" = /turf/simulated/open,
		"8" = /turf/simulated/floor/outdoors/rocks/virgo3b,
		"9" = /turf/simulated/floor/outdoors/rocks/virgo3b
		)

	station_name  = "NSB Tether"
	station_short = "Tether"
	dock_name     = "Virgo 3b Colony"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage")


/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1

// TODO - Re-Implement this using the /datum/map_z_level
/datum/map/tether/New()
	..()
	holomap_offset_y[1] = 60
	holomap_offset_y[2] = 180
	holomap_offset_y[3] = 300

	holomap_offset_x[1] = 100
	holomap_offset_x[2] = 100
	holomap_offset_x[3] = 100

	holomap_offset_x[5] = 260
	holomap_offset_x[7] = 260
	holomap_offset_x[6] = 260

	holomap_offset_y[5] = 60
	holomap_offset_y[6] = 180
	holomap_offset_y[7] = 300

	for(var/z in list(1,2,3,5,6,7))
		holomap_legend_x[z] = 220
		holomap_legend_y[z] = 160
	holomap_smoosh = list(list(1,2,3,5,6,7))
