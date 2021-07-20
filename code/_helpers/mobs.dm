/proc/random_hair_style(gender, species = SPECIES_HUMAN)
	var/h_style = "Bald"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

/proc/random_facial_hair_style(gender, species = SPECIES_HUMAN)
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

/proc/sanitize_name(name, species = SPECIES_HUMAN, robot = 0)
	var/datum/species/current_species
	if(species)
		current_species = GLOB.all_species[species]

	return current_species ? current_species.sanitize_name(name, robot) : sanitizeName(name, MAX_NAME_LEN, robot)

/proc/random_name(gender, species = SPECIES_HUMAN)

	var/datum/species/current_species
	if(species)
		current_species = GLOB.all_species[species]

	if(!current_species || current_species.name_language == null)
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return current_species.get_random_name(gender)

/proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

/proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

/proc/RoundHealth(health)
	var/list/icon_states = cached_icon_states(ingame_hud_med)
	for(var/icon_state in icon_states)
		if(health >= text2num(icon_state))
			return icon_state
	return icon_states[icon_states.len] // If we had no match, return the last element

/*
Proc for attack log creation, because really why not
1 argument is the actor
2 argument is the target of action
3 is the description of action(like punched, throwed, or any other verb)
4 should it make adminlog note or not
5 is the tool with which the action was made(usually item)					5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
6 is additional information, anything that needs to be added
*/

/proc/add_attack_logs(mob/user, mob/target, what_done, var/admin_notify = TRUE)
	if(islist(target)) //Multi-victim adding
		var/list/targets = target
		for(var/mob/M in targets)
			add_attack_logs(user,M,what_done,admin_notify)
		return

	var/user_str = key_name(user)
	var/target_str = key_name(target)

	if(ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attacked [target_str]: [what_done]</font>")
	if(ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Attacked by [user_str]: [what_done]</font>")
	log_attack(user_str,target_str,what_done)
	if(admin_notify)
		msg_admin_attack("[key_name_admin(user)] vs [target_str]: [what_done]")

//checks whether this item is a module of the robot it is located in.
/proc/is_robot_module(var/obj/item/thing)
	if (!thing || !istype(thing.loc, /mob/living/silicon/robot))
		return 0
	var/mob/living/silicon/robot/R = thing.loc
	return (thing in R.module.modules)

/proc/get_exposed_defense_zone(var/atom/movable/target)
	var/obj/item/weapon/grab/G = locate() in target
	if(G && G.state >= GRAB_NECK) //works because mobs are currently not allowed to upgrade to NECK if they are grabbing two people.
		return pick("head", "l_hand", "r_hand", "l_foot", "r_foot", "l_arm", "r_arm", "l_leg", "r_leg")
	else
		return pick("chest", "groin")

/proc/do_mob(mob/user , mob/target, time = 30, target_zone = 0, uninterruptible = FALSE, progress = TRUE, ignore_movement = FALSE, exclusive = FALSE)
	if(!user || !target)
		return FALSE
	if(!time)
		return TRUE //Done!
	if(user.status_flags & DOING_TASK)
		to_chat(user, "<span class='warning'>You're in the middle of doing something else already.</span>")
		return FALSE //Performing an exclusive do_after or do_mob already
	if(target?.flags & IS_BUSY)
		to_chat(user, "<span class='warning'>Someone is already doing something with \the [target].</span>")
		return FALSE
	var/user_loc = user.loc
	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time+time
	var/starttime = world.time

	if(exclusive & TASK_USER_EXCLUSIVE)
		user.status_flags |= DOING_TASK
	if(target && exclusive & TASK_TARGET_EXCLUSIVE)
		target.flags |= IS_BUSY

	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)
		if(!user || !target)
			. = FALSE
			break
		if(uninterruptible)
			continue

		if(!user || user.incapacitated())
			. = FALSE
			break

		if(user.loc != user_loc && !ignore_movement)
			. = FALSE
			break

		if(target.loc != target_loc && !ignore_movement)
			. = FALSE
			break

		if(user.get_active_hand() != holding)
			. = FALSE
			break

		if(target_zone && user.zone_sel.selecting != target_zone)
			. = FALSE
			break

	if(exclusive & TASK_USER_EXCLUSIVE)
		user.status_flags &= ~DOING_TASK
	if(exclusive & TASK_TARGET_EXCLUSIVE)
		target?.status_flags &= ~IS_BUSY

	if (progbar)
		qdel(progbar)

/proc/do_after(mob/user, delay, atom/target = null, needhand = TRUE, progress = TRUE, incapacitation_flags = INCAPACITATION_DEFAULT, ignore_movement = FALSE, max_distance = null, exclusive = FALSE)
	if(!user)
		return FALSE
	if(!delay)
		return TRUE //Okay. Done.
	if(user.status_flags & DOING_TASK)
		to_chat(user, "<span class='warning'>You're in the middle of doing something else already.</span>")
		return FALSE //Performing an exclusive do_after or do_mob already
	if(target?.flags & IS_BUSY)
		to_chat(user, "<span class='warning'>Someone is already doing something with \the [target].</span>")
		return FALSE
		
	var/atom/target_loc = null
	if(target)
		target_loc = target.loc

	var/atom/original_loc = user.loc

	var/obj/mecha/M = null

	if(istype(user.loc, /obj/mecha))
		original_loc = get_turf(original_loc)
		M = user.loc

	var/holding = user.get_active_hand()

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time

	if(exclusive & TASK_USER_EXCLUSIVE)
		user.status_flags |= DOING_TASK
	
	if(target && (exclusive & TASK_TARGET_EXCLUSIVE))
		target.flags |= IS_BUSY

	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if(progress)
			progbar.update(world.time - starttime)

		if(!user || user.incapacitated(incapacitation_flags))
			. = FALSE
			break

		if(M)
			if(user.loc != M || (M.loc != original_loc && !ignore_movement)) // Mech coooooode.
				. = FALSE
				break

		else if(user.loc != original_loc && !ignore_movement)
			. = FALSE
			break

		if(target_loc && (QDELETED(target)))
			. = FALSE
			break

		if(target && target_loc != target.loc && !ignore_movement)
			. = FALSE
			break

		if(needhand)
			if(user.get_active_hand() != holding)
				. = FALSE
				break

		if(max_distance && target && get_dist(user, target) > max_distance)
			. = FALSE
			break

	if(exclusive & TASK_USER_EXCLUSIVE)
		user.status_flags &= ~DOING_TASK
	if(target && (exclusive & TASK_TARGET_EXCLUSIVE))
		target.flags &= ~IS_BUSY

	if(progbar)
		qdel(progbar)

/atom/proc/living_mobs(var/range = world.view)
	var/list/viewers = oviewers(src,range)
	var/list/living = list()
	for(var/mob/living/L in viewers)
		living += L

	return living

/atom/proc/human_mobs(var/range = world.view)
	var/list/viewers = oviewers(src,range)
	var/list/humans = list()
	for(var/mob/living/carbon/human/H in viewers)
		humans += H

	return humans

/proc/cached_character_icon(var/mob/desired)
	var/cachekey = "\ref[desired][desired.real_name]"

	if(cached_character_icons[cachekey])
		. = cached_character_icons[cachekey]
	else
		. = getCompoundIcon(desired)
		cached_character_icons[cachekey] = .
