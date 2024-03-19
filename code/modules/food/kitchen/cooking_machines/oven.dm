/obj/machinery/appliance/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "ovenopen"
	cook_type = "baked"
	appliancetype = OVEN
	food_color = "#A34719"
	can_burn_food = TRUE
	var/datum/looping_sound/oven/oven_loop
	circuit = /obj/item/weapon/circuitboard/oven
	active_power_usage = 6 KILOWATTS
	heating_power = 6 KILOWATTS
	//Based on a double deck electric convection oven

	resistance = 2 KILOWATTS // Approx. 2 minutes to heat up.
	idle_power_usage = 2 KILOWATTS
	//uses ~30% power to stay warm
	optimal_power = 0.8 // Oven cooks .2 faster than the default speed.

	light_x = 3
	light_y = 4
	max_contents = 5
	container_type = /obj/item/weapon/reagent_containers/cooking_container/oven

	stat = POWEROFF	//Starts turned off

	var/open = FALSE // Start closed just so people don't try to preheat with it open, lol.

	output_options = list(
		"Pizza" = /obj/item/weapon/reagent_containers/food/snacks/variable/pizza,
		"Bread" = /obj/item/weapon/reagent_containers/food/snacks/variable/bread,
		"Pie" = /obj/item/weapon/reagent_containers/food/snacks/variable/pie,
		"Cake" = /obj/item/weapon/reagent_containers/food/snacks/variable/cake,
		"Hot Pocket" = /obj/item/weapon/reagent_containers/food/snacks/variable/pocket,
		"Kebab" = /obj/item/weapon/reagent_containers/food/snacks/variable/kebab,
		"Waffles" = /obj/item/weapon/reagent_containers/food/snacks/variable/waffles,
		"Cookie" = /obj/item/weapon/reagent_containers/food/snacks/variable/cookie,
		"Donut" = /obj/item/weapon/reagent_containers/food/snacks/variable/donut,
		)

/obj/machinery/appliance/cooker/oven/Initialize()
	. = ..()

	oven_loop = new(list(src), FALSE)

/obj/machinery/appliance/cooker/oven/Destroy()
	QDEL_NULL(oven_loop)
	return ..()

/obj/machinery/appliance/cooker/oven/update_icon()
	if(!open)
		if(!stat)
			icon_state = "ovenclosed_on"
			if(cooking == TRUE)
				icon_state = "ovenclosed_cooking"
				if(oven_loop)
					oven_loop.start(src)
			else
				icon_state = "ovenclosed_on"
				if(oven_loop)
					oven_loop.stop(src)
		else
			icon_state = "ovenclosed_off"
			if(oven_loop)
				oven_loop.stop(src)
	else
		icon_state = "ovenopen"
		if(oven_loop)
			oven_loop.stop(src)
	..()

/obj/machinery/appliance/cooker/oven/AltClick(var/mob/user)
	try_toggle_door(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/machinery/appliance/cooker/oven/verb/toggle_door()
	set src in oview(1)
	set category = "Object"
	set name = "Open/close oven door"

	try_toggle_door(usr)

/obj/machinery/appliance/cooker/oven/proc/try_toggle_door(mob/user)
	if(!isliving(usr) || isAI(user))
		return

	if(!usr.IsAdvancedToolUser())
		to_chat(user, "<span class='notice'>You lack the dexterity to do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(user, "<span class='notice'>You can't reach the [src] from there, get closer!</span>")
		return

	if(open)
		open = FALSE
		loss = (heating_power / resistance) * 0.5
		cooking = TRUE
	else
		open = TRUE
		loss = (heating_power / resistance) * 4
		//When the oven door is opened, heat is lost MUCH faster and you stop cooking (because the door is open)
		cooking = FALSE

	playsound(src, 'sound/machines/hatch_open.ogg', 20, 1)
	to_chat(user, "<span class='notice'>You [open? "open":"close"] the oven door</span>")
	update_icon()

/obj/machinery/appliance/cooker/oven/proc/manip(var/obj/item/I)
	// check if someone's trying to manipulate the machine

	if(I.has_tool_quality(TOOL_CROWBAR) || I.has_tool_quality(TOOL_SCREWDRIVER) || istype(I, /obj/item/weapon/storage/part_replacer))
		return TRUE
	else
		return FALSE

/obj/machinery/appliance/cooker/oven/can_insert(var/obj/item/I, var/mob/user)
	if(!open && !manip(I))
		to_chat(user, "<span class='warning'>You can't put anything in while the door is closed!</span>")
		return 0

	else
		return ..()


//If an oven's door is open it will lose heat every proc, even if it also gained it
//But dont call equalize twice in one stack. A return value of -1 from the parent indicates equalize was already called
/obj/machinery/appliance/cooker/oven/heat_up()
	.=..()
	if(open && . != -1)
		var/turf/T = get_turf(src)
		if(temperature > T.temperature)
			equalize_temperature()

/obj/machinery/appliance/cooker/oven/can_remove_items(var/mob/user, show_warning = TRUE)
	if(!open)
		if(show_warning)
			to_chat(user, "<span class='warning'>You can't take anything out while the door is closed!</span>")
		return 0

	else
		return ..()


//Oven has lots of recipes and combine options. The chance for interference is high, so
//If a combine target is set the oven will do it instead of checking recipes
/obj/machinery/appliance/cooker/oven/finish_cooking(var/datum/cooking_item/CI)
	if(CI.combine_target)
		CI.result_type = 3//Combination type. We're making something out of our ingredients
		visible_message("<b>\The [src]</b> pings!")
		combination_cook(CI)
		return
	else
		..()
