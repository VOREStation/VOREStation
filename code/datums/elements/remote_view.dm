/// Use this if you need to remote view something WITHOUT being inside of it.
/// Do not attach element manually, use mob/start_remoteviewing()
/datum/element/remote_view

/datum/element/remote_view/Attach(datum/target)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(target, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))

/datum/element/remote_view/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/element/remote_view/proc/on_moved(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	end_view()
	Detach(source)

/datum/element/remote_view/proc/on_reset_perspective(datum/source)
	SIGNAL_HANDLER
	Detach(source)

/datum/element/remote_view/proc/end_view(mob/host)
	host.reset_perspective(null)


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper proc
// ONLY give this component from this proc please...
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Begin remotely viewing something, remote view will end when mob moves, or something else changes the mob's perspective. Call AFTER you forceMove() the mob into the location!
/mob/proc/start_remoteviewing(atom/target)
	ASSERT(src != target, "[src] attempt to remote view itself.")
	// Just incase someone makes an ugly tgui_input that doesn't check before attempting to set view...
	if(!target || QDELETED(target))
		return
	// Set the view, THEN add the component, or it'll clear itself on it's own perspective change signal.
	reset_perspective(target)
	AddElement(/datum/element/remote_view)
