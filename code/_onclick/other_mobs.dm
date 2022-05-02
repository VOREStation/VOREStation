// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user as mob)
	return 0

/atom/proc/take_damage(var/damage)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/human/UnarmedAttack(var/atom/A, var/proximity)

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
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE

/mob/living/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/human/RangedAttack(var/atom/A)
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
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return
