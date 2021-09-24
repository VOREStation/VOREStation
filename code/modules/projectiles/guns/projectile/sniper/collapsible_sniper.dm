////////////// PTR-7 Anti-Materiel Rifle //////////////

/obj/item/weapon/gun/projectile/heavysniper/collapsible

/obj/item/weapon/gun/projectile/heavysniper/collapsible/verb/take_down()
	set category = "Object"
	set name = "Disassemble Rifle"

	var/mob/living/carbon/human/user = usr
	if(user.stat)
		return

	if(chambered)
		to_chat(user, "<span class='warning'>You need to empty the rifle to break it down.</span>")
	else
		collapse_rifle(user)

/obj/item/weapon/gun/projectile/heavysniper/proc/collapse_rifle(mob/user)
	to_chat(user, "<span class='warning'>You begin removing \the [src]'s barrel.</span>")
	if(do_after(user, 40))
		if(user.unEquip(src, force=1))
			to_chat(user, "<span class='warning'>You remove \the [src]'s barrel.</span>")
			qdel(src)
			var/obj/item/barrel = new /obj/item/sniper_rifle_part/barrel(user)
			var/obj/item/sniper_rifle_part/assembly = new /obj/item/sniper_rifle_part/body(user)
			var/obj/item/sniper_rifle_part/scope/scope = new(assembly)
			assembly.scope = scope
			assembly.part_count = 2
			assembly.update_build()
			user.put_in_any_hand_if_possible(assembly) || assembly.dropInto(user.loc)
			user.put_in_any_hand_if_possible(barrel) || barrel.dropInto(user.loc)


/obj/item/sniper_rifle_part
	name = "AM rifle part"
	desc = "A part of an antimateriel rifle."

	w_class = ITEMSIZE_NORMAL

	icon = 'icons/obj/gun.dmi'

	var/obj/item/sniper_rifle_part/barrel = null
	var/obj/item/sniper_rifle_part/scope = null
	var/obj/item/sniper_rifle_part/body = null
	var/part_count = 1


/obj/item/sniper_rifle_part/barrel
	name = "AM rifle barrel"
	icon_state = "heavysniper-barrel"

/obj/item/sniper_rifle_part/barrel/New()
	..()
	barrel = src

/obj/item/sniper_rifle_part/scope
	name = "AM rifle scope"
	icon_state = "heavysniper-scope"

/obj/item/sniper_rifle_part/scope/New()
	..()
	scope = src

/obj/item/sniper_rifle_part/body
	name = "AM rifle trigger assembly"
	icon_state = "heavysniper-body"

/obj/item/sniper_rifle_part/body/New()
	..()
	body = src

/obj/item/sniper_rifle_part/attack_self(mob/user as mob)
	if(part_count == 1)
		to_chat(user, "<span class='warning'>You can't disassemble this further!</span>")
		return

	to_chat(user, "<span class='notice'>You start disassembling \the [src].</span>")
	if(!do_after(user, 40))
		return

	to_chat(user, "<span class='notice'>You disassemble \the [src].</span>")
	for(var/obj/item/sniper_rifle_part/P in list(barrel, scope, body))
		if(P.barrel != P)
			P.barrel = null
		if(P.scope != P)
			P.scope = null
		if(P.body != P)
			P.body = null
		if(P != src)
			user.put_in_any_hand_if_possible(P) || P.dropInto(loc)
		P.part_count = 1

	update_build()

/obj/item/sniper_rifle_part/attackby(var/obj/item/sniper_rifle_part/A as obj, mob/user as mob)

	to_chat(user, "<span class='notice'>You begin adding \the [A] to \the [src].</span>")
	if(!do_after(user, 30))
		return



	if(istype(A, /obj/item/sniper_rifle_part/body))
		if(A.part_count > 1 && src.part_count > 1)
			to_chat(user, "<span class='warning'>Disassemble one of these parts first!</span>")
			return

		if(!body)
			if(user.unEquip(A, force=1))
				body = A
		else
			to_chat(user, "<span class='warning'>There's already a trigger group!</span>")
			return

	else if(istype(A, /obj/item/sniper_rifle_part/barrel))
		if(!barrel)
			if(user.unEquip(A, force=1))
				barrel = A
		else
			to_chat(user, "<span class='warning'>There's already a barrel!</span>")
			return

	else if(istype(A, /obj/item/sniper_rifle_part/scope))
		if(!scope)
			if(user.unEquip(A, force=1))
				scope = A
		else
			to_chat(user, "<span class='warning'>There's already a scope!</span>")
			return

	A.forceMove(src)
	to_chat(user, "<span class='notice'>You install \the [A].</span>")

	if(A.barrel && !src.barrel)
		src.barrel = A.barrel
	if(A.scope && !src.scope)
		src.scope = A.scope
	if(A.body && !src.body)
		src.body = A.body


	part_count = A.part_count + src.part_count
	update_build(user)


/obj/item/sniper_rifle_part/proc/update_build()
	switch(part_count)
		if(1)
			name = initial(name)
			w_class = ITEMSIZE_NORMAL
			icon_state = initial(icon_state)
		if(2)
			if(barrel && body)
				name = "AM rifle scope-body assembly"
				icon_state = "heavysniper-scopebody"
			else if(scope && body)
				name = "AM rifle barrel-body assembly"
				icon_state = "heavysniper-bodybarrel"
			else if(scope && barrel)
				name = "AM rifle scope and barrel"
				icon_state = "heavysniper-scopebarrel"
			w_class = ITEMSIZE_LARGE

		if(3)
			var/obj/item/weapon/gun/projectile/heavysniper/collapsible/gun = new (get_turf(src), 0)
			if(usr && istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/user = usr
				user.unEquip(src, force=1)
				user.put_in_any_hand_if_possible(gun) || gun.dropInto(loc)
			qdel(src)

/obj/item/weapon/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"
