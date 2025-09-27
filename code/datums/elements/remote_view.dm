/// Use this if you need to remote view something WITHOUT being inside of it.
/// Do not attach element manually, use mob/start_remoteviewing()
/datum/element/remote_view

/datum/element/remote_view/Attach(datum/target)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(target, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))
	RegisterSignal(target, COMSIG_MOB_DEATH, PROC_REF(on_death))

/datum/element/remote_view/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(target, COMSIG_MOB_DEATH)

/datum/element/remote_view/proc/on_moved(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	end_view()
	Detach(source)

/datum/element/remote_view/proc/on_reset_perspective(datum/source)
	SIGNAL_HANDLER
	Detach(source)

/datum/element/remote_view/mremote_mutation/on_death(datum/source)
	SIGNAL_HANDLER
	end_view()
	Detach(source)

/datum/element/remote_view/proc/end_view(mob/host)
	host.reset_perspective(null)


// Special varient that cares about mRemote mutation in humans!
/datum/element/remote_view/mremote_mutation

/datum/element/remote_view/Attach(datum/target)
	RegisterSignal(target, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	. = ..()

/datum/element/remote_view/Detach(datum/target)
	UnregisterSignal(target, COMSIG_LIVING_LIFE)
	. = ..()

/datum/element/remote_view/mremote_mutation/on_life(datum/source)
	SIGNAL_HANDLER
	var/mob/mob_source = source
	if(mRemote in mob_source.mutations)
		return
	end_view()
	Detach(source)


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper proc
// ONLY give this component from this proc please...
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Begin remotely viewing something, remote view will end when mob moves, or something else changes the mob's perspective. Call AFTER you forceMove() the mob into the location!
/mob/proc/start_remoteviewing(atom/target, using_mutation = FALSE)
	ASSERT(src != target, "[src] attempt to remote view itself.")
	// Just incase someone makes an ugly tgui_input that doesn't check before attempting to set view...
	if(!target || QDELETED(target))
		return
	// Set the view, THEN add the component, or it'll clear itself on it's own perspective change signal.
	reset_perspective(target)
	if(using_mutation) // Mutation can be cleared at any time, need tocheck for that if we're using that power!
		AddElement(/datum/element/remote_view/mremote_mutation)
		return
	AddElement(/datum/element/remote_view)

/mob/proc/is_remote_viewing()
	if(!client)
		return FALSE
	return (client.eye != client.mob)
