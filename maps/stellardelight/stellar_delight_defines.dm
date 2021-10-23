//Normal map defs
#define Z_LEVEL_SHIP_LOW					1
#define Z_LEVEL_SHIP_MID					2
#define Z_LEVEL_SHIP_HIGH					3
#define Z_LEVEL_CENTCOM						4
#define Z_LEVEL_MISC						5
#define Z_LEVEL_BEACH						6
#define Z_LEVEL_BEACH_CAVE					7
#define Z_LEVEL_AEROSTAT					8
#define Z_LEVEL_AEROSTAT_SURFACE			9
#define Z_LEVEL_DEBRISFIELD					10
#define Z_LEVEL_FUELDEPOT					11
#define Z_LEVEL_OVERMAP						12
#define Z_LEVEL_OFFMAP1						13
#define Z_LEVEL_GATEWAY						14

//Camera networks
#define NETWORK_HALLS "Halls"
#define NETWORK_TCOMMS "Telecommunications" //Using different from Polaris one for better name
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"

/datum/map/stellar_delight/New()
	..()
	var/choice = pickweight(list(
		"logo1" = 50,
		"logo2" = 50,
		"gateway" = 5
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/stellar_delight
	name = "Virgo"
	full_name = "NRV Stellar Delight"
	path = "stellardelight"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_OVERMAP
	overmap_size = 99
	overmap_event_areas = 200
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/stellar_delight

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether2_night")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	accessible_z_levels = list(
		Z_LEVEL_SHIP_LOW = 100,
		Z_LEVEL_SHIP_MID = 100,
		Z_LEVEL_SHIP_HIGH = 100
		)

/*
	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH))
*/
	station_name  = "NRV Stellar Delight"
	station_short = "Stellar Delight"
	dock_name     = "Virgo-3B Colony"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The shuttle has left the station. Estimate %ETA% until arrival at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The shuttle will be arriving shortly. Those departing should proceed to deck three, aft within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Evacuation Shuttle"
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
							NETWORK_OUTSIDE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TELECOM,
							NETWORK_HALLS
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
							NETWORK_TALON_SHIP
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

	unit_test_exempt_areas = list()

	unit_test_exempt_from_atmos = list() //it maint


	lateload_z_levels = list(
		list("Ship - Central Command"),
		list("Ship - Misc"), //Shuttle transit zones, holodeck templates, etc
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space"),
		list("Fuel Depot - Z1 Space"),
		list("Overmap"),
		list("Offmap Ship - Talon V2")
		)

	lateload_single_pick = list(
		list("Carp Farm"),
		list("Snow Field"),
		list("Listening Post"),
		list(list("Honleth Highlands A", "Honleth Highlands B")),
		list("Arynthi Lake Underground A","Arynthi Lake A"),
		list("Arynthi Lake Underground B","Arynthi Lake B"),
		list("Eggnog Town Underground","Eggnog Town"),
		list("Wild West")
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_SHIP_LOW,
		Z_LEVEL_SHIP_MID,
		Z_LEVEL_SHIP_HIGH,
		Z_LEVEL_MISC,
		Z_LEVEL_BEACH,
		Z_LEVEL_AEROSTAT
		)

/*
	belter_docked_z = 		list(Z_LEVEL_SPACE_LOW)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2)

	mining_station_z =		list(Z_LEVEL_SPACE_LOW)
	mining_outpost_z =		list(Z_LEVEL_SURFACE_MINE)
*/
	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/virgo3b,
								/datum/planet/virgo4)

/datum/map/stellar_delight/get_map_info()
	. = list()
	. +=  "The [full_name] is an ancient ruin turned workplace in the Virgo-Erigone System, deep in the midst of the Coreward Periphery.<br>"
	. +=  "Humanity has spread across the stars and has met many species on similar or even more advanced terms than them - it's a brave new world and many try to find their place in it . <br>"
	. +=  "Though Virgo-Erigone is not important for the great movers and shakers, it sees itself in the midst of the interests of a reviving alien species of the Zorren, corporate and subversive interests and other exciting dangers the Periphery has to face.<br>"
	. +=  "As an employee or contractor of NanoTrasen, operators of the Adephagia and one of the galaxy's largest corporations, you're probably just here to do a job."
	return jointext(., "<br>")

/*
/datum/map/stellar_delight/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1
*/

/datum/skybox_settings/stellar_delight
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3b
	expected_z_levels = list(Z_LEVEL_CENTCOM)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_LEVEL_BEACH
	)

// For making the 6-in-1 holomap, we calculate some offsets
#define SHIP_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define SHIP_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define SHIP_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define SHIP_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE)) / 2) // 30

/obj/effect/landmark/map_data/stellar_delight
	height = 3

/obj/effect/overmap/visitable/ship/stellar_delight
	name = "NRV Stellar Delight"
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "stellar_delight_g"
	desc = "Spacefaring vessel. Friendly IFF detected."
	scanner_desc = @{"[i]Registration[/i]: NRV Stellar Delight
[i]Class[/i]: Nanotrasen Response Frigate
[i]Transponder[/i]: Transmitting (CIV), non-hostile"
[b]Notice[/b]: A response vessel registered to Nanotrasen."}
	vessel_mass = 25000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("starboard_shuttlepad","port_shuttlepad","sd-1-23-54","sd-1-67-15","sd-1-70-130","sd-1-115-85","sd-2-25-98","sd-2-117-98","sd-3-22-78","sd-3-36-33","sd-3-104-33","sd-3-120-78")
	initial_restricted_waypoints = list("Exploration Shuttle" = list("sd_explo"), "Mining Shuttle" = list("sd_mining"))
	levels_for_distress = list(Z_LEVEL_OFFMAP1, Z_LEVEL_BEACH, Z_LEVEL_AEROSTAT, Z_LEVEL_DEBRISFIELD, Z_LEVEL_FUELDEPOT)
	unowned_areas = list(/area/shuttle/sdboat)
	known = TRUE
	start_x = 2
	start_y = 2

	fore_dir = NORTH

	skybox_icon = 'stelardelightskybox.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 450
	skybox_pixel_y = 200

/obj/effect/overmap/visitable/ship/stellar_delight/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")


// We have a bunch of stuff common to the station z levels
/datum/map_z_level/stellar_delight
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/stellar_delight/deck_one
	z = Z_LEVEL_SHIP_LOW
	name = "Deck 1"
	base_turf = /turf/space
	transit_chance = 100

/datum/map_z_level/stellar_delight/deck_two
	z = Z_LEVEL_SHIP_MID
	name = "Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 100

/datum/map_z_level/stellar_delight/deck_three
	z = Z_LEVEL_SHIP_HIGH
	name = "Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 100

/datum/map_template/ship_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/////STATIC LATELOAD/////

/datum/map_template/ship_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_template/ship_lateload/ship_centcom
	name = "Ship - Central Command"
	desc = "Central Command lives here!"
	mappath = 'ship_centcom.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/ship_centcom

/datum/map_z_level/ship_lateload/ship_centcom
	z = Z_LEVEL_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/area/centcom //Just to try to make sure there's not space!!!
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_template/ship_lateload/ship_misc
	name = "Ship - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'ship_misc.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/misc

/datum/map_z_level/ship_lateload/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/ship_lateload/overmap
	name = "Overmap"
	desc = "Overmap lives here :3"
	mappath = 'overmap.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/overmap

/datum/map_z_level/ship_lateload/overmap
	z = Z_LEVEL_OVERMAP
	name = "Overmap"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "../expedition_vr/aerostat/_aerostat_science_outpost.dm"
/datum/map_template/common_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = 'maps/expedition_vr/aerostat/aerostat_science_outpost.dmm'
	associated_map_datum = /datum/map_z_level/common_lateload/away_aerostat



////////////////SHUTTLE TIME///////////////////

//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = SOUTH
	docking_controller_tag = "escape_shuttle"

/datum/shuttle/autodock/ferry/escape_pod/portescape
	name = "Port Escape Pod"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/stellardelight/deck2/portescape
	warmup_time = 0
	landmark_station = "port_ship_berth"
	landmark_offsite = "port_escape_cc"
	landmark_transition = "port_escape_transit"
	docking_controller_tag = "port_escape_pod"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = EAST

/datum/shuttle/autodock/ferry/escape_pod/starboardescape
	name = "Starboard Escape Pod"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/stellardelight/deck2/starboardescape
	warmup_time = 0
	landmark_station = "starboard_ship_berth"
	landmark_offsite = "starboard_escape_cc"
	landmark_transition = "starboard_escape_transit"
	docking_controller_tag = "starboard_escape_pod"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = WEST


//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	move_direction = WEST

/////EXPLORATION SHUTTLE
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/stellardelight/exploration
	name = "boat control console"
	shuttle_tag = "Exploration Shuttle"
	req_one_access = null

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/exploration
	name = "Exploration Shuttle Landing Pad"
	base_area = /area/stellardelight/deck1/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "sd_explo"
	docking_controller = "explodocker_bay"
	shuttle_type = /datum/shuttle/autodock/overmap/exboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/exboat
	name = "Exploration Shuttle"
	current_location = "sd_explo"
	docking_controller_tag = "explodocker"
	shuttle_area = /area/stellardelight/deck1/exploshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1

/////MINING SHUTTLE
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/stellardelight/mining
	name = "boat control console"
	shuttle_tag = "Mining Shuttle"
	req_one_access = null

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mining
	name = "Mining Shuttle Landing Pad"
	base_area = /area/stellardelight/deck1/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "sd_mining"
	docking_controller = "miningdocker_bay"
	shuttle_type = /datum/shuttle/autodock/overmap/mineboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/mineboat
	name = "Mining Shuttle"
	current_location = "sd_mining"
	docking_controller_tag = "miningdocker"
	shuttle_area = /area/stellardelight/deck1/miningshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1

/////STARSTUFF/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/sdboat
	name = "Star Stuff control console"
	shuttle_tag = "Starstuff"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/sd_boat
	name = "NTV Starstuff"
	desc = "A small shuttle from the NRV Stellar Delight."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Starstuff"
	known = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/sdboat
	name = "Port Shuttlepad"
	base_area = /area/stellardelight/deck3/exterior
	base_turf = /turf/simulated/floor/reinforced/airless
	landmark_tag = "port_shuttlepad"
	docking_controller = "sd_port_landing"
	shuttle_type = /datum/shuttle/autodock/overmap/sdboat

/datum/shuttle/autodock/overmap/sdboat
	name = "Starstuff"
	current_location = "port_shuttlepad"
	docking_controller_tag = "sd_bittyshuttle" 
	shuttle_area = /area/shuttle/sdboat
	fuel_consumption = 2
	defer_initialisation = TRUE

/area/shuttle/sdboat
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Starstuff"
	requires_power = 1

/////LANDING LANDMARKS/////
/obj/effect/shuttle_landmark/premade/sd/deck1/portairlock
	name = "Near Deck 1 Port Airlock"
	landmark_tag = "sd-1-23-54"
/obj/effect/shuttle_landmark/premade/sd/deck1/aft
	name = "Near Deck 1 Aft"
	landmark_tag = "sd-1-67-15"
/obj/effect/shuttle_landmark/premade/sd/deck1/fore
	name = "Near Deck 1 Fore"
	landmark_tag = "sd-1-70-130"
/obj/effect/shuttle_landmark/premade/sd/deck1/starboard
	name = "Near Deck 1 Starboard"
	landmark_tag = "sd-1-115-85"

/obj/effect/shuttle_landmark/premade/sd/deck2/port
	name = "Near Deck 2 Port"
	landmark_tag = "sd-2-25-98"
/obj/effect/shuttle_landmark/premade/sd/deck2/starboard
	name = "Near Deck 2 Starboard"
	landmark_tag = "sd-2-117-98"

/obj/effect/shuttle_landmark/premade/sd/deck3/portairlock
	name = "Near Deck 3 Port Airlock"
	landmark_tag = "sd-3-22-78"
/obj/effect/shuttle_landmark/premade/sd/deck3/portlanding
	name = "Near Deck 3 Port Landing Pad"
	landmark_tag = "sd-3-36-33"
/obj/effect/shuttle_landmark/premade/sd/deck3/starboardlanding
	name = "Near Deck 3 Starboard Landing Pad"
	landmark_tag = "sd-3-104-33"
/obj/effect/shuttle_landmark/premade/sd/deck3/starboardairlock
	name = "Near Deck 3 Starboard Airlock"
	landmark_tag = "sd-3-120-78"

/obj/item/weapon/paper/dockingcodes/sd
	name = "Stellar Delight Docking Codes"
	codes_from_z = Z_LEVEL_SHIP_LOW


///////////////////////////////////////////////////////////
/////Misc stuff from the tether that's likely to get used in one way or another!/////`

// Tram departure cryo doors that turn into ordinary airlock doors at round end
/obj/machinery/cryopod/robot/door/tram
	name = "\improper Tram Station"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	icon_state = "door_closed"
	can_atmos_pass = ATMOS_PASS_NO
	base_icon_state = "door_closed"
	occupied_icon_state = "door_locked"
	desc = "The tram station you might've came in from.  You could leave the base easily using this."
	on_store_message = "has departed on the tram."
	on_store_name = "Travel Oversight"
	on_enter_occupant_message = "The tram arrives at the platform; you step inside and take a seat."
	on_store_visible_message_1 = "'s speakers chime, anouncing a tram has arrived to take"
	on_store_visible_message_2 = "to the colony"
	time_till_despawn = 10 SECONDS
	spawnpoint_type = /datum/spawnpoint/tram
/obj/machinery/cryopod/robot/door/tram/process()
	if(emergency_shuttle.online() || emergency_shuttle.returned())
		// Transform into a door!  But first despawn anyone inside
		time_till_despawn = 0
		..()
		var/turf/T = get_turf(src)
		var/obj/machinery/door/airlock/glass_external/door = new(T)
		door.req_access = null
		door.req_one_access = null
		qdel(src)
	// Otherwise just operate normally
	return ..()

/obj/machinery/cryopod/robot/door/tram/Bumped(var/atom/movable/AM)
	if(!ishuman(AM))
		return

	var/mob/living/carbon/human/user = AM

	var/choice = tgui_alert(user, "Do you want to depart via the tram? Your character will leave the round.","Departure",list("Yes","No"))
	if(user && Adjacent(user) && choice == "Yes")
		var/mob/observer/dead/newghost = user.ghostize()
		newghost.timeofdeath = world.time
		despawn_occupant(user)

var/global/list/latejoin_tram   = list()

/obj/effect/landmark/tram
	name = "JoinLateTram"
	delete_me = 1

/obj/effect/landmark/tram/New()
	latejoin_tram += loc // Register this turf as tram latejoin.
	latejoin += loc // Also register this turf as fallback latejoin, since we won't have any arrivals shuttle landmarks.
	..()

/datum/spawnpoint/tram
	display_name = "Tram Station"
	msg = "has arrived on the tram"

/datum/spawnpoint/tram/New()
	..()
	turfs = latejoin_tram

/obj/machinery/camera/network/halls
	network = list(NETWORK_HALLS)

/obj/machinery/camera/network/exploration
	network = list(NETWORK_EXPLORATION)

/obj/machinery/camera/network/research/xenobio
	network = list(NETWORK_RESEARCH, NETWORK_XENOBIO)

/obj/machinery/computer/security/xenobio
	name = "xenobiology camera monitor"
	desc = "Used to access the xenobiology cell cameras."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list(NETWORK_XENOBIO)
	circuit = /obj/item/weapon/circuitboard/security/xenobio
	light_color = "#F9BBFC"

/obj/item/weapon/circuitboard/security/xenobio
	name = T_BOARD("xenobiology camera monitor")
	build_path = /obj/machinery/computer/security/xenobio
	network = list(NETWORK_XENOBIO)
	req_access = list()

/obj/machinery/vending/wallmed1/public
	products = list(/obj/item/stack/medical/bruise_pack = 8,/obj/item/stack/medical/ointment = 8,/obj/item/weapon/reagent_containers/hypospray/autoinjector = 16,/obj/item/device/healthanalyzer = 4)

/turf/unsimulated/mineral/virgo3b
	blocks_air = TRUE

/area/tether/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"

/turf/simulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

	var/area/shock_area = /area/tether/surfacebase/tram

/turf/simulated/floor/maglev/Initialize()
	. = ..()
	shock_area = locate(shock_area)

// Walking on maglev tracks will shock you! Horray!
/turf/simulated/floor/maglev/Entered(var/atom/movable/AM, var/atom/old_loc)
	if(isliving(AM) && !(AM.is_incorporeal()) && prob(50))
		track_zap(AM)
/turf/simulated/floor/maglev/attack_hand(var/mob/user)
	if(prob(75))
		track_zap(user)
/turf/simulated/floor/maglev/proc/track_zap(var/mob/living/user)
	if (!istype(user)) return
	if (electrocute_mob(user, shock_area, src))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"

// Some turfs to make floors look better in centcom tram station.

/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_grid"

/turf/unsimulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

/turf/unsimulated/wall/transit
	icon = 'icons/turf/transit_vr.dmi'

/turf/unsimulated/floor/transit
	icon = 'icons/turf/transit_vr.dmi'

/obj/effect/floor_decal/transit/orange
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "transit_techfloororange_edges"

/obj/effect/transit/light
	icon = 'icons/turf/transit_128.dmi'
	icon_state = "tube1-2"

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b,
		/turf/simulated/floor/outdoors/dirt/virgo3b
		)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
/turf/simulated/floor/outdoors/dirt/virgo3b
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

/////FOR CENTCOMM (at least)/////
/obj/effect/overmap/visitable/sector/virgo3b
	name = "Virgo 3B"
	desc = "Full of phoron, and home to the NSB Adephagia."
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	known = TRUE
	
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "virgo3b"

	skybox_icon = 'icons/skybox/virgo3b.dmi'
	skybox_icon_state = "small"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	initial_restricted_waypoints = list()

/////SD Starts at V3b to pick up crew refuel and repair (And to make sure it doesn't spawn on hazards)
/obj/effect/overmap/visitable/sector/virgo3b/Initialize()
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

/obj/effect/overmap/visitable/sector/virgo3b/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		atc.msg(message)

/obj/item/weapon/paper/sdshield
	name = "ABOUT THE SHIELD GENERATOR"
	info = "<H1>ABOUT THE SHIELD GENERATOR</H1><BR><BR>If you&#39;re up here you are more than likely worried about hitting rocks or some other such thing. It is good to worry about such things as that is an inevitability.<BR><BR>The Stellar Delight is a rather compact vessel, so a setting of 55 to the range will just barely cover her aft. <BR><BR>It is recommended that you turn off all of the different protection types except multi dimensional warp and whatever it is you&#39;re worried about running into. (probably meteors (hyperkinetic)). <BR><BR>With only those two and all the other default settings, the shield uses more than 6 MW to run, which is more than the ship can ordinarily produce. AS SUCH, it is also recommended that you reduce the input cap to whatever you find reasonable (being as it defaults to 1 MW, which is the entirety of the stock power supply) and activate and configure the shield BEFORE you need it. <BR><BR>The shield takes some time to expand its range to the desired specifications, and on top of that, under the default low power setting, takes around 40 seconds to spool up. Once it is active, the fully charged internal capacitors will last for around 1 to 2 minutes before depleting fully. You can increase the passive energy use to decrease the spool up time, but it also uses the stored energy much faster, so, that is not recommended except in dire emergencies.<BR><BR>So, this shield is not intended to be run indefinitely, unless you seriously beef up the ship&#39;s engine and power supply.<BR><BR>Fortunately, if you&#39;ve got a good pilot, you shouldn&#39;t really need the shield generator except in rare cases and only for short distances. Still, it is a good idea to configure the shield to be ready before you need it.<BR><BR>Good luck out there - <I>Budly Gregington</I>"
