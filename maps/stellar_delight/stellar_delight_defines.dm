/datum/map/stellar_delight/New()
	..()
	var/choice = pickweight(list(
		"logo1" = 50,
		"logo2" = 50,
		"gateway" = 5,
		"youcanttaketheskyfromme" = 200,
		"intothedark" = 200,
		"above3b" = 200,
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/stellar_delight
	name = "StellarDelight"
	full_name = "NRV Stellar Delight"
	path = "stellardelight"

	use_overmap = TRUE
	overmap_z = Z_NAME_OVERMAP
	overmap_size = 99
	overmap_event_areas = 200
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/stellar_delight

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("youcanttaketheskyfromme")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'


	holomap_smoosh = list(list(
		Z_LEVEL_SHIP_LOW,
		Z_LEVEL_SHIP_MID,
		Z_LEVEL_SHIP_HIGH,
		))

	station_name  = "NRV Stellar Delight"
	station_short = "Stellar Delight"
	facility_type = "ship"
	dock_name     = "Virgo-3B Colony"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The shuttle has departed. Estimate %ETA% until arrival at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The shuttle will arrive shortly. Those departing should proceed to deck three, aft within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Crew Transport"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has departed. Estimate %ETA% until arrival at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule shuttle has been called. It will arrive at deck three, aft in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation shuttle has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_EXPLORATION,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TELECOM,
							NETWORK_HALLS,
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_TALON_HELMETS,
							NETWORK_TALON_SHIP,
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Gateway","Cryogenic Storage","Cyborg Storage","ITV Talon Cryo")
	spawnpoint_died = /datum/spawnpoint/cryo
	spawnpoint_left = /datum/spawnpoint/gateway
	spawnpoint_stayed = /datum/spawnpoint/cryo

	/*
	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)
	*/

	default_skybox = /datum/skybox_settings/stellar_delight

	unit_test_exempt_areas = list(
		/area/stellardelight/deck1/exterior,
		/area/stellardelight/deck1/exploshuttle,
		/area/stellardelight/deck1/miningshuttle,
		/area/stellardelight/deck2/exterior,
		/area/stellardelight/deck2/portescape,
		/area/stellardelight/deck2/starboardescape,
		/area/stellardelight/deck3/exterior,

		/area/medical/cryo,
		/area/holodeck_control,
		/area/tcommsat/chamber,
		)

	unit_test_exempt_from_atmos = list() //it maint

	unit_test_z_levels = list(
		Z_LEVEL_SHIP_LOW,
		Z_LEVEL_SHIP_MID,
		Z_LEVEL_SHIP_HIGH,
		)

	lateload_z_levels = list(
		list(Z_NAME_SHIP_CENTCOM), // Aliased to Z_NAME_ALIAS_CENTCOM
		list(Z_NAME_SHIP_MISC), //Aliased to Z_NAME_ALIAS_MISC: Shuttle transit zones, holodeck templates, etc
		list(Z_NAME_SPACE_ROCKS),
		list(Z_NAME_BEACH, Z_NAME_BEACH_CAVE),
		list(Z_NAME_AEROSTAT, Z_NAME_AEROSTAT_SURFACE),
		list(Z_NAME_DEBRISFIELD),
		list(Z_NAME_FUELDEPOT),
		list(Z_NAME_OVERMAP),
		list(Z_NAME_OFFMAP1),
		)

	lateload_gateway = list(
		list(Z_NAME_GATEWAY_CARP_FARM),
		list(Z_NAME_GATEWAY_SNOW_FIELD),
		list(Z_NAME_GATEWAY_LISTENING_POST),
		list(list(Z_NAME_GATEWAY_HONLETH_A, Z_NAME_GATEWAY_HONLETH_B)),
		list(Z_NAME_GATEWAY_ARYNTHI_CAVE_A,Z_NAME_GATEWAY_ARYNTHI_A),
		list(Z_NAME_GATEWAY_ARYNTHI_CAVE_B,Z_NAME_GATEWAY_ARYNTHI_B),
		list(Z_NAME_GATEWAY_WILD_WEST),
		)

	lateload_overmap = list(
		list(Z_NAME_OM_GRASS_CAVE),
		)

	lateload_redgate = list(
		list(Z_NAME_REDGATE_TEPPI_RANCH),
		list(Z_NAME_REDGATE_INNLAND),
//		list(Z_NAME_REDGATE_ABANDONED_ISLAND),	//This will come back later
		list(Z_NAME_REDGATE_DARK_ADVENTURE),
		list(Z_NAME_REDGATE_EGGNOG_CAVE, Z_NAME_REDGATE_EGGNOG_TOWN),
		list(Z_NAME_REDGATE_STAR_DOG),
		list(Z_NAME_REDGATE_HOTSPRINGS),
		list(Z_NAME_REDGATE_RAIN_CITY),
		list(Z_NAME_REDGATE_ISLANDS_UNDERWATER, Z_NAME_REDGATE_ISLANDS),
		list(Z_NAME_REDGATE_MOVING_TRAIN, Z_NAME_REDGATE_MOVING_TRAIN_UPPER),
		list(Z_NAME_REDGATE_FANTASY_DUNGEON, Z_NAME_REDGATE_FANTASY_TOWN),
		list(Z_NAME_REDGATE_LASERDOME),
		list(Z_NAME_REDGATE_CASCADING_FALLS),
		list(Z_NAME_REDGATE_JUNGLE_CAVE, Z_NAME_REDGATE_JUNGLE),
		list(Z_NAME_REDGATE_FACILITY),
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_SHIP_LOW,
		Z_LEVEL_SHIP_MID,
		Z_LEVEL_SHIP_HIGH,
		Z_NAME_ALIAS_MISC,
		Z_NAME_BEACH,
		Z_NAME_AEROSTAT,
		)

/*
	belter_docked_z = 		list(Z_LEVEL_TETHER_SPACE_LOW)
	belter_transit_z =	 	list(Z_NAME_ALIAS_MISC)
	belter_belt_z = 		list(Z_NAME_TETHER_ROGUEMINE_1,
						 		 Z_NAME_TETHER_ROGUEMINE_2)

	mining_station_z =		list(Z_LEVEL_TETHER_SPACE_LOW)
	mining_outpost_z =		list(Z_LEVEL_TETHER_SURFACE_MINE)
*/
	planet_datums_to_make = list(
		/datum/planet/virgo3b,
		/datum/planet/virgo4,
		)

/datum/map/stellar_delight/get_map_info()
	. = list()
	. +=  "The [full_name] is a recently commissioned multi-role starship assigned to patrol the Virgo-Erigone system. Its mission is flexible, being a response vessel, the [station_short] is assigned to respond to emergencies in the system, and to investigate anomalous activities where a more specialized vessel is unavailable.<br>"
	. +=  "Humanity has spread across the stars and has met many species on similar or even more advanced terms than them - it's a brave new world and many try to find their place in it . <br>"
	. +=  "Though Virgo-Erigone is not important for the great movers and shakers, it sees itself in the midst of the interests of a reviving alien species of the Zorren, corporate and subversive interests and other exciting dangers the Periphery has to face.<br>"
	. +=  "As an employee or contractor of NanoTrasen, operators of the Adephagia and one of the galaxy's largest corporations, you're probably just here to do a job."
	return jointext(., "<br>")


/datum/map/stellar_delight/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_NAME_SPACE_ROCKS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_NAME_SPACE_ROCKS, 64, 64)         // Create the mining ore distribution map.
	return 1


/datum/skybox_settings/stellar_delight
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3b
	expected_z_levels = list(Z_NAME_ALIAS_CENTCOM)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_NAME_BEACH
	)

/obj/effect/overmap/visitable/ship/stellar_delight/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")

// For making the 6-in-1 holomap, we calculate some offsets
#define SHIP_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define SHIP_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define SHIP_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*SHIP_MAP_SIZE) - SHIP_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define SHIP_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (2*SHIP_MAP_SIZE)) / 2) // 30

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/stellar_delight
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/stellar_delight/deck_one
	z = Z_LEVEL_SHIP_LOW
	name = "Deck 1"
	base_turf = /turf/space
	transit_chance = 33
	holomap_offset_x = SHIP_HOLOMAP_MARGIN_X
	holomap_offset_y = SHIP_HOLOMAP_MARGIN_Y

/datum/map_z_level/stellar_delight/deck_two
	z = Z_LEVEL_SHIP_MID
	name = "Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = SHIP_HOLOMAP_MARGIN_X
	holomap_offset_y = SHIP_HOLOMAP_MARGIN_Y + SHIP_MAP_SIZE

/datum/map_z_level/stellar_delight/deck_three
	z = Z_LEVEL_SHIP_HIGH
	name = "Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - SHIP_HOLOMAP_MARGIN_X - SHIP_MAP_SIZE
	holomap_offset_y = SHIP_HOLOMAP_MARGIN_Y + SHIP_MAP_SIZE

/datum/map_template/ship_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/////STATIC LATELOAD/////

/datum/map_template/ship_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)
	return ..()

/datum/map_z_level/ship_lateload/New(datum/map/map, mapZ)
	z = mapZ
	return ..(map)

/datum/map_template/ship_lateload/ship_centcom
	name = Z_NAME_SHIP_CENTCOM
	desc = "Central Command lives here!"
	mappath = "maps/stellar_delight/ship_centcom.dmm"
	name_alias = Z_NAME_ALIAS_CENTCOM

	associated_map_datum = /datum/map_z_level/ship_lateload/ship_centcom

/datum/map_z_level/ship_lateload/ship_centcom
	//z = Z_NAME_ALIAS_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/area/centcom //Just to try to make sure there's not space!!!
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_template/ship_lateload/ship_misc
	name = Z_NAME_SHIP_MISC
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "maps/stellar_delight/ship_misc.dmm"
	name_alias = Z_NAME_ALIAS_MISC

	associated_map_datum = /datum/map_z_level/ship_lateload/misc

/datum/map_z_level/ship_lateload/misc
	//z = Z_NAME_ALIAS_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "../submaps/space_rocks/space_rocks.dm"
/datum/map_template/ship_lateload/space_rocks
	name = Z_NAME_SPACE_ROCKS
	desc = "Space debris is common in V3b's orbit due to the proximity of Virgo 3"
	mappath = "maps/submaps/space_rocks/space_rocks.dmm"

	associated_map_datum = /datum/map_z_level/ship_lateload/space_rocks

/datum/map_template/ship_lateload/space_rocks/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 60, /area/sdmine/unexplored, /datum/map_template/space_rocks)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)

/datum/map_z_level/ship_lateload/space_rocks
	//z = Z_NAME_SPACE_ROCKS
	name = Z_NAME_SPACE_ROCKS
	base_turf = /turf/space
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_template/ship_lateload/overmap
	name = Z_NAME_OVERMAP
	desc = "Overmap lives here :3"
	mappath = "maps/stellar_delight/overmap.dmm"

	associated_map_datum = /datum/map_z_level/ship_lateload/overmap

/datum/map_z_level/ship_lateload/overmap
	//z = Z_NAME_OVERMAP
	name = Z_NAME_OVERMAP
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "../expedition_vr/aerostat/_aerostat_science_outpost.dm"
/datum/map_template/common_lateload/away_aerostat
	name = Z_NAME_AEROSTAT
	desc = "The Virgo 2 Aerostat away mission."
	mappath = "maps/expedition_vr/aerostat/aerostat_science_outpost.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_aerostat

/////FOR CENTCOMM (at least)/////
/obj/effect/overmap/visitable/sector/virgo3b
	known = TRUE
	in_space = TRUE

	initial_generic_waypoints = list("sr-c","sr-n","sr-s")
	initial_restricted_waypoints = list("Central Command Shuttlepad" = list("cc_shuttlepad"))

	extra_z_levels = list(Z_NAME_SPACE_ROCKS)

/////SD Starts at V3b to pick up crew refuel and repair (And to make sure it doesn't spawn on hazards)
/obj/effect/overmap/visitable/sector/virgo3b/Initialize(mapload)
	. = ..()
	for(var/obj/effect/overmap/visitable/ship/stellar_delight/sd in world)
		sd.forceMove(loc, SOUTH)
		return

/obj/effect/overmap/visitable/sector/virgo3b/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/virgo3b/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/virgo3b/announce_atc(var/atom/movable/AM, var/going = FALSE)
	if(istype(AM, /obj/effect/overmap/visitable/ship/simplemob))
		if(world.time < mob_announce_cooldown)
			return
		else
			mob_announce_cooldown = world.time + 5 MINUTES
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			SSatc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		SSatc.msg(message)

/obj/effect/overmap/visitable/sector/virgo3b/get_space_zlevels()
	return list(GLOB.map_templates_loaded[Z_NAME_SPACE_ROCKS])
