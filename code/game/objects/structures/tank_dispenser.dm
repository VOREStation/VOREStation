#define TANK_DISPENSER_CAPACITY 10

/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten phoron tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = ITEMSIZE_HUGE
	var/oxygentanks = TANK_DISPENSER_CAPACITY
	var/phorontanks = TANK_DISPENSER_CAPACITY


/obj/structure/dispenser/oxygen
	phorontanks = 0

/obj/structure/dispenser/phoron
	oxygentanks = 0


/obj/structure/dispenser/Initialize()
	. = ..()
	for(var/i in 1 to oxygentanks)
		new /obj/item/weapon/tank/oxygen(src)
	for(var/i in 1 to phorontanks)
		new /obj/item/weapon/tank/phoron(src)
	update_icon()

/obj/structure/dispenser/update_icon()
	cut_overlays()
	switch(oxygentanks)
		if(1 to 3)	add_overlay("oxygen-[oxygentanks]")
		if(4 to INFINITY) add_overlay("oxygen-4")
	switch(phorontanks)
		if(1 to 4)	add_overlay("phoron-[phorontanks]")
		if(5 to INFINITY) add_overlay("phoron-5")

/obj/structure/dispenser/attack_ai(mob/user)
	// This looks silly, but robots also call attack_ai, and they're allowed physical state stuff.
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	tgui_interact(user)

/obj/structure/dispenser/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/structure/dispenser/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TankDispenser", name)
		ui.open()

/obj/structure/dispenser/tgui_data(mob/user)
	var/list/data = list()
	data["oxygen"] = oxygentanks
	data["plasma"] = phorontanks

	return data

/obj/structure/dispenser/attackby(obj/item/I, mob/user)
	var/full
	if(istype(I, /obj/item/weapon/tank/oxygen) || istype(I, /obj/item/weapon/tank/air) || istype(I, /obj/item/weapon/tank/anesthetic))
		if(oxygentanks < TANK_DISPENSER_CAPACITY)
			oxygentanks++
		else
			full = TRUE
	else if(istype(I, /obj/item/weapon/tank/phoron))
		if(phorontanks < TANK_DISPENSER_CAPACITY)
			phorontanks++
		else
			full = TRUE
	else if(I.is_wrench())
		if(anchored)
			to_chat(user, "<span class='notice'>You lean down and unwrench [src].</span>")
			anchored = FALSE
		else
			to_chat(user, "<span class='notice'>You wrench [src] into place.</span>")
			anchored = TRUE
		return
	else if(user.a_intent != I_HURT)
		to_chat(user, "<span class='notice'>[I] does not fit into [src].</span>")
		return
	else
		return ..()

	if(full)
		to_chat(user, "<span class='notice'>[src] can't hold any more of [I].</span>")
		return

	if(!user.unEquip(I, target = src))
		return
	to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
	update_icon()


/obj/structure/dispenser/tgui_act(action, params)
	if(..())
		return
	switch(action)
		if("plasma")
			var/obj/item/weapon/tank/phoron/tank = locate() in src
			if(tank && Adjacent(usr))
				usr.put_in_hands(tank)
				phorontanks--
			. = TRUE
			playsound(src, 'sound/items/drop/gascan.ogg', 100, 1, 1)
		if("oxygen")
			var/obj/item/weapon/tank/tank = null
			for(var/obj/item/weapon/tank/T in src)
				if(istype(T, /obj/item/weapon/tank/oxygen) || istype(T, /obj/item/weapon/tank/air) || istype(T, /obj/item/weapon/tank/anesthetic))
					tank = T
					break
			if(tank && Adjacent(usr))
				usr.put_in_hands(tank)
				oxygentanks--
			. = TRUE
			playsound(src, 'sound/items/drop/gascan.ogg', 100, 1, 1)
	update_icon()