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
	set_ready_state(FALSE)
	chassis.proc_res["dyndomove"] = src
	ion_trail.start()
	occupant_message("Activated")
	log_message("Activated")

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/proc/turn_off()
	set_ready_state(TRUE)
	chassis.proc_res["dyndomove"] = null
	ion_trail.stop()
	occupant_message("Deactivated")
	log_message("Deactivated")

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/proc/dyndomove(direction)
	if(!action_checks())
		return chassis.dyndomove(direction)
	var/move_result = 0
	if(direction == UP || direction == DOWN)
		if(!chassis.can_ztravel())
			chassis.occupant_message("<span class='warning'>Your vehicle lacks the capacity to move in that direction!</span>")
			return FALSE

		//We're using locs because some mecha are 2x2 turfs. So thicc!
		var/result = TRUE

		for(var/turf/T in chassis.locs)
			if(!T.CanZPass(chassis,direction))
				chassis.occupant_message("<span class='warning'>You can't move that direction from here!</span>")
				result = FALSE
				break
			var/turf/dest = (direction == UP) ? GetAbove(chassis) : GetBelow(chassis)
			if(!dest)
				chassis.occupant_message("<span class='notice'>There is nothing of interest in this direction.</span>")
				result = FALSE
				break
			if(!dest.CanZPass(chassis,direction))
				chassis.occupant_message("<span class='warning'>There's something blocking your movement in that direction!</span>")
				result = FALSE
				break
		if(result)
			move_result = chassis.mechstep(direction)

		if(move_result)
			chassis.can_move = 0
			chassis.use_power(chassis.step_energy_drain)
			if(istype(chassis.loc, /turf/space))
				if(!chassis.check_for_support())
					chassis.float_direction = direction
					chassis.start_process(MECHA_PROC_MOVEMENT)
					chassis.log_message("<span class='warning'>Movement control lost. Inertial movement started.</span>")
			if(chassis.do_after(get_step_delay()))
				chassis.can_move = 1
			return 1
		return 0
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
		chassis.float_direction = direction
		if(!(chassis.current_processes & MECHA_PROC_MOVEMENT))
			chassis.start_process(MECHA_PROC_MOVEMENT)
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

/obj/item/mecha_parts/mecha_equipment/tool/jetpack/check_ztravel()
	return equip_ready
