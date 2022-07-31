
#define Z_LEVEL_MAIN_VIRGO_TESTING					1

/datum/map/virgo_minitest
	name = "Virgo_minitest"
	full_name = "NSS Ade-testing"
	path = "virgo_minitest"

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("logo2")

	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	accessible_z_levels = list("1" = 100)
	base_turf_by_z = list("1" = /turf/space)

	use_overmap = TRUE
	//var/overmap_size = 20		 // Dimensions of overmap zlevel if overmap is used.
	//var/overmap_z = 0		     // If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	//var/overmap_event_areas = 0  // How many event "clouds" will be generated

	zlevel_datum_type = /datum/map_z_level/minitest

	station_name  = "NSS Ade-testing"
	station_short = "VORE-testing"
	dock_name     = "Virgo-test CC"
	dock_type     = "surface"
	boss_name     = "Central Command-testing"
	boss_short    = "CentCom-testing"
	company_name  = "NanoTrasen-testing"
	company_short = "NT-testing"
	starsys_name  = "Virgo-Erigone-testing"

	shuttle_docked_message = "Test Shuttle Docked"
	shuttle_leaving_dock = "Test Shuttle Leaving"
	shuttle_called_message = "Test Shuttle Coming"
	shuttle_recall_message = "Test Shuttle Cancelled"
	shuttle_name = "NAS |Hawking|"
	emergency_shuttle_docked_message = "Test E-Shuttle Docked"
	emergency_shuttle_leaving_dock = "Test E-Shuttle Left"
	emergency_shuttle_called_message = "Test E-Shuttle Coming"
	emergency_shuttle_recall_message = "Test E-Shuttle Cancelled"

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

	allowed_spawns = list("Arrivals Shuttle","Gateway","Cryogenic Storage","Cyborg Storage")

/datum/map/virgo_minitest/Initialize()
	. = ..()
	SSticker.start_immediately = TRUE

/datum/map_z_level/minitest/station
	z = Z_LEVEL_MAIN_VIRGO_TESTING
	name = "Station Level"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map/virgo_minitest/perform_map_generation()
/*
	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_MAIN_VIRGO_TESTING, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MAIN_VIRGO_TESTING, 64, 64)
*/
	return 1
