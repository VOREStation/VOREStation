/datum/remote_view_config
	// Signal config for remote view component. This controls what signals will be subbed to during init.
	var/forbid_movement = TRUE
	var/relay_movement = FALSE
	var/use_zoom_hud = FALSE
	// Status effects that will knock us out of remote view
	var/will_death = TRUE
	var/will_stun = TRUE
	var/will_weaken = TRUE
	var/will_paralyze = TRUE
	var/will_sleep = TRUE
	var/will_blind = TRUE
	// Hud overrides, datum is responsible for restoring the hud state on attach and detatch
	var/override_entire_hud = FALSE // Overrides all others, only this needs to be set if you do a fully custom hud
	var/override_health_hud = FALSE
	var/override_darkvision_hud = FALSE

/// Called when remote view component finishes attaching to the mob
/datum/remote_view_config/proc/attached_to_mob( datum/component/remote_view/owner_component, mob/host_mob)
	RETURN_TYPE(null)
	return

/// Called when remote view component is destroyed
/datum/remote_view_config/proc/detatch_from_mob( datum/component/remote_view/owner_component, mob/host_mob)
	RETURN_TYPE(null)
	return

/// Handles relayed movement during a remote view. Override this in a subtype to handle specialized logic. If it returns true, the mob will not move, allowing you to handle remotely controlled movement.
/datum/remote_view_config/proc/handle_relay_movement( datum/component/remote_view/owner_component, mob/host_mob, datum/coordinator, atom/movable/remote_view_target, direction)
	SIGNAL_HANDLER
	// By default, we ask our remote_view_target to handle relaymove for us.
	if(!remote_view_target)
		return FALSE
	return remote_view_target.relaymove(host_mob, direction)

/// Handles visual changes to mob's hud or flags when in use, it is fired every life tick.
/datum/remote_view_config/proc/handle_apply_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	RETURN_TYPE(null)
	return

/// Handles visual changes when ending the view
/datum/remote_view_config/proc/handle_remove_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	RETURN_TYPE(null)
	return

/// Handles hud health indicator being replaced with a custom one (like showing the remote_view_target's health).
/datum/remote_view_config/proc/handle_hud_override( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	return COMSIG_COMPONENT_HANDLED_HUD

/// Handles hud health indicator being replaced with a custom one (like showing the remote_view_target's health).
/datum/remote_view_config/proc/handle_hud_health( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	return COMSIG_COMPONENT_HANDLED_HEALTH_ICON

/// Handles hud darkvision for if the remote view uses it's own logic for darkvision, or asks the remote_view_target to calculate it.
/datum/remote_view_config/proc/handle_hud_darkvision( datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	RETURN_TYPE(null)
	return


//////////////////////////////////////////////////////////////////////////////////////////////////
// Basic subtypes
//////////////////////////////////////////////////////////////////////////////////////////////////
/// Remote view that allows moving without clearing the remote view.
/datum/remote_view_config/allow_movement
	forbid_movement = FALSE

/// Remote view that ignores stuns and other status effects ending the view
/datum/remote_view_config/effect_immune
	will_stun = FALSE
	will_weaken = FALSE
	will_paralyze = FALSE
	will_sleep = FALSE
	will_blind = FALSE

/// Remote view that handles being inside of an object. This ignores stuns and other effects, as you are remaining within the object anyway.
/datum/remote_view_config/inside_object
	forbid_movement = TRUE
	will_death = TRUE
	will_stun = FALSE
	will_weaken = FALSE
	will_paralyze = FALSE
	will_sleep = FALSE
	will_blind = FALSE

/// Remote view that only allows decoupling a turf view by movement. Seperate from effect_immune to allow for easier removal in the future if the underlying issue that makes this needed is someday fixed
/datum/remote_view_config/turf_decoupling
	forbid_movement = TRUE
	will_death = TRUE
	will_stun = FALSE
	will_weaken = FALSE
	will_paralyze = FALSE
	will_sleep = FALSE
	will_blind = FALSE

/// Remote view that only allows decoupling a turf view by movement. Seperate from effect_immune to allow for easier removal in the future if the underlying issue that makes this needed is someday fixed
/datum/remote_view_config/looking_up
	forbid_movement = TRUE
	use_zoom_hud = TRUE

/// Remote view that relays movement to the remote_view_target
/datum/remote_view_config/relay_movement
	relay_movement = TRUE

/// Remote view that relays movement and hides most of the hud
/datum/remote_view_config/zoomed_item
	relay_movement = TRUE
	use_zoom_hud = TRUE

/// Remote view that respects camera vision flags and checking for functionality of the camera.
/datum/remote_view_config/camera_standard
	use_zoom_hud = TRUE

/datum/remote_view_config/camera_standard/handle_apply_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	var/obj/machinery/camera/view_camera = owner_component.get_target()
	if(!view_camera || !view_camera.can_use())
		host_mob.reset_perspective()
		return
	if(view_camera.isXRay())
		host_mob.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
