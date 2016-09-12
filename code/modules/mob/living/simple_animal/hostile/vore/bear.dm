//Space bears!
/mob/living/simple_animal/hostile/vore/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "spacebear"
	icon_living = "spacebear"
	icon_dead = "spacebear-dead"
	icon_gib = "bear-gib"
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	stop_automated_movement_when_pulled = 0
	maxHealth = 60
	health = 60
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
	var/stance_step = 0

	faction = "russian"

/mob/living/simple_animal/hostile/vore/bear/brown
	name = "brown bear"
	desc = "RawrRawr!!"
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"

//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/vore/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

/mob/living/simple_animal/hostile/vore/bear/Life()
	. =..()
	if(!.)
		return
/*
	if(loc && istype(loc,/turf/space))
		icon_state = "bear"
	else
		icon_state = "bearfloor"
*/
	switch(stance)

		if(STANCE_TIRED)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(target_mob && target_mob in ListTargets(10))
					stance = STANCE_ATTACK //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					stance = STANCE_IDLE

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
				stance = STANCE_IDLE
			if(stance_step >= 7)   //If we have been staring at a mob for 7 ticks,
				stance = STANCE_ATTACK

		if(STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				custom_emote(1, "is worn out and needs to rest." )
				stance = STANCE_TIRED
				stance_step = 0
				walk(src, 0) //This stops the bear's walking
				return



/mob/living/simple_animal/hostile/vore/bear/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stance != STANCE_ATTACK && stance != STANCE_ATTACKING)
		stance = STANCE_ALERT
		stance_step = 6
		target_mob = user
	..()

/mob/living/simple_animal/hostile/vore/bear/attack_hand(mob/living/carbon/human/M as mob)
	if(stance != STANCE_ATTACK && stance != STANCE_ATTACKING)
		stance = STANCE_ALERT
		stance_step = 6
		target_mob = M
	..()
/*
/mob/living/simple_animal/hostile/vore/bear/Process_Spacemove(var/check_drift = 0)
	return	//No drifting in space for space bears!
*/
/mob/living/simple_animal/hostile/vore/bear/FindTarget() // TODO: Make it so if the target is laying down, the bear actually won't bother them.
	. = ..()
	if(.)
		custom_emote(1,"stares alertly at [.]")
		stance = STANCE_ALERT

/mob/living/simple_animal/hostile/vore/bear/LoseTarget()
	..(5)

/mob/living/simple_animal/hostile/vore/bear/AttackingTarget()

	// Need to snowflake the vode in the bear code here because of the snowflakey way bears work.
	if(isliving(target_mob.loc)) //They're inside a mob, maybe us, ignore!
		return

	if(!isliving(target_mob)) //Can't eat 'em if they ain't alive. Prevents eating borgs/bots.
		..()
		return

	if(picky && target_mob.digestable && target_mob.lying && target_mob.size_multiplier >= min_size && target_mob.size_multiplier <= max_size && !(target_mob in prey_exclusions))
		if(capacity)
			var/check_size = target_mob.size_multiplier + fullness
			if(check_size <= capacity)
				animal_nom(target_mob)
		else
			animal_nom(target_mob)
		return

	// Original bear attack code.
	if(!Adjacent(target_mob))
		return
	custom_emote(1, pick( list("slashes at [target_mob]", "bites [target_mob]") ) )

	var/damage = rand(20,30)

	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/dam_zone = pick(BP_TORSO, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG)
		var/obj/item/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), sharp=1, edge=1)
		return H
	else if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.adjustBruteLoss(damage)
		return L
