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
	// turf release flag
	var/release_view_to_turf = FALSE

/datum/remote_view_config/proc/register_signals(mob/host_mob, datum/component/remote_view/component)
	RETURN_TYPE(null)
	SHOULD_NOT_OVERRIDE(TRUE)
	// Basic handling
	if(forbid_movement)
		component.RegisterSignal(host_mob, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/remote_view, handle_hostmob_moved))
	else
		component.RegisterSignal(host_mob, COMSIG_MOVABLE_Z_CHANGED, TYPE_PROC_REF(/datum/component/remote_view, handle_hostmob_moved))
	// Upon any disruptive status effects
	if(will_stun)
		component.RegisterSignal(host_mob, COMSIG_LIVING_STATUS_STUN, TYPE_PROC_REF(/datum/component/remote_view, handle_status_effects))
	if(will_weaken)
		component.RegisterSignal(host_mob, COMSIG_LIVING_STATUS_WEAKEN, TYPE_PROC_REF(/datum/component/remote_view, handle_status_effects))
	if(will_paralyze)
		component.RegisterSignal(host_mob, COMSIG_LIVING_STATUS_PARALYZE, TYPE_PROC_REF(/datum/component/remote_view, handle_status_effects))
	if(will_sleep)
		component.RegisterSignal(host_mob, COMSIG_LIVING_STATUS_SLEEP, TYPE_PROC_REF(/datum/component/remote_view, handle_status_effects))
	if(will_blind)
		component.RegisterSignal(host_mob, COMSIG_LIVING_STATUS_BLIND, TYPE_PROC_REF(/datum/component/remote_view, handle_status_effects))
	if(will_death)
		component.RegisterSignal(host_mob, COMSIG_MOB_DEATH, TYPE_PROC_REF(/datum/component/remote_view, handle_endview))
	RegisterSignal(host_mob, COMSIG_MOB_HANDLE_VISION, PROC_REF(handle_apply_visuals))
	// Hud overrides
	if(override_entire_hud)
		RegisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD, PROC_REF(handle_hud_override))
	if(override_health_hud)
		RegisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_HEALTH_ICON, PROC_REF(handle_hud_health))
	if(override_darkvision_hud)
		RegisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_DARKSIGHT, PROC_REF(handle_hud_darkvision))

/datum/remote_view_config/proc/unregister_signals(mob/host_mob, datum/component/remote_view/component)
	RETURN_TYPE(null)
	SHOULD_NOT_OVERRIDE(TRUE)
	// Basic handling
	if(forbid_movement)
		component.UnregisterSignal(host_mob, COMSIG_MOVABLE_MOVED)
	else
		component.UnregisterSignal(host_mob, COMSIG_MOVABLE_Z_CHANGED)
	// Status effects
	if(will_stun)
		component.UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_STUN)
	if(will_weaken)
		component.UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_WEAKEN)
	if(will_paralyze)
		component.UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_PARALYZE)
	if(will_sleep)
		component.UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_SLEEP)
	if(will_blind)
		component.UnregisterSignal(host_mob, COMSIG_LIVING_STATUS_BLIND)
	if(will_death)
		component.UnregisterSignal(host_mob, COMSIG_MOB_DEATH)
	UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_VISION)
	// Hud overrides
	if(override_entire_hud)
		UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD)
	if(override_health_hud)
		UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_HEALTH_ICON)
	if(override_darkvision_hud)
		UnregisterSignal(host_mob, COMSIG_MOB_HANDLE_HUD_DARKSIGHT)

/// Called when remote view component finishes attaching to the mob
/datum/remote_view_config/proc/attached_to_mob(datum/component/remote_view/owner_component, mob/host_mob)
	RETURN_TYPE(null)
	return

/// Called when remote view component is destroyed
/datum/remote_view_config/proc/detatch_from_mob(datum/component/remote_view/owner_component, mob/host_mob)
	RETURN_TYPE(null)
	return

/// Handles relayed movement during a remote view. Override this in a subtype to handle specialized logic. If it returns true, the mob will not move, allowing you to handle remotely controlled movement.
/datum/remote_view_config/proc/handle_relay_movement(datum/component/remote_view/owner_component, mob/host_mob, datum/coordinator, atom/movable/remote_view_target, direction)
	SIGNAL_HANDLER
	return remote_view_target.relaymove(host_mob, direction)

/// Handles visual changes to mob's hud or flags when in use, it is fired every life tick.
/datum/remote_view_config/proc/handle_apply_visuals(mob/host_mob)
	SIGNAL_HANDLER
	RETURN_TYPE(null)
	return

/// Handles visual changes when ending the view
/datum/remote_view_config/proc/handle_remove_visuals(datum/component/remote_view/owner_component, mob/host_mob)
	SIGNAL_HANDLER
	RETURN_TYPE(null)
	return

/// Handles hud health indicator being replaced with a custom one (like showing the remote_view_target's health).
/datum/remote_view_config/proc/handle_hud_override(mob/host_mob)
	SIGNAL_HANDLER
	return COMSIG_COMPONENT_HANDLED_HUD

/// Handles hud health indicator being replaced with a custom one (like showing the remote_view_target's health).
/datum/remote_view_config/proc/handle_hud_health(mob/host_mob)
	SIGNAL_HANDLER
	return COMSIG_COMPONENT_HANDLED_HEALTH_ICON

/// Handles hud darkvision for if the remote view uses it's own logic for darkvision, or asks the remote_view_target to calculate it.
/datum/remote_view_config/proc/handle_hud_darkvision(mob/host_mob)
	SIGNAL_HANDLER
	RETURN_TYPE(null)
	return

/datum/remote_view_config/proc/get_component_coordinator(mob/host_mob)
	RETURN_TYPE(/atom)
	var/datum/component/remote_view/owner_component = host_mob.GetComponent(/datum/component/remote_view)
	return owner_component.get_coordinator()


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
	release_view_to_turf = TRUE

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
