/atom
	layer = TURF_LAYER //This was here when I got here. Why though?
	var/level = 2
	var/flags = 0
	var/was_bloodied
	var/blood_color
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = TRUE //filter for actions - used by lighting overlays
	var/atom_say_verb = "says"
	var/bubble_icon = "normal" ///what icon the atom uses for speechbubbles
	var/datum/forensics_crime/forensic_data
	var/fluorescent // Shows up under a UV light.

	var/last_bumped = 0

	///Chemistry.
	var/datum/reagents/reagents = null

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	// Overlays
	///Our local copy of (non-priority) overlays without byond magic. Use procs in SSoverlays to manipulate
	var/list/our_overlays
	///Overlays that should remain on top and not normally removed when using cut_overlay functions, like c4.
	var/list/priority_overlays
	///vis overlays managed by SSvis_overlays to automaticaly turn them like other overlays
	var/list/managed_vis_overlays

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom
	// Track if we are already had initialize() called to prevent double-initialization.
	//var/initialized = FALSE // using the atom flags

	/// Last name used to calculate a color for the chatmessage overlays
	var/chat_color_name
	/// Last color calculated for the the chatmessage overlays
	var/chat_color
	/// A luminescence-shifted value of the last color calculated for chatmessage overlays
	var/chat_color_darkened
	/// The chat color var, without alpha.
	var/chat_color_hover
	//! Colors
	/**
	 * used to store the different colors on an atom
	 *
	 * its inherent color, the colored paint applied on it, special color effect etc...
	 */
	var/list/atom_colours
	/// Lazylist of all images to update when we change z levels
	/// You will need to manage adding/removing from this yourself, but I'll do the updating for you
	var/list/image/update_on_z

/atom/Destroy()
	if(reagents)
		QDEL_NULL(reagents)
	if(light)
		QDEL_NULL(light)
	if(forensic_data)
		QDEL_NULL(forensic_data)
	return ..()

/atom/proc/reveal_blood()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

//return flags that should be added to the viewer's sight var.
//Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (isAI(user)) // WHYYYY
		return 0
	return -1

/atom/proc/Bumped(AM as mob|obj)
	set waitfor = FALSE

	SEND_SIGNAL(src, COMSIG_ATOM_BUMPED, AM)

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

// Used to be for the PROXMOVE flag, but that was terrible, so instead it's just here as a stub for
// all the atoms that still have the proc, but get events other ways.
/atom/proc/HasProximity(turf/T, datum/weakref/WF, old_loc)
	SIGNAL_HANDLER
	return

//Register listeners on turfs in a certain range
/atom/proc/sense_proximity(var/range = 1, var/callback)
	ASSERT(callback)
	ASSERT(isturf(loc))
	var/list/turfs = trange(range, src)
	for(var/turf/T as anything in turfs)
		RegisterSignal(T, COMSIG_OBSERVER_TURF_ENTERED, callback)

//Unregister from prox listening in a certain range. You should do this BEFORE you move, but if you
// really can't, then you can set the center where you moved from.
/atom/proc/unsense_proximity(var/range = 1, var/callback, var/center)
	ASSERT(isturf(center) || isturf(loc))
	var/list/turfs = trange(range, center ? center : src)
	for(var/turf/T as anything in turfs)
		UnregisterSignal(T, COMSIG_OBSERVER_TURF_ENTERED)


/atom/proc/emp_act(var/severity)
	return

/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	if(SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, P, def_zone) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return

	P.on_hit(src, 0, def_zone)
	. = 0

// Called when a blob expands onto the tile the atom occupies.
/atom/proc/blob_act()
	return

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

/atom/proc/get_examine_desc()
	return desc

//All atoms
/atom/proc/examine(mob/user, var/infix = "", var/suffix = "")
	SHOULD_CALL_PARENT(TRUE)
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src][infix]."
	if(forensic_data?.has_blooddna() && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		if(blood_color != SYNTH_BLOOD_COLOUR)
			f_name += "[span_danger("blood-stained")] [name][infix]!"
		else
			f_name += "oil-stained [name][infix]."

	var/borg = "" // Borg grippers say if the item can be gripped
	if(isrobot(user) && isitem(src))
		borg = "None of your grippers can hold this."
		var/mob/living/silicon/robot/R = user
		if(R.module?.modules)
			for(var/obj/item/gripper/G in R.module.modules)
				if(is_type_in_list(src,G.can_hold))
					borg = span_boldnotice("\The [G]") + span_notice(" can hold this.")
					break

	var/examine_text = replacetext(get_examine_desc(), "||", "")
	var/list/output = list("[icon2html(src,user.client)] That's [f_name] [suffix] [borg]", examine_text)

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, output)
	return output

// Don't make these call bicon or anything, these are what bicon uses. They need to return an icon.
/atom/proc/examine_icon()
	return src // 99% of the time just returning src will be sufficient. More complex examine icon things are available where they are needed

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-changes
/atom/proc/set_dir(new_dir)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, new_dir)
	. = new_dir != dir
	dir = new_dir

// Called to set the atom's density and used to add behavior to density changes.
/atom/proc/set_density(var/new_density)
	if(density == new_density)
		return FALSE
	density = !!new_density // Sanitize to be strictly 0 or 1
	return TRUE

// Called to set the atom's invisibility and usd to add behavior to invisibility changes.
/atom/proc/set_invisibility(var/new_invisibility)
	if(invisibility == new_invisibility)
		return FALSE
	invisibility = new_invisibility
	return TRUE

/atom/proc/ex_act(var/strength = 3)
	return (SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, strength, src) & COMPONENT_IGNORE_EXPLOSION)

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return -1

/atom/proc/fire_act()
	return


// Returns an assoc list of RCD information.
// Example would be: list(RCD_VALUE_MODE = RCD_DECONSTRUCT, RCD_VALUE_DELAY = 50, RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 4)
// This occurs before rcd_act() is called, and it won't be called if it returns FALSE.
/atom/proc/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/atom/proc/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return

/atom/proc/occult_act(mob/living/user)
	return

/atom/proc/melt()
	return

// Previously this was defined both on /obj/ and /turf/ seperately.  And that's bad.
/atom/proc/update_icon()
	return


/atom/proc/hitby(atom/movable/AM as mob|obj)
	if (density)
		AM.throwing = 0
	return

//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)

	if(flags & NOBLOODY)
		return 0

	was_bloodied = TRUE
	if(!blood_color)
		blood_color = "#A10808"
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		blood_color = M.species.get_blood_colour(M)
	. = 1
	return 1

/atom/proc/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	wash(CLEAN_WASH)
	R.reagents.splash(src, 1)

/atom/proc/get_global_map_pos()
	if(!islist(GLOB.global_map) || isemptylist(GLOB.global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x = 1, cur_x <= GLOB.global_map.len, cur_x++)
		y_arr = GLOB.global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	to_world("X = [cur_x]; Y = [cur_y]")
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return (pass_flags&passflag)

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0

// Show a message to all mobs and objects in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(var/message, var/blind_message, var/list/exclude_mobs, var/range = world.view, var/runemessage = "<span style='font-size: 1.5em'>👁</span>")

	//VOREStation Edit
	var/list/see
	if(isbelly(loc))
		var/obj/belly/B = loc
		see = B.get_mobs_and_objs_in_belly()
	else
		see = get_mobs_and_objs_in_view_fast(get_turf(src), range, remote_ghosts = FALSE)
	//VOREStation Edit End

	var/list/seeing_mobs = see["mobs"]
	var/list/seeing_objs = see["objs"]
	if(LAZYLEN(exclude_mobs))
		seeing_mobs -= exclude_mobs

	for(var/obj/O as anything in seeing_objs)
		O.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
	for(var/mob/M as anything in seeing_mobs)
		if(M.see_invisible >= invisibility && MOB_CAN_SEE_PLANE(M, plane))
			M.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
			if(runemessage != -1)
				M.create_chat_message(src, "[runemessage]", FALSE, list("emote"), audible = FALSE)
		else if(blind_message)
			M.show_message(blind_message, AUDIBLE_MESSAGE)

// Show a message to all mobs and objects in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance, var/radio_message, var/runemessage)

	var/range = hearing_distance || world.view
	var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)

	var/list/hearing_mobs = hear["mobs"]
	var/list/hearing_objs = hear["objs"]

	if(radio_message)
		for(var/obj/O as anything in hearing_objs)
			O.hear_talk(src, list(new /datum/multilingual_say_piece(GLOB.all_languages["Noise"], radio_message)), null)
	else
		for(var/obj/O as anything in hearing_objs)
			O.show_message(message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)

	for(var/mob/M as anything in hearing_mobs)
		var/msg = message
		M.show_message(msg, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
		if(runemessage != -1)
			M.create_chat_message(src, "[runemessage || message]", FALSE, list("emote"))

/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return moveToNullspace()

/atom/proc/onDropInto(var/atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.

/atom/proc/InsertedContents()
	return contents

/atom/proc/get_gravity(turf/T)
	if(!T || !isturf(T))
		T = get_turf(src)
	if(istype(T, /turf/space)) // Turf never has gravity
		return FALSE
	var/area/A = get_area(T)
	if(A && A.get_gravity())
		return TRUE
	return FALSE

/atom/proc/is_incorporeal()
	return FALSE

/atom/proc/drop_location()
	var/atom/L = loc
	if(!L)
		return null
	return L.AllowDrop() ? L : L.drop_location()

/atom/proc/AllowDrop()
	return FALSE

/atom/proc/get_nametag_name(mob/user)
	return name

/atom/proc/get_nametag_desc(mob/user)
	return "" //Desc itself is often too long to use

/atom/proc/atom_say(message)
	if(!message)
		return
	var/list/speech_bubble_hearers = list()
	for(var/mob/M in get_mobs_in_view(7, src))
		M.show_message(span_npc_say(span_name("[src]") + " [atom_say_verb], \"[message]\""), 2, null, 1)
		if(M.client)
			speech_bubble_hearers += M.client

	if(length(speech_bubble_hearers))
		var/image/I = generate_speech_bubble(src, "[bubble_icon][say_test(message)]", FLY_LAYER)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), I, speech_bubble_hearers, 30)

/atom/proc/speech_bubble(bubble_state = "", bubble_loc = src, list/bubble_recipients = list())
	return

/atom/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	SEND_SIGNAL(AM, COMSIG_OBSERVER_MOVED, old_loc, AM.loc)
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, AM, old_loc)
	SEND_SIGNAL(AM, COMSIG_ATOM_ENTERING, src, old_loc)

/atom/Exit(atom/movable/AM, atom/new_loc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_ATOM_EXIT, AM, new_loc) & COMPONENT_ATOM_BLOCK_EXIT)
		return FALSE

/atom/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_EXITED, AM, new_loc)

/atom/proc/get_visible_gender(mob/user, force)
	return gender

/atom/proc/interact(mob/user)
	return

// Purpose: Determines if the object can pass this atom.
// Called by: Movement.
// Inputs: The moving atom, target turf.
// Outputs: Boolean if can pass.
// Airflow and ZAS zones now uses CanZASPass() instead of this proc.
/atom/proc/CanPass(atom/movable/mover, turf/target)
	return !density


//! ## Atom Colour Priority System
/**
 * A System that gives finer control over which atom colour to colour the atom with.
 * The "highest priority" one is always displayed as opposed to the default of
 * "whichever was set last is displayed"
 */

/// Adds an instance of colour_type to the atom's atom_colours list
/atom/proc/add_atom_colour(coloration, colour_priority)
	if(!atom_colours || !atom_colours.len)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(!coloration)
		return
	if(colour_priority > atom_colours.len)
		return
	atom_colours[colour_priority] = coloration
	update_atom_colour()

/// Removes an instance of colour_type from the atom's atom_colours list
/atom/proc/remove_atom_colour(colour_priority, coloration)
	if(!atom_colours)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(colour_priority > atom_colours.len)
		return
	if(coloration && atom_colours[colour_priority] != coloration)
		return //if we don't have the expected color (for a specific priority) to remove, do nothing
	atom_colours[colour_priority] = null
	update_atom_colour()

/// Resets the atom's color to null, and then sets it to the highest priority colour available
/atom/proc/update_atom_colour()
	if(!atom_colours)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	color = null
	for(var/C in atom_colours)
		if(islist(C))
			var/list/L = C
			if(L.len)
				color = L
				return
		else if(C)
			color = C
			return

///Passes Stat Browser Panel clicks to the game and calls client click on an atom
/atom/Topic(href, list/href_list)
	. = ..()
	if(!usr?.client)
		return
	var/client/usr_client = usr.client
	var/list/paramslist = list()

	if(href_list["statpanel_item_click"])
		switch(href_list["statpanel_item_click"])
			if("left")
				paramslist["left"] = "1"
			if("right")
				paramslist["right"] = "1"
			if("middle")
				paramslist["middle"] = "1"
			else
				return

		if(href_list["statpanel_item_shiftclick"])
			paramslist["shift"] = "1"
		if(href_list["statpanel_item_ctrlclick"])
			paramslist["ctrl"] = "1"
		if(href_list["statpanel_item_altclick"])
			paramslist["alt"] = "1"

		var/mouseparams = list2params(paramslist)
		usr_client.Click(src, loc, null, mouseparams)
		return TRUE

GLOBAL_LIST_EMPTY(icon_dimensions)

/atom/proc/get_oversized_icon_offsets()
	if (pixel_x == 0 && pixel_y == 0)
		return list("x" = 0, "y" = 0)
	var/list/icon_dimensions = get_icon_dimensions(icon)
	var/icon_width = icon_dimensions["width"]
	var/icon_height = icon_dimensions["height"]
	return list(
		"x" = icon_width > world.icon_size && pixel_x != 0 ? (icon_width - world.icon_size) * 0.5 : 0,
		"y" = icon_height > world.icon_size /*&& pixel_y != 0*/ ? (icon_height - world.icon_size) * 0.5 : 0, // we don't have pixel_y in use
	)

/// Returns a list containing the width and height of an icon file
/proc/get_icon_dimensions(icon_path)
	// Icons can be a real file(), a rsc backed file(), a dynamic rsc (dyn.rsc) reference (known as a cache reference in byond docs), or an /icon which is pointing to one of those.
	// Runtime generated dynamic icons are an unbounded concept cache identity wise, the same icon can exist millions of ways and holding them in a list as a key can lead to unbounded memory usage if called often by consumers.
	// Check distinctly that this is something that has this unspecified concept, and thus that we should not cache.
	if (!isfile(icon_path) || !length("[icon_path]"))
		var/icon/my_icon = icon(icon_path)
		return list("width" = my_icon.Width(), "height" = my_icon.Height())
	if (isnull(GLOB.icon_dimensions[icon_path]))
		var/icon/my_icon = icon(icon_path)
		GLOB.icon_dimensions[icon_path] = list("width" = my_icon.Width(), "height" = my_icon.Height())
	return GLOB.icon_dimensions[icon_path]

/// Returns the src and all recursive contents as a list.
/atom/proc/get_all_contents(ignore_flag_1)
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		if(checked_atom.flags & ignore_flag_1)
			continue
		. += checked_atom.contents

/// Identical to get_all_contents but returns a list of atoms of the type passed in the argument.
/atom/proc/get_all_contents_type(type)
	var/list/processing_list = list(src)
	. = list()
	while(length(processing_list))
		var/atom/checked_atom = processing_list[1]
		processing_list.Cut(1, 2)
		processing_list += checked_atom.contents
		if(istype(checked_atom, type))
			. += checked_atom

/**
*	Respond to our atom being checked by a virus extrapolator.
*
*	Default behaviour is to send COMSIG_ATOM_EXTRAPOLATOR_ACT and return an empty list (which may be populated by the signal)
*
*	Returns a list of viruses in the atom.
*	Include EXTRAPOLATOR_SPECIAL_HANDLED in the list if the extrapolation act has been handled by this proc or a signal, and should not be handled by the extrapolator itself.
*/
/atom/proc/extrapolator_act(mob/living/user, obj/item/extrapolator/extrapolator, dry_run = FALSE)
	. = list(EXTRAPOLATOR_RESULT_DISEASES = list())
	SEND_SIGNAL(src, COMSIG_ATOM_EXTRAPOLATOR_ACT, user, extrapolator, dry_run, .)

/**
*	Wash this atom
*
*	This will clean it off any temporary stuff like blood. Override this in your item to add custom cleaning behavior.
*	Returns true if any washing was necessary and thus performed
*	Arguments:
*	clean_types: any of the CLEAN_ constants
*/
/atom/proc/wash(clean_types)
	SHOULD_CALL_PARENT(TRUE)

	. = FALSE
	if(SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, clean_types))
		. = TRUE

	// Basically "if has washable coloration"
	if(length(atom_colours) >= WASHABLE_COLOUR_PRIORITY && atom_colours[WASHABLE_COLOUR_PRIORITY])
		remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
		return TRUE

	forensic_data?.wash(clean_types)
	blood_color = null
	germ_level = 0
	fluorescent = 0
