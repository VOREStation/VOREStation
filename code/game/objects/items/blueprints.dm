/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	preserve_item = 1
	var/const/AREA_ERRNONE = 0
	var/const/AREA_STATION = 1
	var/const/AREA_SPACE =   2
	var/const/AREA_SPECIAL = 3

	var/const/BORDER_ERROR = 0
	var/const/BORDER_NONE = 1
	var/const/BORDER_BETWEEN =   2
	var/const/BORDER_2NDTILE = 3
	var/const/BORDER_SPACE = 4

	var/const/ROOM_ERR_LOLWAT = 0
	var/const/ROOM_ERR_SPACE = -1
	var/const/ROOM_ERR_TOOLARGE = -2

	var/static/list/SPACE_AREA_TYPES = list(
		/area/space,
		/area/mine
	)
	var/static/list/SPECIAL_AREA_TYPES = list(
		/area/shuttle,
		/area/admin,
		/area/arrival,
		/area/centcom,
		/area/asteroid,
		/area/tdome,
		/area/syndicate_station,
		/area/wizard_station,
		/area/prison
		// /area/derelict //commented out, all hail derelict-rebuilders!
	)

	// For the color overlays
	var/list/areaColor_turfs = list()
	// Easy configuring of what we're allowed to do where or whatnot
	var/can_create_areas_in = AREA_SPACE	// Must be standing in space to create
	var/can_create_areas_into = AREA_SPACE	// New areas will only overwrite space area turfs.
	var/can_expand_areas_in = AREA_STATION	// Must be standing in station to expand
	var/can_expand_areas_into = AREA_SPACE	// Can expand station areas only into space.
	var/can_rename_areas_in = AREA_STATION	// Only station areas can be reanamed

/obj/item/blueprints/attack_self(mob/M as mob)
	if (!istype(M,/mob/living/human))
		to_chat(M, "This stack of blue paper means nothing to you.") //monkeys cannot into projecting
		return
	interact()
	return

/obj/item/blueprints/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	if (!href_list["action"])
		return
	switch(href_list["action"])
		if ("create_area")
			if (!(get_area_type() & can_create_areas_in))
				to_chat(usr, "<span class='danger'>You can't make a new area here.</span>")
				interact()
				return
			create_area()
		if ("edit_area")
			if (!(get_area_type() & can_rename_areas_in))
				to_chat(usr, "<span class='danger'>You can't rename this area.</span>")
				interact()
				return
			edit_area()
		if ("expand_area")
			if (!(get_area_type() & can_expand_areas_in))
				to_chat(usr, "<span class='danger'>You can't expand this area.</span>")
				interact()
				return
			expand_area()

/obj/item/blueprints/interact()
	var/area/A = get_area()
	var/text = {"<HTML><head><title>[src]</title></head><BODY>
<h2>[station_name()] blueprints</h2>
<small>Property of [using_map.company_name]. For heads of staff only. Store in high-secure storage.</small><hr>
"}
	var/curAreaType = get_area_type()
	switch (curAreaType)
		if (AREA_SPACE)
			text += "<p>According the blueprints, you are now in <b>outer space</b>.  Hold your breath.</p>"
		if (AREA_STATION)
			text += "<p>According the blueprints, you are now in <b>\"[A.name]\"</b>.</p>"
		if (AREA_SPECIAL)
			text += "<p>This place isn't noted on the blueprint.</p>"
		else
			text += "<p class='danger'>There is a coffee stain over this part of the blueprint.</p>"
			return // Shouldn ever get here, just sanity check

	// Offer links for what user is allowed to do based on current area
	if(curAreaType & can_create_areas_in)
		text += "<p>You can <a href='?src=\ref[src];action=create_area'>Mark this place as new area</a>.</p>"
	if(curAreaType & can_expand_areas_in)
		text += "<p>You can <a href='?src=\ref[src];action=expand_area'>expand the area</a>.</p>"
	if(curAreaType & can_rename_areas_in)
		text += "<p>You can <a href='?src=\ref[src];action=edit_area'>rename the area</a>.</p>"

	text += "</BODY></HTML>"
	usr << browse(text, "window=blueprints")
	onclose(usr, "blueprints")


/obj/item/blueprints/proc/get_area()
	var/turf/T = get_turf(usr)
	var/area/A = T.loc
	return A

/obj/item/blueprints/proc/get_area_type(var/area/A = get_area())
	for(var/type in SPACE_AREA_TYPES)
		if(istype(A, type))
			return AREA_SPACE
	for (var/type in SPECIAL_AREA_TYPES)
		if(istype(A, type))
			return AREA_SPECIAL
	return AREA_STATION

/**
 * Create a new area encompasing the current room.
 */
/obj/item/blueprints/proc/create_area()
	var/res = detect_room_ex(get_turf(usr), can_create_areas_into)
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Error! Please notify administration!</span>")
				return
	var/list/turf/turfs = res
	var/str = sanitizeSafe(input(usr, "New area name:","Blueprint Editing", ""), MAX_NAME_LEN)
	if(!str || !length(str)) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Name too long.</span>")
		return
	var/area/A = new
	A.name = str
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	move_turfs_to_area(turfs, A)

	A.always_unpowered = 0

	spawn(5)
		interact()
	return

/**
 * Expand the current area to fill the current room.
 */
/obj/item/blueprints/proc/expand_area()
	var/turf/startingTurf = get_turf(usr)
	var/res = detect_room_ex(startingTurf, can_expand_areas_into)
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Error! Please notify administration!</span>")
				return
	var/list/turf/turfs = res

	var/area/A = get_area(startingTurf)
	for(var/turf/T in A.contents)
		turfs -= T // Don't add turfs already in A to A
	if(turfs.len == 0)
		to_chat(usr, "<span class='warning'>\The [A] already covers the entire room.</span>")
		return

	move_turfs_to_area(turfs, A)
	to_chat(usr, "<span class='notice'>Expanded \the [A] by [turfs.len] turfs</span>")
	spawn(5)
		interact()
	return

/obj/item/blueprints/proc/move_turfs_to_area(var/list/turf/turfs, var/area/A)
	for(var/T in turfs)
		ChangeArea(T, A)

/obj/item/blueprints/proc/edit_area()
	var/area/A = get_area()
	var/prevname = "[A.name]"
	var/str = sanitizeSafe(input(usr, "New area name:","Blueprint Editing", prevname), MAX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Text too long.</span>")
		return
	set_area_machinery_title(A,str,prevname)
	A.name = str
	to_chat(usr, "<span class='notice'>You set the area '[prevname]' title to '[str]'.</span>")
	interact()
	return



/obj/item/blueprints/proc/set_area_machinery_title(var/area/A,var/title,var/oldtitle)
	if (!oldtitle) // or replacetext goes to infinite loop
		return

	for(var/obj/machinery/alarm/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/power/apc/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/atmospherics/unary/vent_pump/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/door/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	//TODO: much much more. Unnamed airlocks, cameras, etc.



/**
 * This detects an airtight room, following ZAS's rules for airtightness.
 * @param first The turf to start searching from. Needn't be anything in particular.
 * @param allowedAreas Bitfield of area types allowed to be included in the room.
 *	This way you can prevent overwriting special areas or station areas etc.
 *  Note: The first turf is always allowed, and turfs in its area.
 * @return On success, a list of turfs included in the room.  On failure will return a ROOM_ERR_* constant.
*/
/obj/item/blueprints/proc/detect_room_ex(var/turf/first, var/allowedAreas = AREA_SPACE)
	if(!istype(first))
		return ROOM_ERR_LOLWAT
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		if (found.len+pending.len > 300)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		for (var/dir in cardinal)
			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue
			// We ask ZAS to determine if its airtight.  Thats what matters anyway right?
			if(air_master.air_blocked(T, NT))
				// Okay thats the edge of the room
				if(get_area_type(NT.loc) == AREA_SPACE && air_master.air_blocked(NT, NT))
					found += NT // So we include walls/doors not already in any area
				continue
			if (istype(NT, /turf/space))
				return ROOM_ERR_SPACE //omg hull breach we all going to die here
			if (istype(NT, /turf/simulated/shuttle))
				return ROOM_ERR_SPACE // Unsure why this, but was in old code. Trusting for now.
			if (NT.loc != first.loc && !(get_area_type(NT.loc) & allowedAreas))
				// Edge of a protected area.  Lets stop here...
				continue
			if (!istype(NT, /turf/simulated))
				// Great, unsimulated... eh, just stop searching here
				continue
			// Okay, NT looks promising, lets continue the search there!
			pending += NT
		found += T
	// end while
	return found

/obj/item/blueprints/verb/seeAreaColors()
	set src in usr
	set category = "Blueprints"
	set name = "Show Area Colors"

	// Remove any existing
	seeAreaColors_remove()

	to_chat(usr, "<span class='notice'>\The [src] shows nearby areas in different colors.</span>")
	var/i = 0
	for(var/area/A in range(usr))
		if(get_area_type(A) == AREA_SPACE)
			continue // Don't overlay all of space!
		var/icon/areaColor = new('icons/misc/debug_rebuild.dmi', "[++i]")
		to_chat(usr, "- [A] as [i]")
		for(var/turf/T in A.contents)
			usr << image(areaColor, T, "blueprints", TURF_LAYER)
			areaColor_turfs += T

/obj/item/blueprints/verb/seeRoomColors()
	set src in usr
	set category = "Blueprints"
	set name = "Show Room Colors"

	// If standing somewhere we can expand from, use expand perms, otherwise create
	var/canOverwrite = (get_area_type() & can_expand_areas_in) ? can_expand_areas_into : can_create_areas_into
	var/res = detect_room_ex(get_turf(usr), canOverwrite)
	if(!istype(res, /list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='danger'>Error! Please notify administration!</span>")
				return
	// Okay we got a room, lets color it
	seeAreaColors_remove()
	var/icon/green = new('icons/misc/debug_group.dmi', "green")
	for(var/turf/T in res)
		usr << image(green, T, "blueprints", TURF_LAYER)
		areaColor_turfs += T
	to_chat(usr, "<span class='notice'>The space covered by the new area is highlighted in green.</span>")

/obj/item/blueprints/verb/seeAreaColors_remove()
	set src in usr
	set category = "Blueprints"
	set name = "Remove Area Colors"

	areaColor_turfs.Cut()
	if(usr.client.images.len)
		for(var/image/i in usr.client.images)
			if(i.icon_state == "blueprints")
				usr.client.images.Remove(i)

// Make sure to turn off the colors when we drop the blueprints.
/obj/item/blueprints/dropped(mob/user as mob)
	if(areaColor_turfs.len)
		seeAreaColors_remove()
	return ..()
