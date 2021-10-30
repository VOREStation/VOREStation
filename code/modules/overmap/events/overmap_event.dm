/*
** /obj/effect/overmap/event - Actual instances of event hazards on the overmap map
*/

// We don't subtype /obj/effect/overmap/visitable because that'll create sections one can travel to
//  And with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap/event
	name = "event"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "event"
	opacity = 1
	var/list/events							// List of event datum paths
	var/list/event_icon_states				// Randomly picked from
	var/difficulty = EVENT_LEVEL_MODERATE
	var/weaknesses //if the BSA can destroy them and with what

/obj/effect/overmap/event/Initialize()
	. = ..()
	icon_state = pick(event_icon_states)
	GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	GLOB.overmap_event_handler.update_hazards(old_loc)
	GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Destroy()//takes a look at this one as well, make sure everything is A-OK
	var/turf/T = loc
	. = ..()
	GLOB.overmap_event_handler.update_hazards(T)

//
// Definitions for specific types!
//

/obj/effect/overmap/event/meteor
	name = "asteroid field"
	events = list(/datum/event/meteor_wave/overmap)
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE

/obj/effect/overmap/event/electric
	name = "electrical storm"
	events = list(/datum/event/electrical_storm/overmap)
	opacity = 0
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP

/obj/effect/overmap/event/dust
	name = "dust cloud"
	events = list(/datum/event/dust/overmap)
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/effect/overmap/event/ion
	name = "ion cloud"
	events = list(/datum/event/ionstorm/overmap)
	opacity = 0
	event_icon_states = list("ion1", "ion2", "ion3", "ion4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP

/obj/effect/overmap/event/carp
	name = "carp shoal"
	events = list(/datum/event/carp_migration/overmap)
	opacity = 0
	difficulty = EVENT_LEVEL_MODERATE
	event_icon_states = list("carp1", "carp2")
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/effect/overmap/event/carp/major
	name = "carp school"
	difficulty = EVENT_LEVEL_MAJOR
	event_icon_states = list("carp3", "carp4")
