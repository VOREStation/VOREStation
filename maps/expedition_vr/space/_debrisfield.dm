// -- Datums -- //

/obj/effect/overmap/visitable/sector/debrisfield
	name = "Debris Field"
	desc = "Space junk galore."
	scanner_desc = @{"[i]Transponder[/i]: Various faint signals
[b]Notice[/b]: Warning! Significant field of space debris detected. May be salvagable."}
	icon_state = "dust1"
	known = FALSE
	color = "#ee3333" //Redish, so it stands out against the other debris-like icons
	initial_generic_waypoints = list("debrisfield_se", "debrisfield_nw")
	icon_state = "spacehulk_g"
	possible_descriptors = list("default")
	unique_identifier = "Debris Field"

// -- Objs -- //


/obj/effect/step_trigger/teleporter/debrisfield_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/debrisfield
	name = "away mission initializer - debrisfield"

/obj/away_mission_init/debrisfield/Initialize(mapload)
	flags |= ATOM_INITIALIZED
	return INITIALIZE_HINT_QDEL

/area/tether_away/debrisfield
	name = "Away Mission - Debris Field"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/tether_away/debrisfield/shuttle_buffer //For space around shuttle landmarks to keep submaps from generating to block them
	icon_state = "debrisexplored"
	name = "\improper Space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = AMBIENCE_SPACE
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/submap/debrisfield
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "debrisunexplored"

/area/submap/debrisfield/derelict
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/submap/debrisfield/derelict/ai_access_port
	name = "POI - Abandoned Derelict AI Acess Port"

/area/submap/debrisfield/derelict/ai_access_starboard
	name = "POI - Abandoned Derelict AI Access Starboard"

/area/submap/debrisfield/derelict/ai_chamber
	name = "POI - Abandoned Derelict AI Chamber"

/area/submap/debrisfield/derelict/bridge
	name = "POI - Abandoned Derelict Bridge"

/area/submap/debrisfield/derelict/interior
	name = "POI - Abandoned Derelict Interior"

/area/submap/debrisfield/foodstand
	name = "POI - Foodstand"

/area/submap/debrisfield/sci_overrun
	name = "POI - Overrun Science Ship"
	requires_power = 0

/area/submap/debrisfield/phoron_tanker
	name = "POI - Hijacked Phoron Tanker"
	var/ic_name = ""
	requires_power = 0
	has_gravity = FALSE


/area/submap/debrisfield/phoron_tanker/Initialize(mapload)
	. = ..()
	var/datum/lore/organization/O = loremaster.organizations[/datum/lore/organization/tsc/nanotrasen]
	ic_name = pick(O.ship_names)
	name = "NTV [ic_name]"
	if(!tag)
		tag = "POI_NT_TANKER_BOAT" //Can't define at compile time, this ensures the area has this if empty
	if(apc)
		apc.name = "[name] APC"
		air_vent_names = list()
		air_scrub_names = list()
		air_vent_info = list()
		air_scrub_info = list()
		for(var/obj/machinery/alarm/AA in src)
			AA.name = "[name] Air Alarm"


/area/submap/debrisfield/luxury_boat
	flags = RAD_SHIELDED | AREA_FORBID_EVENTS

/area/submap/debrisfield/luxury_boat/bridge
	name = "Captain's Quarters"

/area/submap/debrisfield/luxury_boat/crew
	name = "Passenger Compartment"

/area/submap/debrisfield/luxury_boat/engine
	name = "Engineering"

/area/submap/debrisfield/luxury_boat/cryo
	name = "Emergency Cryopods" //Separated out based on comments on Pull Request
	requires_power = 0 //Idea is to reinforce that this place SHOULD have its air retained.

/datum/shuttle/autodock/overmap/luxury_boat
	name = "Luxury Yacht"
	warmup_time = 0
	current_location = "debris_field_yacht_start"
	docking_controller_tag = "debris_yacht_docker"
	shuttle_area = list(/area/submap/debrisfield/luxury_boat/engine, /area/submap/debrisfield/luxury_boat/cryo, /area/submap/debrisfield/luxury_boat/crew, /area/submap/debrisfield/luxury_boat/bridge)
	fuel_consumption = 6 //wasteful decadent thing
	defer_initialisation = TRUE
	move_direction = WEST

/obj/effect/shuttle_landmark/shuttle_initializer/luxury_boat
	name = "Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "debris_field_yacht_start"
	shuttle_type = /datum/shuttle/autodock/overmap/luxury_boat

/obj/effect/shuttle_landmark/shuttle_initializer/luxury_boat/Initialize(mapload)
	var/obj/effect/overmap/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Luxury Yacht"] = list(landmark_tag)
	. = ..()

/obj/effect/overmap/visitable/ship/landable/luxury_boat
	name = "TBD"
	scanner_desc = "TBD"
	vessel_mass = 20000 //10 000 is too low. It's incredibly speedy that way. This is supposed to be a crappy luxury yacht, not a racer!
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Luxury Yacht"

/obj/effect/overmap/visitable/ship/landable/luxury_boat/Initialize(mapload)
	. = ..()
	var/datum/lore/organization/O = loremaster.organizations[/datum/lore/organization/gov/elysia]
	var/newname = "ECS-T [pick(O.ship_names)]"
	name = newname
	scanner_desc = {"\[i\]Registration\[/i\]: [newname]
\[i\]Class\[/i\]: Private Pleasure Yacht
\[i\]Transponder\[/i\]: Transmitting (CIV), Weak Signal
\[b\]Notice\[/b\]: Reported missing."}
	rename_areas(newname)

/obj/effect/overmap/visitable/ship/landable/luxury_boat/proc/rename_areas(newname)
	if(!SSshuttles.subsystem_initialized)
		spawn(300)
			rename_areas(newname)
		return
	var/datum/shuttle/S = SSshuttles.shuttles[shuttle]
	for(var/area/A in S.shuttle_area)
		A.name = "[newname] [initial(A.name)]"
		if(A.apc)
			A.apc.name = "[A.name] APC"
		A.air_vent_names = list()
		A.air_scrub_names = list()
		A.air_vent_info = list()
		A.air_scrub_info = list()
		for(var/obj/machinery/alarm/AA in A)
			AA.name = "[A.name] Air Alarm"

/obj/machinery/computer/shuttle_control/explore/luxury_boat
	shuttle_tag = "Luxury Yacht"
	req_one_access = list()

/area/submap/debrisfield/old_sat
	name = "POI - Old Satellite"

/area/submap/debrisfield/old_tele
	name = "POI - Old Teleporter"

/area/submap/debrisfield/mining_drone_ship
	name = "POI - Disabled Mining Drone"
	requires_power = 0

/area/submap/debrisfield/mining_outpost
	name = "POI - Destroyed Mining Outpost"

/area/submap/debrisfield/tinyshuttle
	flags = RAD_SHIELDED | AREA_FORBID_EVENTS

/area/submap/debrisfield/tinyshuttle/crew
	name = "Crew Bay"

/area/submap/debrisfield/tinyshuttle/bridge
	name = "Bridge"

/area/submap/debrisfield/tinyshuttle/hangar
	name = "Hangar"
	has_gravity = 0

/area/submap/debrisfield/tinyshuttle/engine
	name = "Systems Bay"

/datum/shuttle/autodock/overmap/tinycarrier
	name = "Debris Carrier"
	warmup_time = 0
	current_location = "debris_field_carrier_start"
	docking_controller_tag = "debris_carrier_docker"
	shuttle_area = list(/area/submap/debrisfield/tinyshuttle/crew, /area/submap/debrisfield/tinyshuttle/bridge, /area/submap/debrisfield/tinyshuttle/hangar, /area/submap/debrisfield/tinyshuttle/engine)
	fuel_consumption = 3
	defer_initialisation = TRUE
	move_direction = WEST

/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier
	name = "Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "debris_field_carrier_start"
	shuttle_type = /datum/shuttle/autodock/overmap/tinycarrier

/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier/Initialize(mapload)
	var/obj/effect/overmap/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Debris Carrier"] = list(landmark_tag)
	. = ..()

/obj/effect/overmap/visitable/ship/landable/tinycarrier
	name = "TBD"
	scanner_desc = "TBD"
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Debris Carrier"

/obj/effect/overmap/visitable/ship/landable/tinycarrier/Initialize(mapload)
	. = ..()
	var/datum/lore/organization/O = loremaster.organizations[/datum/lore/organization/other/sysdef]
	var/newname = "SDV [pick(O.ship_names)]"
	name = newname
	scanner_desc = {"\[i\]Registration\[/i\]: [newname]
\[i\]Class\[/i\]: Light Escort Carrier
\[i\]Transponder\[/i\]: Transmitting (MIL), Weak Signal
\[b\]Notice\[/b\]: Registration Expired"}
	rename_areas(newname)

/obj/effect/overmap/visitable/ship/landable/tinycarrier/proc/rename_areas(newname)
	if(!SSshuttles.subsystem_initialized)
		spawn(300)
			rename_areas(newname)
		return
	var/datum/shuttle/S = SSshuttles.shuttles[shuttle]
	for(var/area/A in S.shuttle_area)
		A.name = "[newname] [initial(A.name)]"
		if(A.apc)
			A.apc.name = "[A.name] APC"
		A.air_vent_names = list()
		A.air_scrub_names = list()
		A.air_vent_info = list()
		A.air_scrub_info = list()
		for(var/obj/machinery/alarm/AA in A)
			AA.name = "[A.name] Air Alarm"

/obj/machinery/computer/shuttle_control/explore/tinycarrier
	shuttle_tag = "Debris Carrier"
	req_one_access = list()

/obj/mecha/combat/fighter/baron/busted
	starting_components = list(/obj/item/mecha_parts/component/hull/lightweight,/obj/item/mecha_parts/component/actuator/hispeed,/obj/item/mecha_parts/component/armor,/obj/item/mecha_parts/component/gas,/obj/item/mecha_parts/component/electrical/high_current)

/obj/mecha/combat/fighter/baron/busted/Initialize(mapload)
	. = ..()
	health = round(rand(50,120))
	cell?.charge = 0
	for(var/slot in internal_components)
		var/obj/item/mecha_parts/component/comp = internal_components[slot]
		if(!istype(comp))
			continue
		comp.adjust_integrity(-(round(rand(comp.max_integrity - 10, 0))))

	setInternalDamage(MECHA_INT_SHORT_CIRCUIT)

/obj/structure/fuel_port/empty_tank/Initialize(mapload)
	. = ..()
	var/obj/item/tank/phoron/T = locate() in src
	if(T)
		T.air_contents.remove(T.air_contents.total_moles)

/area/submap/debrisfield/misc_debris //for random bits of debris that should use dynamic lights
	requires_power = 1
	always_unpowered = 1
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
