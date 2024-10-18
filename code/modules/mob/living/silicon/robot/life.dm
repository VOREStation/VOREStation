/mob/living/silicon/robot/Life()
	set invisibility = 0
	set background = 1

	if (src.transforming)
		return

	src.blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()
	handle_instability()
	// For some reason borg Life() doesn't call ..()
	handle_modifiers()
	handle_light()

	if(client)
		handle_regular_hud_updates()
		handle_vision()
		update_items()
	if (src.stat != DEAD) //still using power
		use_power()
		process_killswitch()
		process_locks()
		process_queued_alarms()
	update_canmove()

/mob/living/silicon/robot/proc/clamp_values()

//	SetStunned(min(stunned, 30))
	SetParalysis(min(paralysis, 30))
//	SetWeakened(min(weakened, 20))
	SetSleeping(0)
	adjustBruteLoss(0)
	adjustToxLoss(0)
	adjustOxyLoss(0)
	adjustFireLoss(0)

/mob/living/silicon/robot/proc/use_power()
	// Debug only
	// to_world("DEBUG: life.dm line 35: cyborg use_power() called at tick [controller_iteration]")
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if ( cell && is_component_functioning("power cell") && src.cell.charge > 0 )
		if(src.module_state_1)
			cell_use_power(50) // 50W load for every enabled tool TODO: tool-specific loads
		if(src.module_state_2)
			cell_use_power(50)
		if(src.module_state_3)
			cell_use_power(50)

		if(lights_on)
			cell_use_power(30) 	// 30W light. Normal lights would use ~15W, but increased for balance reasons.

		src.has_power = 1
	else
		if (src.has_power)
			to_chat(src, span_red("You are now running on emergency backup power."))
		src.has_power = 0
		if(lights_on) // Light is on but there is no power!
			lights_on = 0
			set_light(0)

/mob/living/silicon/robot/handle_regular_status_updates()

	if(src.camera && !scrambledcodes)
		if(src.stat == 2 || wires.is_cut(WIRE_BORG_CAMERA))
			src.camera.set_status(0)
		else
			src.camera.set_status(1)

	updatehealth()

	if(src.sleeping)
		Paralyse(3)
		AdjustSleeping(-1)

	//if(src.resting) // VOREStation edit. Our borgos would rather not.
	//	Weaken(5)

	if(health < config.health_threshold_dead && src.stat != 2) //die only once
		death()

	if (src.stat != 2) //Alive.
		if (src.weakened > 0)	// Do not fullstun on weaken
			AdjustWeakened(-1)
		if (src.paralysis || src.stunned || !src.has_power) //Stunned etc.
			src.set_stat(UNCONSCIOUS)
			if (src.stunned > 0)
				AdjustStunned(-1)
			if (src.weakened > 0)
				AdjustWeakened(-1)
			if (src.paralysis > 0)
				AdjustParalysis(-1)
				src.blinded = 1
			else
				src.blinded = 0

		else	//Not stunned.
			src.set_stat(CONSCIOUS)

		AdjustConfused(-1)

	else //Dead or just unconscious.
		src.blinded = 1

	if (src.stuttering) src.stuttering--

	if (src.eye_blind)
		src.AdjustBlinded(-1)
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf--
	if (src.ear_damage < 25)
		src.ear_damage -= 0.05
		src.ear_damage = max(src.ear_damage, 0)

	src.density = !( src.lying )

	if (src.sdisabilities & BLIND)
		src.blinded = 1
	if (src.sdisabilities & DEAF)
		src.ear_deaf = 1

	if (src.eye_blurry > 0)
		src.eye_blurry--
		src.eye_blurry = max(0, src.eye_blurry)

	if (src.druggy > 0)
		src.druggy--
		src.druggy = max(0, src.druggy)

	//update the state of modules and components here
	if (src.stat != 0)
		uneq_all()

	if(radio)
		if(!is_component_functioning("radio"))
			radio.on = 0
		else
			radio.on = 1

	if(is_component_functioning("camera"))
		src.blinded = 0
	else
		src.blinded = 1

	return 1

/mob/living/silicon/robot/handle_regular_hud_updates()
	var/fullbright = FALSE
	var/seemeson = FALSE
	var/seejanhud = src.sight_mode & BORGJAN

	var/area/A = get_area(src)
	if(A?.no_spoilers)
		disable_spoiler_vision()

	if (src.stat == DEAD || (XRAY in mutations) || (src.sight_mode & BORGXRAY))
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.sight |= SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_MINIMUM
	else if ((src.sight_mode & BORGMESON) && (src.sight_mode & BORGTHERM))
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
		fullbright = TRUE
	else if (src.sight_mode & BORGMESON)
		src.sight |= SEE_TURFS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
		fullbright = TRUE
		seemeson = TRUE
	else if (src.sight_mode & BORGMATERIAL)
		src.sight |= SEE_OBJS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
		fullbright = TRUE
	else if (src.sight_mode & BORGTHERM)
		src.sight |= SEE_MOBS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_LEVEL_TWO
		fullbright = TRUE
	else if (src.sight_mode & BORGANOMALOUS)
		src.see_in_dark = 8
		src.see_invisible = INVISIBILITY_SHADEKIN
		fullbright = TRUE
	else if (!seedarkness)
		src.sight &= ~SEE_MOBS
		src.sight &= ~SEE_TURFS
		src.sight &= ~SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_NOLIGHTING
	else if (src.stat != DEAD)
		src.sight &= ~SEE_MOBS
		src.sight &= ~SEE_TURFS
		src.sight &= ~SEE_OBJS
		src.see_in_dark = 8 			 // see_in_dark means you can FAINTLY see in the dark, humans have a range of 3 or so, tajaran have it at 8
		src.see_invisible = SEE_INVISIBLE_LIVING // This is normal vision (25), setting it lower for normal vision means you don't "see" things like darkness since darkness
							 // has a "invisible" value of 15

	if(plane_holder)
		plane_holder.set_vis(VIS_FULLBRIGHT,fullbright)
		plane_holder.set_vis(VIS_MESONS,seemeson)
		plane_holder.set_vis(VIS_JANHUD,seejanhud)

	..()

	if (src.healths)
		if (src.stat != 2)
			if(istype(src,/mob/living/silicon/robot/drone))
				switch(health)
					if(35 to INFINITY)
						src.healths.icon_state = "health0"
					if(25 to 34)
						src.healths.icon_state = "health1"
					if(15 to 24)
						src.healths.icon_state = "health2"
					if(5 to 14)
						src.healths.icon_state = "health3"
					if(0 to 4)
						src.healths.icon_state = "health4"
					if(-35 to 0)
						src.healths.icon_state = "health5"
					else
						src.healths.icon_state = "health6"
			else
				if(health >= 200)
					src.healths.icon_state = "health0"
				else if(health >= 150)
					src.healths.icon_state = "health1"
				else if(health >= 100)
					src.healths.icon_state = "health2"
				else if(health >= 50)
					src.healths.icon_state = "health3"
				else if(health >= 0)
					src.healths.icon_state = "health4"
				else if(health >= config.health_threshold_dead)
					src.healths.icon_state = "health5"
				else
					src.healths.icon_state = "health6"
		else
			src.healths.icon_state = "health7"

	if (src.syndicate && src.client)
		for(var/datum/mind/tra in traitors.current_antagonists)
			if(tra.current)
				// TODO: Update to new antagonist system.
				var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
				src.client.images += I
		src.disconnect_from_ai()
		if(src.mind)
			// TODO: Update to new antagonist system.
			if(!src.mind.special_role)
				src.mind.special_role = "traitor"
				traitors.current_antagonists |= src.mind

	update_cell()

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	if(environment)
		switch(environment.temperature) //310.055 optimal body temp
			if(400 to INFINITY)
				throw_alert("temp", /obj/screen/alert/hot/robot, HOT_ALERT_SEVERITY_MODERATE)
			if(360 to 400)
				throw_alert("temp", /obj/screen/alert/hot/robot, HOT_ALERT_SEVERITY_LOW)
			if(260 to 360)
				clear_alert("temp")
			if(200 to 260)
				throw_alert("temp", /obj/screen/alert/cold/robot, COLD_ALERT_SEVERITY_LOW)
			else
				throw_alert("temp", /obj/screen/alert/cold/robot, COLD_ALERT_SEVERITY_MODERATE)

//Oxygen and fire does nothing yet!!
//	if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
//	if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"

	if(stat != 2)
		if(blinded)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)

	if (src.machine)
		if (src.machine.check_eye(src) < 0)
			src.reset_view(null)
	else
		if(client && !client.adminobs)
			reset_view(null)

	if(emagged)
		throw_alert("hacked", /obj/screen/alert/hacked)
	else
		clear_alert("hacked")

	return 1

/mob/living/silicon/robot/proc/update_cell()
	if(cell)
		var/cellcharge = cell.charge/cell.maxcharge
		switch(cellcharge)
			if(0.75 to INFINITY)
				clear_alert("charge")
			if(0.5 to 0.75)
				throw_alert("charge", /obj/screen/alert/lowcell, 1)
			if(0.25 to 0.5)
				throw_alert("charge", /obj/screen/alert/lowcell, 2)
			if(0.01 to 0.25)
				throw_alert("charge", /obj/screen/alert/lowcell, 3)
			else
				throw_alert("charge", /obj/screen/alert/emptycell)
	else
		throw_alert("charge", /obj/screen/alert/nocell)


/mob/living/silicon/robot/proc/update_items()
	if(client)
		client.screen -= contents
		for(var/obj/I in contents)
			if(I && !(istype(I,/obj/item/cell) || istype(I,/obj/item/radio)  || istype(I,/obj/machinery/camera) || istype(I,/obj/item/mmi)))
				client.screen += I
	if(module_state_1)
		module_state_1:screen_loc = ui_inv1
	if(module_state_2)
		module_state_2:screen_loc = ui_inv2
	if(module_state_3)
		module_state_3:screen_loc = ui_inv3
	update_icon()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(src.client)
				to_chat(src, span_danger("Killswitch Activated"))
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(src.client)
				to_chat(src, span_danger("Weapon Lock Timed Out!"))
			weapon_lock = 0
			weaponlock_time = 120

/mob/living/silicon/robot/update_canmove()
	..() // Let's not reinvent the wheel.
	if(lockdown || !is_component_functioning("actuator"))
		canmove = FALSE
	return canmove

/mob/living/silicon/robot/update_fire()
	cut_overlay(image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state()))
	if(on_fire)
		add_overlay(image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state()))

/mob/living/silicon/robot/fire_act()
	if(!on_fire) //Silicons don't gain stacks from hotspots, but hotspots can ignite them
		IgniteMob()

/mob/living/silicon/robot/handle_light()
	if(lights_on)
		set_light(integrated_light_power, 1, "#FFFFFF")
		return TRUE
	else
		. = ..()
