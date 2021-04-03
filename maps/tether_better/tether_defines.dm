//Normal map defs
#define Z_LEVEL_SURFACE_LOW					1
#define Z_LEVEL_SURFACE_MID					2
#define Z_LEVEL_SURFACE_HIGH				3
#define Z_LEVEL_TRANSIT						4
#define Z_LEVEL_SPACE_LOW					5
#define Z_LEVEL_SPACE_MID					6
#define Z_LEVEL_SPACE_HIGH					7
#define Z_LEVEL_SURFACE_MINE				8
#define Z_LEVEL_SOLARS						9
#define Z_LEVEL_MISC						10
#define Z_LEVEL_UNDERDARK					11
#define Z_LEVEL_PLAINS						12
#define Z_LEVEL_OFFMAP1						13
#define Z_LEVEL_OFFMAP2						14
#define Z_LEVEL_ROGUEMINE_1					15
#define Z_LEVEL_ROGUEMINE_2					16
#define Z_LEVEL_BEACH						17
#define Z_LEVEL_BEACH_CAVE					18
#define Z_LEVEL_AEROSTAT					19
#define Z_LEVEL_AEROSTAT_SURFACE			20
#define Z_LEVEL_DEBRISFIELD					21
#define Z_LEVEL_FUELDEPOT					22
#define Z_LEVEL_GATEWAY						23

//Camera networks
#define NETWORK_TETHER "Tether"
#define NETWORK_TCOMMS "Telecommunications" //Using different from Polaris one for better name
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"

/datum/map/tether/New()
	..()
	var/choice = pickweight(list(
		"tether_perfect" = 1
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/tether
	name = "Virgo"
	full_name = "NSB Adephagia"
	path = "tether"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_MISC
	overmap_size = 50
	overmap_event_areas = 44
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/tether

	lobby_icon = 'icons/misc/title_vr_2.dmi'
	lobby_screens = list("tether_perfect")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH))

	station_name  = "NSB Twodephagia"
	station_short = "Tether But Better"
	dock_name     = "Virgo-3BB Colony"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled ULTRA BLING tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The ULTRA BLING tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The ULTRA BLING tram will be arriving shortly. Those departing should proceed to the ULTRA BLING tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Automated Tram"
	emergency_shuttle_docked_message = "The evacuation ULTRA BLING tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency ULTRA BLING tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule ULTRA BLING tram has been called. It will arrive at the ULTRA BLING tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation ULTRA BLING tram has been recalled."

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
							NETWORK_TCOMMS,
							NETWORK_TETHER
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
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)

	default_skybox = /datum/skybox_settings/tether

	unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
		/area/tether/elevator,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo,
		/area/looking_glass/lg_1,
		/area/rnd/miscellaneous_lab
		)

//TFF 5/4/20 - Mining Ops move, airlock path change
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos_intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium,
		/area/tether/surfacebase/lowernortheva, // it airlock
		/area/tether/surfacebase/lowernortheva/external, //it outside
		/area/tether/surfacebase/security/gasstorage) //it maint


	lateload_z_levels = list(
		list("Tether - Misc","Tether - Underdark","Tether - Plains"), //Stock Tether lateload maps
		list("Offmap Ship - Talon Z1","Offmap Ship - Talon Z2"),
		list("Asteroid Belt 1","Asteroid Belt 2"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space"),
		list("Fuel Depot - Z1 Space")
		)

	lateload_single_pick = list(
		list("Snow Outpost"),
		list("Carp Farm"),
		list("Snow Field"),
		list("Listening Post")
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_TRANSIT,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_MISC,
		Z_LEVEL_BEACH
		)

	belter_docked_z = 		list(Z_LEVEL_SPACE_HIGH)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2)

//TFF 16/4/20 - mining outpost shuttle defines
	mining_station_z =		list(Z_LEVEL_SPACE_HIGH)
	mining_outpost_z =		list(Z_LEVEL_SURFACE_MINE)

	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/virgo3b_better,
								/datum/planet/virgo4)

/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1

/datum/map/tether/get_map_info()
	. = list()
	. +=  "Tether? Bah! Who needs Tether. We have something better! Way better! Welcome to better tether!<br>"
	. +=  "Virgo 3B? Phoron? Wake up, samurai, it's time to vore on new and god damn improved planet! Virgo 3BB. What does it mean? Virgo 3B BETTER!<br>"
	. +=  "Fresh air! Green grass! Sunny days! You want it? It's yours, my friend. As long as you come to NSB Twodephagia!<br>"
	. +=  "No elevator! Better pond! Extra original gaslamps! Now, get on and have some vore-mazing fuckin' time!"
	return jointext(., "<br>")

/datum/skybox_settings/tether
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3b_better
	expected_z_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_PLAINS
		)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_LEVEL_BEACH
	)

// Overmap represetation of tether
/obj/effect/overmap/visitable/sector/virgo3b_better
	name = "Virgo 3B 2.0"
	desc = "Full of not-phoron, and home to the NSB Twophagia, where you can dock and vore some booty."
	scanner_desc = @{"[i]Registration[/i]: NSB Twophagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	base = 1
	icon_state = "globe"
	color = "#d35b5b"
	initial_generic_waypoints = list(
		"tether_dockarm_d1a1", //Bottom left,
		"tether_dockarm_d1a2", //Top left,
		"tether_dockarm_d1a3", //Left on inside,
		"tether_dockarm_d2a1", //Bottom right,
		"tether_dockarm_d2a2", //Top right,
		"tether_dockarm_d1l", //End of left arm,
		"tether_dockarm_d2l", //End of right arm,
		"tether_space_SE", //station1, bottom right of space,
		"tether_space_NE", //station1, top right of space,
		"tether_space_SW", //station3, bottom left of space,
		"tether_excursion_hangar", //Excursion shuttle hangar,
		"tether_medivac_dock", //Medical shuttle dock,
		"tourbus_dock" //Surface large hangar
		)
	//Despite not being in the multi-z complex, these levels are part of the overmap sector
	extra_z_levels = list(
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_PLAINS,
		Z_LEVEL_UNDERDARK
	)

/obj/effect/overmap/visitable/sector/virgo3b_better/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/virgo3b_better/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/virgo3b_better/get_space_zlevels()
	return list(Z_LEVEL_SPACE_LOW, Z_LEVEL_SPACE_MID, Z_LEVEL_SPACE_HIGH)

/obj/effect/overmap/visitable/sector/virgo3b_better/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
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

// For making the 6-in-1 holomap, we calculate some offsets
#define TETHER_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define TETHER_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define TETHER_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define TETHER_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TETHER_MAP_SIZE)) / 2) // 30

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/tether/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/tether/station/surface_low
	z = Z_LEVEL_SURFACE_LOW
	name = "Surface 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b_better
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/tether/station/surface_high
	z = Z_LEVEL_SURFACE_HIGH
	name = "Surface 3"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/tether/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/tether/station/space_low
	z = Z_LEVEL_SPACE_LOW
	name = "Asteroid 1"
	base_turf = /turf/space
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/space_mid
	z = Z_LEVEL_SPACE_MID
	name = "Asteroid 2"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/tether/station/space_high
	z = Z_LEVEL_SPACE_HIGH
	name = "Asteroid 3"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/tether/mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Mining Outpost"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b_better

/datum/map_z_level/tether/solars
	z = Z_LEVEL_SOLARS
	name = "Solar Field"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b_better

