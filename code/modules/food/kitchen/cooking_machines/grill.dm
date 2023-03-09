/obj/machinery/appliance/cooker/grill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	cook_type = "grilled"
	appliancetype = GRILL
	food_color = "#A34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	can_burn_food = TRUE
	var/datum/looping_sound/grill/grill_loop
	circuit = /obj/item/weapon/circuitboard/grill
	active_power_usage = 4 KILOWATTS
	heating_power = 4000
	idle_power_usage = 2 KILOWATTS

	optimal_power = 1.2 // Things on the grill cook .6 faster - this is now the fastest appliance to heat and to cook on. BURGERS GO SIZZLE.

	stat = POWEROFF // Starts turned off.

	// Grill is faster to heat and setup than the rest.
	optimal_temp = 120 + T0C
	min_temp = 60 + T0C
	resistance = 8 KILOWATTS // Very fast to heat up.

	max_contents = 3 // Arbitrary number, 3 grill 'racks'
<<<<<<< HEAD
	container_type = /obj/item/weapon/reagent_containers/cooking_container/grill
	
=======
	container_type = /obj/item/reagent_containers/cooking_container/grill

>>>>>>> 75577bd3ca9... cleans up so many to_chats so they use vchat filters, unsorted chat filter for everything else (#9006)
/obj/machinery/appliance/cooker/grill/Initialize()
	. = ..()
	grill_loop = new(list(src), FALSE)

/obj/machinery/appliance/cooker/grill/Destroy()
	QDEL_NULL(grill_loop)
	return ..()

/obj/machinery/appliance/cooker/grill/update_icon() // TODO: Cooking icon
	if(!stat)
		icon_state = on_icon
		if(cooking == TRUE)
			if(grill_loop)
				grill_loop.start(src)
		else
			if(grill_loop)
				grill_loop.stop(src)
	else
		icon_state = off_icon
		if(grill_loop)
			grill_loop.stop(src)
<<<<<<< HEAD
=======

/* // Test Comment this out too, /cooker does this for us, and this path '/obj/machinery/appliance/grill' is invalid anyways, meaning it does jack shit. - Updated the paths, but I'm basically commenting all this shit out and if the grill works as-normal, none of this stuff is needed.
/obj/machinery/appliance/grill/toggle_power()
	set src in view()
	set name = "Toggle Power"
	set category = "Object"

	var/datum/cooking_item/CI = cooking_objs[1]

	if (stat & POWEROFF)//Its turned off
		stat &= ~POWEROFF
		if (usr)
			usr.visible_message("<span class='filter_notice'>[usr] turns \the [src] on.</span>", "<span class='filter_notice'>You turn on \the [src].</span>")
			get_cooking_work(CI)
			use_power = 2
	else //It's on, turn it off
		stat |= POWEROFF
		use_power = 0
		if (usr)
			usr.visible_message("<span class='filter_notice'>[usr] turns \the [src] off.</span>", "<span class='filter_notice'>You turn off \the [src].</span>")
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()


/obj/machinery/appliance/cooker/grill/Initialize()
	. = ..()
	// cooking_objs += new /datum/cooking_item(new /obj/item/reagent_containers/cooking_container(src))
	cooking = FALSE

/obj/machinery/appliance/cooker/grill/has_space(var/obj/item/I)
	var/datum/cooking_item/CI = cooking_objs[1]
	if (!CI || !CI.container)
		return 0

	if (CI.container.can_fit(I))
		return CI

	return 0
*/
/* // Test comment this out, I don't think this is doing shit anyways.
//Container is not removable
/obj/machinery/appliance/grill/removal_menu(var/mob/user)
	if (can_remove_items(user))
		var/list/menuoptions = list()
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			if (CI.container)
				if (!CI.container.check_contents())
					to_chat(user, "<span class='filter_notice'>There's nothing in the [src] you can remove!</span>")
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
*/

/* // Test remove this too.
/obj/machinery/appliance/grill/process()
	if (!stat)
		for (var/i in cooking_objs)
			do_cooking_tick(i)
*/
>>>>>>> 75577bd3ca9... cleans up so many to_chats so they use vchat filters, unsorted chat filter for everything else (#9006)
