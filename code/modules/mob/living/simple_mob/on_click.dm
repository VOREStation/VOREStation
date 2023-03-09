/*
	Animals
*/
/mob/living/simple_mob/UnarmedAttack(var/atom/A, var/proximity)
	if(!(. = ..()))
		return

//	setClickCooldown(get_attack_speed())

	if(has_hands && istype(A,/obj) && a_intent != I_HURT)
		var/obj/O = A
		return O.attack_hand(src)

	switch(a_intent)
		if(I_HELP)
			var/mob/living/L = A
			if(istype(L) && (!has_hands || !L.attempt_to_scoop(src)))
				custom_emote(1,"[pick(friendly)] \the [A]!")

		if(I_HURT)
			if(can_special_attack(A) && special_attack_target(A))
				return

			else if(melee_damage_upper == 0 && isliving(A))
				custom_emote(1,"[pick(friendly)] \the [A]!")

			else
				attack_target(A)

		if(I_GRAB)
			if(has_hands)
				A.attack_hand(src)
			else if(isliving(A) && src.client)
				animal_nom(A)
			else
				attack_target(A)

		if(I_DISARM)
			if(has_hands)
				A.attack_hand(src)
			else
				attack_target(A)

<<<<<<< HEAD
/mob/living/simple_mob/RangedAttack(var/atom/A)
//	setClickCooldown(get_attack_speed())
=======
/mob/living/simple_mob/proc/do_help_interaction(var/atom/A)
	if(isliving(A))
		custom_emote(VISIBLE_MESSAGE,"[pick(friendly)] \the [A]!")
		return TRUE
	return FALSE
>>>>>>> 642348983f6... Fixing positional custom emotes. (#9011)

	if(can_special_attack(A) && special_attack_target(A))
		return
<<<<<<< HEAD

	if(projectiletype)
		shoot_target(A)
=======
	else if(melee_damage_upper == 0 && istype(A,/mob/living))
		custom_emote(VISIBLE_MESSAGE,"[pick(friendly)] \the [A]!")
	else
		attack_target(A)

/mob/living/simple_mob/proc/do_disarm_interaction(var/atom/A)
	if(has_hands)
		A.attack_hand(src)
	else
		attack_target(A)

/mob/living/simple_mob/proc/do_grab_interaction(var/atom/A)
	if(has_hands)
		A.attack_hand(src)
	else
		attack_target(A)
>>>>>>> 642348983f6... Fixing positional custom emotes. (#9011)
