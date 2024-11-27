#define BP_MAX_ROOM_SIZE 300

// WARNING: ESOTERIC BULLSHIT INSIDE OF THIS FILE.
// This is a port of /tg/'s blueprints that also have Virgo modifications as well.
// However it is heavily modified and lacking the 't-ray' scanner functionality that /TG/ has. We have our own t-rays after all.
// This works and uses a bunch of really odd hacks and trickery to get it to all function.
// If you're looking at this a few years from now and going 'What the hell were they thinking' just know that this was the best we had at the time.

// Now that I've scared away half the people looking at this file, here's the relevant info:

// Banning areas: Go to global_lists_vr, jump to the BUILDABLE_AREA_TYPES and read the comments left there.




// These areas are defined here so they can be blacklisted in global_lists_vr
/area/tether/elevator

	name = "Tether Elevator"

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

/area/offmap/aerostat/surface
	name = "Aerostat Surface"

/area/tether_away/beach
	name = "\improper Away Mission - Virgo 4 Beach"

/area/tether_away/cave
	name = "Tether Away Cave"

/area/offmap/aerostat/surface

	name = "Aerostat Surface"

/area/submap/virgo2
	name = "Submap Area"

/area/submap/casino_event
	name = "\improper Space Casino"

/obj/item/areaeditor
	name = "area modification item"
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	in_use = FALSE
	preserve_item = 1
	var/uses_charges = 0 					// If the area editor has limited uses.
	var/initial_charges = 10
	var/charges = 10						// The amount of uses the area editor has.
	var/station_master = 1					// If the areaeditor can add charges to others.
	var/wire_schematics = 0					// If the areaeditor can see wires.
	var/can_override = 0						// If you want the areaeditor to override the 'Don't make a new area where one already exists' logic. Only given to CE blueprints.

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

/obj/item/areaeditor/examine(mob/user)
	. =..()
	if(uses_charges && !isnull(charges))
		. += "There appears to be enough space for a total of [charges] more changes!"
		if(!charges)
			. += "There seems to be no more room for any more edits!"

/obj/item/areaeditor/attackby(obj/item/W, mob/user, params)
	if(uses_charges && (charges < initial_charges) && istype(W, /obj/item/areaeditor)) //Do we have a reason to add charges? And is it something that COULD add charges?
		var/missing_charges = initial_charges-charges
		var/obj/item/areaeditor/blueprint = W
		if(blueprint.station_master) //Master can refill.
			charges = initial_charges
			to_chat(user, span_notice("You add some more writing material to the [src] with the [blueprint]!"))
			return
		else if(blueprint.uses_charges && blueprint.charges) //Getting from another with limited charges.
			var/to_add = tgui_input_number(user, "How many charges do you want to add to the [src]?", "[blueprint]", missing_charges, blueprint.charges)
			if(!isnull(to_add) && blueprint.charges >= to_add)
				to_chat(user, span_notice("You add some more writing material to the [src] with the [blueprint]!"))
				blueprint.charges -= to_add
				charges += to_add
				return

			else
				to_chat(user, span_notice("You decide not to add any more material to the [src]"))
				return
		else if(!blueprint.uses_charges || !blueprint.charges) // The item it's being hit by doesn't use charges OR doesn't have any charges.
			to_chat(user, span_warning("You can't add find any suitable material to add from the [blueprint]!"))
	else
		..()

/obj/item/areaeditor/attack_self(mob/user) //Convert this to TGUI some time.
	add_fingerprint(user)
	. = "<BODY><HTML><head><title>[src]</title></head> \
				<h2>[station_name()] [src.name]</h2>"
	switch(get_area_type())
		if(AREA_SPACE)
			. += "<p>According to the [src.name], you are now in an unclaimed territory.</p>"
		if(AREA_SPECIAL)
			. += "<p>This place is not noted on the [src.name].</p>"
			return //If we're in a special area, no modifying.
	if(!uses_charges || (uses_charges && charges)) //No charges OR it has charges available.
		. += "<p><a href='?src=[REF(src)];create_area=1'>Create or modify an existing area (3x3 space) (1 Charge)</a></p>"
		. += "<p><a href='?src=[REF(src)];create_area_whole=1'>Create new area or merge two areas. (Whole Room.) (5 Charges)</a></p>"
		. += "There is a note on the corner of the [src.name]: Use 3x3 for fine-tuning and including walls into your area!"
	if(uses_charges)
		if(!charges) //We're out!
			. += "Your [src.name] has been completely filled! You would need to get some extra blueprint paper from the CE's blueprints to expand further!"
		else
			. += "Your [src.name] seems like it has enough room for [charges] more edits!"


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
		create_area(usr, src)
		in_use = FALSE
	if(href_list["create_area_whole"])
		if(in_use)
			return
		in_use = TRUE
		var/area/A = create_area_whole(usr, src)
		if(A && (A.flags & BLUE_SHIELDED))
			to_chat(usr, span_warning("You cannot edit restricted areas."))
			in_use = FALSE
			return
		in_use = FALSE
	updateUsrDialog()




//Station Wire Tool.
/obj/item/wire_reader //Not really a blueprint, but it's included here as such.
	name = "wire schematics"
	desc = "A blueprint detailing the various internal wiring of machinery around the station."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	preserve_item = 1
	var/legend = 1

/obj/item/wire_reader/attack_self(mob/user) //Convert this to TGUI some time.
	add_fingerprint(user)
	. = "<BODY><HTML><head><title>[src]</title></head> \
				<h2>[station_name()] [src.name]</h2>"
	if(legend == TRUE)
		. += view_station_wire_devices(user);
	else
		//legend is a wireset
		. += "<a href='?src=[REF(src)];view_legend=1'><< Back</a>"
		. += view_station_wire_set(user, legend)

	var/datum/browser/popup = new(user, "blueprints", "[src]", 700, 500)
	popup.set_content(.)
	popup.open()
	onclose(user, "blueprints")

/obj/item/wire_reader/Topic(href, href_list)
	if(..())
		return
	if(href_list["view_wireset"])
		legend = href_list["view_wireset"];
	if(href_list["view_legend"])
		legend = TRUE
	attack_self(usr)

/obj/item/wire_reader/proc/view_station_wire_devices(mob/user)
	var/message = "<br>You examine the wire legend.<br>"
	for(var/wireset in GLOB.wire_color_directory)
		//if(istype(wireset,/datum/wires/grid_checker))//Uncomment this in if you want the grid checker minigame to not be revealed here.
		//	continue
		message += "<br><a href='?src=[REF(src)];view_wireset=[wireset]'>[GLOB.wire_name_directory[wireset]]</a>"
	message += "</p>"
	return message

/obj/item/wire_reader/proc/view_station_wire_set(mob/user, wireset)
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

//Station blueprints!!!
/obj/item/areaeditor/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	//var/list/image/showing = list()	//For viewing pipes. Unused.
	//var/client/viewing 	//For viewing pipes. Unused.
	can_override = 1 //In case there is a reason for building in a non-blacklisted, non-buildable area.

/obj/item/areaeditor/blueprints/engineers
	name = "writing blueprints"
	desc = "A piece of paper that allows for expansion of the station and creaiton of new areas. There is a \"For Official Use Only\" stamp on it. NOT to be mistaken with the staion blueprints."
	station_master = 0
	uses_charges = 1
	can_override = 0




/obj/item/areaeditor/blueprints/Destroy()
	//clear_viewer()
	return ..()


/obj/item/areaeditor/blueprints/attack_self(mob/user)
	. = ..()
	var/area/A = get_area(user)
	if(!legend)
		if(get_area_type() == AREA_STATION)
			. += "<p>According to \the [src], you are now in <b>\"[html_encode(A.name)]\"</b>.</p>"
			. += "<p><a href='?src=[REF(src)];edit_area=1'>Change area name</a></p>" //You can change the name without charges.
		if(wire_schematics)
			. += "<p><a href='?src=[REF(src)];view_legend=1'>View wire colour legend</a></p>"
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
		if(wire_schematics) //No href hacks allow for you, my friend!
			legend = TRUE;
	if(href_list["view_wireset"])
		if(wire_schematics) //No href hacks allow for you, my friend!
			legend = href_list["view_wireset"];
	attack_self(usr)


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

			//The below checks to make sure air can pass between the two turfs. If not, it can't be added to the area.
			//This means walls can not be added to an area. The turf must first be added and then the wall.
			//UNCOMMENT THIS IF YOU WANT THE BLUEPRINTS TO NOT ADD WALLS TO AN AREA.
			//I personally think adding walls to an area is a big deal, so this is commented out.

			//BEGIN ESOTERIC BULLSHIT
			//log_debug("Origin: [origin.c_airblock(checkT)] SourceT: [sourceT.c_airblock(checkT)] 0=NB 1=AB 2=ZB, 3=B")
			/*
			if(origin.c_airblock(checkT)) //If everything breaks and it doesn't want to work, turn on the above debug and check this line. C.L. 0 = not blocked.
				continue
			*/
			//END ESOTERIC BULLSHIT

			found_turfs += checkT // Since checkT is connected, add it to the list to be processed
		if(found_turfs.len)
			found_turfs += origin //If this isn't done, it just adds the 8 tiles around the user.
		return found_turfs

/proc/create_area(mob/creator, var/obj/item/areaeditor/AO)
	if(AO && istype(AO,/obj/item/areaeditor))
		if(AO.uses_charges && AO.charges < 1)
			to_chat(creator, span_warning("You need more paper before you can even think of editing this area!"))
			return

	var/list/turfs = detect_room(get_turf(creator), area_or_turf_fail_types, BP_MAX_ROOM_SIZE*2)
	if(!turfs)
		to_chat(creator, span_warning("The new area must have a floor and not a part of a shuttle."))
		return
	if(length(turfs) > BP_MAX_ROOM_SIZE)
		to_chat(creator, span_warning("The room you're in is too big. It is [length(turfs) >= BP_MAX_ROOM_SIZE *2 ? "more than 100" : ((length(turfs) / BP_MAX_ROOM_SIZE)-1)*100]% larger than allowed."))
		return
	var/list/areas = list("New Area" = /area)
	var/annoy_admins = 0

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
			to_chat(creator, span_warning("Name too long."))
			return
		for(var/area/A in world) //Check to make sure we're not making a duplicate name. Sanity.
			if(A.name == str)
				to_chat(creator, span_warning("An area in the world alreay has this name."))
				return
		annoy_admins = 1 //They just made a new area entirely.
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
	if(annoy_admins)
		message_admins("[key_name(creator, creator.client)] just made a new area called [newA.name] ](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[creator]'>?</A>) at ([creator.x],[creator.y],[creator.z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[creator.x];Y=[creator.y];Z=[creator.z]'>JMP</a>)",0,1)
	log_game("[key_name(creator, creator.client)] just made a new area called [newA.name]")
	if(AO && istype(AO,/obj/item/areaeditor))
		if(AO.uses_charges)
			AO.charges -= 1
	return TRUE



// USED FOR VARIANT ROOM CREATION.
// OLD CODE. DON'T TOUCH OR 100 RABID SQUIRRELS WILL DEVOUR YOU.
// I say old code, but it truly isn't. It's a bastardization of the new create_area code and the old create_area code.
// In essence, it does a few things: Ensure no blacklisted areas are nearby, get the nearby areas (to allow merging), and allow you to make a whole near area.
/obj/item/areaeditor/proc/create_area_whole(mob/creator, var/override = 0) //Gets the entire enclosed space and makes a new area out of it. Can overwrite old areas.
	if(uses_charges && charges < 5)
		to_chat(creator, span_warning("You need more paper before you can even think of editing this area!"))
		return

	var/res = detect_room_ex(get_turf(creator), can_create_areas_into, area_or_turf_fail_types)
	if(!res)
		to_chat(creator, span_warning("There is an area forbidden from being edited here! Use the fine-tune area creator! (3x3)"))
		return

	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(creator, span_warning("The new area must be completely airtight!"))
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(creator, span_warning("The new area too large!"))
				return
			if(ROOM_ERR_FORBIDDEN)
				to_chat(creator, span_warning("There is an area forbidden from being edited here!"))
				return
			else
				to_chat(creator, span_warning("Error! Please notify administration!"))
				return
	var/list/turf/turfs = res

	var/list/areas = list("New Area" = /area)	//The list of areas surrounding the user.
	var/area/newA								//The new area
	var/area/oldA = get_area(get_turf(creator))	//The old area (area currently standing in)
	var/str										//What the new area is named.
	var/can_make_new_area = 1					//If they can make a new area here or not.

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
		if(!BUILDABLE_AREA_TYPES[place.type]) //TODOTODOTODO
			can_make_new_area = 0
		if(!place.requires_power || (place.flags & BLUE_SHIELDED))
			continue // No expanding powerless rooms etc
		areas[place.name] = place

	//They can select an area they want to turn their current area into.
	var/area_choice = tgui_input_list(creator, "What area do you want to turn the area YOU ARE CURRENTLY STANDING IN to? Or do you want to make a new area?", "Area Expansion", areas)
	if(isnull(area_choice)) //They pressed cancel.
		to_chat(creator, span_warning("No changes made."))
		return

	area_choice = areas[area_choice]


	if(!isarea(area_choice)) //They chose "New Area"
		if(!can_make_new_area && !can_override)
			to_chat(creator, span_warning("Making a new area here would be meaningless. Renaming it would be a better option."))
			return
		str = tgui_input_text(creator, "New area name", "Blueprint Editing", max_length = MAX_NAME_LEN)
		str = sanitize(str,MAX_NAME_LEN)
		if(!str || !length(str)) //cancel
			return
		if(length(str) > 50)
			to_chat(creator, span_warning("Name too long."))
			return
		for(var/area/A in world) //Check to make sure we're not making a duplicate name. Sanity.
			if(A.name == str)
				to_chat(creator, span_warning("An area in the world alreay has this name."))
				return

		var/confirm = tgui_alert(creator, "Are you sure you want to change [oldA.name] into a new area named [str]?", "READ CAREFULLY", list("No", "Yes"))
		if(confirm != "Yes")
			to_chat(creator, span_warning("No changes made."))
			return

		newA = new area_choice
		newA.setup(str)
		newA.has_gravity = oldA.has_gravity
	else
		var/confirm = tgui_alert(creator, "Are you sure you want to change [oldA.name] into [area_choice]?", "READ CAREFULLY", list("No", "Yes"))
		if(confirm != "Yes")
			to_chat(creator, span_warning("No changes made."))
			return
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
	message_admins("[key_name(creator, creator.client)] just made a new area called [newA.name] ](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[creator]'>?</A>) at ([creator.x],[creator.y],[creator.z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[creator.x];Y=[creator.y];Z=[creator.z]'>JMP</a>)",0,1)
	log_game("[key_name(creator, creator.client)] just made a new area called [newA.name]")
	charges -= 5

	spawn(5)
		interact()
	return

/proc/move_turfs_to_area(var/list/turf/turfs, var/area/A)
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
			if(SSair.air_blocked(T, NT))
				// Okay thats the edge of the room
				if(get_area_type(NT.loc) == AREA_SPACE && SSair.air_blocked(NT, NT))
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
				to_chat(usr, span_warning("The new area must be completely airtight!"))
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, span_warning("The new area too large!"))
				return
			else
				to_chat(usr, span_danger("Error! Please notify administration!"))
				return
	// Okay we got a room, lets color it
	seeAreaColors_remove()
	var/icon/green = new('icons/misc/debug_group.dmi', "green")
	for(var/turf/T in res)
		usr << image(green, T, "blueprints", TURF_LAYER)
		areaColor_turfs += T
	to_chat(usr, span_notice("The space covered by the new area is highlighted in green."))

/obj/item/areaeditor/verb/seeAreaColors()
	set src in usr
	set category = "Blueprints"
	set name = "Show Area Colors"

	// Remove any existing
	seeAreaColors_remove()

	to_chat(usr, span_notice("\The [src] shows nearby areas in different colors."))
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











//GLOBAL VERB FOR PAPER TO ENABLE ANYONE TO MAKE AN AREA IN BUILDABLE AREAS.
//THIS IS 70 TILES. ANYTHING LARGER SHOULD USE ACTUAL BLUEPRINTS.

/obj/item/paper
	var/created_area = 0
	var/area_cooldown = 0

/obj/item/paper/verb/create_area()
	set name = "Create Area"
	set category = "Object"
	set src in usr

	if(created_area)
		to_chat(usr, span_warning("This paper has already been used to create an area."))
		return

	if(usr.stat || world.time < area_cooldown)
		to_chat(usr, span_warning("You recently used this paper to try to create an area. Wait one minute before using it again."))
		return

	area_cooldown = world.time + 600 //Anti spam.

	create_new_area(usr)
	add_fingerprint(usr)
	return

/proc/get_new_area_type(area/A) //1 = can build in. 0 = can not build in.
	if (!A)
		A = get_area(usr)
	if(A.outdoors) //ALWAYS able to build outdoors. This means if it's missed in BUILDABLE_AREA_TYPES it's fine.
		return 1

	for (var/type in BUILDABLE_AREA_TYPES) //This works well.
		if ( istype(A,type) )
			return 1

	for (var/type in SPECIALS)
		if ( istype(A,type) )
			return 0
	return 0 //If it's not a buildable area, don't let them build in it.


/proc/detect_new_area(var/turf/first, var/user) //Heavily simplified version for creating an area yourself.
	if(!istype(first)) //Not on a turf.
		to_chat(usr, span_warning("You can not create a room here."))
		return
	if(get_new_area_type(first.loc) == 1) //Are they in an area they can build? I tried to do this BUILDABLE_AREA_TYPES[first.loc.type] but it refused.
		var/list/turf/found = new
		var/list/turf/pending = list(first)
		while(pending.len)
			if (found.len+pending.len > 70)
				return 1 //TOOLARGE
			var/turf/T = pending[1]
			pending -= T
			for (var/dir in cardinal)
				var/turf/NT = get_step(T,dir)
				if (!isturf(NT) || (NT in found) || (NT in pending))
					continue
				if(!get_new_area_type(NT.loc) == 1) //The contains somewhere that is NOT a buildable area.
					return 3 //NOT A BUILDABLE AREA

				if(SSair.air_blocked(T, NT)) //Is the room airtight?
					// Okay thats the edge of the room
					if(get_new_area_type(NT.loc) == 1 && SSair.air_blocked(NT, NT))
						found += NT // So we include walls/doors not already in any area
					continue
				if (istype(NT, /turf/space))
					return 2 //SPACE
				if (istype(NT, /turf/simulated/shuttle))
					return 2 //SPACE
				if (NT.loc != first.loc && !(get_new_area_type(NT.loc) & 1))
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
	else
		return 3

/proc/create_new_area(mob/creator) //Heavily simplified version of the blueprint version.
	var/res = detect_new_area(get_turf(creator), creator)
	if(!res)
		to_chat(creator, span_warning("Something went wrong."))
		return

	if(!istype(res,/list))
		switch(res)
			if(1)
				to_chat(creator, span_warning("The new area too large! You can only have an area that is up to 70 tiles."))
				return
			if(2)
				to_chat(creator, span_warning("The new area must be completely airtight and not be part of a shuttle!"))
				return
			if(3)
				to_chat(creator, span_warning("There is an area not permitted to be built in somewhere in the room!"))
				return
			else
				to_chat(creator, span_warning("Error! Please notify administration!"))
				return
	var/list/turf/turfs = res

	var/area/newA								//The new area
	var/area/oldA = get_area(get_turf(creator))	//The old area (area currently standing in)
	var/str										//What the new area is named.

	var/list/nearby_turfs_to_check = detect_room(get_turf(creator), area_or_turf_fail_types, 70) //Get the nearby areas.

	if(!nearby_turfs_to_check)
		to_chat(creator, span_warning("The new area must have a floor and not a part of a shuttle."))
		return
	if(length(turfs) > 70) //Sanity
		to_chat(creator, span_warning("The room you're in is too big. It can only be 70 tiles in size, excluding walls."))
		return

	//They can select an area they want to turn their current area into.
	str = sanitizeSafe(tgui_input_text(usr, "What would you like to name the area?", "Area Name", null, MAX_NAME_LEN), MAX_NAME_LEN)
	if(isnull(str)) //They pressed cancel.
		to_chat(creator, span_warning("No new area made. Cancelling."))
		return
	if(!str || !length(str)) //sanity
		to_chat(creator, span_warning("No new area made. Cancelling."))
		return
	if(length(str) > MAX_NAME_LEN)
		to_chat(creator, span_warning("Name too long."))
		return
	for(var/area/A in world) //Check to make sure we're not making a duplicate name. Sanity.
		if(A.name == str)
			to_chat(creator, span_warning("An area in the world alreay has this name."))
			return
	newA = new /area
	newA.setup(str)
	newA.has_gravity = oldA.has_gravity
	newA.setup(str)

	for(var/i in 1 to length(turfs)) //Fix lighting. Praise the lord.
		var/turf/thing = turfs[i]
		newA.contents += thing
		thing.change_area(oldA, newA)

	move_turfs_to_area(turfs, newA)
	newA.has_gravity = oldA.has_gravity
	set_area_machinery(newA, newA.name, oldA.name)
	oldA.power_check() //Simply makes the area turn the power off if you nicked an APC from it.
	to_chat(creator, span_notice("You have created a new area, named [newA.name]. It is now weather proof, and constructing an APC will allow it to be powered."))
	message_admins("[key_name(creator, creator.client)] just made a new area called [newA.name] ](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[creator]'>?</A>) at ([creator.x],[creator.y],[creator.z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[creator.x];Y=[creator.y];Z=[creator.z]'>JMP</a>)",0,1)
	log_game("[key_name(creator, creator.client)] just made a new area called [newA.name]")

	return


#undef BP_MAX_ROOM_SIZE
