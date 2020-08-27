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

// -- Objs -- //


/obj/effect/step_trigger/teleporter/debrisfield_loop/north/New()
	..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/south/New()
	..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/west/New()
	..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/east/New()
	..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/debrisfield
	name = "away mission initializer - debrisfield"

/obj/away_mission_init/debrisfield/Initialize()
	initialized = TRUE
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

//TFF 26/12/19 - Sub-areas for the APCs.

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

/area/submap/debrisfield/misc_debris //for random bits of debris that should use dynamic lights
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
