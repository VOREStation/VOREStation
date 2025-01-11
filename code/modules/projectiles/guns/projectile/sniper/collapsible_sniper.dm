////////////// PTR-7 Anti-Materiel Rifle //////////////

/obj/item/gun/projectile/heavysniper/collapsible

/obj/item/gun/projectile/heavysniper/collapsible/verb/take_down()
	set category = "Object"
	set name = "Disassemble Rifle"

	var/mob/living/carbon/human/user = usr
	if(user.stat)
		return

	if(chambered)
		to_chat(user, span_warning("You need to empty the rifle to break it down."))
	else
		collapse_rifle(user)

/obj/item/gun/projectile/heavysniper/proc/collapse_rifle(mob/user)
	to_chat(user, span_warning("You begin removing \the [src]'s barrel."))
	if(do_after(user, 40))
		if(user.unEquip(src, force=1))
			to_chat(user, span_warning("You remove \the [src]'s barrel."))
			qdel(src)
			var/obj/item/barrel = new /obj/item/sniper_rifle_part/barrel(user)
			var/obj/item/sniper_rifle_part/assembly = new /obj/item/sniper_rifle_part/trigger_group(user)
			var/obj/item/sniper_rifle_part/stock/stock = new(assembly)
			assembly.stock = stock
			assembly.part_count = 2
			assembly.update_build(user)
			user.put_in_any_hand_if_possible(assembly) || assembly.dropInto(user.loc)
			user.put_in_any_hand_if_possible(barrel) || barrel.dropInto(user.loc)


/obj/item/sniper_rifle_part
	name = "AM rifle part"
	desc = "A part of an antimateriel rifle."

	w_class = ITEMSIZE_NORMAL

	icon = 'icons/obj/gun.dmi'

	var/obj/item/sniper_rifle_part/barrel = null
	var/obj/item/sniper_rifle_part/stock = null
	var/obj/item/sniper_rifle_part/trigger_group = null
	var/part_count = 1


/obj/item/sniper_rifle_part/barrel
	name = "AM rifle barrel"
	icon_state = "heavysniper-barrel"

/obj/item/sniper_rifle_part/barrel/New()
	..()
	barrel = src

/obj/item/sniper_rifle_part/stock
	name = "AM rifle stock"
	icon_state = "heavysniper-stock"

/obj/item/sniper_rifle_part/stock/New()
	..()
	stock = src

/obj/item/sniper_rifle_part/trigger_group
	name = "AM rifle trigger assembly"
	icon_state = "heavysniper-trig"

/obj/item/sniper_rifle_part/trigger_group/New()
	..()
	trigger_group = src

/obj/item/sniper_rifle_part/attack_self(mob/user)
	if(part_count == 1)
		to_chat(user, span_warning("You can't disassemble this further!"))
		return

	to_chat(user, span_notice("You start disassembling \the [src]."))
	if(!do_after(user, 40))
		return

	to_chat(user, span_notice("You disassemble \the [src]."))
	for(var/obj/item/sniper_rifle_part/P in list(barrel, stock, trigger_group))
		if(P.barrel != P)
			P.barrel = null
		if(P.stock != P)
			P.stock = null
		if(P.trigger_group != P)
			P.trigger_group = null
		if(P != src)
			user.put_in_any_hand_if_possible(P) || P.dropInto(loc)
		P.part_count = 1

	update_build(user)

/obj/item/sniper_rifle_part/attackby(var/obj/item/sniper_rifle_part/A as obj, mob/user as mob)

	to_chat(user, span_notice("You begin adding \the [A] to \the [src]."))
	if(!do_after(user, 30))
		return



	if(istype(A, /obj/item/sniper_rifle_part/trigger_group))
		if(A.part_count > 1 && src.part_count > 1)
			to_chat(user, span_warning("Disassemble one of these parts first!"))
			return

		if(!trigger_group)
			if(user.unEquip(A, force=1))
				trigger_group = A
		else
			to_chat(user, span_warning("There's already a trigger group!"))
			return

	else if(istype(A, /obj/item/sniper_rifle_part/barrel))
		if(!barrel)
			if(user.unEquip(A, force=1))
				barrel = A
		else
			to_chat(user, span_warning("There's already a barrel!"))
			return

	else if(istype(A, /obj/item/sniper_rifle_part/stock))
		if(!stock)
			if(user.unEquip(A, force=1))
				stock = A
		else
			to_chat(user, span_warning("There's already a stock!"))
			return

	A.forceMove(src)
	to_chat(user, span_notice("You install \the [A]."))

	if(A.barrel && !src.barrel)
		src.barrel = A.barrel
	if(A.stock && !src.stock)
		src.stock = A.stock
	if(A.trigger_group && !src.trigger_group)
		src.trigger_group = A.trigger_group


	part_count = A.part_count + src.part_count
	update_build(user)


/obj/item/sniper_rifle_part/proc/update_build(mob/user)
	switch(part_count)
		if(1)
			name = initial(name)
			w_class = ITEMSIZE_NORMAL
			icon_state = initial(icon_state)
		if(2)
			if(barrel && trigger_group)
				name = "AM rifle barrel-trigger assembly"
				icon_state = "heavysniper-trigbar"
			else if(stock && trigger_group)
				name = "AM rifle stock-trigger assembly"
				icon_state = "heavysniper-trigstock"
			else if(stock && barrel)
				name = "AM rifle stock-barrel assembly"
				icon_state = "heavysniper-barstock"
			w_class = ITEMSIZE_LARGE

		if(3)
			var/obj/item/gun/projectile/heavysniper/collapsible/gun = new (get_turf(src), 0)
			if(user && ishuman(user))
				var/mob/living/carbon/human/H = user
				H.unEquip(src, force=1)
				H.put_in_any_hand_if_possible(gun) || gun.dropInto(loc)
			qdel(src)

/obj/item/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"
