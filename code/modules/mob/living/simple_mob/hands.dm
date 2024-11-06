// Hand procs for player-controlled SA's
/mob/living/simple_mob/swap_hand()
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"
	return

/mob/living/simple_mob/put_in_hands(var/obj/item/W) // No hands.
	if(has_hands)
		put_in_active_hand(W)
		return 1
	W.forceMove(get_turf(src))
	return 1

//Puts the item into our active hand if possible. returns 1 on success.
/mob/living/simple_mob/put_in_active_hand(var/obj/item/W)
	if(!has_hands)
		return FALSE
	return (hand ? put_in_l_hand(W) : put_in_r_hand(W))

/mob/living/simple_mob/put_in_l_hand(var/obj/item/W)
	if(!..() || l_hand)
		return 0
	W.forceMove(src)
	l_hand = W
	W.equipped(src,slot_l_hand)
	W.add_fingerprint(src)
	update_inv_l_hand()
	return TRUE

/mob/living/simple_mob/put_in_r_hand(var/obj/item/W)
	if(!..() || r_hand)
		return 0
	W.forceMove(src)
	r_hand = W
	W.equipped(src,slot_r_hand)
	W.add_fingerprint(src)
	update_inv_r_hand()
	return TRUE

/mob/living/simple_mob/update_inv_r_hand()
	if(QDESTROYING(src))
		return

	if(r_hand)
		r_hand.screen_loc = ui_rhand	//TODO

		//determine icon state to use
		var/t_state
		if(LAZYACCESS(r_hand.item_state_slots, slot_r_hand_str))
			t_state = r_hand.item_state_slots[slot_r_hand_str]
		else if(r_hand.item_state)
			t_state = r_hand.item_state
		else
			t_state = r_hand.icon_state

		//determine icon to use
		var/icon/t_icon
		if(LAZYACCESS(r_hand.item_icons, slot_r_hand_str))
			t_icon = r_hand.item_icons[slot_r_hand_str]
		else if(r_hand.icon_override)
			t_state += "_r"
			t_icon = r_hand.icon_override
		else
			t_icon = INV_R_HAND_DEF_ICON

		//apply color
		var/image/standing = image(icon = t_icon, icon_state = t_state)
		standing.color = r_hand.color

		r_hand_sprite = standing

	else
		r_hand_sprite = null

	update_icon()

/mob/living/simple_mob/update_inv_l_hand()
	if(QDESTROYING(src))
		return

	if(l_hand)
		l_hand.screen_loc = ui_lhand	//TODO

		//determine icon state to use
		var/t_state
		if(LAZYACCESS(l_hand.item_state_slots, slot_l_hand_str))
			t_state = l_hand.item_state_slots[slot_l_hand_str]
		else if(l_hand.item_state)
			t_state = l_hand.item_state
		else
			t_state = l_hand.icon_state

		//determine icon to use
		var/icon/t_icon
		if(LAZYACCESS(l_hand.item_icons, slot_l_hand_str))
			t_icon = l_hand.item_icons[slot_l_hand_str]
		else if(l_hand.icon_override)
			t_state += "_l"
			t_icon = l_hand.icon_override
		else
			t_icon = INV_L_HAND_DEF_ICON

		//apply color
		var/image/standing = image(icon = t_icon, icon_state = t_state)
		standing.color = l_hand.color

		l_hand_sprite = standing

	else
		l_hand_sprite = null

	update_icon()

//Can insert extra huds into the hud holder here.
/mob/living/simple_mob/proc/extra_huds(var/datum/hud/hud,var/icon/ui_style,var/list/hud_elements)
	return

//If they can or cannot use tools/machines/etc
/mob/living/simple_mob/IsAdvancedToolUser()
	return has_hands

/mob/living/simple_mob/proc/IsHumanoidToolUser(var/atom/tool)
	if(!humanoid_hands)
		var/display_name = null
		if(tool)
			display_name = tool
		else
			display_name = "object"
		to_chat(src, span_danger("Your [hand_form] are not fit for use of \the [display_name]."))
	return humanoid_hands

/mob/living/simple_mob/is_holding_item_of_type(typepath)
	for(var/obj/item/I in list(l_hand, r_hand))
		if(istype(I, typepath))
			return I
	return FALSE

/mob/living/simple_mob/get_all_held_items()
	. = list()
	if(l_hand)
		. += l_hand
	if(r_hand)
		. += r_hand
