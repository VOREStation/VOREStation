//Space bears!
/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"

	faction = "russian"
	intelligence_level = SA_ANIMAL
	cooperative = 1

	maxHealth = 120
	health = 120
	turns_per_move = 5
	see_in_dark = 6
	stop_when_pulled = 0

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

	melee_damage_lower = 20
	melee_damage_upper = 30

	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	speak_chance = 1
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat

//	var/stance_step = 0

/mob/living/simple_animal/hostile/bear/handle_stance(var/new_stance)
	// Below was a bunch of code that made this specific mob be 'alert' and will hurt you when it gets closer.
	// It's commented out because it made infinite loops and the AI is going to be moved/rewritten sometime soon (famous last words)
	// and it would be better if this 'alert before attacking' behaviour was on the parent instead of a specific type of mob anyways.

	// Instead we're just gonna get angry if we're dying.
	..(new_stance)
	if(stance == STANCE_ATTACK || stance == STANCE_ATTACKING)
		if((health / maxHealth) <= 0.5) // At half health, and fighting someone currently.
			add_modifier(/datum/modifier/berserk, 30 SECONDS)

	/*
	switch(stance)
		if(STANCE_TIRED)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(target_mob && target_mob in ListTargets(10))
					handle_stance(STANCE_ATTACK) //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					handle_stance(STANCE_IDLE)

		if(STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target_mob && target_mob in ListTargets(10))
				if(!(SA_attackable(target_mob)))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					src.set_dir(get_dir(src,target_mob))	//Keep staring at the mob

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "growls at [target_mob]", "stares angrily at [target_mob]", "prepares to attack [target_mob]", "closely watches [target_mob]" ) )
						if(action)
							custom_emote(1,action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have not found a mob for 20-ish ticks, revert to idle mode
				handle_stance(STANCE_IDLE)
			if(stance_step >= 7)   //If we have been staring at a mob for 7 ticks,
				handle_stance(STANCE_ATTACK)

		if(STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				custom_emote(1, "is worn out and needs to rest." )
				handle_stance(STANCE_TIRED)
				stance_step = 0
				walk(src, 0) //This stops the bear's walking
				return
		else
			..()
	*/

/mob/living/simple_animal/hostile/bear/update_icons()
	..()
	if(!stat)
		if(loc && istype(loc,/turf/space))
			icon_state = "bear"
		else
			icon_state = "bearfloor"

/mob/living/simple_animal/hostile/bear/Process_Spacemove(var/check_drift = 0)
	return

/mob/living/simple_animal/hostile/bear/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"stares alertly at [.]")
//		handle_stance(STANCE_ALERT)

/mob/living/simple_animal/hostile/bear/PunchTarget()
	if(!Adjacent(target_mob))
		return
	custom_emote(1, pick( list("slashes at [target_mob]", "bites [target_mob]") ) )

	var/damage = rand(melee_damage_lower, melee_damage_upper)

	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/dam_zone = pick(BP_TORSO, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG)
		var/obj/item/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), H.get_armor_soak(affecting, "melee"), sharp=1, edge=1)
		return H
	else if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.adjustBruteLoss(damage)
		return L
	else
		..()
