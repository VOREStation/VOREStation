/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	if(src.valid_accessory_slots && (A.slot in src.valid_accessory_slots))
		if(accessories.len && restricted_accessory_slots && (A.slot in restricted_accessory_slots))
			for(var/obj/item/clothing/accessory/AC in accessories)
				if (AC.slot == A.slot)
					return FALSE
		return TRUE
	else
		return FALSE

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/A = I
		if(attempt_attach_accessory(A, user))
			return

	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(I, user)
		return

	..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(accessories.len && src.loc == user)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attack_hand(user)
		return
	if (ishuman(user) && src.loc == user)
		var/mob/living/carbon/human/H = user
		if(src != H.l_store && src != H.r_store && src != H.s_store)
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
	..(user)
	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			user << "\A [A] is attached to it."

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attempt_attach_accessory(obj/item/clothing/accessory/A, mob/user)
	if(!valid_accessory_slots || !valid_accessory_slots.len)
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
	accessories += A
	A.on_attached(src, user)
	src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_accessory_slowdown()
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!(A in accessories))
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
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(!accessories.len) return
	var/obj/item/clothing/accessory/A
	if(accessories.len > 1)
		A = input("Select an accessory to remove from [src]") as null|anything in accessories
	else
		A = accessories[1]
	src.remove_accessory(usr,A)
	if(!accessories.len)
		src.verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()