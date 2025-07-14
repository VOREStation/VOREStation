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


/datum/controller/subsystem/overlays/Initialize()
	fire(FALSE, TRUE)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/overlays/stat_entry(msg)
	msg = "Queued Atoms: [queue.len], Cache Size: [cache_size]"
	return ..()


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
		AppearanceListEntry(entry, result, icon)
	return result

//Fixes runtime with overlays present in 515
/datum/controller/subsystem/overlays/proc/AppearanceListEntry(var/atom/entry,var/list/result,var/icon/icon)
	if (!entry)
		return
	else if(islist(entry))
		var/list/entry_list = entry
		for(var/entry_item in entry_list)
			AppearanceListEntry(entry_item)
	else if (istext(entry))
		result += GetStateAppearance(icon, entry)
	else if (isicon(entry))
		result += GetIconAppearance(entry)
	else
		if (isloc(entry))
			if (entry.flags & OVERLAY_QUEUED)
				entry.ImmediateOverlayUpdate()
		if (!ispath(entry))
			if(entry.appearance)
				result += entry.appearance
		else
			var/image/image = entry
			result += image.appearance

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

// Debug procs

/atom
	/// List of overlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the overlays list
	var/list/realized_overlays
	/// List of underlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the underlays list
	var/list/realized_underlays

/image
	/// List of overlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the overlays list
	var/list/realized_overlays
	/// List of underlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the underlays list
	var/list/realized_underlays

/// Takes the atoms's existing overlays and underlays, and makes them mutable so they can be properly vv'd in the realized_overlays/underlays list
/atom/proc/realize_overlays()
	realized_overlays = realize_appearance_queue(overlays)
	realized_underlays = realize_appearance_queue(underlays)

/// Takes the image's existing overlays, and makes them mutable so they can be properly vv'd in the realized_overlays list
/image/proc/realize_overlays()
	realized_overlays = realize_appearance_queue(overlays)
	realized_underlays = realize_appearance_queue(underlays)

/// Takes a list of appearnces, makes them mutable so they can be properly vv'd and inspected
/proc/realize_appearance_queue(list/appearances)
	var/list/real_appearances = list()
	var/list/queue = appearances.Copy()
	var/queue_index = 0
	while(queue_index < length(queue))
		queue_index++
		// If it's not a command, we assert that it's an appearance
		var/mutable_appearance/appearance = queue[queue_index]
		if(!appearance) // Who fucking adds nulls to their sublists god you people are the worst
			continue

		var/mutable_appearance/new_appearance = new /mutable_appearance()
		new_appearance.appearance = appearance
		var/key = "[appearance.icon]-[appearance.icon_state]-[appearance.plane]-[appearance.layer]-[appearance.dir]-[appearance.color]"
		var/tmp_key = key
		var/appearance_indx = 1
		while(real_appearances[tmp_key])
			tmp_key = "[key]-[appearance_indx]"
			appearance_indx++

		real_appearances[tmp_key] = new_appearance
		var/add_index = queue_index
		// Now check its children
		for(var/mutable_appearance/child_appearance as anything in appearance.overlays)
			add_index++
			queue.Insert(add_index, child_appearance)
		for(var/mutable_appearance/child_appearance as anything in appearance.underlays)
			add_index++
			queue.Insert(add_index, child_appearance)
	return real_appearances

/// Takes two appearances as args, prints out, logs, and returns a text representation of their differences
/// Including suboverlays
/proc/diff_appearances(mutable_appearance/first, mutable_appearance/second, iter = 0)
	var/list/diffs = list()
	var/list/firstdeet = first.vars
	var/list/seconddeet = second.vars
	var/diff_found = FALSE
	for(var/name in first.vars)
		var/firstv = firstdeet[name]
		var/secondv = seconddeet[name]
		if(firstv ~= secondv)
			continue
		if((islist(firstv) || islist(secondv)) && length(firstv) == 0 && length(secondv) == 0)
			continue
		if(name == "vars") // Go away
			continue
		if(name == "_listen_lookup") // This is just gonna happen with marked datums, don't care
			continue
		if(name == "overlays")
			first.realize_overlays()
			second.realize_overlays()
			var/overlays_differ = FALSE
			for(var/i in 1 to length(first.realized_overlays))
				if(diff_appearances(first.realized_overlays[i], second.realized_overlays[i], iter + 1))
					overlays_differ = TRUE

			if(!overlays_differ)
				continue

		diff_found = TRUE
		diffs += "Diffs detected at [name]: First ([firstv]), Second ([secondv])"

	var/text = "Depth of: [iter]\n\t[diffs.Join("\n\t")]"
	message_admins(text)
	log_world(text)
	return diff_found
