/mob/living/simple_mob/Life()
	..()

	//Health
	updatehealth()
	if(stat >= DEAD)
		return FALSE

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_supernatural()
	handle_atmos()

	handle_special()

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
	if(nutrition_icon)
		var/food_per = (nutrition / initial(nutrition)) * 100
		switch(food_per)
			if(90 to INFINITY)
				nutrition_icon.icon_state = "nutrition0"
			if(75 to 90)
				nutrition_icon.icon_state = "nutrition1"
			if(50 to 75)
				nutrition_icon.icon_state = "nutrition2"
			if(25 to 50)
				nutrition_icon.icon_state = "nutrition3"
			if(0 to 25)
				nutrition_icon.icon_state = "nutrition4"

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

			if(min_oxy)
				if(Environment.gas["oxygen"] < min_oxy)
					atmos_unsuitable = 1
			if(max_oxy)
				if(Environment.gas["oxygen"] > max_oxy)
					atmos_unsuitable = 1
			if(min_tox)
				if(Environment.gas["phoron"] < min_tox)
					atmos_unsuitable = 2
			if(max_tox)
				if(Environment.gas["phoron"] > max_tox)
					atmos_unsuitable = 2
			if(min_n2)
				if(Environment.gas["nitrogen"] < min_n2)
					atmos_unsuitable = 1
			if(max_n2)
				if(Environment.gas["nitrogen"] > max_n2)
					atmos_unsuitable = 1
			if(min_co2)
				if(Environment.gas["carbon_dioxide"] < min_co2)
					atmos_unsuitable = 1
			if(max_co2)
				if(Environment.gas["carbon_dioxide"] > max_co2)
					atmos_unsuitable = 1

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustFireLoss(cold_damage_per_tick)
		if(fire)
			fire.icon_state = "fire1"
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustFireLoss(heat_damage_per_tick)
		if(fire)
			fire.icon_state = "fire2"
	else
		fire_alert = 0
		if(fire)
			fire.icon_state = "fire0"

	if(atmos_unsuitable)
		adjustOxyLoss(unsuitable_atoms_damage)
		if(oxygen)
			oxygen.icon_state = "oxy1"
	else if(oxygen)
		if(oxygen)
			oxygen.icon_state = "oxy0"
		adjustOxyLoss(-unsuitable_atoms_damage)


/mob/living/simple_mob/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_mob/death(gibbed, deathmessage = "dies!")
	density = 0 //We don't block even if we did before

	if(has_eye_glow)
		remove_eyes()

	if(loot_list.len) //Drop any loot
		for(var/path in loot_list)
			if(prob(loot_list[path]))
				new path(get_turf(src))

	spawn(3) //We'll update our icon in a sec
		update_icon()

	return ..(gibbed,deathmessage)