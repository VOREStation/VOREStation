// TODO: most of these need to be updated for multihands

/mob/living/proc/hands_are_full()
	return (get_right_hand() && get_left_hand())

/mob/living/proc/item_is_in_hands(var/obj/item/I)
	return (I == get_right_hand() || I == get_left_hand())

/mob/living/proc/update_held_icons()
	var/obj/item/l_hand = get_left_hand()
	var/obj/item/r_hand = get_right_hand()

	if(istype(l_hand))
		l_hand.update_held_icon()
	if(istype(r_hand))
		r_hand.update_held_icon()

/mob/living/proc/get_type_in_hands(var/T)
	var/obj/item/l_hand = get_left_hand()
	var/obj/item/r_hand = get_right_hand()

	if(istype(l_hand, T))
		return l_hand
	if(istype(r_hand, T))
		return r_hand
	return null

/mob/living/ret_grab(var/list/L, var/mobchain_limit = 5)
	// We're the first!
	if(!L)
		L = list()

	var/obj/item/l_hand = get_left_hand()
	var/obj/item/r_hand = get_right_hand()

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

	var/obj/item/l_hand = get_left_hand()
	var/obj/item/r_hand = get_right_hand()

	if(hand)
		var/obj/item/W = l_hand
		if (istype(W))
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (istype(W))
			W.attack_self(src)
			update_inv_r_hand()
	return
