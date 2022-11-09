/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	//Just no, okay
	if(!A.slot)
		return FALSE

	//Not valid at all, not in the valid list period.
	if((valid_accessory_slots & A.slot) != A.slot)
		return FALSE

	//Find all consumed slots
	var/consumed_slots = 0
	for(var/obj/item/clothing/accessory/AC as anything in accessories)
		consumed_slots |= AC.slot

	//Mask to just consumed restricted
	var/consumed_restricted = restricted_accessory_slots & consumed_slots

	//They share at least one bit with the restricted slots
	if(consumed_restricted & A.slot)
		return FALSE

	return TRUE

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/A = I
		if(attempt_attach_accessory(A, user))
			return TRUE
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(I, user)
			if(QDELETED(I) || I.loc != user)
				break
		return TRUE
	return ..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(LAZYLEN(accessories) && src.loc == user)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attack_hand(user)
		return
	if (ishuman(user) && src.loc == user)
		var/mob/living/carbon/human/H = user
		if(src == H.w_uniform) // VOREStation Edit - Un-equip on single click, but not on uniform.
			return
	return ..()

/obj/item/clothing/MouseDrop(var/obj/over_object)
	if (over_object && (ishuman(usr) || issmall(usr)))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if (!(src.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if (!usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

/obj/item/clothing/examine(var/mob/user)
	. = ..(user)
	if(LAZYLEN(accessories))
		. += "It has the following attached: [counting_english_list(accessories)]"

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attempt_attach_accessory(obj/item/clothing/accessory/A, mob/user)
	if(!valid_accessory_slots)
		if(user)
			to_chat(user, "<span class='warning'>You cannot attach accessories of any kind to \the [src].</span>")
		return FALSE

	var/obj/item/clothing/accessory/acc = A
	if(can_attach_accessory(acc))
		if(user)
			user.drop_item()
		attach_accessory(user, acc)
		return TRUE
	else
		if(user)
			to_chat(user, "<span class='warning'>You cannot attach more accessories of this type to [src].</span>")
		return FALSE


/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	LAZYADD(accessories,A)
	A.on_attached(src, user)
	src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_accessory_slowdown()
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!LAZYLEN(accessories) || !(A in accessories))
		return

	A.on_removed(user)
	accessories -= A
	update_accessory_slowdown()
	update_clothing_icon()

/obj/item/clothing/proc/update_accessory_slowdown()
	slowdown = initial(slowdown)
	for(var/obj/item/clothing/accessory/A in accessories)
		slowdown += A.slowdown

/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr

	if(!istype(usr, /mob/living))
		return

	if(usr.stat)
		return

	var/obj/item/clothing/accessory/A
	var/accessory_amount = LAZYLEN(accessories)
	if(accessory_amount)
		if(accessory_amount == 1)
			A = accessories[1] // If there's only one accessory, just remove it without any additional prompts.
		else
			A = tgui_input_list(usr, "Select an accessory to remove from \the [src]", "Accessory Choice", accessories)

	if(A)
		remove_accessory(usr,A)

	if(!LAZYLEN(accessories))
		src.verbs -= /obj/item/clothing/proc/removetie_verb
		accessories = null

/obj/item/clothing/emp_act(severity)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()
