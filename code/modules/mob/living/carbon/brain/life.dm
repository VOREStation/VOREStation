/mob/living/carbon/brain/handle_breathing()
	return

/mob/living/carbon/brain/handle_mutations_and_radiation()
	if (radiation)
		if (radiation > 100)
			radiation = 100
			if(!container)//If it's not in an MMI
				to_chat(src, span_red("You feel weak."))
			else//Fluff-wise, since the brain can't detect anything itself, the MMI handles thing like that
				to_chat(src, span_red("STATUS: CRITICAL AMOUNTS OF RADIATION DETECTED."))

		switch(radiation)
			if(1 to 49)
				radiation--
				if(prob(25))
					adjustToxLoss(1)
					updatehealth()

			if(50 to 74)
				radiation -= 2
				adjustToxLoss(1)
				if(prob(5))
					radiation -= 5
					if(!container)
						to_chat(src, span_red("You feel weak."))
					else
						to_chat(src, span_red("STATUS: DANGEROUS LEVELS OF RADIATION DETECTED."))
				updatehealth()

			if(75 to 100)
				radiation -= 3
				adjustToxLoss(3)
				updatehealth()


/mob/living/carbon/brain/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return
	var/environment_heat_capacity = environment.heat_capacity()
	if(istype(get_turf(src), /turf/space))
		var/turf/heat_turf = get_turf(src)
		environment_heat_capacity = heat_turf.heat_capacity

	if((environment.temperature > (T0C + 50)) || (environment.temperature < (T0C + 10)))
		var/transfer_coefficient = 1

		handle_temperature_damage(HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)

	if(stat==2)
		bodytemperature += 0.1*(environment.temperature - bodytemperature)*environment_heat_capacity/(environment_heat_capacity + 270000)

	//Account for massive pressure differences

	return //TODO: DEFERRED

/mob/living/carbon/brain/proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
	if(SEND_SIGNAL(src, COMSIG_CHECK_FOR_GODMODE) & COMSIG_GODMODE_CANCEL)
		return 0	// Cancelled by a component

	if(exposed_temperature > bodytemperature)
		var/discomfort = min( abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)
		//adjustFireLoss(2.5*discomfort)
		//adjustFireLoss(5.0*discomfort)
		adjustFireLoss(20.0*discomfort)

	else
		var/discomfort = min( abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)
		//adjustFireLoss(2.5*discomfort)
		adjustFireLoss(5.0*discomfort)


/mob/living/carbon/brain/handle_chemicals_in_body()
	chem_effects.Cut()

	if(touching) touching.metabolize()
	if(ingested) ingested.metabolize()
	if(bloodstr) bloodstr.metabolize()

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/brain/handle_regular_status_updates()	//TODO: comment out the unused bits >_>
	updatehealth()

	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		if( !container && (health < -getMaxHealth() || ((world.time - timeofhostdeath) > CONFIG_GET(number/revival_brain_life))) )
			death()
			blinded = 1
			silent = 0
			return 1

		//Handling EMP effect in the Life(), it's made VERY simply, and has some additional effects handled elsewhere
		if(emp_damage)			//This is pretty much a damage type only used by MMIs, dished out by the emp_act
			if(!(container && istype(container, /obj/item/mmi)))
				emp_damage = 0
			else
				emp_damage = round(emp_damage,1)//Let's have some nice numbers to work with
			switch(emp_damage)
				if(31 to INFINITY)
					emp_damage = 30//Let's not overdo it
				if(21 to 30)//High level of EMP damage, unable to see, hear, or speak
					SetBlinded(1)
					blinded = 1
					ear_deaf = 1
					silent = 1
					if(!alert)//Sounds an alarm, but only once per 'level'
						emote("alarm")
						to_chat(src, span_red("Major electrical distruption detected: System rebooting."))
						alert = 1
					if(prob(75))
						emp_damage -= 1
				if(20)
					alert = 0
					blinded = 0
					SetBlinded(0)
					ear_deaf = 0
					silent = 0
					emp_damage -= 1
				if(11 to 19)//Moderate level of EMP damage, resulting in nearsightedness and ear damage
					eye_blurry = 1
					ear_damage = 1
					if(!alert)
						emote("alert")
						to_chat(src, span_red("Primary systems are now online."))
						alert = 1
					if(prob(50))
						emp_damage -= 1
				if(10)
					alert = 0
					eye_blurry = 0
					ear_damage = 0
					emp_damage -= 1
				if(2 to 9)//Low level of EMP damage, has few effects(handled elsewhere)
					if(!alert)
						emote("notice")
						to_chat(src, span_red("System reboot nearly complete."))
						alert = 1
					if(prob(25))
						emp_damage -= 1
				if(1)
					alert = 0
					to_chat(src, span_red("All systems restored."))
					emp_damage -= 1

	return 1

/mob/living/carbon/brain/handle_regular_hud_updates()
	if (stat == 2 || (XRAY in src.mutations))
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if (stat != 2)
		sight &= ~SEE_TURFS
		sight &= ~SEE_MOBS
		sight &= ~SEE_OBJS
		see_in_dark = 2
		see_invisible = SEE_INVISIBLE_LIVING

	if (healths)
		if (stat != 2)
			switch(health)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

		if (stat == 2 || (XRAY in src.mutations))
			sight |= SEE_TURFS
			sight |= SEE_MOBS
			sight |= SEE_OBJS
			see_in_dark = 8
			see_invisible = SEE_INVISIBLE_LEVEL_TWO
		else if (stat != 2)
			sight &= ~SEE_TURFS
			sight &= ~SEE_MOBS
			sight &= ~SEE_OBJS
			see_in_dark = 2
			see_invisible = SEE_INVISIBLE_LIVING
	if (client)
		client.screen.Remove(GLOB.global_hud.blurry,GLOB.global_hud.druggy,GLOB.global_hud.vimpaired)

	if (stat != 2)
		if ((blinded))
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)

		if (machine)
			if (!( machine.check_eye(src) ))
				reset_view(null)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return 1
