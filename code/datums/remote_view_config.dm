/datum/remote_view_config
	// Signal config for remote view component. This controls what signals will be subbed to during init.
	var/forbid_movement = TRUE
	var/relay_movement = TRUE
	// Status effects that will knock us out of remote view
	var/will_death = TRUE
	var/will_stun = TRUE
	var/will_weaken = TRUE
	var/will_paralyze = TRUE
	var/will_sleep = TRUE
	var/will_blind = TRUE

/// Handles relayed movement during a remote view. Override this in a subtype to handle specialized logic. If it returns true, the mob will not move, allowing you to handle remotely controlled movement.
/datum/remote_view_config/proc/handle_relay_movement( datum/component/remote_view/owner_component, mob/host_mob, datum/coordinator, atom/movable/remote_view_target, direction)
	SIGNAL_HANDLER
	// By default, we ask our remote_view_target to handle relaymove for us.
	return remote_view_target.relaymove(host_mob, direction)

/// Handles visual changes to mob's hud or flags when in use, it is fired every life tick.
/datum/remote_view_config/proc/handle_apply_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	return

/// Handles visual changes when ending the view
/datum/remote_view_config/proc/handle_remove_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	return


//////////////////////////////////////////////////////////////////////////////////////////////////
// Basic subtypes
//////////////////////////////////////////////////////////////////////////////////////////////////
/// Remote view that allows moving without clearing the remote view.
/datum/remote_view_config/allow_movement
	forbid_movement = FALSE

/// Remote view that respects camera vision flags and checking for functionality of the camera.
/datum/remote_view_config/camera_standard
	forbid_movement = TRUE

/datum/remote_view_config/camera_standard/handle_apply_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	var/obj/machinery/camera/view_camera = owner_component.get_target()
	if(!view_camera || !view_camera.can_use())
		host_mob.reset_perspective()
		return
	if(view_camera.isXRay())
		host_mob.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
