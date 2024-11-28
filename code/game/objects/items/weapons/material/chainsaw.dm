/obj/item/chainsaw
	name = "chainsaw"
	desc = "Vroom vroom."
	icon_state = "chainsaw0"
	item_state = "chainsaw0"
	var/on = 0
	var/max_fuel = 100
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	var/active_force = 55
	var/inactive_force = 10

/obj/item/chainsaw/Initialize()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/chainsaw/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(reagents)
		qdel(reagents)
	..()

/obj/item/chainsaw/proc/turnOn(mob/user as mob)
	if(on) return

	visible_message("You start pulling the string on \the [src].", "[user] starts pulling the string on the [src].")

	if(max_fuel <= 0)
		if(do_after(user, 15))
			to_chat(user, "\The [src] won't start!")
		else
			to_chat(user, "You fumble with the string.")
	else
		if(do_after(user, 15))
			visible_message("You start \the [src] up with a loud grinding!", "[user] starts \the [src] up with a loud grinding!")
			attack_verb = list("shredded", "ripped", "torn")
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',40,1)
			force = active_force
			edge = TRUE
			sharp = TRUE
			on = 1
			update_icon()
		else
			to_chat(user, "You fumble with the string.")

/obj/item/chainsaw/proc/turnOff(mob/user as mob)
	if(!on) return
	to_chat(user, "You switch the gas nozzle on the chainsaw, turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',40,1)
	force = inactive_force
	edge = FALSE
	sharp = FALSE
	on = 0
	update_icon()

/obj/item/chainsaw/attack_self(mob/user as mob)
	if(!on)
		turnOn(user)
	else
		turnOff(user)

/obj/item/chainsaw/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(on)
		playsound(src, 'sound/weapons/chainsaw_attack.ogg',40,1)
	if(A && on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			new /obj/structure/grille/broken(A.loc)
			new /obj/item/stack/rods(A.loc)
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			qdel(P) //Plant isn't surviving that. At all
		else if(istype(A,/obj/machinery/portable_atmospherics/hydroponics))
			var/obj/machinery/portable_atmospherics/hydroponics/Hyd = A
			if(Hyd.seed && !Hyd.dead)
				to_chat(user, span_notice("You shred the plant."))
				Hyd.die()
	if (istype(A, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,A) <= 1)
		to_chat(user, span_notice("You begin filling the tank on the chainsaw."))
		if(do_after(user, 15))
			A.reagents.trans_to_obj(src, max_fuel)
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			to_chat(user, span_notice("Chainsaw succesfully refueled."))
		else
			to_chat(user, span_notice("Don't move while you're refilling the chainsaw."))

/obj/item/chainsaw/process()
	if(!on) return

	if(on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
			playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',15,1)
		if(get_fuel() <= 0)
			to_chat(usr, "\The [src] sputters to a stop!")
			turnOff()

/obj/item/chainsaw/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/chainsaw/examine(mob/user)
	. = ..()
	if(max_fuel && get_dist(user, src) == 0)
		. += span_notice("The [src] feels like it contains roughtly [get_fuel()] units of fuel left.")

/obj/item/chainsaw/update_icon()
	if(on)
		icon_state = "chainsaw1"
		item_state = "chainsaw1"
	else
		icon_state = "chainsaw0"
		item_state = "chainsaw0"
