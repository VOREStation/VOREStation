/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	item_state_slots = list(slot_r_hand_str = "magboots", slot_l_hand_str = "magboots")
	species_restricted = null
	force = 3
	overshoes = 1
	shoes_under_pants = -1	//These things are huge
	var/magpulse = 0
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/carbon/human/wearer = null	//For shoe procs

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	slowdown = shoes? max(SHOES_SLOWDOWN, shoes.slowdown): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown += 3

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		if(icon_base) icon_state = "[icon_base]0"
		user << "You disable the mag-pulse traction system."
	else
		item_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		if(icon_base) icon_state = "[icon_base]1"
		user << "You enable the mag-pulse traction system."
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user, slot)
	var/mob/living/carbon/human/H = user

	if(H.shoes)
		shoes = H.shoes
		if(shoes.overshoes)
			if(slot && slot == slot_shoes)
				to_chat(user, "You are unable to wear \the [src] as \the [H.shoes] are in the way.")
			shoes = null
			return 0
		H.drop_from_inventory(shoes)	//Remove the old shoes so you can put on the magboots.
		shoes.forceMove(src)

	if(!..())
		if(shoes) 	//Put the old shoes back on if the check fails.
			if(H.equip_to_slot_if_possible(shoes, slot_shoes))
				src.shoes = null
		return 0

	if (shoes)
		if(slot && slot == slot_shoes)
			to_chat(user, "You slip \the [src] on over \the [shoes].")
	set_slowdown()
	wearer = H
	return 1

/obj/item/clothing/shoes/magboots/dropped()
	..()
	var/mob/living/carbon/human/H = wearer
	if(shoes)
		if(!H.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.forceMove(get_turf(src))
		src.shoes = null
	wearer = null

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if(item_flags & NOSLIP)
		state = "enabled"
	user << "Its mag-pulse traction system appears to be [state]."

/obj/item/clothing/shoes/magboots/vox

	desc = "A pair of heavy, jagged armoured foot pieces, seemingly suitable for a velociraptor."
	name = "vox magclaws"
	item_state = "boots-vox"
	icon_state = "boots-vox"
	item_flags = PHORONGUARD
	phoronproof = 1
	species_restricted = list("Vox")

	action_button_name = "Toggle the magclaws"

/obj/item/clothing/shoes/magboots/vox/attack_self(mob/user)
	if(src.magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		canremove = 1
		to_chat(user, "You relax your deathgrip on the flooring.")
	else
		//make sure these can only be used when equipped.
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/H = user
		if (H.shoes != src)
			to_chat(user, "You will have to put on the [src] before you can do that.")
			return

		item_flags |= NOSLIP
		magpulse = 1
		canremove = 0	//kinda hard to take off magclaws when you are gripping them tightly.
		to_chat(user, "You dig your claws deeply into the flooring, bracing yourself.")
	user.update_action_buttons()

//In case they somehow come off while enabled.
/obj/item/clothing/shoes/magboots/vox/dropped(mob/user as mob)
	..()
	if(src.magpulse)
		user.visible_message("The [src] go limp as they are removed from [usr]'s feet.", "The [src] go limp as they are removed from your feet.")
		item_flags &= ~NOSLIP
		magpulse = 0
		canremove = 1

/obj/item/clothing/shoes/magboots/vox/examine(mob/user)
	..(user)
	if (magpulse)
		to_chat(user, "It would be hard to take these off without relaxing your grip first.")//theoretically this message should only be seen by the wearer when the claws are equipped.