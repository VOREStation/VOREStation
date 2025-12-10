/**
 * Use this if you need to remote view something. Remote view will end if you move or the remote view target is deleted. Cleared automatically if another remote view begins.
 */
/datum/component/remote_view
	VAR_PROTECTED/datum/remote_view_config/settings = null
	VAR_PROTECTED/mob/host_mob
	VAR_PROTECTED/atom/remote_view_target

/datum/component/remote_view/Initialize(atom/focused_on, vconfig_path)
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	// Set config
	if(!vconfig_path)
		vconfig_path = /datum/remote_view_config
	settings = new vconfig_path
	// Safety check, focus on ourselves if the target is deleted, and flag any movement to end the view.
	host_mob = parent
	if(QDELETED(focused_on))
		focused_on = host_mob
		settings.forbid_movement = TRUE
	// Begin remoteview
	host_mob.reset_perspective(focused_on) // Must be done before registering the signals
	if(settings.forbid_movement)
		RegisterSignal(host_mob, COMSIG_MOVABLE_MOVED, PROC_REF(handle_hostmob_moved))
	else
		RegisterSignal(host_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(handle_hostmob_moved))
	RegisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))
	RegisterSignal(host_mob, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_forced_endview))
	// Upon any disruptive status effects
	if(settings.will_stun)
		RegisterSignal(host_mob, COMSIG_LIVING_STATUS_STUN, PROC_REF(handle_status_effects))
	if(settings.will_weaken)
		RegisterSignal(host_mob, COMSIG_LIVING_STATUS_WEAKEN, PROC_REF(handle_status_effects))
	if(settings.will_paralyze)
		RegisterSignal(host_mob, COMSIG_LIVING_STATUS_PARALYZE, PROC_REF(handle_status_effects))
	if(settings.will_sleep)
		RegisterSignal(host_mob, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(handle_status_effects))
	if(settings.will_blind)
		RegisterSignal(host_mob, COMSIG_LIVING_STATUS_BLIND, PROC_REF(handle_status_effects))
	if(settings.will_death)
		RegisterSignal(host_mob, COMSIG_MOB_DEATH, PROC_REF(handle_endview))
	// Handle relayed movement
	if(settings.relay_movement)
		RegisterSignal(host_mob, COMSIG_MOB_RELAY_MOVEMENT, PROC_REF(handle_relay_movement))
	RegisterSignal(host_mob, COMSIG_MOB_HANDLE_VISION, PROC_REF(handle_mob_vision_update))
	// Hud overrides
	if(settings.override_entire_hud)
		RegisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD, PROC_REF(handle_hud_override))
	if(settings.override_health_hud)
		RegisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_HEALTH_ICON, PROC_REF(handle_hud_health))
	if(settings.override_darkvision_hud)
		RegisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_DARKSIGHT, PROC_REF(handle_hud_darkvision))
	// Recursive move component fires this, we only want it to handle stuff like being inside a paicard when releasing turf lock
	if(isturf(focused_on))
		RegisterSignal(host_mob, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(handle_recursive_moved))
	// Focus on remote view
	remote_view_target = focused_on
	if(host_mob != remote_view_target) // Some items just offset our view, so we set ourselves as the view target, don't double dip if so!
		RegisterSignal(remote_view_target, COMSIG_QDELETING, PROC_REF(handle_endview))
		RegisterSignal(remote_view_target, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_remotetarget_reset_perspective))
		RegisterSignal(remote_view_target, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_forced_endview))

/datum/component/remote_view/RegisterWithParent()
	// Update the mob's vision after we attach.
	host_mob.handle_vision()
	host_mob.handle_regular_hud_updates()
	settings.attached_to_mob(src, host_mob)

/datum/component/remote_view/Destroy(force)
	. = ..()
	// Basic handling
	if(settings.forbid_movement)
		UnregisterSignal(host_mob, COMSIG_MOVABLE_MOVED)
	else
		UnregisterSignal(host_mob, COMSIG_MOVABLE_Z_CHANGED)
	UnregisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(host_mob, COMSIG_REMOTE_VIEW_CLEAR)
	// Status effects
	if(settings.will_stun)
		UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_STUN)
	if(settings.will_weaken)
		UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_WEAKEN)
	if(settings.will_paralyze)
		UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_PARALYZE)
	if(settings.will_sleep)
		UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_SLEEP)
	if(settings.will_blind)
		UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_BLIND)
	if(isturf(remote_view_target))
		UnregisterSignal(host_mob, COMSIG_MOVABLE_ATTEMPTED_MOVE)
	if(settings.will_death)
		UnregisterSignal(host_mob, COMSIG_MOB_DEATH)
	// Handle relayed movement
	if(settings.relay_movement)
		UnregisterSignal(host_mob, COMSIG_MOB_RELAY_MOVEMENT)
	UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_VISION)
	// Hud overrides
	if(settings.override_entire_hud)
		UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD)
	if(settings.override_health_hud)
		UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_HEALTH_ICON)
	if(settings.override_darkvision_hud)
		UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_DARKSIGHT)
	// Cleanup remote view
	if(host_mob != remote_view_target) // If target is not ourselves
		UnregisterSignal(remote_view_target, COMSIG_QDELETING)
		UnregisterSignal(remote_view_target, COMSIG_MOB_RESET_PERSPECTIVE)
		UnregisterSignal(remote_view_target, COMSIG_REMOTE_VIEW_CLEAR)
	// Update the mob's vision right away if it still exists
	if(!QDELETED(host_mob))
		settings.detatch_from_mob(src, host_mob)
		settings.handle_remove_visuals(src, host_mob)
		host_mob.handle_vision()
		host_mob.handle_regular_hud_updates()
	host_mob = null
	remote_view_target = null
	// Clear settings
	QDEL_NULL(settings)

// Signal handlers

/datum/component/remote_view/proc/handle_hostmob_moved(atom/source, atom/oldloc, direction, forced, movetime)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	if(!host_mob)
		return
	end_view()
	qdel(src)

/datum/component/remote_view/proc/handle_recursive_moved(atom/source, atom/oldloc, atom/new_loc)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	ASSERT(isturf(remote_view_target))
	// This signal handler is for recursive move decoupling us from /datum/component/remote_view/mob_holding_item's turf focusing when dropped in an item like a paicard
	// This signal is only hooked when we focus on a turf. Check the subtype for more info, this horrorshow took several days to make consistently behave.
	if(!host_mob)
		return
	end_view()
	qdel(src)

/// By default pass this down, but we need unique handling for subtypes sometimes
/datum/component/remote_view/proc/handle_forced_endview(datum/source)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	handle_endview(source)

/datum/component/remote_view/proc/handle_endview(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(null)
	if(!host_mob)
		return
	end_view()
	qdel(src)

/datum/component/remote_view/proc/handle_status_effects(datum/source, amount, ignore_canstun)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	if(!host_mob)
		return
	// We don't really care what effect was caused, just that it was increasing the value and thus negatively affecting us.
	if(amount <= 0)
		return
	if(host_mob.client && isturf(host_mob.client.eye) && host_mob.client.eye == get_turf(host_mob.client.mob)) // This handles turf decoupling being protected until we actually move.
		return
	handle_endview(source)

/datum/component/remote_view/proc/on_reset_perspective(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(null)
	if(!host_mob)
		return
	// Check if we're still remote viewing the SAME target!
	if(host_mob.client.eye == remote_view_target)
		return
	// The object already changed it's view, lets not interupt it like the others
	qdel(src)

/datum/component/remote_view/proc/on_remotetarget_reset_perspective(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(null)
	// Non-mobs can't do this anyway
	if(!host_mob)
		return
	if(!ismob(remote_view_target))
		return
	var/mob/remote_view_mob = remote_view_target
	// This is an ugly one, but if we want to follow the other object properly we need to copy its state!
	if(!remote_view_mob.client || !host_mob.client)
		end_view()
		qdel(src)
		return
	// Only continue to observe if their view location is the same as their turf. otherwise they are doing their own ACTUALLY-REMOTE viewing
	// we just won't update it if you're trying to look at the remote view target of another mob as they remote view someone else!
	if(get_turf(remote_view_mob) != get_turf(remote_view_mob.client.eye))
		host_mob.client.eye = remote_view_mob
		host_mob.client.perspective = MOB_PERSPECTIVE
		return
	// Copy the view, do not use reset_perspective, because it will call our signal and end our view!
	host_mob.client.eye = remote_view_mob.client.eye
	host_mob.client.perspective = remote_view_mob.client.perspective

/datum/component/remote_view/proc/end_view()
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	host_mob.reset_perspective()

// Optional signal handlers for more advanced remote views

/datum/component/remote_view/proc/handle_relay_movement(datum/source, direction)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return FALSE
	return settings.handle_relay_movement(src, host_mob, direction)

/datum/component/remote_view/proc/handle_hud_override(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	return settings.handle_hud_override(src, host_mob)

/datum/component/remote_view/proc/handle_hud_health(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	return settings.handle_hud_health(src, host_mob)

/datum/component/remote_view/proc/handle_hud_darkvision(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	RETURN_TYPE(null)
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	settings.handle_hud_darkvision(src, host_mob)

/datum/component/remote_view/proc/handle_mob_vision_update(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	return settings.handle_apply_visuals(src, host_mob)

// Accessors

/datum/component/remote_view/proc/get_host()
	RETURN_TYPE(/mob)
	return host_mob

/datum/component/remote_view/proc/get_target()
	RETURN_TYPE(/atom)
	return remote_view_target

/datum/component/remote_view/proc/get_coordinator()
	RETURN_TYPE(/atom)
	return null // For subtype

/datum/component/remote_view/proc/looking_at_target_already(atom/target)
	return (remote_view_target == target)


/**
 * Remote view subtype where if the item used with it is moved or dropped the view ends too
 */
/datum/component/remote_view/item_zoom
	VAR_PRIVATE/obj/item/host_item
	VAR_PRIVATE/show_message

/datum/component/remote_view/item_zoom/Initialize(atom/focused_on, vconfig_path, obj/item/our_item, viewsize, tileoffset, show_visible_messages)
	. = ..()
	host_item = our_item
	RegisterSignal(host_item, COMSIG_QDELETING, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_MOVABLE_MOVED, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_ITEM_DROPPED, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_ITEM_EQUIPPED, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_forced_endview))
	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
	if(host_mob.hud_used.hud_shown)
		host_mob.toggle_zoom_hud()
	host_mob.set_viewsize(viewsize)
	// Unfortunately too many things read this to control item state for me to remove this.
	// Oh well! better than GetComponent() everywhere. Lets just manage item/zoom in this component though...
	our_item.zoom = TRUE
	// Offset view
	var/tilesize = 32
	var/viewoffset = tilesize * tileoffset
	switch(host_mob.dir)
		if (NORTH)
			host_mob.client.pixel_x = 0
			host_mob.client.pixel_y = viewoffset
		if (SOUTH)
			host_mob.client.pixel_x = 0
			host_mob.client.pixel_y = -viewoffset
		if (EAST)
			host_mob.client.pixel_x = viewoffset
			host_mob.client.pixel_y = 0
		if (WEST)
			host_mob.client.pixel_x = -viewoffset
			host_mob.client.pixel_y = 0
	// Feedback
	show_message = show_visible_messages
	if(show_message)
		host_mob.visible_message(span_filter_notice("[host_mob] peers through the [host_item.zoomdevicename ? "[host_item.zoomdevicename] of the [host_item.name]" : "[host_item.name]"]."))
	host_mob.handle_vision()

/datum/component/remote_view/item_zoom/Destroy(force)
	// Feedback
	if(show_message)
		host_mob.visible_message(span_filter_notice("[host_item.zoomdevicename ? "[host_mob] looks up from the [host_item.name]" : "[host_mob] lowers the [host_item.name]"]."))
	// Reset to default
	host_mob.set_viewsize()
	if(!host_mob.hud_used.hud_shown)
		host_mob.toggle_zoom_hud()
	host_item.zoom = FALSE
	// return view offset
	if(host_mob.client)
		host_mob.client.pixel_x = 0
		host_mob.client.pixel_y = 0
	host_mob.handle_vision()
	// decouple
	UnregisterSignal(host_item, COMSIG_QDELETING)
	UnregisterSignal(host_item, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(host_item, COMSIG_ITEM_DROPPED)
	UnregisterSignal(host_item, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(host_item, COMSIG_REMOTE_VIEW_CLEAR)
	host_item = null
	. = ..()


/**
 * Remote view subtype that stops if the remote view target is dead, or you lose access to the mremote mutation
 */
/datum/component/remote_view/mremote_mutation

/datum/component/remote_view/mremote_mutation/Initialize(atom/focused_on, vconfig_path)
	if(!ismob(focused_on)) // What are you doing? This gene only works on mob targets, if you adminbus this I will personally eat your face.
		return COMPONENT_INCOMPATIBLE
	. = ..()
	// Remote view mutation stops viewing when mobs die or if we lose the mutation/gene
	RegisterSignal(host_mob, COMSIG_MOB_DNA_MUTATION, PROC_REF(on_mutation))
	if(host_mob != remote_view_target)
		RegisterSignal(remote_view_target, COMSIG_MOB_DEATH, PROC_REF(handle_endview))

/datum/component/remote_view/mremote_mutation/Destroy(force)
	UnregisterSignal(host_mob, COMSIG_MOB_DNA_MUTATION)
	if(host_mob != remote_view_target)
		UnregisterSignal(remote_view_target, COMSIG_MOB_DEATH)
	. = ..()

/datum/component/remote_view/mremote_mutation/proc/on_mutation(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	var/mob/remote_mob = remote_view_target
	if(host_mob.stat == CONSCIOUS && (mRemote in host_mob.mutations) && remote_mob && remote_mob.stat == CONSCIOUS)
		return
	end_view()
	qdel(src)


/**
 * Remote view subtype that handles look() and unlook() procs while managing a list of viewers. Expects a viewer list stored by the object itself, passed in with AddComponent(). Ensure the list exists before passing it to the component or pass by reference will fail.
 */
/datum/component/remote_view/viewer_managed
	VAR_PRIVATE/datum/view_coordinator // The object containing the viewer_list, with look() and unlook() logic
	VAR_PRIVATE/list/viewers // list from the view_coordinator, lists in byond are pass by reference, so this is the SAME list as on the coordinator! If you pass a null this will explode.

/datum/component/remote_view/viewer_managed/Initialize(atom/focused_on, vconfig_path, datum/coordinator, list/viewer_list)
	. = ..()
	if(!islist(viewer_list)) // BAD BAD BAD NO
		CRASH("Passed a viewer_list that was not a list, or was null, to /datum/component/remote_view/viewer_managed component. Ensure the viewer_list exists before passing it into AddComponent.")
	viewers = viewer_list
	view_coordinator = coordinator
	view_coordinator.look(host_mob)
	LAZYDISTINCTADD(viewers, WEAKREF(host_mob))
	RegisterSignal(view_coordinator, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_forced_endview))

/datum/component/remote_view/viewer_managed/Destroy(force)
	UnregisterSignal(view_coordinator, COMSIG_REMOTE_VIEW_CLEAR)
	view_coordinator.unlook(host_mob, FALSE)
	LAZYREMOVE(viewers, WEAKREF(host_mob))
	view_coordinator = null
	viewers = null
	. = ..()

/datum/component/remote_view/viewer_managed/get_coordinator()
	return view_coordinator

/**
 * Remote view subtype that is handling a byond bug where mobs changing their client eye from inside of
 * and object will not have their eye change, and instead focus on any mob currently holding the item,
 * and only be released once we move ourselves to a new turf. This subtype does some loc witchcraft
 * to put us on a turf, change our view, and put us back without calling signals or move/enter.
 * Hopefully this will not be needed someday in the future - Willbird
 */
#define MAX_RECURSIVE 64
/datum/component/remote_view/mob_holding_item
	var/needs_to_decouple = FALSE // if the current top level atom is a mob

/datum/component/remote_view/mob_holding_item/Initialize(atom/focused_on, vconfig_path)
	if(!isobj(focused_on)) // You shouldn't be using this if so.
		return COMPONENT_INCOMPATIBLE
	. = ..()
	// Items can be nested deeply, so we need to update on any parent reorganization or actual move.
	host_mob.AddComponent(/datum/component/recursive_move)
	RegisterSignal(host_mob, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(handle_recursive_moved)) // Doesn't need override, basetype only ever registers this signal if we're looking at a turf
	// Check our inmob state
	if(ismob(find_topmost_atom()))
		needs_to_decouple = TRUE

/datum/component/remote_view/mob_holding_item/Destroy(force)
	UnregisterSignal(host_mob, COMSIG_MOVABLE_MOVED)
	. = ..()

/datum/component/remote_view/mob_holding_item/handle_status_effects(datum/source, amount, ignore_canstun)
	if(host_mob.loc == remote_view_target) // If we are still inside our holder or belly than don't bother spamming this
		return
	. = ..()

/datum/component/remote_view/mob_holding_item/handle_hostmob_moved(atom/source, atom/oldloc)
	// We handle this in recursive move
	if(!host_mob)
		return
	if(isturf(host_mob.loc))
		if(oldloc == remote_view_target)
			needs_to_decouple = TRUE
		decouple_view_to_turf( host_mob, host_mob.loc)
		return

/datum/component/remote_view/mob_holding_item/handle_recursive_moved(atom/source, atom/oldloc, atom/new_loc)
	if(!host_mob)
		return
	// default moved signal will handle this
	if(isturf(host_mob.loc))
		return
	// This only triggers when we are deeper in than our mob. See who is in charge of this clowncar...
	// Loop upward until we find a mob or a turf. Mobs will hold our current view, turfs mean our bag-stack was dropped.
	var/atom/top_most = find_topmost_atom()
	if(isturf(top_most))
		if(needs_to_decouple) // Only need to do this if we were held by a mob prior, otherwise this triggers every move and is expensive for no reason
			decouple_view_to_turf( host_mob, top_most)
		return
	if(ismob(top_most) || ismecha(top_most)) // Mobs and mechas both do this
		host_mob.AddComponent(/datum/component/recursive_move) // Will rebuild parent chain.
		needs_to_decouple = TRUE
		return

/// Get our topmost atom state, if it's a mob or a turf
/datum/component/remote_view/mob_holding_item/proc/find_topmost_atom()
	var/atom/cur_parent = remote_view_target?.loc // first loc could be null
	var/recursion = 0 // safety check - max iterations
	while(!isnull(cur_parent) && (recursion < MAX_RECURSIVE))
		if(cur_parent == cur_parent.loc) //safety check incase a thing is somehow inside itself, cancel
			log_runtime("REMOTE_VIEW: Parent is inside itself. ([host_mob]) ([host_mob.type]) : [MAX_RECURSIVE - recursion]")
			return null
		if(ismob(cur_parent) || ismecha(cur_parent) || isturf(cur_parent))
			return cur_parent
		recursion++
		cur_parent = cur_parent.loc

	if(recursion >= MAX_RECURSIVE) // If we escaped due to iteration limit, cancel
		log_runtime("REMOTE_VIEW: Turf search hit recursion limit. ([host_mob]) ([host_mob.type])")
	return null

/// Makes a new remote view focused on the release_turf argument. This remote view ends as soon as any movement happens. Even if we are inside many levels of objects due to our recursive_move listener
/datum/component/remote_view/mob_holding_item/proc/decouple_view_to_turf(mob/cache_mob, turf/release_turf)
	if(needs_to_decouple)
		// Yes this spawn is needed, yes I wish it wasn't.
		spawn(0)
			// Decouple the view to the turf on drop, or we'll be stuck on the mob that dropped us forever
			if(!QDELETED(cache_mob))
				cache_mob.AddComponent(/datum/component/remote_view, focused_on = release_turf, vconfig_path = /datum/remote_view_config/turf_decoupling)
				cache_mob.client.eye = release_turf // Yes--
				cache_mob.client.perspective = EYE_PERSPECTIVE // --this is required too.
				if(!isturf(cache_mob.loc)) // For stuff like paicards
					cache_mob.AddComponent(/datum/component/recursive_move) // Will rebuild parent chain.
			// If you somehow deleted before the decouple... Just fix this mess.
			else
				cache_mob.reset_perspective()
		// Because nested vore bellies do NOT get handled correctly for recursive prey. We need to tell the belly's occupants to decouple too... Then their own belly's occupants...
		// Yes, two loops is faster. Because we skip typechecking byondcode side and instead do it engine side when getting the contents of the mob,
		// we also skip typechecking every /obj in the mob on the byondcode side... Evil wizard knowledge.
		for(var/obj/belly/check_belly in cache_mob.contents)
			SEND_SIGNAL(check_belly, COMSIG_REMOTE_VIEW_CLEAR)
		for(var/obj/item/dogborg/sleeper/check_sleeper in cache_mob.contents)
			SEND_SIGNAL(check_sleeper, COMSIG_REMOTE_VIEW_CLEAR)
	qdel(src)

/// We were forcibly disconnected, this situation is probably a recursive hellscape, so just decouple entirely and fix it when someone moves.
/datum/component/remote_view/mob_holding_item/handle_forced_endview(atom/source)
	if(!host_mob)
		return
	needs_to_decouple = TRUE
	decouple_view_to_turf( host_mob, get_turf(host_mob))

#undef MAX_RECURSIVE
