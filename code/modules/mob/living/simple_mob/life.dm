/mob/living/simple_mob/Life()
	..()

	//Health
	updatehealth()
	if(stat >= DEAD)
		return FALSE

	handle_sleeping()
	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_supernatural()
	handle_atmos()

	handle_special()

	handle_guts()
	do_healing()	//VOREStation Add

	return TRUE


//Should we be dead?
/mob/living/simple_mob/updatehealth()
	health = getMaxHealth() - getFireLoss() - getBruteLoss() - getToxLoss() - getOxyLoss() - getCloneLoss()

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Overhealth
	if(health > getMaxHealth())
		health = getMaxHealth()

	//Update our hud if we have one
	if(healths)
		if(stat != DEAD)
			var/heal_per = (health / getMaxHealth()) * 100
			switch(heal_per)
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

	//Updates the nutrition while we're here
	var/food_per = (nutrition / 500) * 100 //VOREStation Edit: Bandaid hardcode number to avoid misleading percentage based hunger alerts with our 6k cap.
	switch(food_per)
		if(90 to INFINITY)
			clear_alert("nutrition")
		if(50 to 90)
			throw_alert("nutrition", /obj/screen/alert/hungry)
		if(-INFINITY to 50)
			throw_alert("nutrition", /obj/screen/alert/starving)

//VOREStation ADD START - I made this for catslugs but tbh it's probably cool to give to everything.
//Gives all simplemobs passive healing as long as they can find food.
//Slow enough that it should affect combat basically not at all

/mob/living/simple_mob/proc/do_healing()
	if(nutrition < 150)
		return
	if(health == maxHealth)
		return
	if(heal_countdown > 0)
		heal_countdown --
		return
	if(resting)
		if(bruteloss > 0)
			adjustBruteLoss(-10)
		else if(fireloss > 0)
			adjustFireLoss(-10)
		nutrition -= 50
		heal_countdown = 5
		return
	if(bruteloss > 0)
		adjustBruteLoss(-1)
	else if(fireloss > 0)
		adjustFireLoss(-1)
	nutrition -= 5
	heal_countdown = 5
//VOREStation ADD END

// Override for special bullshit.
/mob/living/simple_mob/proc/handle_special()
	return


// Handle interacting with and taking damage from atmos
// TODO - Refactor this to use handle_environment() like a good /mob/living
/mob/living/simple_mob/proc/handle_atmos()
	var/atmos_unsuitable = 0

	if(in_stasis)
		return 1 // return early to skip atmos checks

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)

			if( abs(Environment.temperature - bodytemperature) > temperature_range )	//VOREStation Edit: heating adjustments
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy && Environment.gas[GAS_O2] < min_oxy)
				atmos_unsuitable = 1
				throw_alert("oxy", /obj/screen/alert/not_enough_oxy)
			else if(max_oxy && Environment.gas[GAS_O2] > max_oxy)
				atmos_unsuitable = 1
				throw_alert("oxy", /obj/screen/alert/too_much_oxy)
			else
				clear_alert("oxy")

			if(min_tox && Environment.gas[GAS_PHORON] < min_tox)
				atmos_unsuitable = 2
				throw_alert("tox_in_air", /obj/screen/alert/not_enough_tox)
			else if(max_tox && Environment.gas[GAS_PHORON] > max_tox)
				atmos_unsuitable = 2
				throw_alert("tox_in_air", /obj/screen/alert/tox_in_air)
			else
				clear_alert("tox_in_air")

			if(min_n2 && Environment.gas[GAS_N2] < min_n2)
				atmos_unsuitable = 1
				throw_alert("n2o", /obj/screen/alert/not_enough_nitro)
			else if(max_n2 && Environment.gas[GAS_N2] > max_n2)
				atmos_unsuitable = 1
				throw_alert("n2o", /obj/screen/alert/too_much_nitro)
			else
				clear_alert("n2o")

			if(min_co2 && Environment.gas[GAS_CO2] < min_co2)
				atmos_unsuitable = 1
				throw_alert("co2", /obj/screen/alert/not_enough_co2)
			else if(max_co2 && Environment.gas[GAS_CO2] > max_co2)
				atmos_unsuitable = 1
				throw_alert("co2", /obj/screen/alert/too_much_co2)
			else
				clear_alert("co2")

	//Atmos effect
	if(bodytemperature < minbodytemp)
		adjustFireLoss(cold_damage_per_tick)
		throw_alert("temp", /obj/screen/alert/cold, COLD_ALERT_SEVERITY_MAX)
	else if(bodytemperature > maxbodytemp)
		adjustFireLoss(heat_damage_per_tick)
		throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_MAX)
	else
		clear_alert("temp")

	if(atmos_unsuitable)
		adjustOxyLoss(unsuitable_atoms_damage)
	else
		adjustOxyLoss(-unsuitable_atoms_damage)

/mob/living/simple_mob/proc/handle_guts()
	for(var/obj/item/organ/OR in internal_organs)
		OR.process()

	for(var/obj/item/organ/OR in organs)
		OR.process()

/mob/living/simple_mob/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_mob/death(gibbed, deathmessage = "dies!")
	density = FALSE //We don't block even if we did before

	if(has_eye_glow)
		remove_eyes()

	if(loot_list.len) //Drop any loot
		for(var/path in loot_list)
			if(prob(loot_list[path]))
				new path(get_turf(src))

	spawn(3) //We'll update our icon in a sec
		update_icon()

	return ..(gibbed,deathmessage)
