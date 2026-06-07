/**
 * Use this if you need to remote view something. Remote view will end if you move or the remote view target is deleted. Cleared automatically if another remote view begins.
 */
/datum/component/remote_view
	VAR_PROTECTED/datum/remote_view_config/settings = null
	VAR_PROTECTED/mob/host_mob
	VAR_PROTECTED/atom/remote_view_target
	// Specialty remote views that rely on another object to manage them
	VAR_PROTECTED/show_message = FALSE
	VAR_PRIVATE/obj/item/host_item
	VAR_PRIVATE/datum/view_coordinator // The object containing the viewer_list, with look() and unlook() logic
	VAR_PRIVATE/list/coordinated_viewers // list from the view_coordinator, lists in byond are pass by reference, so this is the SAME list as on the coordinator!

/datum/component/remote_view/Initialize(atom/focused_on = null, viewsize = null, vconfig_path = null, obj/item/managing_item = null, tileoffset = 0, show_visible_messages = TRUE, datum/coordinator = null, list/viewer_list = null)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	// to_chat(world, "======================================== STARTED VIEW on: [focused_on]")

	/**
	 * Set config
	 * All remote views use a vconfig_path to create a settings datum. This datum controls most features of the remote view.
	 * It also allows for unique overrides per view type, such as the UAV overriding the hud for special effects, without
	 * needing to make an entirely new type of remote view to do so. See code\datums\remote_view_config.dm
	 */
	if(!vconfig_path)
		vconfig_path = /datum/remote_view_config
	settings = new vconfig_path

	/**
	 * Safety check, focus on our own turf if the target is deleted, and flag any movement to end the view.
	 *
	 * IMPORTANT:
	 * Passing null for the focused_on target of the remote view will use the turf of the mob creating the view.
	 * This behavior is called "turf decoupling" and is used to correct a byond issue where mobs dropping mobs lock
	 * the view to the mob that dropped them. See release_remote_view() below. Creating a remote_view with no
	 * arguments will just cause turf decoupling behavior, and is safe to do.
	 */
	host_mob = parent
	if(!focused_on || QDELETED(focused_on))
		focused_on = get_turf(host_mob)
		settings.forbid_movement = TRUE
	// Focus on remote view
	remote_view_target = focused_on
	host_mob.reset_perspective(remote_view_target) // Must be done before registering the signals
	host_mob.AddComponent(/datum/component/recursive_move) // Updates our parent tree if we already have it

	/**
	 * If a complex datum with a viewer list is coordinating this view (shuttle consoles for example)
	 * This is intended for views that required a managed list of coordinated_viewers.
	 * This allows the view_coordinator to decide things, like maximum number of viewers, or if actions disconnect all viewers at once.
	 * Calls look() and unlook() on the coordinator when the view starts and ends.
	 */
	if(coordinator)
		if(!islist(viewer_list)) // BAD BAD BAD NO
			CRASH("Passed a viewer_list that was not a list, or was null, to /datum/component/remote_view component. Ensure the viewer_list exists before passing it into AddComponent.")
		coordinated_viewers = viewer_list
		view_coordinator = coordinator
		view_coordinator.look(host_mob)
		LAZYDISTINCTADD(coordinated_viewers, WEAKREF(host_mob))

	/**
	 * If an item is coordinating this view (scopes/binoculars)
	 * Handles remote views that are managed by a held item. The held item must remain in the mob's
	 * inventory, and will call zoom() and unzoom() when it starts and ends. Optionally showing a message.
	 */
	if(isitem(managing_item))
		host_item = managing_item
		// Unfortunately too many things read this to control item state for me to remove this.
		// Oh well! better than GetComponent() everywhere. Lets just manage item/zoom in this component though...
		host_item.zoom = TRUE
		// Feedback
		show_message = show_visible_messages
		if(show_message)
			host_mob.visible_message(span_filter_notice("[host_mob] peers through the [host_item.zoomdevicename ? "[host_item.zoomdevicename] of the [host_item.name]" : "[host_item.name]"]."))

	/**
	 * Offset view, optionally offset the final view. Used by binoculars.
	 * Having the target of the view, and the owner mob of the view be the same thing allows you to offset the view as desired from the view owner.
	 */
	var/viewoffset = WORLD_ICON_SIZE * tileoffset
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

/datum/component/remote_view/Destroy(force)
	// Clear item
	if(host_item)
		host_item.zoom(host_mob)
		// Feedback
		if(show_message)
			host_mob.visible_message(span_filter_notice("[host_item.zoomdevicename ? "[host_mob] looks up from the [host_item.name]" : "[host_mob] lowers the [host_item.name]"]."))
		host_item = null

	// clear coordinator
	if(view_coordinator)
		view_coordinator.unlook(host_mob, FALSE)
		LAZYREMOVE(coordinated_viewers, WEAKREF(host_mob))
		view_coordinator = null
		coordinated_viewers = null

	// Reset to default size
	host_mob.set_viewsize()
	if(settings.use_zoom_hud && !host_mob.hud_used.hud_shown)
		host_mob.toggle_zoom_hud()

	// Unregister remaining signals
	// to_chat(world, "======================================== ENDED VIEW on: [remote_view_target]")
	. = ..()

	// Update the mob's vision right away if it still exists
	if(!QDELETED(host_mob) && host_mob.client)
		settings.detatch_from_mob(src, host_mob)
		settings.handle_remove_visuals(src, host_mob)
		host_mob.client.pixel_x = 0
		host_mob.client.pixel_y = 0
		host_mob.handle_vision()
		host_mob.handle_regular_hud_updates()

	// Finish cleanup
	QDEL_NULL(settings)
	host_mob = null
	remote_view_target = null

/datum/component/remote_view/RegisterWithParent()
	RegisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))
	RegisterSignal(host_mob, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))
	if(host_mob != remote_view_target) // Some items just offset our view, so we set ourselves as the view target, don't double dip if so!
		RegisterSignal(remote_view_target, COMSIG_QDELETING, PROC_REF(handle_endview))
		RegisterSignal(remote_view_target, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_remotetarget_reset_perspective))
		RegisterSignal(remote_view_target, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))
	if(host_item)
		RegisterSignal(host_item, COMSIG_QDELETING, PROC_REF(handle_endview))
		RegisterSignal(host_item, COMSIG_MOVABLE_MOVED, PROC_REF(handle_endview))
		RegisterSignal(host_item, COMSIG_ITEM_DROPPED, PROC_REF(handle_endview))
		RegisterSignal(host_item, COMSIG_ITEM_EQUIPPED, PROC_REF(handle_endview))
		RegisterSignal(host_item, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))
	if(view_coordinator)
		RegisterSignal(view_coordinator, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))
	settings.register_signals(host_mob, src)
	if(settings.relay_movement) // Handle relayed movement
		RegisterSignal(host_mob, COMSIG_MOB_RELAY_MOVEMENT, PROC_REF(handle_relay_movement))
	if(settings.release_view_to_turf || isturf(remote_view_target)) // So it triggers if we are inside an item too... And if the item is being moved around by pull...
		RegisterSignal(host_mob, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(handle_recursive_move))

	// Update the mob's vision after we attach everything
	host_mob.handle_vision()
	host_mob.handle_regular_hud_updates()
	settings.attached_to_mob(src, host_mob)

/datum/component/remote_view/UnregisterFromParent()
	UnregisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(host_mob, COMSIG_REMOTE_VIEW_CLEAR)
	if(host_mob != remote_view_target) // If target is not ourselves
		UnregisterSignal(remote_view_target, COMSIG_QDELETING)
		UnregisterSignal(remote_view_target, COMSIG_MOB_RESET_PERSPECTIVE)
		UnregisterSignal(remote_view_target, COMSIG_REMOTE_VIEW_CLEAR)
	if(host_item)
		UnregisterSignal(host_item, COMSIG_QDELETING)
		UnregisterSignal(host_item, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(host_item, COMSIG_ITEM_DROPPED)
		UnregisterSignal(host_item, COMSIG_ITEM_EQUIPPED)
		UnregisterSignal(host_item, COMSIG_REMOTE_VIEW_CLEAR)
	if(view_coordinator)
		UnregisterSignal(view_coordinator, COMSIG_REMOTE_VIEW_CLEAR)
	settings.unregister_signals(host_mob, src)
	if(settings.relay_movement) // Handle relayed movement
		UnregisterSignal(host_mob, COMSIG_MOB_RELAY_MOVEMENT)
	if(settings.release_view_to_turf || isturf(remote_view_target))
		UnregisterSignal(host_mob, COMSIG_MOVABLE_ATTEMPTED_MOVE)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Signal handlers
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/remote_view/proc/handle_hostmob_moved(atom/source, atom/oldloc, direction, forced, movetime)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	release_remote_view()

/datum/component/remote_view/proc/handle_endview(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(null)
	release_remote_view()

/datum/component/remote_view/proc/handle_status_effects(datum/source, amount, ignore_canstun)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
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
	// The object already changed it's view, lets not interupt it like the others
	qdel(src)

/datum/component/remote_view/proc/on_remotetarget_reset_perspective(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(null)
	// Non-mobs can't do this anyway
	if(!ismob(remote_view_target))
		return
	var/mob/remote_view_mob = remote_view_target
	// This is an ugly one, but if we want to follow the other object properly we need to copy its state!
	if(!remote_view_mob.client || !host_mob.client)
		release_remote_view()
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

/datum/component/remote_view/proc/handle_recursive_move(datum/source, atom/old_loc, atom/current_loc)
	SIGNAL_HANDLER
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	var/needs_to_force_turf_decouple = ismob(old_loc) && isturf(current_loc) // Handle an edge case where another mob is dropped by a mob with someone else inside them
	release_remote_view(needs_to_force_turf_decouple)

/datum/component/remote_view/proc/handle_relay_movement(datum/source, direction)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// I'd move this into the config datum if it didn't require the component to also be passed too. Lets avoid GetComponent on a hotpath.
	return settings.handle_relay_movement(src, host_mob, direction)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Horrible byond hack
// This is only here to solve an issue where dropping a held mob while inside a mob will linger on the turf of that mob forever
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/remote_view/proc/release_remote_view(force_turf_decouple = FALSE)
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(null)
	// to_chat(world, "RELEASING: [remote_view_target] : forced turf decouple? [force_turf_decouple]")
	var/mob/cache_mob = host_mob
	var/releases_to_turf = settings.release_view_to_turf
	qdel(src) // Delete here so the remote view is nice and clean
	if(QDELETED(cache_mob) || !cache_mob.client)
		// to_chat(world, "--DELETED")
		return

	// We're nothing special, ask the mob to check if it should start a new remote view (like if we were dropped into a belly from being held by another mob!)
	if(!releases_to_turf && !force_turf_decouple)
		// to_chat(world, "--Reset perspective")
		cache_mob.reset_perspective()
		return

	// Check to see if it's legal to release the view. Our top level object MUST NOT be a mob!
	var/emergency = 0
	var/atom/movable/recursive_scan = cache_mob.loc
	if(!force_turf_decouple && !isturf(recursive_scan)) // If our actual mob was placed on a turf, skip all of this recursion checking. We're good to decouple.
		while(recursive_scan && !isturf(recursive_scan) && emergency++ < 64)
			if(ismob(recursive_scan))
				// to_chat(world, "--held by mob still")
				cache_mob.reset_perspective() // We're still inside another mob... Do not decouple to turf. Hold onto our current target.
				return
			recursive_scan = recursive_scan.loc

	// Focus on the turf, this prevents the view lingering on a mob forever
	// to_chat(world, "--turf decouple")
	// Decouple to turf, this is a hack.
	// Yes this is required.
	spawn(0) // Yes I hate it.
		cache_mob.AddComponent(/datum/component/remote_view)
	// Good luck refactoring this until the byond issue is fixed. This needs to happen AFTER the move resolves, but needs to be called by recursive move...


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Accessors
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/remote_view/proc/get_host()
	RETURN_TYPE(/mob)
	return host_mob

/datum/component/remote_view/proc/get_target()
	RETURN_TYPE(/atom)
	return remote_view_target

/datum/component/remote_view/proc/get_coordinator()
	RETURN_TYPE(/atom)
	return view_coordinator

/datum/component/remote_view/proc/looking_at_target_already(atom/target)
	return (remote_view_target == target)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Prefabs
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Gene remote view
/datum/component/remote_view/mremote_mutation

/datum/component/remote_view/mremote_mutation/RegisterWithParent()
	// Remote view mutation stops viewing when mobs die or if we lose the mutation/gene
	RegisterSignal(host_mob, COMSIG_MOB_DNA_MUTATION, PROC_REF(on_mutation))
	RegisterSignal(remote_view_target, COMSIG_MOB_DEATH, PROC_REF(handle_endview))

/datum/component/remote_view/mremote_mutation/UnregisterFromParent()
	. = ..()
	UnregisterSignal(host_mob, COMSIG_MOB_DNA_MUTATION)
	UnregisterSignal(remote_view_target, COMSIG_MOB_DEATH)

/datum/component/remote_view/mremote_mutation/proc/on_mutation(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	var/mob/remote_mob = remote_view_target
	if(host_mob.stat == CONSCIOUS && (mRemote in host_mob.mutations) && remote_mob && remote_mob.stat == CONSCIOUS)
		return
	release_remote_view()
