/mob/living/silicon/robot/Life()
	set invisibility = 0

	if (transforming)
		return

	blinded = null

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
	if (stat != DEAD) //still using power
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
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if ( cell && is_component_functioning("power cell") && cell.charge > 0 )
		if(module_state_1)
			cell_use_power(50) // 50W load for every enabled tool TODO: tool-specific loads
		if(module_state_2)
			cell_use_power(50)
		if(module_state_3)
			cell_use_power(50)

		if(lights_on)
			cell_use_power(30) 	// 30W light. Normal lights would use ~15W, but increased for balance reasons.

		has_power = 1
	else
		if (has_power)
			to_chat(src, span_red("You are now running on emergency backup power."))
		has_power = 0
		if(lights_on) // Light is on but there is no power!
			lights_on = 0
			set_light(0)

/mob/living/silicon/robot/handle_regular_status_updates()

	if(camera && !scrambledcodes)
		if(stat == 2 || wires.is_cut(WIRE_BORG_CAMERA))
			camera.set_status(0)
		else
			camera.set_status(1)

	updatehealth()

	if(sleeping)
		Paralyse(3)
		AdjustSleeping(-1)

	//if(resting) // VOREStation edit. Our borgos would rather not.
	//	Weaken(5)

	if(health < CONFIG_GET(number/health_threshold_dead) && stat != 2) //die only once
		death()

	if (stat != 2) //Alive.
		if (weakened > 0)	// Do not fullstun on weaken
			AdjustWeakened(-1)
		if (paralysis || stunned || !has_power) //Stunned etc.
			set_stat(UNCONSCIOUS)
			if (stunned > 0)
				AdjustStunned(-1)
			if (weakened > 0)
				AdjustWeakened(-1)
			if (paralysis > 0)
				AdjustParalysis(-1)
				blinded = 1
			else
				blinded = 0

		else	//Not stunned.
			if(stat != 0) //We are just getting done with being stunned
				set_stat(CONSCIOUS)
				update_icon()

		AdjustConfused(-1)

	else //Dead or just unconscious.
		blinded = 1

	if (stuttering) stuttering--

	if (eye_blind)
		AdjustBlinded(-1)
		blinded = 1

	if (ear_deaf > 0) ear_deaf--
	if (ear_damage < 25)
		ear_damage -= 0.05
		ear_damage = max(ear_damage, 0)

	density = !( lying )

	if (sdisabilities & BLIND)
		blinded = 1
	if (sdisabilities & DEAF)
		ear_deaf = 1

	if (eye_blurry > 0)
		eye_blurry--
		eye_blurry = max(0, eye_blurry)

	if (druggy > 0)
		druggy--
		druggy = max(0, druggy)

	//update the state of modules and components here
	if (stat != 0)
		uneq_all()

	if(radio)
		if(!is_component_functioning("radio"))
			radio.on = 0
		else
			radio.on = 1

	if(is_component_functioning("camera"))
		blinded = 0
	else
		blinded = 1

	return 1

/mob/living/silicon/robot/handle_regular_hud_updates()
	var/fullbright = FALSE
	var/seemeson = FALSE
	var/seejanhud = sight_mode & BORGJAN

	var/area/A = get_area(src)
	if(A?.flag_check(AREA_NO_SPOILERS))
		disable_spoiler_vision()

	if (stat == DEAD || (XRAY in mutations) || (sight_mode & BORGXRAY))
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if ((sight_mode & BORGMESON) && (sight_mode & BORGTHERM))
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
		fullbright = TRUE
	else if (sight_mode & BORGMESON)
		sight |= SEE_TURFS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
		fullbright = TRUE
		seemeson = TRUE
	else if (sight_mode & BORGMATERIAL)
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
		fullbright = TRUE
	else if (sight_mode & BORGTHERM)
		sight |= SEE_MOBS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
		fullbright = TRUE
	else if (sight_mode & BORGANOMALOUS)
		see_in_dark = 8
		see_invisible = INVISIBILITY_SHADEKIN
		fullbright = TRUE
	else if (!seedarkness)
		sight &= ~SEE_MOBS
		sight &= ~SEE_TURFS
		sight &= ~SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_NOLIGHTING
	else if (stat != DEAD)
		sight &= ~SEE_MOBS
		sight &= ~SEE_TURFS
		sight &= ~SEE_OBJS
		see_in_dark = 8 			 // see_in_dark means you can FAINTLY see in the dark, humans have a range of 3 or so, tajaran have it at 8
		see_invisible = SEE_INVISIBLE_LIVING // This is normal vision (25), setting it lower for normal vision means you don't "see" things like darkness since darkness
							 // has a "invisible" value of 15

	if(plane_holder)
		plane_holder.set_vis(VIS_FULLBRIGHT,fullbright)
		plane_holder.set_vis(VIS_MESONS,seemeson)
		plane_holder.set_vis(VIS_JANHUD,seejanhud)

	..()

	if (healths)
		if (stat != 2)
			if(istype(src,/mob/living/silicon/robot/drone))
				switch(health)
					if(35 to INFINITY)
						healths.icon_state = "health0"
					if(25 to 34)
						healths.icon_state = "health1"
					if(15 to 24)
						healths.icon_state = "health2"
					if(5 to 14)
						healths.icon_state = "health3"
					if(0 to 4)
						healths.icon_state = "health4"
					if(-35 to 0)
						healths.icon_state = "health5"
					else
						healths.icon_state = "health6"
			else
				if(health >= 200)
					healths.icon_state = "health0"
				else if(health >= 150)
					healths.icon_state = "health1"
				else if(health >= 100)
					healths.icon_state = "health2"
				else if(health >= 50)
					healths.icon_state = "health3"
				else if(health >= 0)
					healths.icon_state = "health4"
				else if(health >= CONFIG_GET(number/health_threshold_dead))
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	if (syndicate && client)
		for(var/datum/mind/tra in traitors.current_antagonists)
			if(tra.current)
				// TODO: Update to new antagonist system.
				var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
				client.images += I
		disconnect_from_ai()
		if(mind)
			// TODO: Update to new antagonist system.
			if(!mind.special_role)
				mind.special_role = "traitor"
				traitors.current_antagonists |= mind

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
//	if (oxygen) oxygen.icon_state = "oxy[oxygen_alert ? 1 : 0]"
//	if (fire) fire.icon_state = "fire[fire_alert ? 1 : 0]"

	if(stat != 2)
		if(blinded)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)

	if (machine)
		if (machine.check_eye(src) < 0)
			reset_view(null)
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
	//update_icon() //Removed and moved to robot/inventory.dm so it's not being called EVERY LIFE TICK

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(client)
				to_chat(src, span_danger("Killswitch Activated"))
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(client)
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
		set_light(integrated_light_power, 1, robot_light_col)
		return TRUE
	else
		. = ..()
