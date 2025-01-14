//
// Champagne bottle for creating new landable ship shuttles in game from scratch.
// Note: It depends on the area being sane.  In theory players could use this to make pretty much any room a shuttle.
//
/obj/item/champagne
	name = "bottle of champagne"
	desc = "Made from grapes grown in the champagne asteroid belt, the bubbly liquid inside is softly glowing.  Suitable for christening boats, not so much for drinking."
	description_info = "This lets you create a new overmap shuttle from scratch. \
			The shuttle must already be constructed and have an area defined (use the blueprints). \
			Only a single area is supported (for now).  Build a shuttle console and hit it with the bottle."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "champagne"
	attack_verb = list("attacked", "bonked", "hit")
	var/min_name_len = 4		// Refuse if shuttle tag is shorter than this.
	var/max_name_len = 32		// Refuse if shuttle tag is longer than this.
	var/max_area_turfs = 256	// Refuse if area has more than this many turfs.

/obj/item/champagne/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	var/obj/machinery/computer/shuttle_control/explore/comp = A
	if(!istype(comp))
		return

	if(comp.shuttle_tag)
		to_chat(user, span_warning("[comp] is already configured to link with [comp.shuttle_tag]"))
		return

	user.visible_message(span_notice("[user] lifts [src] bottle over [comp]!"))
	var/shuttle_name = tgui_input_text(usr, "Choose a name for the shuttle", "New Shuttle Name")
	if(!shuttle_name || QDELETED(src) || QDELETED(comp) || comp.shuttle_tag || user.incapacitated())
		return // After input() safety re-checks

	// Tons of safety checks here.  Make sure they don't destroy everything.
	if(length(shuttle_name) < min_name_len || length(shuttle_name) > max_name_len)
		to_chat(user, span_warning("Name length must be between [min_name_len] and [max_name_len]."))
		return
	if(shuttle_name in SSshuttles.shuttles)
		to_chat(user, span_warning("Invalid name: Already in use."))
		return

	var/area/my_area = get_area(comp)
	if(!my_area || istype(my_area, /area/space))
		to_chat(user, span_warning("[comp] must be in a valid area to become a shuttle."))
		return
	if(my_area in SSshuttles.shuttle_areas)
		to_chat(user, span_warning("[comp] is already in a shuttle."))
		return
	// Count turfs in the area
	var/list/turfs = get_current_area_turfs(my_area)
	if(turfs.len > max_area_turfs)
		to_chat(user, span_warning("The new shuttle area is too large."))
		return

	var/turf/comp_turf = get_turf(comp)
	var/datum/shuttle/autodock/S = create_landable_shuttle(shuttle_name, comp_turf, my_area)
	playsound(src, 'sound/effects/Glassbr3.ogg', 100, 0)
	user.visible_message(span_notice("[user] smashes [src] on [comp]"),
		span_info("You smash [src] on [comp], christening a new landable ship named [S.name]"),
		span_notice("You hear glass shattering"))
	log_and_message_admins("Created a new shuttle [S.name]. [ADMIN_JMP(comp_turf)]", user)
	spawn(1 SECOND)
		playsound(comp_turf, 'sound/voice/Serithi/Shuttlehere.ogg', 75, 0)
	qdel(src)

	return TRUE

/obj/item/champagne/proc/create_landable_shuttle(var/shuttle_name, var/turf/start_loc, var/area/shuttle_area)
	// First things first, create the starting location landmark.
	// WARNING - We can't figure out a good base_area or base_turf from inspecttion, as the shuttle is already built!
	// For now its going to just do world.area and z level base turf. Beware!
	var/area/base_area = world.area
	var/base_turf = get_base_turf(get_z(start_loc))
	var/obj/effect/shuttle_landmark/automatic/champagne/starting_landmark = new(start_loc, base_area, base_turf)

	// Okay first things first create the shuttle Override to no areas to prevent runtimes, then add them in.
	var/datum/shuttle/autodock/overmap/shuttle = new /datum/shuttle/autodock/overmap{shuttle_area = list()}(shuttle_name, starting_landmark)
	LAZYADD(shuttle.shuttle_area, shuttle_area)
	shuttle.refresh_fuel_ports_list() // We added area, refresh
	shuttle.set_docking_codes(null)  // It doesn't get to magically know docking codes.

	// Unfortunately we can't simply call initialize_shuttle because it takes a typepath.
	// I Don't want to rewrite that right now, so we must emulate. This is a special case anyway.
	// Emulation of SSshuttles.initialize_shuttle(): All it does is add to shuttle areas and populate objects
	SSshuttles.shuttle_areas |= shuttle.shuttle_area
	shuttle.populate_shuttle_objects()

	// Okay now create the SHIP part
	var/obj/effect/overmap/visitable/ship/landable/champagne/newship = new(start_loc, shuttle_name, shuttle_name)
	// It automatically registers itself with SSshuttles

	log_debug("Created new ship [newship] for shuttle [shuttle] at landmark [starting_landmark]")
	return shuttle

//
// Shuttle landmark dynamically generated at runtime by champagne bottle.
//
/obj/effect/shuttle_landmark/automatic/champagne
	flags = SLANDMARK_FLAG_ZERO_G // Don't auto-set

/obj/effect/shuttle_landmark/automatic/champagne/Initialize(mapload, base_area, base_turf)
	src.base_turf = base_turf
	src.base_area = base_area
	. = ..()

//
// Landable ship dynamically created at runtime by champagne bottle.
//
/obj/effect/overmap/visitable/ship/landable/champagne
	desc = "Newly minted space faring vessel."

/obj/effect/overmap/visitable/ship/landable/champagne/Initialize(mapload, _name, _shuttle)
	src.name = _name
	src.shuttle = _shuttle
	. = ..()
