/datum/map/tether/New()
	..()
	var/choice = pickweight(list(
		"title" = 10,
		"tether" = 50,
		"tether_night" = 50,
		"tether2_night" = 50,
		"tether2_dog" = 1,
		"tether2_love" = 1,
		"tether_future" = 10,
		"logo1" = 20,
		"logo2" = 20,
		"gateway" = 5
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/tether
	name = "Tether"
	full_name = "NSB Adephagia"
	path = "tether"

	use_overmap = TRUE
	overmap_z = Z_NAME_ALIAS_MISC
	overmap_size = 50
	overmap_event_areas = 44
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/tether

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether2_night")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	holomap_smoosh = list(list(
		Z_LEVEL_TETHER_SURFACE_LOW,
		Z_LEVEL_TETHER_SURFACE_MID,
		Z_LEVEL_TETHER_SURFACE_HIGH,
		Z_LEVEL_TETHER_SPACE_LOW,
		))

	station_name  = "NSB Adephagia"
	station_short = "Tether"
	facility_type = "station"
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
	shuttle_name = "Automated Tram"
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
							NETWORK_TETHER,
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
		/area/rnd/miscellaneous_lab,
		/area/tether/transit, // Tether Debug Transit
		/area/tether/surfacebase/outside/outside2, // Very Outside
		/area/tether/surfacebase/outside/outside3 // Very Outside
		)

	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos_intake, // Outside,
		/area/engineering/engine_gas,
		/area/rnd/external, //  Outside,
		/area/rnd/outpost/xenobiology/outpost_stairs,
		/area/tether/surfacebase/entertainment/stage, // Connected to entertainment area
		/area/tether/surfacebase/emergency_storage/atmos,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium,
		/area/tether/surfacebase/lowernortheva, // it airlock
		/area/tether/surfacebase/lowernortheva/external, //it outside
		/area/tether/surfacebase/security/gasstorage, // Maint
		/area/tcommsat/chamber,
		/area/tether/outpost/solars_outside, // Outside
		/area/vacant/vacant_bar_upper // Maint
		)

	unit_test_z_levels = list(
		Z_LEVEL_TETHER_SURFACE_LOW,
		Z_LEVEL_TETHER_SURFACE_MID,
		Z_LEVEL_TETHER_SURFACE_HIGH,
		Z_LEVEL_TETHER_TRANSIT,
		Z_LEVEL_TETHER_SPACE_LOW,
	)

	lateload_z_levels = list(
		list(Z_NAME_TETHER_CENTCOM, Z_NAME_TETHER_MISC, Z_NAME_TETHER_UNDERDARK, Z_NAME_TETHER_PLAINS), //Stock Tether lateload maps
		list(Z_NAME_OFFMAP1),
		list(Z_NAME_TETHER_ROGUEMINE_1, Z_NAME_TETHER_ROGUEMINE_2),
		list(Z_NAME_BEACH, Z_NAME_BEACH_CAVE),
		list(Z_NAME_AEROSTAT, Z_NAME_AEROSTAT_SURFACE),
		list(Z_NAME_DEBRISFIELD),
		list(Z_NAME_FUELDEPOT),
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
		list(Z_NAME_REDGATE_EGGNOG_CAVE,Z_NAME_REDGATE_EGGNOG_TOWN),
		list(Z_NAME_REDGATE_STAR_DOG),
		list(Z_NAME_REDGATE_HOTSPRINGS),
		list(Z_NAME_REDGATE_RAIN_CITY),
		list(Z_NAME_REDGATE_ISLANDS_UNDERWATER,Z_NAME_REDGATE_ISLANDS),
		list(Z_NAME_REDGATE_MOVING_TRAIN, Z_NAME_REDGATE_MOVING_TRAIN_UPPER),
		list(Z_NAME_REDGATE_FANTASY_DUNGEON, Z_NAME_REDGATE_FANTASY_TOWN),
		list(Z_NAME_REDGATE_LASERDOME),
		list(Z_NAME_REDGATE_CASCADING_FALLS),
		list(Z_NAME_REDGATE_JUNGLE_CAVE, Z_NAME_REDGATE_JUNGLE),
		list(Z_NAME_REDGATE_FACILITY),
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_TETHER_SURFACE_LOW,
		Z_LEVEL_TETHER_SURFACE_MID,
		Z_LEVEL_TETHER_SURFACE_HIGH,
		Z_LEVEL_TETHER_TRANSIT,
		Z_LEVEL_TETHER_SPACE_LOW,
		Z_LEVEL_TETHER_SURFACE_MINE,
		Z_LEVEL_TETHER_SOLARS,
		Z_NAME_ALIAS_MISC,
		Z_NAME_BEACH,
		)

	belter_docked_z = 		list(Z_LEVEL_TETHER_SPACE_LOW)
	belter_transit_z =	 	list(Z_NAME_ALIAS_MISC)
	belter_belt_z = 		list(Z_NAME_TETHER_ROGUEMINE_1,
						 		 Z_NAME_TETHER_ROGUEMINE_2)

	mining_station_z =		list(Z_LEVEL_TETHER_SPACE_LOW)
	mining_outpost_z =		list(Z_LEVEL_TETHER_SURFACE_MINE)

	planet_datums_to_make = list(
		/datum/planet/virgo3b,
		/datum/planet/virgo4,
		)

/datum/map/tether/get_map_info()
	. = list()
	. +=  "The [full_name] is an ancient ruin turned workplace in the Virgo-Erigone System, deep in the midst of the Coreward Periphery.<br>"
	. +=  "Humanity has spread across the stars and has met many species on similar or even more advanced terms than them - it's a brave new world and many try to find their place in it . <br>"
	. +=  "Though Virgo-Erigone is not important for the great movers and shakers, it sees itself in the midst of the interests of a reviving alien species of the Zorren, corporate and subversive interests and other exciting dangers the Periphery has to face.<br>"
	. +=  "As an employee or contractor of NanoTrasen, operators of the Adephagia and one of the galaxy's largest corporations, you're probably just here to do a job."
	return jointext(., "<br>")

/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_TETHER_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_TETHER_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_TETHER_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_TETHER_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1

/datum/skybox_settings/tether
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3b
	expected_z_levels = list(
		Z_LEVEL_TETHER_SURFACE_LOW,
		Z_LEVEL_TETHER_SURFACE_MID,
		Z_LEVEL_TETHER_SURFACE_HIGH,
		Z_LEVEL_TETHER_SURFACE_MINE,
		Z_LEVEL_TETHER_SOLARS,
		Z_NAME_TETHER_PLAINS,
		Z_NAME_ALIAS_CENTCOM
		)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_NAME_BEACH
	)

// Overmap represetation of tether
/obj/effect/overmap/visitable/sector/virgo3b
	base = 1

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
	initial_restricted_waypoints = list("Central Command Shuttlepad" = list("cc_shuttlepad"))
	//Despite not being in the multi-z complex, these levels are part of the overmap sector
	extra_z_levels = list(
		Z_LEVEL_TETHER_SURFACE_MINE,
		Z_LEVEL_TETHER_SOLARS,
		Z_NAME_TETHER_PLAINS,
		Z_NAME_TETHER_UNDERDARK
	)

	levels_for_distress = list(Z_NAME_OFFMAP1, Z_NAME_BEACH, Z_NAME_AEROSTAT, Z_NAME_DEBRISFIELD, Z_NAME_FUELDEPOT)

/obj/effect/overmap/visitable/sector/virgo3b/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/virgo3b/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/virgo3b/get_space_zlevels()
	return list(Z_LEVEL_TETHER_SPACE_LOW)

/obj/effect/overmap/visitable/sector/virgo3b/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
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
			atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		atc.msg(message)

/obj/effect/overmap/visitable/sector/virgo3b/generate_skybox(zlevel)
	var/static/image/bigone = image(icon = 'icons/skybox/virgo3b.dmi', icon_state = "large")
	var/static/image/smallone = image(icon = 'icons/skybox/virgo3b.dmi', icon_state = "small")

	if(zlevel == Z_LEVEL_TETHER_TRANSIT)
		return bigone
	else
		return smallone

// For making the 6-in-1 holomap, we calculate some offsets
#define TETHER_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define TETHER_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define TETHER_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define TETHER_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE)) / 2) // 30

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/tether/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/tether/station/surface_low
	z = Z_LEVEL_TETHER_SURFACE_LOW
	name = "Surface 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y

/datum/map_z_level/tether/station/surface_mid
	z = Z_LEVEL_TETHER_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE

/datum/map_z_level/tether/station/surface_high
	z = Z_LEVEL_TETHER_SURFACE_HIGH
	name = "Surface 3"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X + TETHER_HOLOMAP_CENTER_GUTTER + TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y

/datum/map_z_level/tether/transit
	z = Z_LEVEL_TETHER_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/space/v3b_midpoint // Special type that spawns fall triggers

/datum/map_z_level/tether/station/space_low
	z = Z_LEVEL_TETHER_SPACE_LOW
	name = "Asteroid 1"
	base_turf = /turf/space
	transit_chance = 33
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST|MAP_LEVEL_BELOW_BLOCKED
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X + TETHER_HOLOMAP_CENTER_GUTTER + TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE

/datum/map_z_level/tether/mine
	z = Z_LEVEL_TETHER_SURFACE_MINE
	name = "Mining Outpost"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_z_level/tether/solars
	z = Z_LEVEL_TETHER_SOLARS
	name = "Solar Field"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b
