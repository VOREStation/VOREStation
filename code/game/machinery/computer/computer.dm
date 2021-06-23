/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	blocks_emissive = FALSE
	var/processing = 0

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_range_on = 2
	var/light_power_on = 1

	clicksound = "keyboard"

/obj/machinery/computer/Initialize()
	. = ..()
	power_change()
	update_icon()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()


/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			fall_apart(severity)
			return
		if(2.0)
			if (prob(25))
				fall_apart(severity)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage()))
		set_broken()
	..()

/obj/machinery/computer/blob_act()
	ex_act(2)

/obj/machinery/computer/update_icon()
	cut_overlays()
	
	. = list()

	if(icon_keyboard)
		if(stat & NOPOWER)
			playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
			return add_overlay("[icon_keyboard]_off")
		. += icon_keyboard

	// This whole block lets screens ignore lighting and be visible even in the darkest room
	var/overlay_state = icon_screen
	if(stat & BROKEN)
		overlay_state = "[icon_state]_broken"
	. += mutable_appearance(icon, overlay_state)
	. += emissive_appearance(icon, overlay_state)
	playsound(src, 'sound/machines/terminal_on.ogg', 50, 1)

	add_overlay(.)

/obj/machinery/computer/power_change()
	..()
	update_icon()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(I as obj, user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		if(istype(I,/obj/item/weapon/gripper)) //Behold, Grippers and their horribleness. If ..() is called by any computers' attackby() now or in the future, this should let grippers work with them appropriately.
			var/obj/item/weapon/gripper/B = I	//B, for Borg.
			if(!B.wrapped)
				to_chat(user, "\The [B] is not holding anything.")
				return
			else
				var/B_held = B.wrapped
				to_chat(user, "You use \the [B] to use \the [B_held] with \the [src].")
				playsound(src, "keyboard", 100, 1, 0)
			return
		attack_hand(user)
		return
