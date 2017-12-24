// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user as mob)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(istype(G) && G.Touch(A,1))
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user as mob)
	return

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/human/RangedAttack(var/atom/A)
	if(!gloves && !mutations.len && !spitting)
		return
	var/obj/item/clothing/gloves/G = gloves
	if((LASER in mutations) && a_intent == I_HURT)
		LaserEyes(A) // moved into a proc below

	else if(istype(G) && G.Touch(A,0)) // for magic gloves
		return

	else if(TK in mutations)
		A.attack_tk(src)

	else if(spitting) //Only used by xenos right now, can be expanded.
		Spit(A)

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return 0

	setClickCooldown(get_attack_speed())
	A.attack_generic(src,rand(5,6),"bitten")

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	if(prob(spattack_prob))
		if(spattack_min_range <= 1)
			target_mob = A
			SpecialAtkTarget()
			target_mob = null
			return

	if(melee_damage_upper == 0 && istype(A,/mob/living))
		custom_emote(1,"[friendly] [A]!")
		return

	setClickCooldown(get_attack_speed())
	if(isliving(A))
		target_mob = A
		PunchTarget()
		target_mob = null
	else
		A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext)

/mob/living/simple_animal/RangedAttack(var/atom/A)
	setClickCooldown(get_attack_speed())
	var/distance = get_dist(src, A)

	if(prob(spattack_prob) && (distance >= spattack_min_range) && (distance <= spattack_max_range))
		target_mob = A
		SpecialAtkTarget()
		target_mob = null
		return

	if(ranged && distance <= shoot_range)
		target_mob = A
		ShootTarget(A)
		target_mob = null

