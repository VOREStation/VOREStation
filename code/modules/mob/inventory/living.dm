
/mob/living/proc/hands_are_full()
	return (r_hand && l_hand)

/mob/living/proc/item_is_in_hands(var/obj/item/I)
	return (I == r_hand || I == l_hand)

/mob/living/proc/update_held_icons()
	if(l_hand)
		l_hand.update_held_icon()
	if(r_hand)
		r_hand.update_held_icon()

/mob/living/proc/get_type_in_hands(var/T)
	if(istype(l_hand, T))
		return l_hand
	if(istype(r_hand, T))
		return r_hand
	return null

/mob/living/proc/get_left_hand()
	return l_hand

/mob/living/proc/get_right_hand()
	return r_hand



/mob/living/ret_grab(var/list/L, var/mobchain_limit = 5)
	// We're the first!
	if(!L)
		L = list()

	// Lefty grab!
	if (istype(l_hand, /obj/item/grab))
		var/obj/item/grab/G = l_hand
		L |= G.affecting
		if(mobchain_limit-- > 0)
			G.affecting?.ret_grab(L, mobchain_limit) // Recurse! They can update the list. It's the same instance as ours.

	// Righty grab!
	if (istype(r_hand, /obj/item/grab))
		var/obj/item/grab/G = r_hand
		L |= G.affecting
		if(mobchain_limit-- > 0)
			G.affecting?.ret_grab(L, mobchain_limit) // Same as lefty!

	// On all but the one not called by us, this will just be ignored. Oh well!
	return L

/mob/living/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(!checkClickCooldown())
		return

	setClickCooldown(1)

	if(istype(loc,/obj/mecha)) return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	return
