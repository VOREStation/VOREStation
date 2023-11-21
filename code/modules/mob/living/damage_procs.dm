
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/soaked = 0, var/used_weapon = null, var/sharp = FALSE, var/edge = FALSE, var/obj/used_weapon = null)
	if(Debug2)
		to_world_log("## DEBUG: apply_damage() was called on [src], with [damage] damage, and an armor value of [blocked].")
	if(!damage || (blocked >= 100))
		return 0
	for(var/datum/modifier/M in modifiers) //MODIFIER STUFF. It's best to do this RIGHT before armor is calculated, so it's done here! This is the 'forcefield' defence.
		if(damagetype == BRUTE && (!isnull(M.effective_brute_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			damage = damage * M.effective_brute_resistance
			continue
		if((damagetype == BURN || damagetype == ELECTROCUTE)&& (!isnull(M.effective_fire_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			damage = damage * M.effective_fire_resistance
			continue
		if(damagetype == TOX && (!isnull(M.effective_tox_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			damage = damage * M.effective_tox_resistance
			continue
		if(damagetype == OXY && (!isnull(M.effective_oxy_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			damage = damage * M.effective_oxy_resistance
			continue
		if(damagetype == CLONE && (!isnull(M.effective_clone_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			damage = damage * M.effective_clone_resistance
			continue
		if(damagetype == HALLOSS && (!isnull(M.effective_hal_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			damage = damage * M.effective_hal_resistance
			continue
		if(damagetype == SEARING && (!isnull(M.effective_fire_resistance) || !isnull(M.effective_brute_resistance)))
			if(M.energy_based)
				M.energy_source.use(M.damage_cost * damage)
			var/damage_mitigation = 0//Used for dual calculations.
			if(!isnull(M.effective_fire_resistance))
				damage_mitigation += round((1/3)*damage * M.effective_fire_resistance)
			if(!isnull(M.effective_brute_resistance))
				damage_mitigation += round((2/3)*damage * M.effective_brute_resistance)
			damage -= damage_mitigation
			continue
		if(damagetype == BIOACID && (isSynthetic() && (!isnull(M.effective_fire_resistance))) || (!isSynthetic() && M.effective_tox_resistance))
			if(isSynthetic())
				damage = damage * M.effective_fire_resistance
			else
				damage = damage * M.effective_tox_resistance
			continue
	if(soaked)
		if(soaked >= round(damage*0.8))
			damage -= round(damage*0.8)
		else
			damage -= soaked

	var/initial_blocked = blocked

	blocked = (100-blocked)/100
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * blocked)
		if(BURN)
			if(COLD_RESISTANCE in mutations)
				damage = 0
			adjustFireLoss(damage * blocked)
		if(SEARING)
			apply_damage(round(damage / 3), BURN, def_zone, initial_blocked, soaked, used_weapon, sharp, edge)
			apply_damage(round(damage / 3 * 2), BRUTE, def_zone, initial_blocked, soaked, used_weapon, sharp, edge)
		if(TOX)
			adjustToxLoss(damage * blocked)
		if(OXY)
			adjustOxyLoss(damage * blocked)
		if(CLONE)
			adjustCloneLoss(damage * blocked)
		if(HALLOSS)
			adjustHalLoss(damage * blocked)
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon, 1.0, def_zone)
		if(BIOACID)
			if(isSynthetic())
				apply_damage(damage, BURN, def_zone, initial_blocked, soaked, used_weapon, sharp, edge)	// Handle it as normal burn.
			else
				adjustToxLoss(damage * blocked)
		if(ELECTROMAG)
			damage = damage * blocked
			switch(round(damage))
				if(91 to INFINITY)
					emp_act(1)
				if(76 to 90)
					if(prob(50))
						emp_act(1)
					else
						emp_act(2)
				if(61 to 75)
					emp_act(2)
				if(46 to 60)
					if(prob(50))
						emp_act(2)
					else
						emp_act(3)
				if(31 to 45)
					emp_act(3)
				if(16 to 30)
					if(prob(50))
						emp_act(3)
					else
						emp_act(4)
				if(0 to 15)
					emp_act(4)
	flash_weak_pain()
	updatehealth()
	return 1


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/blocked = 0)
	if(blocked >= 100)
		return 0
	// INSERT MODIFIER CODE HERE... But no, really, only two things in the game use it, quad and viruses. The former is admin-only and the latter wouldn't be affected logically, but would if shield code was inerted here. If you really want, you can copy&paste the above and modify it to adjust brute/burn/etc. I do not advise this however.
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone, blocked)
	return 1



/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(Debug2)
		to_world_log("## DEBUG: apply_effect() was called.  The type of effect is [effecttype].  Blocked by [blocked].")
	if(!effect || (blocked >= 100))
		return 0
	blocked = (100-blocked)/100

	switch(effecttype)
		if(STUN)
			Stun(effect * blocked)
		if(WEAKEN)
			Weaken(effect * blocked)
		if(PARALYZE)
			Paralyse(effect * blocked)
		if(AGONY)
			halloss += max((effect * blocked), 0) // Useful for objects that cause "subdual" damage. PAIN!
		if(IRRADIATE)
		/*
			var/rad_protection = check_protection ? getarmor(null, "rad")/100 : 0
			radiation += max((1-rad_protection)*effect/(blocked+1),0)//Rads auto check armor
		*/
			var/rad_protection = getarmor(null, "rad")
			rad_protection = (100-rad_protection)/100
			radiation += max((effect * rad_protection), 0)
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect * blocked))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect * blocked))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0, var/ignite = 0, var/flammable = 0)
	if(blocked >= 100)
		return 0
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(agony)		apply_effect(agony, AGONY, blocked)
	if(flammable)	adjust_fire_stacks(flammable)
	if(ignite)
		if(ignite >= 3)
			add_modifier(/datum/modifier/fire/stack_managed/intense, 60 SECONDS)
		else
			add_modifier(/datum/modifier/fire/stack_managed, 45 * ignite SECONDS)
	return 1
