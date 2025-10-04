/**
 * Use this if you need to remote view something. Remote view will end if you move or the remote view target is deleted. Cleared automatically if another remote view begins.
 */
/datum/component/remote_view
	VAR_PROTECTED/mob/host_mob
	VAR_PROTECTED/atom/remote_view_target
	VAR_PROTECTED/forbid_movement = TRUE

/datum/component/remote_view/allow_moving
	forbid_movement = FALSE

/datum/component/remote_view/Initialize(atom/focused_on)
	. = ..()
	to_chat(world, "[parent] BEGIN REMOTE VIEW [type] -> [focused_on]")
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	// Safety check, focus on ourselves if the target is deleted, and flag any movement to end the view.
	host_mob = parent
	if(QDELETED(focused_on))
		focused_on = host_mob
		forbid_movement = TRUE
	// Begin remoteview
	host_mob.reset_perspective(focused_on) // Must be done before registering the signals
	if(forbid_movement)
		RegisterSignal(host_mob, COMSIG_MOVABLE_MOVED, PROC_REF(handle_endview))
	else
		RegisterSignal(host_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(handle_endview))
	RegisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))
	RegisterSignal(host_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_reset_perspective))
	RegisterSignal(host_mob, COMSIG_MOB_DEATH, PROC_REF(handle_endview))
	RegisterSignal(host_mob, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))
	// Focus on remote view
	remote_view_target = focused_on
	if(host_mob != remote_view_target) // Some items just offset our view, so we set ourselves as the view target, don't double dip if so!
		RegisterSignal(remote_view_target, COMSIG_QDELETING, PROC_REF(handle_endview))
		RegisterSignal(remote_view_target, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_remotetarget_reset_perspective))
		RegisterSignal(remote_view_target, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))

/datum/component/remote_view/Destroy(force)
	. = ..()
	to_chat(world, "[parent] ENDED REMOTE VIEW [type] -> [remote_view_target]")
	if(forbid_movement)
		UnregisterSignal(host_mob, COMSIG_MOVABLE_MOVED)
	else
		UnregisterSignal(host_mob, COMSIG_MOVABLE_Z_CHANGED)
	UnregisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(host_mob, COMSIG_MOB_LOGOUT)
	UnregisterSignal(host_mob, COMSIG_MOB_DEATH)
	UnregisterSignal(host_mob, COMSIG_REMOTE_VIEW_CLEAR)
	// Cleanup remote view
	if(host_mob != remote_view_target)
		UnregisterSignal(remote_view_target, COMSIG_QDELETING)
		UnregisterSignal(remote_view_target, COMSIG_MOB_RESET_PERSPECTIVE)
		UnregisterSignal(remote_view_target, COMSIG_REMOTE_VIEW_CLEAR)
	host_mob = null
	remote_view_target = null

/datum/component/remote_view/proc/handle_endview(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	end_view()
	qdel(src)

/datum/component/remote_view/proc/on_reset_perspective(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!host_mob)
		return
	// Check if we're still remote viewing the SAME target!
	if(host_mob.client.eye == remote_view_target)
		to_chat(world, "[parent] PERSISTING THE VIEW [type] -> [remote_view_target]")
		return
	// The object already changed it's view, lets not interupt it like the others
	qdel(src)

/datum/component/remote_view/proc/on_remotetarget_reset_perspective(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
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
	host_mob.reset_perspective()



/**
 * Remote view subtype where if the item used with it is moved or dropped the view ends too
 */
/datum/component/remote_view/item_zoom
	VAR_PRIVATE/obj/item/host_item
	VAR_PRIVATE/show_message

/datum/component/remote_view/item_zoom/allow_moving
	forbid_movement = FALSE


/datum/component/remote_view/item_zoom/Initialize(atom/focused_on, obj/item/our_item, viewsize, tileoffset, show_visible_messages)
	. = ..()
	host_item = our_item
	RegisterSignal(host_item, COMSIG_QDELETING, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_MOVABLE_MOVED, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_ITEM_DROPPED, PROC_REF(handle_endview))
	RegisterSignal(host_item, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))
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
	host_mob.client.pixel_x = 0
	host_mob.client.pixel_y = 0
	host_mob.handle_vision()
	// decouple
	UnregisterSignal(host_item, COMSIG_QDELETING)
	UnregisterSignal(host_item, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(host_item, COMSIG_ITEM_DROPPED)
	UnregisterSignal(host_item, COMSIG_REMOTE_VIEW_CLEAR)
	host_item = null
	. = ..()


/**
 * Remote view subtype that stops if the remote view target is dead, or you lose access to the mremote mutation
 */
/datum/component/remote_view/mremote_mutation

/datum/component/remote_view/mremote_mutation/allow_moving
	forbid_movement = FALSE

/datum/component/remote_view/mremote_mutation/Initialize(atom/focused_on)
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

/datum/component/remote_view/viewer_managed/allow_moving
	forbid_movement = FALSE

/datum/component/remote_view/viewer_managed/Initialize(atom/focused_on, datum/coordinator, list/viewer_list)
	. = ..()
	if(!islist(viewer_list)) // BAD BAD BAD NO
		CRASH("Passed a viewer_list that was not a list, or was null, to /datum/component/remote_view/viewer_managed component. Ensure the viewer_list exists before passing it into AddComponent.")
	viewers = viewer_list
	view_coordinator = coordinator
	view_coordinator.look(host_mob)
	LAZYDISTINCTADD(viewers, WEAKREF(host_mob))
	RegisterSignal(view_coordinator, COMSIG_REMOTE_VIEW_CLEAR, PROC_REF(handle_endview))

/datum/component/remote_view/viewer_managed/Destroy(force)
	UnregisterSignal(view_coordinator, COMSIG_REMOTE_VIEW_CLEAR)
	view_coordinator.unlook(host_mob, FALSE)
	LAZYREMOVE(viewers, WEAKREF(host_mob))
	view_coordinator = null
	viewers = null
	. = ..()


/**
 * Remote view subtype that is handling a byond bug where mobs changing their client eye from inside of
 * and object will not have their eye change, and instead focus on any mob currently holding the item,
 * and only be released once we move ourselves to a new turf. This subtype does some loc witchcraft
 * to put us on a turf, change our view, and put us back without calling signals or move/enter.
 * Hopefully this will not be needed someday in the future - Willbird
 */
/datum/component/remote_view/mob_holding_item

/datum/component/remote_view/mob_holding_item/Initialize(atom/focused_on)
	. = ..()
	// Items can be nested deeply, so we need to update on any parent reorganization or actual move.
	host_mob.AddComponent(/datum/component/recursive_move)

/datum/component/remote_view/mob_holding_item/Destroy(force)
	// Check if we're still looking at our own object, allow us to release if so!
	var/turf/release_turf
	if(host_mob?.client?.eye == host_mob || host_mob?.client?.eye == remote_view_target)
		if(!QDELETED(remote_view_target) && isturf(remote_view_target.loc))
			release_turf = get_turf(remote_view_target)
		if(!QDELETED(host_mob) && isturf(host_mob.loc))
			release_turf = get_turf(host_mob)

	// Parent will clear a lot of stuff, so cache the mob here
	var/mob/cache_host = host_mob
	. = ..()

	// If our host or our item gets released, then focus the turf until we move again.
	if(QDELETED(cache_host) || !release_turf) // You're doing nothing if this is gone...
		return
	cache_host.AddComponent(/datum/component/remote_view, focused_on = release_turf)
	cache_host.client.eye = release_turf // Yes--
	cache_host.client.perspective = EYE_PERSPECTIVE // --this is required too.
	if(!isturf(cache_host.loc)) // Need our item's moves forwarded to us
		cache_host.AddComponent(/datum/component/recursive_move)
