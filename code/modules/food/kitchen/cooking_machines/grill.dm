/obj/machinery/appliance/cooker/grill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	cook_type = "grilled"
	food_color = "#A34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	can_burn_food = 1
	stat = POWEROFF

/obj/machinery/appliance/grill/toggle_power()
	set src in view()
	set name = "Toggle Power"
	set category = "Object"

	var/datum/cooking_item/CI = cooking_objs[1]

	if (stat & POWEROFF)//Its turned off
		stat &= ~POWEROFF
		if (usr)
			usr.visible_message("[usr] turns \the [src] on", "You turn on \the [src].")
			get_cooking_work(CI)
			use_power = 2
	else //It's on, turn it off
		stat |= POWEROFF
		use_power = 0
		if (usr)
			usr.visible_message("[usr] turns \the [src] off", "You turn off \the [src].")
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/grill/initialize()
	. = ..()
	cooking_objs += new /datum/cooking_item(new /obj/item/weapon/reagent_containers/cooking_container(src))
	cooking = 0

/obj/machinery/appliance/grill/has_space(var/obj/item/I)
	var/datum/cooking_item/CI = cooking_objs[1]
	if (!CI || !CI.container)
		return 0

	if (CI.container.can_fit(I))
		return CI

	return 0

//Container is not removable
/obj/machinery/appliance/grill/removal_menu(var/mob/user)
	if (can_remove_items(user))
		var/list/menuoptions = list()
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			if (CI.container)
				if (!CI.container.check_contents())
					to_chat(user, "There's nothing in the [src] you can remove!")
					return

				for (var/obj/item/I in CI.container)
					menuoptions[I.name] = I

		var/selection = input(user, "Which item would you like to remove? If you want to remove chemicals, use an empty beaker.", "Remove ingredients") as null|anything in menuoptions
		if (selection)
			var/obj/item/I = menuoptions[selection]
			if (!user || !user.put_in_hands(I))
				I.forceMove(get_turf(src))
			update_icon()
		return 1
	return 0

/obj/machinery/appliance/grill/update_icon()
	if (!stat)
		icon_state = on_icon
	else
		icon_state = off_icon

/obj/machinery/appliance/grill/process()
	if (!stat)
		for (var/i in cooking_objs)
			do_cooking_tick(i)