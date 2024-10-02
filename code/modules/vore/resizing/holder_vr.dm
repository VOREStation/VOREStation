/obj/item/holder/dropped(mob/user)
	if (held_mob?.loc != src || isturf(loc))
		var/held = held_mob
		dump_mob()
		held_mob = held

/obj/item/holder/attack_hand(mob/living/user as mob) //straight up just copypasted from objects/items.dm with a few things changed (doesn't called dropped unless +actually dropped+)
	if (!user) return
	if(anchored)
		to_chat(user, span_notice("\The [src] won't budge, you can't pick it up!"))
		return
	if (hasorgans(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (user.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
		if(!temp)
			to_chat(user, "<span class='notice'>You try to use your hand, but realize it is no longer attached!</span>")
			return
	if(held_mob == user) return // No picking your own micro self up

	var/old_loc = src.loc
	if (istype(src.loc, /obj/item/storage))
		var/obj/item/storage/S = src.loc
		if(!S.remove_from_storage(src))
			return

	src.pickup(user)
	src.throwing = 0
	if (src.loc == user)
		if(!mob_can_unequip(user, user.get_inventory_slot(src))) //VOREStation Edit
			return
		else //VOREStation Edit
			user.temporarilyRemoveItemFromInventory(src)
	else
		if(isliving(src.loc))
			return

	if(user.put_in_active_hand(src))
		if(isturf(old_loc))
			var/obj/effect/temporary_effect/item_pickup_ghost/ghost = new(old_loc)
			ghost.assumeform(src)
			ghost.animate_towards(user)
	else if (old_loc == user) //VOREStation Edit
		dropInto(user.drop_location())
		dropped(user)
	//VORESTATION EDIT START. This handles possessed items.
	if(src.possessed_voice && src.possessed_voice.len && !(user.ckey in warned_of_possession)) //Is this item possessed?
		warned_of_possession |= user.ckey
		tgui_alert_async(user,{"
		THIS ITEM IS POSSESSED BY A PLAYER CURRENTLY IN THE ROUND. This could be by anomalous means or otherwise.
		If this is not something you wish to partake in, it is highly suggested you place the item back down.
		If this is fine to you, ensure that the other player is fine with you doing things to them beforehand!
		"},"OOC Warning")
	//VORESTATION EDIT END.
	return
