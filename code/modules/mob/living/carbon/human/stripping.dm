/mob/living/carbon/human/proc/handle_strip(var/slot_to_strip,var/mob/living/user)

	if(!slot_to_strip || !istype(user))
		return

	if(user.incapacitated()  || !user.Adjacent(src))
		user << browse(null, text("window=mob[src.name]"))
		return

	var/obj/item/target_slot = get_equipped_item(text2num(slot_to_strip))

	switch(slot_to_strip)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("pockets")
			visible_message("<span class='danger'>\The [user] is trying to empty \the [src]'s pockets!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				empty_pockets(user)
			return
		if("splints")
			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s splints!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				remove_splints(user)
			return
		if("sensors")
			visible_message("<span class='danger'>\The [user] is trying to set \the [src]'s sensors!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				toggle_sensors(user)
			return
		if("internals")
			visible_message("<span class='danger'>\The [usr] is trying to set \the [src]'s internals!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				toggle_internals(user)
			return
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || !LAZYLEN(suit.accessories))
				return
			var/obj/item/clothing/accessory/A = suit.accessories[1]
			if(!istype(A))
				return
			visible_message("<span class='danger'>\The [usr] is trying to remove \the [src]'s [A.name]!</span>")

			if(!do_after(user,HUMAN_STRIP_DELAY,src))
				return

			if(!A || suit.loc != src || !(A in suit.accessories))
				return

			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				user.visible_message("<span class='danger'>\The [user] tears off \the [A] from [src]'s [suit.name]!</span>")
			add_attack_logs(user,src,"Stripped [A.name] off [suit.name]")
			A.on_removed(user)
			suit.accessories -= A
			update_inv_w_uniform()
			return

	// Are we placing or stripping?
	var/stripping
	var/obj/item/held = user.get_active_hand()
	if(!istype(held) || is_robot_module(held))
		stripping = TRUE
	else
		var/obj/item/weapon/holder/holder = held
		if(istype(holder) && src == holder.held_mob)
			stripping = TRUE
		else
			var/obj/item/weapon/grab/grab = held
			if(istype(grab) && grab.affecting == src)
				stripping = TRUE
		
	if(stripping)
		if(!istype(target_slot))  // They aren't holding anything valid and there's nothing to remove, why are we even here?
			return
		if(!target_slot.canremove)
			to_chat(user, "<span class='warning'>You cannot remove \the [src]'s [target_slot.name].</span>")
			return
		visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s [target_slot.name]!</span>")
	else
		if(slot_to_strip == slot_wear_mask && istype(held, /obj/item/weapon/grenade))
			visible_message("<span class='danger'>\The [user] is trying to put \a [held] in \the [src]'s mouth!</span>")
		else
			visible_message("<span class='danger'>\The [user] is trying to put \a [held] on \the [src]!</span>")

	if(!do_after(user,HUMAN_STRIP_DELAY,src))
		return

	if(!stripping)
		if(user.get_active_hand() != held)
			return
		var/obj/item/weapon/holder/mobheld = held
		if(istype(mobheld)&&mobheld.held_mob==src)
			to_chat(user, "<span class='warning'>You can't put someone on themselves! Stop trying to break reality!</span>")
			return


	if(stripping)
		add_attack_logs(user,src,"Removed equipment from slot [target_slot]")
		unEquip(target_slot)
	else if(user.unEquip(held))
		equip_to_slot_if_possible(held, text2num(slot_to_strip), 0, 1, 1)
		if(held.loc != src)
			user.put_in_hands(held)

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(var/mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, "<span class='warning'>\The [src] has nothing in their pockets.</span>")
		return
	if(r_store)
		unEquip(r_store)
	if(l_store)
		unEquip(l_store)
	visible_message("<span class='danger'>\The [user] empties \the [src]'s pockets!</span>")

// Modify the current target sensor level.
/mob/living/carbon/human/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/under/suit = w_uniform
	if(!suit)
		to_chat(user, "<span class='warning'>\The [src] is not wearing a suit with sensors.</span>")
		return
	if (suit.has_sensor >= 2)
		to_chat(user, "<span class='warning'>\The [src]'s suit sensor controls are locked.</span>")
		return
	add_attack_logs(user,src,"Adjusted suit sensor level")
	suit.set_sensors(user)

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)

	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, "<span class='warning'>You cannot remove the splints - [src]'s [suit] is supporting some of the breaks.</span>")
			can_reach_splints = 0

	if(can_reach_splints)
		var/removed_splint
		for(var/obj/item/organ/external/o in organs)
			if (o && o.splinted)
				var/obj/item/S = o.splinted
				if(istype(S) && S.loc == o) //can only remove splints that are actually worn on the organ (deals with hardsuit splints)
					S.add_fingerprint(user)
					if(o.remove_splint())
						user.put_in_active_hand(S)
						removed_splint = 1
		if(removed_splint)
			visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has no splints to remove.</span>")

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		internal.add_fingerprint(user)
		internal = null
		if(internals)
			internals.icon_state = "internal0"
	else
		// Check for airtight mask/helmet.
		if(!(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space)))
			return
		// Find an internal source.
		if(istype(back, /obj/item/weapon/tank))
			internal = back
		else if(istype(s_store, /obj/item/weapon/tank))
			internal = s_store
		else if(istype(belt, /obj/item/weapon/tank))
			internal = belt

	if(internal)
		visible_message("<span class='warning'>\The [src] is now running on internals!</span>")
		internal.add_fingerprint(user)
		if (internals)
			internals.icon_state = "internal1"
	else
		visible_message("<span class='danger'>\The [user] disables \the [src]'s internals!</span>")
