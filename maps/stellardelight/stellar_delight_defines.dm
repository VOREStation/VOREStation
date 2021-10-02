//Normal map defs
#define Z_LEVEL_SHIP_LOW					1
#define Z_LEVEL_SHIP_MID					2
#define Z_LEVEL_SHIP_HIGH					3
#define Z_LEVEL_MISC						4
#define Z_LEVEL_BEACH						5
#define Z_LEVEL_BEACH_CAVE					6
#define Z_LEVEL_AEROSTAT					7
#define Z_LEVEL_AEROSTAT_SURFACE			8
#define Z_LEVEL_DEBRISFIELD					9
#define Z_LEVEL_FUELDEPOT					10
#define Z_LEVEL_OVERMAP						11
#define Z_LEVEL_OFFMAP1						12
#define Z_LEVEL_GATEWAY						13

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
	overmap_size = 140
	overmap_event_areas = 100
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/stellar_delight

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether2_night")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

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

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Evacuation Shuttle"
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_EXPLORATION,
							//NETWORK_DEFAULT,  //Is this even used for anything? Robots show up here, but they show up in ROBOTS network too,
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

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage","ITV Talon Cryo")
	spawnpoint_died = /datum/spawnpoint/cryo
	spawnpoint_left = /datum/spawnpoint/cryo
	spawnpoint_stayed = /datum/spawnpoint/cryo

	/*
	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)
	*/

	default_skybox = /datum/skybox_settings/stellar_delight

	unit_test_exempt_areas = list()

	unit_test_exempt_from_atmos = list() //it maint


	lateload_z_levels = list(
		list("Ship - Misc"), //Stock Tether lateload maps
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
		Z_LEVEL_BEACH
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
	expected_z_levels = list()
/datum/planet/virgo4
	expected_z_levels = list(
		Z_LEVEL_BEACH
	)

// Overmap represetation of tether
/obj/effect/overmap/visitable/visitable/stellar_delight
	name = "Stellar Delight"
	desc = "It's a ship!"
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	base = 1
	
	icon = 'icons/obj/overmap_vr.dmi' //Overmap icon
	icon_state = "virgo3b"

	skybox_icon = 'icons/skybox/virgo3b.dmi' //Skybox icon
	skybox_icon_state = "small"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	initial_generic_waypoints = list()
	//Despite not being in the multi-z complex, these levels are part of the overmap sector

	levels_for_distress = list(Z_LEVEL_OFFMAP1, Z_LEVEL_BEACH, Z_LEVEL_AEROSTAT, Z_LEVEL_DEBRISFIELD, Z_LEVEL_FUELDEPOT)

/*
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
*/


// For making the 6-in-1 holomap, we calculate some offsets
#define SHIP_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define SHIP_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define SHIP_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define SHIP_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE)) / 2) // 30

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/stellar_delight
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/stellar_delight/deck_one
	z = Z_LEVEL_SHIP_LOW
	name = "Deck 1"
	base_turf = /turf/space

/datum/map_z_level/stellar_delight/deck_two
	z = Z_LEVEL_SHIP_MID
	name = "Deck 2"
	base_turf = /turf/simulated/open

/datum/map_z_level/stellar_delight/deck_three
	z = Z_LEVEL_SHIP_HIGH
	name = "Deck 3"
	base_turf = /turf/simulated/open

/datum/map_template/ship_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/ship_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_template/ship_lateload/ship_misc
	name = "Ship - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'ship_misc.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/misc

/datum/map_z_level/ship_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/ship_lateload/overmap
	name = "Overmap"
	desc = "Overmap lives here :3"
	mappath = 'overmap.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/overmap

/datum/map_z_level/ship_lateload/overmap
	name = "Overmap"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

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