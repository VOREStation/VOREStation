/obj/item/mecha_parts/mecha_equipment/tool/jetpack
	name = "ion jetpack"
	desc = "Using directed ion bursts and cunning solar wind reflection technique, this device enables controlled space flight."
	icon_state = "mecha_jetpack"
	equip_cooldown = 5
	energy_drain = 50
	var/wait = 0
	var/datum/effect/effect/system/ion_trail_follow/ion_trail


/obj/item/mecha_parts/mecha_equipment/tool/jetpack/can_attach(obj/mecha/M as obj)
	if(!(locate(src.type) in M.equipment) && !M.proc_res["dyndomove"])
		return ..()

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/detach()
	..()
	chassis.proc_res["dyndomove"] = null
	return

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/attach(obj/mecha/M as obj)
	..()
	if(!ion_trail)
		ion_trail = new
	ion_trail.set_up(chassis)
	return

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/proc/toggle()
	if(!chassis)
		return
	!equip_ready? turn_off() : turn_on()
	return equip_ready

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/proc/turn_on()
	set_ready_state(0)
	chassis.proc_res["dyndomove"] = src
	ion_trail.start()
	occupant_message("Activated")
	log_message("Activated")

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/proc/turn_off()
	set_ready_state(1)
	chassis.proc_res["dyndomove"] = null
	ion_trail.stop()
	occupant_message("Deactivated")
	log_message("Deactivated")

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/proc/dyndomove(direction)
	if(!action_checks())
		return chassis.dyndomove(direction)
	var/move_result = 0
	if(chassis.hasInternalDamage(MECHA_INT_CONTROL_LOST))
		move_result = step_rand(chassis)
	else if(chassis.dir!=direction)
		chassis.set_dir(direction)
		move_result = 1
	else
		move_result	= step(chassis,direction)
		if(chassis.occupant)
			for(var/obj/effect/speech_bubble/B in range(1, chassis))
				if(B.parent == chassis.occupant)
					B.loc = chassis.loc
	if(move_result)
		wait = 1
		chassis.use_power(energy_drain)
		if(!chassis.pr_inertial_movement.active())
			chassis.pr_inertial_movement.start(list(chassis,direction))
		else
			chassis.pr_inertial_movement.set_process_args(list(chassis,direction))
		do_after_cooldown()
		return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/action_checks()
	if(equip_ready || wait)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	if(chassis.check_for_support())
		return 0
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] \[<a href=\"?src=\ref[src];toggle=1\">Toggle</a>\]"

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/Topic(href,href_list)
	..()
	if(href_list["toggle"])
		toggle()

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/do_after_cooldown()
	sleep(equip_cooldown)
	wait = 0
	return 1