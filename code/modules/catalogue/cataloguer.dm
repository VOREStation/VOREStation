GLOBAL_LIST_EMPTY(all_cataloguers)

/*
	This is a special scanner which exists to give explorers something to do besides shoot things.
	The scanner is able to be used on certain things in the world, and after a variable delay, the scan finishes,
	giving the person who scanned it some fluff and information about what they just scanned,
	as well as points that currently do nothing but measure epeen,
	and will be used as currency in The Future(tm) to buy things explorers care about.

	Scanning hostile mobs and objects is tricky since only mobs that are alive are scannable, so scanning
	them requires careful position to stay out of harms way until the scan finishes. That is why
	the person with the scanner gets a visual box that shows where they are allowed to move to
	without inturrupting the scan.
*/
/obj/item/cataloguer
	name = "cataloguer"
	desc = "A hand-held device, used for compiling information about an object by scanning it. Alt+click to highlight scannable objects around you."
	description_info = "This is a special device used to obtain information about objects and entities in the environment. \
	To scan something, click on it with the scanner at a distance. \
	Scanning something requires remaining within a certain radius of the object for a specific period of time, until the \
	scan is finished. If the scan is inturrupted, it can be resumed from where it was left off, if the same thing is \
	scanned again."
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	icon_state = "cataloguer"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 3, TECH_MAGNET = 3)
	force = 0
	slot_flags = SLOT_BELT
	var/points_stored = 0 // Amount of 'exploration points' this device holds.
	var/scan_range = 3 // How many tiles away it can scan. Changing this also changes the box size.
	var/credit_sharing_range = 14 // If another person is within this radius, they will also be credited with a successful scan.
	var/datum/category_item/catalogue/displayed_data = null // Used for viewing a piece of data in the UI.
	var/busy = FALSE // Set to true when scanning, to stop multiple scans.
	var/debug = FALSE // If true, can view all catalogue data defined, regardless of unlock status.
	var/weakref/partial_scanned = null // Weakref of the thing that was last scanned if inturrupted. Used to allow for partial scans to be resumed.
	var/partial_scan_time = 0 // How much to make the next scan shorter.

/obj/item/cataloguer/advanced
	name = "advanced cataloguer"
	icon_state = "adv_cataloguer"
	desc = "A hand-held device, used for compiling information about an object by scanning it. This one is an upgraded model, \
	with a scanner that both can scan from farther away, and with less time."
	scan_range = 4
	toolspeed = 0.8

// Able to see all defined catalogue data regardless of if it was unlocked, intended for testing.
/obj/item/cataloguer/debug
	name = "omniscient cataloguer"
	desc = "A hand-held cataloguer device that appears to be plated with gold. For some reason, it \
	just seems to already know everything about narrowly defined pieces of knowledge one would find \
	from nearby, perhaps due to being colored gold. Truly a epistemological mystery."
	icon_state = "debug_cataloguer"
	toolspeed = 0.1
	scan_range = 7
	debug = TRUE


/obj/item/cataloguer/Initialize()
	GLOB.all_cataloguers += src
	return ..()

/obj/item/cataloguer/Destroy()
	GLOB.all_cataloguers -= src
	displayed_data = null
	return ..()

/obj/item/cataloguer/update_icon()
	if(busy)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)

/obj/item/cataloguer/afterattack(atom/target, mob/user, proximity_flag)
	// Things that invalidate the scan immediately.
	if(busy)
		to_chat(user, span("warning", "\The [src] is already scanning something."))
		return

	if(isturf(target) && (!target.can_catalogue()))
		var/turf/T = target
		for(var/atom/A as anything in T) // If we can't scan the turf, see if we can scan anything on it, to help with aiming.
			if(A.can_catalogue())
				target = A
				break

	if(!target.can_catalogue(user)) // This will tell the user what is wrong.
		return

	if(get_dist(target, user) > scan_range)
		to_chat(user, span("warning", "You are too far away from \the [target] to catalogue it. Get closer."))
		return

	// Get how long the delay will be.
	var/scan_delay = target.get_catalogue_delay() * toolspeed
	if(partial_scanned)
		if(partial_scanned.resolve() == target)
			scan_delay -= partial_scan_time
			to_chat(user, span("notice", "Resuming previous scan."))
		else
			to_chat(user, span("warning", "Scanning new target. Previous scan buffer cleared."))

	// Start the special effects.
	busy = TRUE
	update_icon()
	var/datum/beam/scan_beam = user.Beam(target, icon_state = "rped_upgrade", time = scan_delay)
	var/filter = filter(type = "outline", size = 1, color = "#FFFFFF")
	target.filters += filter
	var/list/box_segments = list()
	if(user.client)
		box_segments = draw_box(target, scan_range, user.client)
		color_box(box_segments, "#00FF00", scan_delay)

	playsound(src, 'sound/machines/beep.ogg', 50)

	// The delay, and test for if the scan succeeds or not.
	var/scan_start_time = world.time
	if(do_after(user, scan_delay, target, ignore_movement = TRUE, max_distance = scan_range))
		if(target.can_catalogue(user))
			to_chat(user, span("notice", "You successfully scan \the [target] with \the [src]."))
			playsound(src, 'sound/machines/ping.ogg', 50)
			catalogue_object(target, user)
		else
			// In case someone else scans it first, or it died, etc.
			to_chat(user, span("warning", "\The [target] is no longer valid to scan with \the [src]."))
			playsound(src, 'sound/machines/buzz-two.ogg', 50)

		partial_scanned = null
		partial_scan_time = 0
	else
		to_chat(user, span("warning", "You failed to finish scanning \the [target] with \the [src]."))
		playsound(src, 'sound/machines/buzz-two.ogg', 50)
		color_box(box_segments, "#FF0000", 3)
		partial_scanned = weakref(target)
		partial_scan_time += world.time - scan_start_time // This is added to the existing value so two partial scans will add up correctly.
		sleep(3)
	busy = FALSE

	// Now clean up the effects.
	update_icon()
	QDEL_NULL(scan_beam)
	if(target)
		target.filters -= filter
	if(user.client) // If for some reason they logged out mid-scan the box will be gone anyways.
		delete_box(box_segments, user.client)

// Todo: Display scanned information, increment points, etc.
/obj/item/cataloguer/proc/catalogue_object(atom/target, mob/living/user)
	// Figure out who may have helped out.
	var/list/contributers = list()
	var/list/contributer_names = list()
	for(var/mob/living/L as anything in player_list)
		if(L == user)
			continue
		if(!istype(L))
			continue
		if(get_dist(L, user) <= credit_sharing_range)
			contributers += L
			contributer_names += L.name

	var/points_gained = 0

	// Discover each datum available.
	var/list/object_data = target.get_catalogue_data()
	if(LAZYLEN(object_data))
		for(var/data_type in object_data)
			var/datum/category_item/catalogue/I = GLOB.catalogue_data.resolve_item(data_type)
			if(istype(I))
				var/list/discoveries = I.discover(user, list(user.name) + contributer_names) // If one discovery leads to another, the list returned will have all of them.
				if(LAZYLEN(discoveries))
					for(var/datum/category_item/catalogue/data as anything in discoveries)
						points_gained += data.value

	// Give out points.
	if(points_gained)
		// First, to us.
		to_chat(user, span("notice", "Gained [points_gained] points from this scan."))
		adjust_points(points_gained)

		// Now to our friends, if any.
		if(contributers.len)
			for(var/mob/M in contributers)
				var/list/things = M.GetAllContents(3) // Depth of two should reach into bags but just in case lets make it three.
				var/obj/item/cataloguer/other_cataloguer = locate() in things // If someone has two or more scanners this only adds points to one.
				if(other_cataloguer)
					to_chat(M, span("notice", "Gained [points_gained] points from \the [user]'s scan of \the [target]."))
					other_cataloguer.adjust_points(points_gained)
			to_chat(user, span("notice", "Shared discovery with [contributers.len] other contributer\s."))




/obj/item/cataloguer/AltClick(mob/user)
	pulse_scan(user)

// Gives everything capable of being scanned an outline for a brief moment.
// Helps to avoid having to click a hundred things in a room for things that have an entry.
/obj/item/cataloguer/proc/pulse_scan(mob/user)
	if(busy)
		to_chat(user, span("warning", "\The [src] is busy doing something else."))
		return

	busy = TRUE
	update_icon()
	playsound(src, 'sound/machines/beep.ogg', 50)

	// First, get everything able to be scanned.
	var/list/scannable_atoms = list()
	for(var/atom/A as anything in view(world.view, user))
		if(A.can_catalogue()) // Not passing the user is intentional, so they don't get spammed.
			scannable_atoms += A

	// Highlight things able to be scanned.
	var/filter = filter(type = "outline", size = 1, color = "#00FF00")
	for(var/atom/A as anything in scannable_atoms)
		A.filters += filter
	to_chat(user, span("notice", "\The [src] is highlighting scannable objects in green, if any exist."))

	sleep(2 SECONDS)

	// Remove the highlights.
	for(var/atom/A as anything in scannable_atoms)
		if(QDELETED(A))
			continue
		A.filters -= filter

	busy = FALSE
	update_icon()
	if(scannable_atoms.len)
		playsound(src, 'sound/machines/ping.ogg', 50)
	else
		playsound(src, 'sound/machines/buzz-two.ogg', 50)
	to_chat(user, span("notice", "\The [src] found [scannable_atoms.len] object\s that can be scanned."))


// Negative points are bad.
/obj/item/cataloguer/proc/adjust_points(amount)
	points_stored = max(0, points_stored += amount)

/obj/item/cataloguer/attack_self(mob/living/user)
	interact(user)

/obj/item/cataloguer/interact(mob/user)
	var/list/dat = list()
	var/title = "Cataloguer Data Display"

	// Important buttons go on top since the scrollbar will default to the top of the window.
	dat += "Contains <b>[points_stored]</b> Exploration Points."
	dat += "<a href='?src=\ref[src];pulse_scan=1'>\[Highlight Scannables\]</a><a href='?src=\ref[src];refresh=1'>\[Refresh\]</a><a href='?src=\ref[src];close=1'>\[Close\]</a>"

	// If displayed_data exists, we show that, otherwise we show a list of all data in the mysterious global list.
	if(displayed_data)
		title = uppertext(displayed_data.name)

		dat += "<a href='?src=\ref[src];show_data=null'>\[Back to List\]</a>"
		if(debug && !displayed_data.visible)
			dat += "<a href='?src=\ref[src];debug_unlock=\ref[displayed_data]'>\[(DEBUG) Force Discovery\]</a>"
		dat += "<hr>"

		dat += "<i>[displayed_data.desc]</i>"
		if(LAZYLEN(displayed_data.cataloguers))
			dat += "Cataloguers : <b>[english_list(displayed_data.cataloguers)]</b>."
		else
			dat += "Catalogued by nobody."
		dat += "Worth <b>[displayed_data.value]</b> exploration points."

	else
		dat += "<hr>"
		for(var/datum/category_group/group as anything in GLOB.catalogue_data.categories)
			var/list/group_dat = list()
			var/show_group = FALSE

			group_dat += "<b>[group.name]</b>"
			for(var/datum/category_item/catalogue/item as anything in group.items)
				if(item.visible || debug)
					group_dat += "<a href='?src=\ref[src];show_data=\ref[item]'>[item.name]</a>"
					show_group = TRUE

			if(show_group || debug) // Avoid showing 'empty' groups on regular cataloguers.
				dat += group_dat

	var/datum/browser/popup = new(user, "cataloguer_display_\ref[src]", title, 500, 600, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()
	add_fingerprint(user)

/obj/item/cataloguer/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=cataloguer_display")
		return 0
	if(href_list["close"] )
		usr << browse(null, "window=cataloguer_display")
		return 0

	if(href_list["show_data"])
		displayed_data = locate(href_list["show_data"])

	if(href_list["pulse_scan"])
		pulse_scan(usr)
		return // Don't refresh the window for this or it will open it back if its closed during the highlighting.

	if(href_list["debug_unlock"] && debug)
		var/datum/category_item/catalogue/item = locate(href_list["debug_unlock"])
		item.discover(usr, list("Debugger"))

	interact(usr) // So it refreshes the window.
	return 1

/obj/item/cataloguer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) && !busy)
		busy = TRUE
		var/obj/item/card/id/ID = W
		if(points_stored)
			ID.survey_points += points_stored
			points_stored = 0
			to_chat(user, "<span class='notice'>You swipe the id over \the [src].</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] has no points available.</span>")
		busy = FALSE
	return ..()
