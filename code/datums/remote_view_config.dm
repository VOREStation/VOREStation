/datum/remote_view_config
	// Base configs
	var/forbid_movement = TRUE
	var/relay_movement = FALSE
	// Interuptions that end the view
	var/will_death = TRUE
	var/will_stun = TRUE
	var/will_weaken = TRUE
	var/will_paralyze = TRUE
	var/will_sleep = TRUE
	var/will_blind = TRUE

/// Handles relayed movement during a remote view. Override this in a subtype to handle specialized logic.
/datum/remote_view_config/proc/handle_relay_movement( datum/component/remote_view/owner_component, mob/host_mob, datum/coordinator, atom/movable/remote_view_target, direction)
	SIGNAL_HANDLER
	return FALSE

/// Handles visual changes to mob's hud or flags when in use
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
/datum/remote_view_config/allow_movement
	forbid_movement = FALSE

/datum/remote_view_config/relay_movement
	relay_movement = TRUE

/datum/remote_view_config/camera_standard
	forbid_movement = TRUE

/datum/remote_view_config/camera_standard/handle_apply_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	var/obj/machinery/camera/view_camera = owner_component.get_target()
	if(!view_camera || !view_camera.can_use())
		host_mob.reset_perspective()
		return
	if(host_mob.isXRay())
		host_mob.vision_flags |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
