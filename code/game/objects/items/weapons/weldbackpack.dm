/obj/item/weldpack
	name = "Welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	w_class = ITEMSIZE_LARGE
	var/max_fuel = 350
	var/obj/item/nozzle = null //Attached welder, or other spray device.
	var/nozzle_type = /obj/item/weldingtool/tubefed
	var/nozzle_attached = 0
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/weldpack/Initialize(mapload)
	. = ..()
	var/datum/reagents/R = new/datum/reagents(max_fuel) //Lotsa refills
	reagents = R
	R.my_atom = src
	R.add_reagent(REAGENT_ID_FUEL, max_fuel)
	nozzle = new nozzle_type(src)
	nozzle_attached = 1

/obj/item/weldpack/Destroy()
	qdel(nozzle)
	nozzle = null
	return ..()

/obj/item/weldpack/dropped(mob/user)
	..()
	if(nozzle)
		user.remove_from_mob(nozzle)
		return_nozzle()
		to_chat(user, span_notice("\The [nozzle] retracts to its fueltank."))

/obj/item/weldpack/proc/get_nozzle(var/mob/living/user)
	if(!ishuman(user))
		return 0

	var/mob/living/carbon/human/H = user

	if(H.hands_are_full()) //Make sure our hands aren't full.
		to_chat(H, span_warning("Your hands are full.  Drop something first."))
		return 0

	var/obj/item/F = nozzle
	H.put_in_hands(F)
	nozzle_attached = 0

	return 1

/obj/item/weldpack/proc/return_nozzle(var/mob/living/user)
	nozzle.forceMove(src)
	nozzle_attached = 1

/obj/item/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weldingtool) && !(W == nozzle))
		var/obj/item/weldingtool/T = W
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, span_danger("That was stupid of you."))
			explosion(get_turf(src),-1,0,2)
			if(src)
				qdel(src)
			return
		else if(T.status)
			if(T.welding)
				to_chat(user, span_danger("That was close!"))
			src.reagents.trans_to_obj(W, T.max_fuel)
			to_chat(user, span_notice("Welder refilled!"))
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			return
	else if(nozzle)
		if(nozzle == W)
			if(!user.unEquip(W))
				to_chat(user, span_notice("\The [W] seems to be stuck to your hand."))
				return
			if(!nozzle_attached)
				return_nozzle()
				to_chat(user, span_notice("You attach \the [W] to the [src]."))
				return
		else
			to_chat(user, span_notice("The [src] already has a nozzle!"))
	else
		to_chat(user, span_warning("The tank scoffs at your insolence. It only provides services to welders."))
	return

/obj/item/weldpack/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/wearer = user
		if(wearer.back == src)
			if(nozzle && nozzle_attached)
				if(!wearer.incapacitated())
					get_nozzle(user)
			else
				to_chat(user, span_notice("\The [src] does not have a nozzle attached!"))
		else
			..()
	else
		..()

/obj/item/weldpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, span_notice("You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, span_warning("The pack is already full!"))
		return

/obj/item/weldpack/MouseDrop(obj/over_object as obj) //This is terrifying.
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

/obj/item/weldpack/examine(mob/user)
	. = ..()
	. += "It has [src.reagents.total_volume] units of fuel left!"

/obj/item/weldpack/survival
	name = "emergency welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack-e"
	item_state = "welderpack"
	w_class = ITEMSIZE_LARGE
	max_fuel = 100
	nozzle_type = /obj/item/weldingtool/tubefed/survival
