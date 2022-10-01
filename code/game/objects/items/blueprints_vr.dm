#define BP_MAX_ROOM_SIZE 300

// WARNING: ESOTERIC BULLSHIT INSIDE OF THIS FILE.
// This is a port of /tg/'s blueprints that also have Virgo modifications as well.
// However it is heavily modified and lacking the 't-ray' scanner functionality that /TG/ has. We have our own t-rays after all.
// This works and uses a bunch of really odd hacks and trickery to get it to all function.
// If you're looking at this a few years from now and going 'What the hell were they thinking' just know that this was the best we had at the time.

// Now that I've scared away half the people looking at this file, here's the relevant info:

// Banning areas: Go to /obj/item/areaeditor/proc/get_area_type and /proc/create_area and add the /area to: (area_or_turf_fail_types)
// That will bar people from doing ANYTHING to those areas. No creating inside of them. No merging into them. Etc.

// Disallow creation but allow merge/expansion: Go to the same two above again.
// Add the /area to 'blacklisted_areas' in /proc/create_area


/area/tether/surfacebase/outside
	name = "Outside - Surface"

/area/groundbase/unexplored/outdoors
	name = "\improper Rascal's Pass"

/area/groundbase/mining
	name = "Mining"

/area/groundbase/unexplored/rock
	name = "\improper Rascal's Pass"

/area/maintenance/groundbase/level1
	name = "Groundbase Level One Maint"

/area/submap/groundbase/wilderness
	name = "Groundbase Wilderness"

//TG blueprints.
#define AREA_ERRNONE 0
#define AREA_STATION 1
#define AREA_SPACE 2
#define AREA_SPECIAL 3

/obj/item/areaeditor
	name = "area modification item"
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	in_use = FALSE
	preserve_item = 1
	var/uses_charges = 0 					// If the area editor has limited uses.
	var/charges = 0							// The amount of uses the area editor has.

	var/can_create_areas_in = AREA_SPACE	// Must be standing in space to create
	var/can_create_areas_into = AREA_SPACE	// New areas will only overwrite space area turfs.
	var/can_expand_areas_in = AREA_STATION	// Must be standing in station to expand
	var/can_expand_areas_into = AREA_SPACE	// Can expand station areas only into space.
	var/can_rename_areas_in = AREA_STATION	// Only station areas can be reanamed


	var/const/ROOM_ERR_LOLWAT = 0 			// Don't touch these three consts or BYOND will literally tear out your throat
	var/const/ROOM_ERR_SPACE = -1
	var/const/ROOM_ERR_TOOLARGE = -2
	var/const/ROOM_ERR_FORBIDDEN = -3

	var/list/areaColor_turfs = list()
	var/legend = 0 //If viewing wires or not.


/obj/item/areaeditor/attack_self(mob/user) //Convert this to TGUI sometime to disallow browser exploits.
	add_fingerprint(user)
	. = "<BODY><HTML><head><title>[src]</title></head> \
				<h2>[station_name()] [src.name]</h2>"
	switch(get_area_type())
		if(AREA_SPACE)
			. += "<p>According to the [src.name], you are now in an unclaimed territory.</p>"
		if(AREA_SPECIAL)
			. += "<p>This place is not noted on the [src.name].</p>"
			return //If we're in a special area, no modifying.
	. += "<p><a href='?src=[REF(src)];create_area=1'>Create or modify an existing area (3x3 space)</a></p>"
	. += "<p><a href='?src=[REF(src)];create_area_whole=1'>Create new area or merge two areas. (Whole Room)</a></p>"
	. += "There is a note on the corner of the [src.name]: Use 3x3 for fine-tuning and including walls into your area!"


/obj/item/areaeditor/Topic(href, href_list)
	if(..())
		return TRUE
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	if(href_list["create_area"])
		if(in_use)
			return
		var/area/A = get_area(usr)
		if(A.flags & BLUE_SHIELDED)
			to_chat(usr, span_warning("You cannot edit restricted areas."))
			return
		in_use = TRUE
		create_area(usr)
		in_use = FALSE
	if(href_list["create_area_whole"])
		if(in_use)
			return
		in_use = TRUE
		var/area/A = create_area_whole(usr)
		if(A && (A.flags & BLUE_SHIELDED))
			to_chat(usr, span_warning("You cannot edit restricted areas."))
			in_use = FALSE
			return
		in_use = FALSE
	updateUsrDialog()

//Station blueprints!!!
/obj/item/areaeditor/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	var/list/image/showing = list()
	var/client/viewing


/obj/item/areaeditor/blueprints/Destroy()
	//clear_viewer()
	return ..()


/obj/item/areaeditor/blueprints/attack_self(mob/user)
	. = ..()
	var/area/A = get_area(user)
	if(!legend)
		if(get_area_type() == AREA_STATION)
			. += "<p>According to \the [src], you are now in <b>\"[html_encode(A.name)]\"</b>.</p>"
			. += "<p><a href='?src=[REF(src)];edit_area=1'>Change area name</a></p>"
		. += "<p><a href='?src=[REF(src)];view_legend=1'>View wire colour legend</a></p>"
		//if(!viewing)
		//	. += "<p><a href='?src=[REF(src)];view_blueprints=1'>View structural data</a></p>"
		//else
		//	. += "<p><a href='?src=[REF(src)];refresh=1'>Refresh structural data</a></p>"
		//	. += "<p><a href='?src=[REF(src)];hide_blueprints=1'>Hide structural data</a></p>"
	else
		if(legend == TRUE)
			. += "<a href='?src=[REF(src)];exit_legend=1'><< Back</a>"
			. += view_wire_devices(user);
		else
			//legend is a wireset
			. += "<a href='?src=[REF(src)];view_legend=1'><< Back</a>"
			. += view_wire_set(user, legend)
	var/datum/browser/popup = new(user, "blueprints", "[src]", 700, 500)
	popup.set_content(.)
	popup.open()
	onclose(user, "blueprints")


/obj/item/areaeditor/blueprints/Topic(href, href_list)
	if(..())
		return
	if(href_list["edit_area"])
		if(get_area_type()!=AREA_STATION)
			return
		if(in_use)
			return
		in_use = TRUE
		edit_area()
		in_use = FALSE
	if(href_list["exit_legend"])
		legend = FALSE;
	if(href_list["view_legend"])
		legend = TRUE;
	if(href_list["view_wireset"])
		legend = href_list["view_wireset"];
	/*
	if(href_list["view_blueprints"])
		set_viewer(usr, span_notice("You flip the blueprints over to view the complex information diagram."))
	if(href_list["hide_blueprints"])
		clear_viewer(usr,span_notice("You flip the blueprints over to view the simple information diagram."))
	if(href_list["refresh"])
		clear_viewer(usr)
		set_viewer(usr)
	*/
	attack_self(usr) //this is not the proper way, but neither of the old update procs work! it's too ancient and I'm tired shush.


//Code for viewing pipes or whatnot. Think t-ray scanner.
//Code for viewing pipes or whatnot. Think t-ray scanner.
//Code for viewing pipes or whatnot. Think t-ray scanner.
/*
/obj/item/areaeditor/blueprints/proc/get_images(turf/central_turf, viewsize)
	. = list()
	var/list/dimensions = getviewsize(viewsize)
	var/horizontal_radius = dimensions[1] / 2
	var/vertical_radius = dimensions[2] / 2
	for(var/turf/nearby_turf as anything in RECT_TURFS(horizontal_radius, vertical_radius, central_turf))
		if(nearby_turf.blueprint_data)
			. += nearby_turf.blueprint_data
*/
/*
/obj/item/areaeditor/blueprints/proc/set_viewer(mob/user, message = "")
	if(user?.client)
		if(viewing)
			clear_viewer()
		viewing = user.client
		showing = get_images(get_turf(viewing.eye || user), viewing.view)
		viewing.images |= showing
		if(message)
			to_chat(user, message)
*/
/*
/obj/item/areaeditor/blueprints/proc/clear_viewer(mob/user, message = "")
	if(viewing)
		viewing.images -= showing
		viewing = null
	showing.Cut()
	if(message)
		to_chat(user, message)
*/
/obj/item/areaeditor/blueprints/dropped(mob/user)
	..()
	//clear_viewer()
	if(areaColor_turfs.len)
		seeAreaColors_remove()
	legend = FALSE



/obj/item/areaeditor/proc/get_area_type(area/A)
	if (!A)
		A = get_area(usr)
	if(A.outdoors)
		return AREA_SPACE

	for (var/type in BUILDABLE_AREA_TYPES)
		if ( istype(A,type) )
			return AREA_SPACE

	for (var/type in SPECIALS)
		if ( istype(A,type) )
			return AREA_SPECIAL
	return AREA_STATION


/obj/item/areaeditor/blueprints/proc/view_wire_devices(mob/user)
	var/message = "<br>You examine the wire legend.<br>"
	for(var/wireset in GLOB.wire_color_directory)
		//if(istype(wireset,/datum/wires/grid_checker))//Uncomment this in if you want the grid checker minigame to not be revealed here.
		//	continue
		message += "<br><a href='?src=[REF(src)];view_wireset=[wireset]'>[GLOB.wire_name_directory[wireset]]</a>"
	message += "</p>"
	return message

/obj/item/areaeditor/blueprints/proc/view_wire_set(mob/user, wireset)
	//for some reason you can't use wireset directly as a derefencer so this is the next best :/
	for(var/device in GLOB.wire_color_directory)
		if("[device]" == wireset) //I know... don't change it...
			var/message = "<p><b>[GLOB.wire_name_directory[device]]:</b>"
			for(var/Col in GLOB.wire_color_directory[device])
				var/wire_name = GLOB.wire_color_directory[device][Col]
				if(!findtext(wire_name, WIRE_DUD_PREFIX)) //don't show duds
					message += "<p><span style='color: [Col]'>[Col]</span>: [wire_name]</p>"
			message += "</p>"
			return message
	return ""


/obj/item/areaeditor/proc/edit_area()
	var/area/A = get_area(usr)
	var/prevname = "[A.name]"
	var/str = tgui_input_text(usr, "New area name", "Area Creation", max_length = MAX_NAME_LEN)
	str = sanitize(str,MAX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, span_warning("The given name is too long. The area's name is unchanged."))
		return

	rename_area(A, str)

	to_chat(usr, span_notice("You rename the '[prevname]' to '[str]'."))
	log_and_message_admins("has changed the area '[prevname]' title to '[str]'.")
	A.update_areasize()
	interact()
	return TRUE

//Blueprint Subtypes

/obj/item/areaeditor/blueprints/cyborg
	name = "station schematics"
	desc = "A digital copy of the station blueprints stored in your memory."


/proc/set_area_machinery(area/area, title, oldtitle)
	if(!oldtitle) // or replacetext goes to infinite loop
		return
	for(var/obj/machinery/alarm/airpanel in area)
		airpanel.name = replacetext(airpanel.name,oldtitle,title)
		airpanel.update_area()
	for(var/obj/machinery/power/apc/apcpanel in area)
		apcpanel.name = replacetext(apcpanel.name,oldtitle,title)
		apcpanel.update_area() //DECIDE IF THIS IS WANTED OR NOT. This can mean that the APC will overwrite the current APC the area being expanded has since areas cant have multiple APCs.
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/scrubber in area)
		scrubber.name = replacetext(scrubber.name,oldtitle,title)
		scrubber.update_area()
	for(var/obj/machinery/atmospherics/unary/vent_pump/vent in area)
		vent.name = replacetext(vent.name,oldtitle,title)
		vent.update_area()
	for(var/obj/machinery/door/door in area)
		door.name = replacetext(door.name,oldtitle,title)
	for(var/obj/machinery/firealarm/firepanel in area)
		firepanel.name = replacetext(firepanel.name,oldtitle,title)
	area.update_areasize()
	//TODO: much much more. Unnamed airlocks, cameras, etc.

/proc/detect_room(turf/origin, list/break_if_found, max_size=INFINITY)
	if(origin.blocks_air)
		return list(origin)

	. = list()
	var/list/checked_turfs = list()
	var/list/found_turfs = list(origin)
	while(length(found_turfs))
		var/turf/sourceT = found_turfs[1]
		found_turfs.Cut(1, 2)
		var/dir_flags = checked_turfs[sourceT]
		for(var/dir in GLOB.alldirs)
			if(length(.) > max_size)
				return
			if(dir_flags & dir) // This means we've checked this dir before, probably from the other turf
				continue
			var/turf/checkT = get_step(sourceT, dir)
			if(!checkT)
				continue

			checked_turfs[sourceT] |= dir
			checked_turfs[checkT] |= turn(dir, 180)
			.[sourceT] |= dir
			.[checkT] |= turn(dir, 180)
			if(break_if_found[checkT.type] || break_if_found[checkT.loc.type])
				return FALSE

			//BEGIN ESOTERIC BULLSHIT
			//log_debug("Origin: [origin.c_airblock(checkT)] SourceT: [sourceT.c_airblock(checkT)] 0=NB 1=AB 2=ZB, 3=B")
			if(origin.c_airblock(checkT)) //If everything breaks and it doesn't want to work, turn on the above debug and check this line. C.L. 0 = not blocked.
				continue
			//END ESOTERIC BULLSHIT

			found_turfs += checkT // Since checkT is connected, add it to the list to be processed
		if(found_turfs.len)
			found_turfs += origin //If this isn't done, it just adds the 8 tiles around the user.
		return found_turfs

/proc/create_area(mob/creator)
	var/list/turfs = detect_room(get_turf(creator), area_or_turf_fail_types, BP_MAX_ROOM_SIZE*2)
	if(!turfs)
		to_chat(creator, span_warning("The new area must have a floor and not a part of a shuttle."))
		return
	if(length(turfs) > BP_MAX_ROOM_SIZE)
		to_chat(creator, span_warning("The room you're in is too big. It is [length(turfs) >= BP_MAX_ROOM_SIZE *2 ? "more than 100" : ((length(turfs) / BP_MAX_ROOM_SIZE)-1)*100]% larger than allowed."))
		return
	var/list/areas = list("New Area" = /area)

	for(var/i in 1 to length(turfs))
		var/area/place = get_area(turfs[i])
		if(blacklisted_areas[place.type])
			continue
		if(!place.requires_power || (place.flags & BLUE_SHIELDED))
			continue // No expanding powerless rooms etc
		areas[place.name] = place

	var/area_choice = tgui_input_list(creator, "Choose an area to expand or make a new area", "Area Expansion", areas)
	if(isnull(area_choice))
		to_chat(creator, span_warning("No choice selected. No adjustments made."))
		return
	area_choice = areas[area_choice]

	var/area/newA
	var/area/oldA = get_area(get_turf(creator))
	if(!isarea(area_choice))
		var/str = tgui_input_text(creator, "New area name", "Blueprint Editing", max_length = MAX_NAME_LEN)
		str = sanitize(str,MAX_NAME_LEN)
		if(!str || !length(str)) //cancel
			return
		if(length(str) > 50)
			to_chat(creator, "<span class='warning'>Name too long.</span>")
			return
		for(var/area/A in world) //Check to make sure we're not making a duplicate name. Sanity.
			if(A.name == str)
				to_chat(creator, "<span class='warning'>An area in the world alreay has this name.</span>")
				return
		newA = new area_choice
		newA.setup(str)
		newA.has_gravity = oldA.has_gravity
	else
		newA = area_choice

	for(var/i in 1 to length(turfs)) //Fix lighting. Praise the lord.
		var/turf/thing = turfs[i]
		newA.contents += thing
		thing.change_area(oldA, newA)


	set_area_machinery(newA, newA.name, oldA.name)// Change the name and area defines of all the machinery to the correct area.
	oldA.power_check() //Simply makes the area turn the power off if you nicked an APC from it.
	to_chat(creator, span_notice("You have created a new area, named [newA.name]. It is now weather proof, and constructing an APC will allow it to be powered."))
	return TRUE



// USED FOR VARIANT ROOM CREATION.
// OLD CODE. DON'T TOUCH OR 100 RABID SQUIRRELS WILL DEVOUR YOU.
// I say old code, but it truly isn't. It's a bastardization of the new create_area code and the old create_area code.
// In essence, it does a few things: Ensure no blacklisted areas are nearby, get the nearby areas (to allow merging), and allow you to make a whole near area.
/obj/item/areaeditor/proc/create_area_whole(mob/creator) //Gets the entire enclosed space and makes a new area out of it. Can overwrite old areas.

	var/res = detect_room_ex(get_turf(creator), can_create_areas_into, area_or_turf_fail_types)
	if(!res)
		to_chat(creator, span_warning("There is an area forbidden from being edited here! Use the fine-tune area creator! (3x3)"))
		return

	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(creator, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(creator, "<span class='warning'>The new area too large!</span>")
				return
			if(ROOM_ERR_FORBIDDEN)
				to_chat(creator, "<span class='warning'>There is an area forbidden from being edited here!</span>")
				return
			else
				to_chat(creator, "<span class='warning'>Error! Please notify administration!</span>")
				return
	var/list/turf/turfs = res

	var/list/areas = list("New Area" = /area)	//The list of areas surrounding the user.
	var/area/newA								//The new area
	var/area/oldA = get_area(get_turf(creator))	//The old area (area currently standing in)
	var/str										//What the new area is named.

	var/list/nearby_turfs_to_check = detect_room(get_turf(creator), area_or_turf_fail_types, BP_MAX_ROOM_SIZE*2) //Get the nearby areas.

	if(!nearby_turfs_to_check)
		to_chat(creator, span_warning("The new area must have a floor and not a part of a shuttle."))
		return
	if(length(turfs) > BP_MAX_ROOM_SIZE)
		to_chat(creator, span_warning("The room you're in is too big. It is [length(turfs) >= BP_MAX_ROOM_SIZE *2 ? "more than 100" : ((length(turfs) / BP_MAX_ROOM_SIZE)-1)*100]% larger than allowed."))
		return

	for(var/i in 1 to length(nearby_turfs_to_check))
		var/area/place = get_area(nearby_turfs_to_check[i])
		if(blacklisted_areas[place.type])
			if(!creator.lastarea != place) //Stops them from merging a blacklisted area to make it larger. Allows them to merge a blacklisted area into an allowed area. (Expansion!)
				continue
		if(!place.requires_power || (place.flags & BLUE_SHIELDED))
			continue // No expanding powerless rooms etc
		areas[place.name] = place

	//They can select an area they want to turn their current area into.
	var/area_choice = tgui_input_list(creator, "What area do you want to turn the area YOU ARE CURRENTLY STANDING IN to? Or do you want to make a new area?", "Area Expansion", areas)
	if(isnull(area_choice)) //They pressed cancel.
		to_chat(creator, "<span class='warning'>No changes made.</span>")
		return

	area_choice = areas[area_choice]

	var/confirm = tgui_alert(creator, "Are you sure you want to turn [oldA.name] into [area_choice]?", "READ CAREFULLY", list("No", "Yes"))
	if(confirm == "No")
		to_chat(creator, "<span class='warning'>No changes made.</span>")
		return

	if(!isarea(area_choice)) //They chose "New Area"
		str = tgui_input_text(creator, "New area name", "Blueprint Editing", max_length = MAX_NAME_LEN)
		str = sanitize(str,MAX_NAME_LEN)
		if(!str || !length(str)) //cancel
			return
		if(length(str) > 50)
			to_chat(creator, "<span class='warning'>Name too long.</span>")
			return
		for(var/area/A in world) //Check to make sure we're not making a duplicate name. Sanity.
			if(A.name == str)
				to_chat(creator, "<span class='warning'>An area in the world alreay has this name.</span>")
				return
		newA = new area_choice
		newA.setup(str)
		newA.has_gravity = oldA.has_gravity
	else
		newA = area_choice //They selected to turn the area they're standing on into the selected area.

	if(str) //New area, new name.
		newA.setup(str)
	else
		newA.setup(newA.name)

	for(var/i in 1 to length(turfs)) //Fix lighting. Praise the lord.
		var/turf/thing = turfs[i]
		newA.contents += thing
		thing.change_area(oldA, newA)

	move_turfs_to_area(turfs, newA)
	newA.has_gravity = oldA.has_gravity
	set_area_machinery(newA, newA.name, oldA.name)
	oldA.power_check() //Simply makes the area turn the power off if you nicked an APC from it.
	to_chat(creator, span_notice("You have created a new area, named [newA.name]. It is now weather proof, and constructing an APC will allow it to be powered."))


	spawn(5)
		interact()
	return

/obj/item/areaeditor/proc/move_turfs_to_area(var/list/turf/turfs, var/area/A)
	for(var/T in turfs)
		ChangeArea(T, A)


/obj/item/areaeditor/proc/detect_room_ex(var/turf/first, var/allowedAreas = AREA_SPACE, var/list/forbiddenAreas = list(), var/visual)
	if(!istype(first))
		return ROOM_ERR_LOLWAT
	if(!visual && forbiddenAreas[first.loc.type] || forbiddenAreas[first.type]) //Is the area of the starting turf a banned area? Is the turf a banned area?
		return ROOM_ERR_FORBIDDEN
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		if (found.len+pending.len > BP_MAX_ROOM_SIZE)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		for (var/dir in cardinal)
			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue
			if(!visual && forbiddenAreas[NT.loc.type])
				return ROOM_ERR_FORBIDDEN
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







//Nice verbs for the engineer to see where areas start/end.

/obj/item/areaeditor/verb/seeRoomColors()
	set src in usr
	set category = "Blueprints"
	set name = "Show Room Colors"

	// If standing somewhere we can expand from, use expand perms, otherwise create
	var/canOverwrite = (get_area_type() & can_expand_areas_in) ? can_expand_areas_into : can_create_areas_into
	var/res = detect_room_ex(get_turf(usr), canOverwrite, visual = 1)
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

/obj/item/areaeditor/verb/seeAreaColors()
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

/obj/item/areaeditor/verb/seeAreaColors_remove()
	set src in usr
	set category = "Blueprints"
	set name = "Remove Area Colors"

	areaColor_turfs.Cut()
	if(usr.client.images.len)
		for(var/image/i in usr.client.images)
			if(i.icon_state == "blueprints")
				usr.client.images.Remove(i)


#undef BP_MAX_ROOM_SIZE