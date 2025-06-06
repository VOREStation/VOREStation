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
	var/open = 0		// true if cover is open
	var/locked = 1		// true if controls are locked
	var/freq = null		// DEPRECATED we don't use radios anymore!
	var/location = ""	// location response text
	var/codes_txt		// DEPRECATED codes as set on map: "tag1;tag2" or "tag1=value;tag2=value"
	var/list/codes = list()	// assoc. list of transponder codes
	req_access = list(access_engine)

/obj/machinery/navbeacon/Initialize(mapload)
	. = ..()
	set_codes_from_txt(codes_txt)
	if(freq)
		warning("[src] at [x],[y],[z] has deprecated var freq=[freq].  Replace it with proper type.")

	var/turf/T = loc
	hide(!T.is_plating())
	GLOB.navbeacons += src

// set the transponder codes assoc list from codes_txt
// DEPRECATED - This is kept only for compatibilty with old map files! Do not use this!
// Instead, you should replace the map instance with one of the appropriate navbeacon subtypes.
// See the bottom of this file for a list of subtypes, make your own examples if your map needs more
/obj/machinery/navbeacon/proc/set_codes_from_txt()
	if(!codes_txt)
		return
	warning("[src] at [x],[y],[z] in [get_area(src)] is using the deprecated 'codes_txt' mapping method.  Replace it with proper type.")

	codes = list()
	var/list/entries = splittext(codes_txt, ";")	// entries are separated by semicolons
	for(var/e in entries)
		var/index = findtext(e, "=")		// format is "key=value"
		if(index)
			var/key = copytext(e, 1, index)
			var/val = copytext(e, index+1)
			codes[key] = val
		else
			codes[e] = "1"

/obj/machinery/navbeacon/hides_under_flooring()
	return 1

// called when turf state changes
// hide the object if turf is intact
/obj/machinery/navbeacon/hide(var/intact)
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

/obj/machinery/navbeacon/attackby(var/obj/item/I, var/mob/user)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent intraction when T-scanner revealed

	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		open = !open
		playsound(src, I.usesound, 50, 1)
		user.visible_message("[user] [open ? "opens" : "closes"] the beacon's cover.", "You [open ? "open" : "close"] the beacon's cover.")

		update_icon()

	else if(I.GetID())
		if(open)
			if(allowed(user))
				locked = !locked
				to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
			else
				to_chat(user, span_warning("Access denied."))
			updateDialog()
		else
			to_chat(user, "You must open the cover first!")
	return

/obj/machinery/navbeacon/attack_ai(var/mob/user)
	interact(user, 1)

/obj/machinery/navbeacon/attack_hand(var/mob/user)

	if(!user.IsAdvancedToolUser())
		return 0

	interact(user, 0)

/obj/machinery/navbeacon/interact(var/mob/user, var/ai = 0)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent intraction when T-scanner revealed

	if(!open && !ai)	// can't alter controls if not open, unless you're an AI
		to_chat(user, "The beacon's control cover is closed.")
		return


	var/t

	if(locked && !ai)
		t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to unlock controls)</i><BR><HR>
Location: [location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

		for(var/key in codes)
			t += "<LI>[key] ... [codes[key]]"
		t+= "<UL></TT>"

	else

		t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to lock controls)</i><BR><HR>
Location: <A href='byond://?src=\ref[src];locedit=1'>[location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

		for(var/key in codes)
			t += "<LI>[key] ... [codes[key]]"
			t += " <small><A href='byond://?src=\ref[src];edit=1;code=[key]'>(edit)</A>"
			t += " <A href='byond://?src=\ref[src];delete=1;code=[key]'>(delete)</A></small><BR>"
		t += "<small><A href='byond://?src=\ref[src];add=1;'>(add new)</A></small><BR>"
		t+= "<UL></TT>"

	var/datum/browser/popup = new(user, "navbeacon", "Navbeacon")
	popup.set_content(t)
	popup.open()

/obj/machinery/navbeacon/Topic(href, href_list)
	..()
	if(usr.stat)
		return
	if((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		if(open && !locked)
			usr.set_machine(src)

			if(href_list["locedit"])
				var/newloc = sanitize(tgui_input_text(usr, "Enter New Location", "Navigation Beacon", location, MAX_NAME_LEN))
				if(newloc)
					location = newloc
					updateDialog()

			else if(href_list["edit"])
				var/codekey = href_list["code"]

				var/newkey = tgui_input_text(usr, "Enter Transponder Code Key", "Navigation Beacon", codekey, MAX_NAME_LEN)
				newkey = sanitize(newkey,MAX_NAME_LEN)
				if(!newkey)
					return

				var/codeval = codes[codekey]
				var/newval = tgui_input_text(usr, "Enter Transponder Code Value", "Navigation Beacon", codeval, MAX_NAME_LEN)
				newval = sanitize(newval,MAX_NAME_LEN)
				if(!newval)
					newval = codekey
					return

				codes.Remove(codekey)
				codes[newkey] = newval

				updateDialog()

			else if(href_list["delete"])
				var/codekey = href_list["code"]
				codes.Remove(codekey)
				updateDialog()

			else if(href_list["add"])

				var/newkey = tgui_input_text(usr, "Enter New Transponder Code Key", "Navigation Beacon", null, MAX_NAME_LEN)
				newkey = sanitize(newkey,MAX_NAME_LEN)
				if(!newkey)
					return

				var/newval = tgui_input_text(usr, "Enter New Transponder Code Value", "Navigation Beacon", null, MAX_NAME_LEN)
				newval = sanitize(newval,MAX_NAME_LEN)
				if(!newval)
					newval = "1"
					return

				if(!codes)
					codes = new()

				codes[newkey] = newval

				updateDialog()

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
