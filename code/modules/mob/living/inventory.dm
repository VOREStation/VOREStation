/mob/living
	var/hand = null
	var/obj/item/l_hand = null
	var/obj/item/r_hand = null
	var/obj/item/weapon/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/clothing/mask/wear_mask = null//Carbon

/mob/living/equip_to_storage(obj/item/newitem)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, 1))
			newitem.forceMove(src.back)
			return 1

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/weapon/storage/S in src.contents)
		if (S.can_be_inserted(newitem, 1))
			newitem.forceMove(S)
			return 1
	return 0

//Returns the thing in our active hand
/mob/living/get_active_hand()
	if(hand)	return l_hand
	else		return r_hand

//Returns the thing in our inactive hand
/mob/living/get_inactive_hand()
	if(hand)	return r_hand
	else		return l_hand

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/living/drop_item(var/atom/Target)
	var/obj/item/item_dropped = null

	if (hand)
		item_dropped = l_hand
		. = drop_l_hand(Target)
	else
		item_dropped = r_hand
		. = drop_r_hand(Target)

	if (istype(item_dropped) && !QDELETED(item_dropped) && is_preference_enabled(/datum/client_preference/drop_sounds))
		addtimer(CALLBACK(src, .proc/make_item_drop_sound, item_dropped), 1)

/mob/proc/make_item_drop_sound(obj/item/I)
	if(QDELETED(I))
		return

	if(I.drop_sound)
		playsound(I, I.drop_sound, 25, 0, preference = /datum/client_preference/drop_sounds)


//Drops the item in our left hand
/mob/living/drop_l_hand(var/atom/Target)
	return drop_from_inventory(l_hand, Target)

//Drops the item in our right hand
/mob/living/drop_r_hand(var/atom/Target)
	return drop_from_inventory(r_hand, Target)

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

/mob/living/u_equip(obj/W as obj)
	if (W == r_hand)
		r_hand = null
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		update_inv_l_hand()
	else if (W == back)
		back = null
		update_inv_back()
	else if (W == wear_mask)
		wear_mask = null
		update_inv_wear_mask()
	return

/mob/living/get_equipped_item(var/slot)
	switch(slot)
		if(slot_l_hand) return l_hand
		if(slot_r_hand) return r_hand
		if(slot_back) return back
		if(slot_wear_mask) return wear_mask
	return null

/mob/living/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

/mob/living/ret_grab(var/list/L, var/mobchain_limit = 5)
	// We're the first!
	if(!L)
		L = list()
	
	// Lefty grab!
	if (istype(l_hand, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = l_hand
		L |= G.affecting
		if(mobchain_limit-- > 0)
			G.affecting?.ret_grab(L, mobchain_limit) // Recurse! They can update the list. It's the same instance as ours.
	
	// Righty grab!
	if (istype(r_hand, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = r_hand
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

/mob/living/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1
	return 0
