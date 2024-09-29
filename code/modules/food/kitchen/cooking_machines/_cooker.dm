/obj/machinery/appliance/cooker
	var/temperature = T20C
	var/min_temp = 80 + T0C	//Minimum temperature to do any cooking
	var/optimal_temp = 200 + T0C	//Temperature at which we have 100% efficiency. efficiency is lowered on either side of this
	var/optimal_power = 0.6 //cooking power at 100% - This variable determines the MAXIMUM increase in do_cooking_ticks, once math goes through. If you want ticks of 0.5, set it to 0.5, etc.

	var/loss = 1	//Temp lost per proc when equalising
	var/resistance = 1200	//Resistance to heating. combines with heating power to determine how long heating takes. 32k by default.

	var/light_x = 0
	var/light_y = 0
	cooking_coeff = 0
	cooking_power = 0
	mobdamagetype = BURN
	can_burn_food = TRUE

/obj/machinery/appliance/cooker/attack_hand(mob/user)
	tgui_interact(user)

/obj/machinery/appliance/cooker/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CookingAppliance", name)
		ui.open()

/obj/machinery/appliance/cooker/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["temperature"] = round(temperature - T0C, 0.1)
	data["optimalTemp"] = round(optimal_temp - T0C, 0.1)
	data["temperatureEnough"] = temperature >= min_temp
	data["efficiency"] = round(get_efficiency(), 0.1)
	data["containersRemovable"] = can_remove_items(user, show_warning = FALSE)

	var/list/our_contents = list()
	for(var/i in 1 to max_contents)
		our_contents += list(list("empty" = TRUE))
		if(i <= LAZYLEN(cooking_objs))
			var/datum/cooking_item/CI = cooking_objs[i]
			if(istype(CI))
				our_contents[i] = list()
				our_contents[i]["progress"] = 0
				our_contents[i]["progressText"] = report_progress_tgui(CI)
				if(CI.max_cookwork)
					our_contents[i]["progress"] = CI.cookwork / CI.max_cookwork
				if(CI.container)
					our_contents[i]["container"] = CI.container.label(i)
				else
					our_contents[i]["container"] = null
	data["our_contents"] = our_contents

	return data

/obj/machinery/appliance/cooker/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("slot")
			var/slot = params["slot"]
			var/obj/item/I = usr.get_active_hand()
			if(slot <= LAZYLEN(cooking_objs)) // Inserting
				var/datum/cooking_item/CI = cooking_objs[slot]

				if(istype(I) && can_insert(I)) // Why do hard work when we can just make them smack us?
					attackby(I, usr)
				else if(istype(CI))
					eject(CI, usr)
				return TRUE
			if(istype(I)) // Why do hard work when we can just make them smack us?
				attackby(I, usr)
			return TRUE

/obj/machinery/appliance/cooker/examine(var/mob/user)
	. = ..()
	if(.)	//no need to duplicate adjacency check
		if(!stat)
			if (temperature < min_temp)
				. += "<span class='warning'>\The [src] is still heating up and is too cold to cook anything yet.</span>"
			else
				. += "<span class='notice'>It is running at [round(get_efficiency(), 0.1)]% efficiency!</span>"
			. += "Temperature: [round(temperature - T0C, 0.1)]C / [round(optimal_temp - T0C, 0.1)]C"
		else
			. += "<span class='warning'>It is switched off.</span>"

/obj/machinery/appliance/cooker/list_contents(var/mob/user)
	if (cooking_objs.len)
		var/string = "Contains...</br>"
		var/num = 0
		for (var/a in cooking_objs)
			num++
			var/datum/cooking_item/CI = a
			if (CI && CI.container)
				string += "- [CI.container.label(num)], [report_progress(CI)]</br>"
		to_chat(user, string)
	else
		to_chat(user, "<span class='notice'>It's empty.</span>")

/obj/machinery/appliance/cooker/proc/get_efficiency()
	// to_world("Our cooking_power is [cooking_power] and our efficiency is [(cooking_power / optimal_power) * 100].") // Debug lines, uncomment if you need to test.
	return (cooking_power / optimal_power) * 100

/obj/machinery/appliance/cooker/Initialize()
	. = ..()
	loss = (active_power_usage / resistance)*0.5
	cooking_objs = list()
	for (var/i = 0, i < max_contents, i++)
		cooking_objs.Add(new /datum/cooking_item/(new container_type(src)))
	cooking = FALSE

	update_icon() // this probably won't cause issues, but Aurora used SSIcons and queue_icon_update() instead

/obj/machinery/appliance/cooker/update_icon()
	cut_overlays()
	var/image/light
	if(use_power == 1 && !stat)
		light = image(icon, "light_idle")
	else if(use_power == 2 && !stat)
		light = image(icon, "light_preheating")
	else
		light = image(icon, "light_off")
	light.pixel_x = light_x
	light.pixel_y = light_y
	add_overlay(light)

/obj/machinery/appliance/cooker/process()
	if (!stat)
		heat_up()
	else
		var/turf/T = get_turf(src)
		if (temperature > T.temperature)
			equalize_temperature()
	..()

/obj/machinery/appliance/cooker/power_change()
	. = ..()
	update_icon() // this probably won't cause issues, but Aurora used SSIcons and queue_icon_update() instead

/obj/machinery/appliance/cooker/proc/update_cooking_power()
	var/temp_scale = 0
	if(temperature > min_temp)
		if(temperature >= optimal_temp) // If we're at or above optimal temp, then we're going to be at 1 for temp scale. No use penalizing you for the cookers increasing heat constantly (until we implement setting a temp on the oven via a menu.)
			temp_scale = 1
		else
			temp_scale = (temperature - min_temp) / (optimal_temp - min_temp) // If we're between min and optimal this will yield a value in the range 0-1

		/* // old code for reference, will be useful if/when we implement ovens with configurable temperatures - TODO recipes with optimal temps for cooking per-recipe??
		temp_scale = (temperature - min_temp) / (optimal_temp - min_temp) // If we're between min and optimal this will yield a value in the range 0-1

		if(temp_scale > 1) // We're above optimal, efficiency goes down as we pass too much over it
			if(temp_scale >= 2)
				temp_scale = 0
			else
				temp_scale = 1 - (temp_scale - 1)
		*/

	cooking_coeff = optimal_power * temp_scale
	// to_world("Our cooking_power is [cooking_power] and our tempscale is [temp_scale], and our cooking_coeff is [cooking_coeff] before RefreshParts.") // Debug lines, uncomment if you need to test.
	RefreshParts()
	// to_world("Our cooking_power is [cooking_power] after RefreshParts.") // Debug lines, uncomment if you need to test.

/obj/machinery/appliance/cooker/proc/heat_up()
	if(temperature < optimal_temp)
		if(use_power == 1 && ((optimal_temp - temperature) > 5))
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			use_power = 2.//If we're heating we use the active power
			update_icon()
		temperature += heating_power / resistance
		update_cooking_power()
		return 1
	else
		if(use_power == 2)
			use_power = 1
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			update_icon()
		//We're holding steady. temperature falls more slowly
		if(prob(25))
			equalize_temperature()
			return -1

/obj/machinery/appliance/cooker/proc/equalize_temperature()
	temperature -= loss//Temperature will fall somewhat slowly
	update_cooking_power()

//Cookers do differently, they use containers
/obj/machinery/appliance/cooker/has_space(var/obj/item/I)
	if(istype(I, /obj/item/reagent_containers/cooking_container))
		//Containers can go into an empty slot
		if(cooking_objs.len < max_contents)
			return 1
	else
		//Any food items directly added need an empty container. A slot without a container cant hold food
		for (var/datum/cooking_item/CI in cooking_objs)
			if (CI.container.check_contents() == 0)
				return CI

	return 0

/obj/machinery/appliance/cooker/add_content(var/obj/item/I, var/mob/user)
	var/datum/cooking_item/CI = ..()
	if(istype(CI) && CI.combine_target)
		to_chat(user, "<span class='filter_notice'>\The [I] will be used to make a [selected_option]. Output selection is returned to default for future items.</span>")
		selected_option = null