// Navigation beacon for AI robots
// Functions as a transponder: looks for incoming signal matching

GLOBAL_LIST_EMPTY(navbeacons) // no I don't like putting this in, but it will do for now

/obj/machinery/navbeacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0-f"
	name = "navigation beacon"
	desc = "A beacon used for bot navigation."
	plane = PLATING_PLANE
	anchored = TRUE
	var/open = FALSE		// true if cover is open
	var/locked = TRUE		// true if controls are locked
	var/location = ""	// location response text
	var/list/codes = list()	// assoc. list of transponder codes
	req_access = list(ACCESS_ENGINE)

/obj/machinery/navbeacon/Initialize(mapload)
	. = ..()
	var/turf/T = loc
	hide(!T.is_plating())
	GLOB.navbeacons += src

/obj/machinery/navbeacon/hides_under_flooring()
	return 1

// called when turf state changes
// hide the object if turf is intact
/obj/machinery/navbeacon/hide(intact)
	invisibility = intact ? INVISIBILITY_ABSTRACT : INVISIBILITY_NONE
	update_icon()

// update the icon_state
/obj/machinery/navbeacon/update_icon()
	var/state="navbeacon[open]"

	if(invisibility)
		icon_state = "[state]-f"	// if invisible, set icon to faded version
									// in case revealed by T-scanner
	else
		icon_state = "[state]"

/obj/machinery/navbeacon/attackby(obj/item/I, mob/user)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent intraction when T-scanner revealed

	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		open = !open
		playsound(src, I.usesound, 50, 1)
		user.visible_message(span_notice("[user] [open ? "opens" : "closes"] the beacon's cover."), span_infoplain("You [open ? "open" : "close"] the beacon's cover."))

		update_icon()
		return

	if(I.GetID())
		togglelock(user)

/obj/machinery/navbeacon/attack_ai(mob/user)
	tgui_interact(user)

/obj/machinery/navbeacon/attack_hand(mob/user)

	if(!user.IsAdvancedToolUser())
		return 0

	tgui_interact(user)

/obj/machinery/navbeacon/proc/togglelock(mob/user)
	if(!open)
		to_chat(user, span_warning("You must open the cover first!"))
		return FALSE

	if(allowed(user))
		locked = !locked
		to_chat(user, span_notice("Controls are now [locked ? "locked." : "unlocked."]"))
		return TRUE

	to_chat(user, span_warning("Access denied."))
	return FALSE

/obj/machinery/navbeacon/tgui_interact(mob/user, datum/tgui/ui)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent intraction when T-scanner revealed

	if(!open && !isAI(user))	// can't alter controls if not open, unless you're an AI
		to_chat(user, span_warning("The beacon's control cover is closed."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NavBeacon", name)
		ui.open()

/obj/machinery/navbeacon/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)

	return list(
		"siliconUser" = issilicon(user),
		"locked" = locked,
		"open" = open,
		"location" = location,
		"codes" = codes,
	)

/obj/machinery/navbeacon/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("lock")
			if(!open)
				return
			return togglelock(ui.user)

	return access_action(action, params, ui.user)

/obj/machinery/navbeacon/proc/access_action(action, list/params, mob/user)
	if(!open || locked)
		return FALSE

	switch(action)
		if("loc_edit")
			var/new_loc = sanitize(params["new_loc"], MAX_NAME_LEN)
			if(!new_loc)
				return FALSE
			location = new_loc
			return TRUE
		if("trans_edit_key")
			var/codekey = params["code"]
			if(!codekey || !(codekey in codes))
				return FALSE
			var/new_key = sanitize(params["new_key"], MAX_NAME_LEN)
			if(!new_key)
				return FALSE
			var/list/new_codes = list()
			for(var/key, value in codes)
				if(key == codekey)
					new_codes[new_key] = value
					continue
				new_codes[key] = value
			codes = new_codes
			return TRUE
		if("trans_edit_code")
			var/codekey = params["code"]
			if(!codekey)
				return FALSE
			var/new_val = sanitize(params["new_val"], MAX_NAME_LEN)
			if(!new_val)
				return FALSE
			codes[codekey] = new_val
			return TRUE
		if("trans_add_code")
			var/new_key = sanitize(params["new_key"], MAX_NAME_LEN)
			if(!new_key)
				return FALSE
			if(codes[new_key])
				return FALSE
			var/new_val = sanitize(params["new_val"], MAX_NAME_LEN)
			if(!new_val)
				return FALSE
			codes[new_key] = new_val
			return TRUE
		if("trans_del")
			var/codekey = params["code"]
			if(!codekey)
				return FALSE
			codes.Remove(codekey)
			return TRUE

/obj/machinery/navbeacon/Destroy()
	GLOB.navbeacons.Remove(src)
	. = ..()


//
// Nav Beacon Mapping
// These subtypes are what you should actually put into maps! they will make your life much easier.
//
// Developer Note: navbeacons do not HAVE to use these subtypes.  They are purely for mapping convenience.
// You can feel free to construct them in-game as just /obj/machinery/navbeacon and they will work just
// fine, and you can define your own specific types for every instance on map if you want (BayStation does)
// This design is a compromise that means you can do mapping without every single one being its own type
// but with it still being easy to map ~ Leshana
//

// Mulebot delivery destinations

/obj/machinery/navbeacon/delivery/north
	codes = list("delivery" = 1, "dir" = NORTH)

/obj/machinery/navbeacon/delivery/south
	codes = list("delivery" = 1, "dir" = SOUTH)

/obj/machinery/navbeacon/delivery/east
	codes = list("delivery" = 1, "dir" = EAST)

/obj/machinery/navbeacon/delivery/west
	codes = list("delivery" = 1, "dir" = WEST)


// For part of the patrol route
// You MUST set "location"
// You MUST set "next_patrol"
/obj/machinery/navbeacon/patrol
	var/next_patrol

/obj/machinery/navbeacon/patrol/Initialize(mapload)
	codes = list("patrol" = 1, "next_patrol" = next_patrol)
	. = ..()
