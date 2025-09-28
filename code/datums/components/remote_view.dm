/// Use this if you need to remote view something WITHOUT being inside of it.
/// Do not attach element manually, use mob/start_remoteviewing()
/datum/component/remote_view
	var/mob/host_mob
	var/atom/remote_view_target

/datum/component/remote_view/Initialize(atom/focused_on)
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	host_mob = parent
	host_mob.reset_perspective(focused_on) // Must be done before registering the signals
	RegisterSignal(host_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))
	RegisterSignal(host_mob, COMSIG_MOB_DEATH, PROC_REF(on_death))
	RegisterSignal(host_mob, COMSIG_QDELETING, PROC_REF(on_qdel))
	// Focus on remote view
	remote_view_target = focused_on
	RegisterSignal(remote_view_target, COMSIG_QDELETING, PROC_REF(on_qdel))

/datum/component/remote_view/Destroy(force)
	. = ..()
	UnregisterSignal(host_mob, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(host_mob, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(host_mob, COMSIG_MOB_DEATH)
	UnregisterSignal(host_mob, COMSIG_QDELETING)
	host_mob = null
	// Cleanup remote view
	UnregisterSignal(remote_view_target, COMSIG_QDELETING)
	remote_view_target = null

/datum/component/remote_view/proc/on_moved(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	end_view()
	qdel(src)

/datum/component/remote_view/proc/on_reset_perspective(datum/source)
	SIGNAL_HANDLER
	// The object already changed it's view, lets not interupt it like the others
	qdel(src)

/datum/component/remote_view/proc/on_death(datum/source)
	SIGNAL_HANDLER
	end_view()
	qdel(src)

/datum/component/remote_view/proc/on_qdel(datum/source)
	SIGNAL_HANDLER
	end_view()
	qdel(src)

/datum/component/remote_view/proc/end_view()
	host_mob.reset_perspective(null)

// Special varient that cares about mRemote mutation in humans!
/datum/component/remote_view/mremote_mutation

/datum/component/remote_view/mremote_mutation/Initialize(atom/focused_on)
	if(!ismob(focused_on)) // What are you doing? This gene only works on mob targets, if you adminbus this I will personally eat your face.
		return COMPONENT_INCOMPATIBLE
	. = ..()
	RegisterSignal(host_mob, COMSIG_MOB_DNA_MUTATION, PROC_REF(on_mutation))
	RegisterSignal(remote_view_target, COMSIG_MOB_DEATH, PROC_REF(on_death))

/datum/component/remote_view/mremote_mutation/Destroy(force)
	UnregisterSignal(host_mob, COMSIG_MOB_DNA_MUTATION)
	UnregisterSignal(remote_view_target, COMSIG_MOB_DEATH)
	. = ..()

/datum/component/remote_view/mremote_mutation/proc/on_mutation(datum/source)
	SIGNAL_HANDLER
	var/mob/remote_mob = remote_view_target
	if(host_mob.stat == CONSCIOUS && (mRemote in host_mob.mutations) && remote_mob && remote_mob.stat == CONSCIOUS)
		return
	end_view()
	qdel(src)


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper proc
// ONLY attach this element from this proc please...
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Begin remotely viewing something, remote view will end when mob moves, or something else changes the mob's perspective. Call AFTER you forceMove() the mob into the location!
/mob/proc/start_remoteviewing(atom/target, using_mutation = FALSE)
	ASSERT(src != target, "[src] attempt to remote view itself.")
	// Just incase someone makes an ugly tgui_input that doesn't check before attempting to set view...
	if(!target || QDELETED(target))
		return
	// Set the view, THEN add the component, or it'll clear itself on it's own perspective change signal.
	if(using_mutation) // Mutation can be cleared at any time, need tocheck for that if we're using that power!
		AddComponent(/datum/component/remote_view/mremote_mutation, target)
		return
	AddComponent(/datum/component/remote_view, target)
