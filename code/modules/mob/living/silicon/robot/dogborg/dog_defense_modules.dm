/obj/item/shield_projector/line/exploborg
	name = "expirmental shield projector"
	description_info = "This creates a shield in a straight line perpendicular to the direction where the user was facing when it was activated. \
	The shield allows projectiles to leave from inside but blocks projectiles from outside.  Everything else can pass through the shield freely, \
	including other people and thrown objects.  The shield also cannot block certain effects which take place over an area, such as flashbangs or explosions."
	shield_health = 90
	max_shield_health = 90
	shield_regen_amount = 25
	line_length = 7			// How long the line is.  Recommended to be an odd number.
	offset_from_center = 2	// How far from the projector will the line's center be.

// To repair a single module
/obj/item/self_repair_system
	name = "plating repair system"
	desc = "A nanite control system to repair damaged armour plating and wiring while not moving. Destroyed armour can't be restored."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "armor"
	var/repair_time = 25
	var/repair_amount = 2.5
	var/power_tick = 25
	var/disabled_icon = "armor"
	var/active_icon = "armor_broken"
	var/list/target_components = list("armour")
	var/repairing = FALSE
	flags = NOBLUDGEON

/obj/item/self_repair_system/attack_self(mob/user)
	if(repairing)
		return
	var/mob/living/silicon/robot/R = user
	var/destroyed_components = FALSE
	var/list/repairable_components = list()
	for(var/target_component in target_components)
		var/datum/robot_component/C = R.components[target_component]
		if(!C)
			continue
		if(istype(C.wrapped, /obj/item/broken_device))
			destroyed_components = TRUE
		else if (C.brute_damage != 0 || C.electronics_damage != 0)
			repairable_components += C
	if(!repairable_components.len && destroyed_components)
		to_chat(R, span_warning("Repair system initialization failed. Can't repair destroyed [target_components.len == 1 ? "[R.components[target_components[1]]]'s" : "component's"] plating or wiring."))
		return
	if(!repairable_components.len)
		to_chat(R, span_warning("No brute or burn damage detected [target_components.len == 1 ? "in [R.components[target_components[1]]]" : ""]."))
		return
	if(destroyed_components)
		to_chat(R, span_warning("WARNING! Destroyed modules detected. Those can not be repaired!"))
	icon_state = active_icon
	update_icon()
	repairing = TRUE
	for(var/datum/robot_component/C in repairable_components)
		to_chat(R, span_notice("Repair system initializated. Repairing plating and wiring of [C]."))
		src.self_repair(R, C, repair_time, repair_amount)
	repairing = FALSE
	icon_state = disabled_icon
	update_icon()

/obj/item/self_repair_system/proc/self_repair(mob/living/silicon/robot/R, datum/robot_component/C, var/tick_delay, var/heal_per_tick)
	if(!C || !R.cell)
		return
	if(C.brute_damage == 0 && C.electronics_damage == 0)
		to_chat(R, span_notice("Repair of [C] completed."))
		return
	if(!R.use_direct_power(power_tick,  500)) //We don't want to drain ourselves too far down during exploration
		to_chat(R, span_warning("Not enough power to initialize the repair system."))
		return
	if(do_after(R, tick_delay))
		if(!C)
			return
		C.brute_damage -= min(C.brute_damage, heal_per_tick)
		C.electronics_damage -= min(C.electronics_damage, heal_per_tick)
		R.updatehealth()
		src.self_repair(R, C, tick_delay, heal_per_tick)

// To repair multiple modules
/obj/item/self_repair_system/advanced
	name = "self repair system"
	desc = "A nanite control system to repair damaged components while not moving. Destroyed components can't be restored."
	target_components = list("actuator", "radio", "power cell", "diagnosis unit", "camera", "comms", "armour")
	power_tick = 10
	repair_time = 15
	repair_amount = 3
