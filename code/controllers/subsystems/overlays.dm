<<<<<<< HEAD
SUBSYSTEM_DEF(overlays)
	name = "Overlay"
	flags = SS_TICKER
	wait = 1
	priority = FIRE_PRIORITY_OVERLAYS
	init_order = INIT_ORDER_OVERLAY

	var/list/queue						// Queue of atoms needing overlay compiling (TODO-VERIFY!)
	var/list/stats
	var/list/overlay_icon_state_caches	// Cache thing
	var/list/overlay_icon_cache			// Cache thing

	var/static/image/stringbro
	var/static/image/iconbro
	var/static/image/appearance_bro

/datum/controller/subsystem/overlays/PreInit()
	overlay_icon_state_caches = list()
	overlay_icon_cache = list()
	queue = list()
	stats = list()

	stringbro = new()
	iconbro = new()
	appearance_bro = new()

/datum/controller/subsystem/overlays/Initialize()
	fire(mc_check = FALSE)
	..()

/datum/controller/subsystem/overlays/stat_entry()
	..("Ov:[length(queue)]")


/datum/controller/subsystem/overlays/Shutdown()
	text2file(render_stats(stats), "[log_path]-overlay.log")

/datum/controller/subsystem/overlays/Recover()
	overlay_icon_state_caches = SSoverlays.overlay_icon_state_caches
	overlay_icon_cache = SSoverlays.overlay_icon_cache
	queue = SSoverlays.queue


/datum/controller/subsystem/overlays/fire(resumed = FALSE, mc_check = TRUE)
	var/list/queue = src.queue
	var/static/count = 0
	if (count)
		var/c = count
		count = 0 //so if we runtime on the Cut, we don't try again.
		queue.Cut(1,c+1)

	for (var/thing in queue)
		count++
		if(thing)
			STAT_START_STOPWATCH
			var/atom/A = thing
			COMPILE_OVERLAYS(A)
			STAT_STOP_STOPWATCH
			STAT_LOG_ENTRY(stats, A.type)
		if(mc_check)
			if(MC_TICK_CHECK)
				break
		else
			CHECK_TICK

	if (count)
		queue.Cut(1,count+1)
		count = 0

/proc/iconstate2appearance(icon, iconstate)
	// var/static/image/stringbro = new() // Moved to be superglobal due to BYOND insane init order stupidness.
	var/list/icon_states_cache = SSoverlays.overlay_icon_state_caches
	var/list/cached_icon = icon_states_cache[icon]
	if (cached_icon)
		var/cached_appearance = cached_icon["[iconstate]"]
		if (cached_appearance)
			return cached_appearance
	SSoverlays.stringbro.icon = icon
	SSoverlays.stringbro.icon_state = iconstate
	if (!cached_icon) //not using the macro to save an associated lookup
		cached_icon = list()
		icon_states_cache[icon] = cached_icon
	var/cached_appearance = SSoverlays.stringbro.appearance
	cached_icon["[iconstate]"] = cached_appearance
	return cached_appearance

/proc/icon2appearance(icon)
	// var/static/image/iconbro = new() // Moved to be superglobal due to BYOND insane init order stupidness.
	var/list/icon_cache = SSoverlays.overlay_icon_cache
	. = icon_cache[icon]
	if (!.)
		SSoverlays.iconbro.icon = icon
		. = SSoverlays.iconbro.appearance
		icon_cache[icon] = .

/atom/proc/build_appearance_list(old_overlays)
	// var/static/image/appearance_bro = new() // Moved to be superglobal due to BYOND insane init order stupidness.
	var/list/new_overlays = list()
	if (!islist(old_overlays))
		old_overlays = list(old_overlays)
	for (var/overlay in old_overlays)
		if(!overlay)
			continue
		if (istext(overlay))
			new_overlays += iconstate2appearance(icon, overlay)
		else if(isicon(overlay))
			new_overlays += icon2appearance(overlay)
		else
			if(isloc(overlay))
				var/atom/A = overlay
				if (A.flags & OVERLAY_QUEUED)
					COMPILE_OVERLAYS(A)
			SSoverlays.appearance_bro.appearance = overlay //this works for images and atoms too!
			if(!ispath(overlay))
				var/image/I = overlay
				SSoverlays.appearance_bro.dir = I.dir
			new_overlays += SSoverlays.appearance_bro.appearance
	return new_overlays

#define NOT_QUEUED_ALREADY (!(flags & OVERLAY_QUEUED))
#define QUEUE_FOR_COMPILE flags |= OVERLAY_QUEUED; SSoverlays.queue += src;

/**
 * Cut all of atom's normal overlays.  Usually leaves "priority" overlays untouched.
 *
 *  @param priority If true, also will cut priority overlays.
 */
/atom/proc/cut_overlays(priority = FALSE)
	var/list/cached_overlays = our_overlays
	var/list/cached_priority = priority_overlays

	var/need_compile = FALSE

	if(LAZYLEN(cached_overlays)) //don't queue empty lists, don't cut priority overlays
		cached_overlays.Cut()  //clear regular overlays
		need_compile = TRUE

	if(priority && LAZYLEN(cached_priority))
		cached_priority.Cut()
		need_compile = TRUE

	if(NOT_QUEUED_ALREADY && need_compile)
		QUEUE_FOR_COMPILE

/**
 * Removes specific overlay(s) from the atom.  Usually does not remove them from "priority" overlays.
 *
 * @param overlays The overlays to removed, type can be anything that is allowed for add_overlay().
 * @param priority If true, also will remove them from the "priority" overlays.
 */
/atom/proc/cut_overlay(list/overlays, priority)
	if(!overlays)
		return

	overlays = build_appearance_list(overlays)

	var/list/cached_overlays = our_overlays	//sanic
	var/list/cached_priority = priority_overlays
	var/init_o_len = LAZYLEN(cached_overlays)
	var/init_p_len = LAZYLEN(cached_priority)  //starter pokemon

	LAZYREMOVE(cached_overlays, overlays)
	if(priority)
		LAZYREMOVE(cached_priority, overlays)

	if(NOT_QUEUED_ALREADY && ((init_o_len != LAZYLEN(cached_overlays)) || (init_p_len != LAZYLEN(cached_priority))))
		QUEUE_FOR_COMPILE

/**
 * Adds specific overlay(s) to the atom.
 * It is designed so any of the types allowed to be added to /atom/overlays can be added here too. More details below.
 *
 * @param overlays The overlay(s) to add.  These may be
 *	- A string: In which case it is treated as an icon_state of the atom's icon.
 *	- An icon: It is treated as an icon.
 *	- An atom: Its own overlays are compiled and then it's appearance is added. (Meaning its current apperance is frozen).
 *	- An image: Image's apperance is added (i.e. subsequently editing the image will not edit the overlay)
 *	- A type path: Added to overlays as is.  Does whatever it is BYOND does when you add paths to overlays.
 *	- Or a list containing any of the above.
 * @param priority The overlays are added to the "priority" list istead of the normal one.
 */
/atom/proc/add_overlay(list/overlays, priority = FALSE)
	if(!overlays)
		return

	overlays = build_appearance_list(overlays)

	LAZYINITLIST(our_overlays)	//always initialized after this point
	LAZYINITLIST(priority_overlays)

	var/list/cached_overlays = our_overlays	//sanic
	var/list/cached_priority = priority_overlays
	var/init_o_len = cached_overlays.len
	var/init_p_len = cached_priority.len  //starter pokemon
	var/need_compile

	if(priority)
		cached_priority += overlays  //or in the image. Can we use [image] = image?
		need_compile = init_p_len != cached_priority.len
	else
		cached_overlays += overlays
		need_compile = init_o_len != cached_overlays.len

	if(NOT_QUEUED_ALREADY && need_compile) //have we caught more pokemon?
		QUEUE_FOR_COMPILE

/**
 * Copy the overlays from another atom, either replacing all of ours or appending to our existing overlays.
 * Note: This copies only the normal overlays, not the "priority" overlays.
 *
 * @param other The atom to copy overlays from.
 * @param cut_old If true, all of our overlays will be *replaced* by the other's. If other is null, that means cutting all ours.
 */
/atom/proc/copy_overlays(atom/other, cut_old)	//copys our_overlays from another atom
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if(cut_old || !LAZYLEN(our_overlays))
			our_overlays = cached_other.Copy()
		else
			our_overlays |= cached_other
		if(NOT_QUEUED_ALREADY)
			QUEUE_FOR_COMPILE
	else if(cut_old)
		cut_overlays()

/**
 * Returns a list of overlays that the target atom has
 *
 * @param priority If true, returns priority overlays as well
 * @param special If true, returns special overlays like emissives and em_blockers
 */
/proc/get_overlays(atom/other, priority, special)
	var/list/including = list()
	if(!other)
		return including

	for(var/image/I as anything in other.our_overlays)
		if(!special && I.plane > 0)
			continue
		including += I
	
	if(!priority)
		return including
	
	for(var/image/I as anything in other.priority_overlays)
		if(!special && I.plane > 0)
			continue
		including += I
	
	return including

#undef NOT_QUEUED_ALREADY
#undef QUEUE_FOR_COMPILE

//TODO: Better solution for these?
/image/proc/add_overlay(x)
	overlays += x

/image/proc/cut_overlay(x)
	overlays -= x

/image/proc/cut_overlays(x)
	overlays.Cut()

/image/proc/copy_overlays(atom/other, cut_old)
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if(cut_old || !overlays.len)
			overlays = cached_other.Copy()
		else
			overlays |= cached_other
	else if(cut_old)
		cut_overlays()
=======
SUBSYSTEM_DEF(overlays)
	name = "Overlay"
	flags = SS_TICKER
	wait = 1 // SS_TICKER - Ticks
	priority = FIRE_PRIORITY_OVERLAYS
	init_order = INIT_ORDER_OVERLAY

	/// The queue of atoms that need overlay updates.
	var/static/tmp/list/queue = list()

	/// A list([icon] = list([state] = [appearance], ...), ...) cache of appearances.
	var/static/tmp/list/state_cache = list()

	/// A list([icon] = [appearance], ...) cache of appearances.
	var/static/tmp/list/icon_cache = list()

	/// The number of appearances currently cached.
	var/static/tmp/cache_size = 0


/datum/controller/subsystem/overlays/Recover()
	queue.Cut()
	state_cache.Cut()
	icon_cache.Cut()
	cache_size = 0
	for (var/atom/atom)
		atom.flags &= ~OVERLAY_QUEUED
		CHECK_TICK


/datum/controller/subsystem/overlays/Initialize(timeofday)
	fire(FALSE, TRUE)


/datum/controller/subsystem/overlays/stat_entry()
	..("Queued Atoms: [queue.len], Cache Size: [cache_size]")


/datum/controller/subsystem/overlays/fire(resumed, no_mc_tick)
	var/count = 1
	for (var/atom/atom as anything in queue)
		++count
		atom?.UpdateOverlays()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, count)
			return
	queue.Cut()


/datum/controller/subsystem/overlays/proc/GetStateAppearance(icon, state)
	var/list/subcache = state_cache[icon]
	if (!subcache)
		subcache = list()
		state_cache[icon] = subcache
	if (!subcache[state])
		var/image/image = new (icon, null, state)
		subcache[state] = image.appearance
		++cache_size
	return subcache[state]


/datum/controller/subsystem/overlays/proc/GetIconAppearance(icon)
	if (!icon_cache[icon])
		var/image/image = new (icon)
		icon_cache[icon] = image.appearance
		++cache_size
	return icon_cache[icon]


/datum/controller/subsystem/overlays/proc/GetAppearanceList(atom/subject, list/sources)
	if (!sources)
		return list()
	if (!islist(sources))
		sources = list(sources)
	var/list/result = list()
	var/icon/icon = subject.icon
	for (var/atom/entry as anything in sources)
		if (!entry)
			continue
		else if (istext(entry))
			result += GetStateAppearance(icon, entry)
		else if (isicon(entry))
			result += GetIconAppearance(entry)
		else
			if (isloc(entry))
				if (entry.flags & OVERLAY_QUEUED)
					entry.ImmediateOverlayUpdate()
			if (!ispath(entry))
				result += entry.appearance
			else
				var/image/image = entry
				result += image.appearance
	return result


/// Enqueues the atom for an overlay update if not already queued
/atom/proc/QueueOverlayUpdate()
	if (flags & OVERLAY_QUEUED)
		return
	SSoverlays.queue += src
	flags |= OVERLAY_QUEUED


/// Builds the atom's overlay state from caches
/atom/proc/UpdateOverlays()
	if (gc_destroyed)
		if (length(overlays))
			overlays.Cut()
		return
	flags &= ~OVERLAY_QUEUED
	if (length(priority_overlays))
		if (length(our_overlays))
			overlays = priority_overlays + our_overlays
		else
			overlays = priority_overlays
	else if (length(our_overlays))
		overlays = our_overlays
	else
		overlays.Cut()


/// Immediately runs an overlay update and dequeues the atom
/atom/proc/ImmediateOverlayUpdate()
	SSoverlays.queue -= src
	UpdateOverlays()


/// Clears the atom's overlay cache(s) and queues an update if needed
/atom/proc/cut_overlays(priority)
	if (priority)
		if (!length(priority_overlays))
			return
		priority_overlays.Cut()
		QueueOverlayUpdate()
	else if (length(our_overlays))
		our_overlays.Cut()
		QueueOverlayUpdate()


/**
 * Adds specific overlay(s) to the atom.
 * It is designed so any of the types allowed to be added to /atom/overlays can be added here too. More details below.
 *
 * @param add The overlay(s) to add.  These may be
 *	- A string: In which case it is treated as an icon_state of the atom's icon.
 *	- An icon: It is treated as an icon.
 *	- An atom: Its own overlays are compiled and then it's appearance is added. (Meaning its current apperance is frozen).
 *	- An image: Image's apperance is added (i.e. subsequently editing the image will not edit the overlay)
 *	- A type path: Added to overlays as is.  Does whatever it is BYOND does when you add paths to overlays.
 *	- Or a list containing any of the above.
 * @param priority The overlays are added to the "priority" list istead of the normal one.
 */
/atom/proc/add_overlay(list/add, priority)
	if (!add)
		return
	add = SSoverlays.GetAppearanceList(src, add)
	if (!length(add))
		return
	if (priority)
		if (priority_overlays)
			priority_overlays += add
		else
			priority_overlays = add
	else if (our_overlays)
		our_overlays += add
	else
		our_overlays = add
	QueueOverlayUpdate()


/**
 * Removes specific overlay(s) from the atom.  Usually does not remove them from "priority" overlays.
 *
 * @param overlays The overlays to removed, type can be anything that is allowed for add_overlay().
 * @param priority If true, also will remove them from the "priority" overlays.
 */
/atom/proc/cut_overlay(list/cut, priority)
	if (!cut)
		return
	cut = SSoverlays.GetAppearanceList(src, cut)
	if (!length(cut))
		return
	var/update
	if (priority && length(priority_overlays))
		priority_overlays -= cut
		update = TRUE
	if (length(our_overlays))
		our_overlays -= cut
		update = TRUE
	if (update)
		QueueOverlayUpdate()


/**
 * Copy the overlays from another atom, either replacing all of ours or appending to our existing overlays.
 * Note: This copies only the normal overlays, not the "priority" overlays.
 *
 * @param other The atom to copy overlays from.
 * @param cut_old If true, all of our overlays will be *replaced* by the other's. If other is null, that means cutting all ours.
 */
/atom/proc/copy_overlays(atom/other, cut)
	if (!other)
		if (cut)
			cut_overlays()
		return
	if (!length(other.our_overlays))
		if (cut)
			cut_overlays()
		return
	if (cut || !length(our_overlays))
		our_overlays = other.our_overlays.Copy()
	else
		our_overlays |= other.our_overlays
	QueueOverlayUpdate()


/**
 * Returns a list of overlays that the target atom has
 *
 * @param priority If true, returns priority overlays as well
 * @param special If true, returns special overlays like emissives and em_blockers
 */
/proc/get_overlays(atom/other, priority, special)
	var/list/including = list()
	if (!other)
		return including
	for (var/image/I as anything in other.our_overlays)
		if (!special && I.plane > 0)
			continue
		including += I
	if (!priority)
		return including
	for (var/image/I as anything in other.priority_overlays)
		if (!special && I.plane > 0)
			continue
		including += I
	return including
>>>>>>> 57232772193... Merge pull request #8593 from Atermonera/open_space_overlays_fixes
