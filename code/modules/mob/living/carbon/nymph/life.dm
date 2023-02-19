//Dionaea regenerate health and nutrition in light.
/mob/living/carbon/diona/handle_environment(datum/gas_mixture/environment)
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(loc)) //else, there's considered to be no light
		var/turf/T = loc
		light_amount = T.get_lumcount() * 5

	adjust_nutrition(light_amount)

	if(light_amount > 2) //if there's enough light, heal
		adjustBruteLoss(-1)
		adjustFireLoss(-1)
		adjustToxLoss(-1)
		adjustOxyLoss(-1)

 	if(!client)
 		handle_npc(src)


// Alien larva are quite simple.
/mob/living/carbon/diona/Life()
	set invisibility = 0
	set background = 1
	if(transforming || !loc)
		return

	..()

	if (stat != DEAD)
		update_progression() // GROW!

	blinded = 0
	update_icons()


/mob/living/carbon/diona/handle_mutations_and_radiation()
	// Currently Dionaea like to eat radiation
	if(!radiation)
		return

	var/rads = radiation/25
	radiation -= rads
	adjust_nutrition(rads)
	heal_overall_damage(rads,rads)
	adjustOxyLoss(-(rads))
	adjustToxLoss(-(rads))
	return


/mob/living/carbon/diona/handle_regular_status_updates()
	if(stat == DEAD)
		SetBlinded(TRUE)
		silent = FALSE
		return TRUE

	updatehealth()
	if(health <= 0)
		death()
		return handle_regular_status_updates()

	if(paralysis > 0)
		SetBlinded(TRUE)
		set_stat(UNCONSCIOUS)
		adjustHalLoss(-3)

	if(sleeping)
		adjustHalLoss(-3)
		if(mind && mind.active && client)
			AdjustSleeping(-1)
		SetBlinded(TRUE)
		set_stat(UNCONSCIOUS)
	else if(resting)
		adjustHalLoss(-3)
	else
		set_stat(CONSCIOUS)
		adjustHalLoss(-1)

	// Eyes and blindness.
	if(!has_eyes())
		SetBlinded(TRUE)
		eye_blurry = TRUE
	else if(eye_blind)
		AdjustBlinded(-1)
	else if(eye_blurry)
		eye_blurry = max(eye_blurry-1, 0)

	update_icons()
	return TRUE


/mob/living/carbon/diona/handle_regular_hud_updates()
	if(stat == DEAD)
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else
		sight &= ~SEE_TURFS
		sight &= ~SEE_MOBS
		sight &= ~SEE_OBJS
		see_in_dark = 2
		see_invisible = SEE_INVISIBLE_LIVING

	if(healths)
		if(stat == DEAD)
			healths.icon_state = "health7"
		else
			var/health_index = round((1 - health / maxHealth) * 5, 1)
			healths.icon_state = "health[health_index]"

	if(client)
		client.screen.Remove(global_hud.blurry,global_hud.druggy,global_hud.vimpaired)

	if (stat != DEAD)
		if ((blinded))
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, TRUE)
			set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)
		if(machine?.check_eye(src) < 0 || (client && !client.adminobs))
			reset_view(null)
	return TRUE


/mob/living/carbon/diona/handle_environment(var/datum/gas_mixture/environment)
	if(!environment)
		return

	if(environment.temperature > (T0C+66))
		adjustFireLoss((environment.temperature - (T0C+66))/5) // Might be too high, check in testing.
		throw_alert("alien_fire", /obj/screen/alert/alien_fire)
		if(prob(20))
			to_chat(src,SPAN_DANGER( "You feel a searing heat!"))
	else
		clear_alert("alien_fire")


/mob/living/carbon/diona/handle_fire()
	. = ..()
	if(!.) // True == Not on fire
		bodytemperature += BODYTEMP_HEATING_MAX //If you're on fire, you heat up!
