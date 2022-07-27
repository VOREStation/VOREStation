//Poojy's miracle 'I don't want generic pizza' / there's noone working kitchen machine
//Yes it's a generic food 3d printer. ~
// in here because makes sense, if really it's just a refillable autolathe of food

/obj/machinery/synthesizer
	name = "food synthesizer"
	desc = "a device able to produce an incredible array of conventional foods. Although only the most ascetic of users claim it produces truly good tasting products."
	icon = 'icons/obj/machines/synthisizer_vr.dmi'
	icon_state = "synthesizer"
	pixel_y = 32 //So it glues to the wall
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/busy = FALSE
	var/usage_amt = 5

	light_system = STATIC_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE

	var/menu_grade //how tasty is it?
	var/speed_grade //how fast can it be?
	var/filtertext

	circuit = /obj/item/weapon/circuitboard/synthesizer
	var/datum/wires/synthesizer/wires = null

	//loaded cartridge
	var/obj/item/weapon/reagent_containers/synth_disp_cartridge/cart
	var/cart_type = /obj/item/weapon/reagent_containers/synth_disp_cartridge

	//all of our food
	var/static/datum/category_collection/synthesizer_recipes/synthesizer_recipes
	var/food_mimic_storage

	//Voice activation stuff
	var/activator = "computer"
	var/list/voicephrase

	//crew printing required stuff.
	var/db_key
	var/datum/transcore_db/our_db

/obj/machinery/synthesizer/Initialize()
	. = ..()
	cart = new /obj/item/weapon/reagent_containers/synth_disp_cartridge(src)
	if(!synthesizer_recipes)
		synthesizer_recipes = new()
	wires = new(src)

	our_db = SStranscore.db_by_key(db_key)
	default_apply_parts()
	RefreshParts()
	update_icon()

/obj/machinery/synthesizer/mini
	name = "small food synthesizer"
	icon = 'icons/obj/machines/synthisizer_vr.dmi'
	icon_state = "portsynth"
	cart_type = /obj/item/weapon/reagent_containers/synth_disp_cartridge/small

/obj/machinery/synthesizer/mini/Initialize()
	. = ..()
	cart = new /obj/item/weapon/reagent_containers/synth_disp_cartridge/small(src)
	if(!synthesizer_recipes)
		synthesizer_recipes = new()
	wires = new(src)

	our_db = SStranscore.db_by_key(db_key)
	default_apply_parts()
	RefreshParts()
	update_icon()

/obj/machinery/synthesizer/Destroy()
	qdel(wires)
	wires = null
	for(var/obj/item/weapon/reagent_containers/synth_disp_cartridge/C in cart)
		C.loc = get_turf(src.loc)
		C = null
	return ..()

/obj/machinery/synthesizer/examine(mob/user)
	. = ..()
	if(panel_open)
		. += "The cartridge is [cart ? "installed" : "missing"]."
	if(cart && (!(stat & (NOPOWER|BROKEN))))
		var/obj/item/weapon/reagent_containers/synth_disp_cartridge/C = cart
		if(istype(C) && C.reagents && C.reagents.total_volume)
			var/percent = round((C.reagents.total_volume / C.volume) * 100)
			. += "The installed cartridge has [percent]% remaining."

	return

// TGUI to do.
/obj/machinery/synthesizer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Synthesizer", name)
		ui.open()

/obj/machinery/synthesizer/tgui_status(mob/user)
	if(disabled)
		return STATUS_CLOSE
	return ..()

/obj/machinery/synthesizer/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	var/list/recipes = list()
	for(var/datum/category_group/synthesizer/A in synthesizer_recipes.categories)
		categories += A.name
		for(var/datum/category_item/synthesizer/F in A.items)
			if(F.hidden && !hacked)
				continue
			recipes.Add(list(list(
				"category" = A.name,
				"name" = F.name,
				"ref" = REF(F),
				"voice_order" = F.voice_order,
				"voice_temp" = F.voice_temp,
				"hidden" = F.hidden,
			)))
	data["recipes"] = recipes
	data["categories"] = categories
	return data

/obj/machinery/synthesizer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["busy"] = busy
	data["isThereCart"] = cart ? TRUE : FALSE
	var/cartfilling[0]
	if(cart && cart.reagents && cart.reagents.reagent_list.len)
		for(var/datum/reagent/R in cart.reagents.reagent_list)
			cartfilling.Add(list(list("name" = R.name, "id" = R.id, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["cartfilling"] = cartfilling

	if(cart)
		data["cartCurrentVolume"] = cart.reagents.total_volume
		data["cartMaxVolume"] = cart.reagents.maximum_volume
	else
		data["cartCurrentVolume"] = null
		data["cartMaxVolume"] = null

	var/bodyrecords_list_ui[0]
	for(var/N in our_db.body_scans)
		var/datum/transhuman/body_record/BR = our_db.body_scans[N]
		bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")
	data["bodyrecords"] = bodyrecords_list_ui

	return data

/obj/machinery/synthesizer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='notice'>The synthesizer is busy. Please wait for completion of previous operation.</span>")
		playsound(src, 'sound/machines/replicator_input_failed.ogg', 100, 1)
		return
	switch(action)
		if("make")
			var/datum/category_item/synthesizer/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			//Check if we still have the materials.
			var/obj/item/weapon/reagent_containers/synth_disp_cartridge/C = cart
			if(src.check_cart(usr, C)
				//Sanity check.
				if(!making || !src)
					return
				busy = TRUE
				update_use_power(USE_POWER_ACTIVE)
				update_icon() // light up time
				playsound(src, 'sound/machines/replicator_input_ok.ogg', 100)
				C.reagents.remove_reagent("synthsoygreen", 5)
				var/obj/item/weapon/reagent_containers/food/snacks/food_mimic = new making.path(src)
				food_mimic_storage = food_mimic //I guess we need to have the item initalize first to get flavorings!
				sleep(speed_grade) //machine go brrr
				playsound(src, 'sound/machines/replicator_working.ogg', 150)

				//Create the desired item.
				var/obj/item/weapon/reagent_containers/food/snacks/synthsized_meal/meal = new /obj/item/weapon/reagent_containers/food/snacks/synthsized_meal(src.loc)

				//Begin mimicking the food
				meal.name = food_mimic.name
				meal.desc = food_mimic.desc
				meal.icon = food_mimic.icon
				meal.icon_state = food_mimic.icon_state
				meal.center_of_mass = food_mimic.center_of_mass

				//flavor mixing
				var/taste_output = food_mimic.reagents.generate_taste_message()
				for(var/datum/reagent/F in meal.reagents.reagent_list)
					if(F.id == "nutripaste") //This should be the only reagent, actually.
						F.taste_description += " as well as [taste_output]"
						F.data = list(F.taste_description = 1)
						meal.nutriment_desc = list(F.taste_description = 1)

				if(src.menu_grade >= 2) //Is the machine upgraded?
					meal.reagents.add_reagent("nutripaste", ((1 * src.menu_grade) - 1)) //add the missing Nutriment bonus, subtracting the one we've already added in.

				meal.bitesize = food_mimic?.bitesize //suffer your aerogel like 1 Nutriment turkey, nerds.
				meal.filling_color = food_mimic?.filling_color
				meal.trash = food_mimic?.trash	//If this can lead to exploits then we'll remove it, but.
				qdel(food_mimic)
				src.food_mimic_storage = null

			/*	for(var/obj/item/weapon/holder/micro/M in making.path) //Soylent Agent Green is People!!!!!
					//Begin mimicking the snackrifice
					meal.name = M.name
					meal.icon = getFlatIcon(M,0)
					meal.nutriment_desc = M?.vore_taste	*/

				src.audible_message("<span class='notice'>Please take your [meal.name].</span>", runemessage = "[meal.name] is complete!")
				if(Adjacent(usr))
					usr.put_in_any_hand_if_possible(meal)
				busy = FALSE
				update_icon() //turn off lights, please.
			return TRUE

		if("crewprint")
			var/datum/category_item/synthesizer/crewprint = locate(params["crewprint"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			//Check if we still have the materials.
			var/obj/item/weapon/reagent_containers/synth_disp_cartridge/C = cart
			if(src.check_cart(usr, C)
				//Sanity check.
				if(!making || !src)
					return
				busy = TRUE
				update_use_power(USE_POWER_ACTIVE)
				update_icon() // light up time
				playsound(src, 'sound/machines/replicator_input_ok.ogg', 100)
				C.reagents.remove_reagent("synthsoygreen", 5)
				var/mob/living/carbon/human/dummy/mannequin = new()
				client.prefs.dress_preview_mob(mannequin)
				var/obj/item/weapon/reagent_containers/food/snacks/food_mimic = new(mannequin)
				food_mimic_storage = food_mimic //I guess we need to have the item initalize first to get flavorings!
				sleep(speed_grade) //machine go brrr
				playsound(src, 'sound/machines/replicator_working.ogg', 150)

	return FALSE

/obj/machinery/synthesizer/update_icon()
	cut_overlays()

	icon_state = initial(icon_state) //we use this to reduce code bloat. It's nice.
	if(panel_open)
		icon_state = "[initial(icon_state)]_off"
		 //add service panels just above our machine
		if(!(stat & (NOPOWER|BROKEN)))
			add_overlay("[initial(icon_state)]_ppanel")
		else
			add_overlay("[initial(icon_state)]_panel")
		if(cart)
			var/obj/item/weapon/reagent_containers/synth_disp_cartridge/C = cart
			if(C.reagents && C.reagents.total_volume)
				var/image/filling_overlay = image("[icon]", src, "[initial(icon_state)]fill_0")	//Modular filling
				var/percent = round((C.reagents.total_volume / C.volume) * 100)
				switch(percent)
					if(0 to 9)			filling_overlay.icon_state = "[initial(icon_state)]fill_0"
					if(10 to 35)		filling_overlay.icon_state = "[initial(icon_state)]fill_25"
					if(36 to 74)		filling_overlay.icon_state = "[initial(icon_state)]fill_50"
					if(75 to 90)		filling_overlay.icon_state = "[initial(icon_state)]fill_75"
					if(91 to 99)		filling_overlay.icon_state = "[initial(icon_state)]fill_100"
					if(100 to INFINITY)	filling_overlay.icon_state = "[initial(icon_state)]fill_100"
				filling_overlay.color = C.reagents.get_color()
				//Add our filling, if any.
				add_overlay(filling_overlay)
			//Then add our cart so the filling is inside of the canister.
			add_overlay("[initial(icon_state)]_cart")
	else
		icon_state = "[initial(icon_state)]_on"

	if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]_off"
		set_light_on(FALSE)
		return

	if(busy)
		icon_state = "[initial(icon_state)]_busy"
		set_light_color("#faebd7") // "antique white"
		set_light_on(TRUE)
	else
		set_light_on(FALSE)

//Cartridge things
/obj/machinery/synthesizer/proc/add_cart(obj/item/weapon/reagent_containers/synth_disp_cartridge/C, mob/user)
	if(!Adjacent(user))
		return //How did you even try?
	if(!panel_open) //just in case
		to_chat(user, "The hatch must be open to insert a [C].")
		return
	if(!istype(C)) //Never. Trust. Byond.
		if(user)
			to_chat(user, "<span class='warning'>\The [src] only accepts synthiziser cartridges.</span>")
		return
	if(istype(C) && (C != cart_type))
		if(user)
			to_chat(user, "<span class='warning'>\The [src] only accepts smaller synthiziser cartridges.</span>")
		return
	var/obj/item/weapon/reagent_containers/synth_disp_cartridge/R = cart
	if(cart && istype(R)) // let's hot swap that bad boy.
		remove_cart(user)
		return
	else
		user.drop_from_inventory(C)
		cart = C
		C.loc = src
		C.add_fingerprint(user)
		to_chat(user, "<span class='notice'>You add the canister to \the [src].</span>")
	update_icon()
	SStgui.update_uis(src)
	return

/obj/machinery/synthesizer/proc/remove_cart(mob/user)
	var/obj/item/weapon/reagent_containers/synth_disp_cartridge/C = cart
	if(!C)
		to_chat(user, "<span class='notice'>There's no cartridge here...</span>") //Sanity checks aren't ever a bad thing
		return
	if(!Adjacent(user)) //gotta, y'know, be in touch range to pull a physical canister out
		return
	C.loc = get_turf(loc)
	C.update_icon()
	cart = null
	var/obj/item/weapon/reagent_containers/synth_disp_cartridge/R = (user.get_active_hand() || user.get_inactive_hand()) //let's check to see if you're holding a different tank
	if(!istype(R))
		to_chat(user, "<span class='notice'>You remove [C] from  \the [src].</span>")
	else
		add_cart(R, user)
	if(Adjacent(user))
		user.put_in_hands(C) //pick up your trash, nerd. and don't hand it to the AI. They will be upset.
	update_icon()
	SStgui.update_uis(src)

/obj/machinery/synthesizer/proc/check_cart(obj/item/weapon/reagent_containers/synth_disp_cartridge/C, mob/user)
	if(!istype(C))
			to_chat(user, "<span class='notice'>The synthesizer cartridge is nonexistant.</span>")
			playsound(src, 'sound/machines/replicator_input_failed.ogg', 100)
			return FALSE
	if((!(C.reagents)) || (C.reagents.total_volume <= 0))
		to_chat(user, "<span class='notice'>The synthesizer cartridge is empty.</span>")
		playsound(src, 'sound/machines/replicator_input_failed.ogg', 100)
		return FALSE

	else if(C.reagents && (C.reagents.total_volume >= 5))
		SStgui.update_uis(src)
		return TRUE

/obj/machinery/synthesizer/attackby(obj/item/W, mob/user)
	if(busy)
		playsound(src, 'sound/machines/replicator_input_failed.ogg', 100)
		audible_message("<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>", runemessage = "The Synthesizer is busy.")
		return
	if(default_part_replacement(user, W))
		return
	if(stat)
		update_icon()
		return
	if(W.is_screwdriver())
		panel_open = !panel_open
		playsound(src, W.usesound, 50, 1)
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon()
		return
	if(panel_open)
		if(istype(W, /obj/item/weapon/reagent_containers/synth_disp_cartridge))
			if(!anchored)
				to_chat(user, "<span class='warning'>Anchor its bolts first.</span>")
				return
			if(cart)
				var/choice = alert(user, "Replace the cartridge?", "", "Yes", "Cancel")
				switch(choice)
					if("Cancel")
						return FALSE
					if("Yes")
						add_cart(W, user)
			else
				add_cart(W, user)

	if(W.is_wrench())
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You begin to [anchored ? "un" : ""]fasten \the [src].</span>")
		if (do_after(user, 20 * W.toolspeed))
			user.visible_message(
				"<span class='notice'>\The [user] [anchored ? "un" : ""]fastens \the [src].</span>",
				"<span class='notice'>You have [anchored ? "un" : ""]fastened \the [src].</span>",
				"You hear a ratchet.")
			anchored = !anchored
		else
			to_chat(user, "<span class='notice'>You decide not to [anchored ? "un" : ""]fasten \the [src].</span>")

	if(default_deconstruction_crowbar(user, W))
		return

	else
		return ..()

/obj/machinery/synthesizer/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	if(!panel_open)
		user.set_machine(src)
		tgui_interact(user)
	else if(panel_open)
		if(cart)
			var/choice = alert(user, "Removing the Cartridge?", "", "Yes", "Cancel", "Wires Menu")
			switch(choice)
				if("Cancel")
					return FALSE
				if("Yes")
					remove_cart(user)
				if("Wires Menu")
					wires.Interact(user)
		else
			wires.Interact(user)
		return

/obj/machinery/synthesizer/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/synthesizer/interact(mob/user)
	if(panel_open)
		return wires.Interact(user)

	if(disabled)
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)

	tgui_interact(user)

//Updates performance
/obj/machinery/synthesizer/RefreshParts()
	..()
	menu_grade = 0
	speed_grade = 0

	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		speed_grade = (10 SECONDS) / M.rating //let's try to make it worthwhile to upgrade 'em 10s, 5s, 3.3s, 2.5s
	for(var/obj/item/weapon/stock_parts/scanning_module/S in component_parts)
		menu_grade = S.rating //how much bonus Nutriment is added to the printed food. the regular wafer is only 1
		// Science parts will be of help if they bother.
	update_tgui_static_data(usr)

//obj/machinery/synthesizer/proc/copy(var/atom/food) //get path.name and details from here
//	var/obj/belly/dupe = new /obj/belly(new_owner)

//obj/machinery/synthesizer/proc/synthesize(var/what, var/temp, var/mob/living/user)
//	var/atom/food

/obj/item/weapon/reagent_containers/synth_disp_cartridge
	name = "Synthesizer cartridge"
	desc = "This goes in a food Synthesizer."
	icon = 'icons/obj/machines/synthisizer_vr.dmi'
	icon_state = "bigcart"

	w_class = ITEMSIZE_NORMAL

	volume = 250 //enough for feeding folk, but not so much it won't be needing replacment
	possible_transfer_amounts = null

/obj/item/weapon/reagent_containers/synth_disp_cartridge/small
	name = "Portable Synthesizer Cartridge"
	icon_state = "Scart"
	w_class = ITEMSIZE_NORMAL
	volume = 100

/obj/item/weapon/reagent_containers/synth_disp_cartridge/Initialize()
	. = ..()
	reagents.add_reagent("synthsoygreen", volume)
	update_icon()

/obj/item/weapon/reagent_containers/synth_disp_cartridge/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/image/filling_overlay = image("[icon]", src, "[initial(icon_state)]fill_0", layer = src.layer - 0.1)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)			filling_overlay.icon_state = "[initial(icon_state)]fill_0"
			if(10 to 35)		filling_overlay.icon_state = "[initial(icon_state)]fill_25"
			if(36 to 74)		filling_overlay.icon_state = "[initial(icon_state)]fill_50"
			if(75 to 90)		filling_overlay.icon_state = "[initial(icon_state)]fill_75"
			if(91 to 100)		filling_overlay.icon_state = "[initial(icon_state)]fill_100"
			if(100 to INFINITY)	filling_overlay.icon_state = "[initial(icon_state)]fill_100"
		filling_overlay.color = reagents.get_color()
		add_overlay(filling_overlay)

/obj/item/weapon/reagent_containers/synth_disp_cartridge/examine(mob/user)
	. = ..()
	if(reagents && reagents.total_volume)
		var/percent = round((reagents.total_volume / volume) * 100)
		. += "The cartridge has [percent]% remaining."

	return

/* Voice activation stuff.
can tgui accept orders that isn't through the menu? Probably. hijack that.

/obj/machinery/synthesizer/hear_talk(mob/M, list/message_pieces, verb)


/obj/machinery/synthesizer/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	. = ..()
	if(speaker == src)
		return
	if(!(get_dist(src, speaker) <= 1))
		return
	else
		check_activation(speaker, raw_message)

/obj/machinery/synthesizer/proc/check_activation(atom/movable/speaker, raw_message)
	if(!powered() || busy || panel_open)//Shut down.
		return
	if(!findtext(raw_message, activator))
		return FALSE //They have to say computer, like a discord bot prefix.
	if(!busy)
		if(findtext(raw_message, "?")) //Burger? no be SPECIFIC.
			return FALSE

		if(!findtext(raw_message, ",")) // gotta place pauses between your request. All hail comma.
			audible_message("<span class='notice'>Unable to Comply, Please state request with specific pauses.</span>", runemessage = "BUZZ")
			return

		var/target
		var/temp = null
		for(var/X in all_menus)
			var/tofind = X
			if(findtext(raw_message, tofind))
				target = tofind //Alright they've asked for something on the menu.

		for(var/Y in temps) //See if they want it hot, or cold.
			var/hotorcold = Y
			if(findtext(raw_message, hotorcold))
				temp = hotorcold //If they specifically request a temperature, we'll oblige. Else it doesn't rename.
		if(target && powered())
			menutype = REPLICATING
			idle_power_usage = 400
			icon_state = "replicator-on"
			playsound(src, 'DS13/sound/effects/replicator.ogg', 100, 1)
			ready = FALSE
			var/speed_mult = 60 //Starts off hella slow.
			speed_mult -= (speed_grade*10) //Upgrade with manipulators to make this faster!

		synthesize(tofind, hotorcold, speaker)


/obj/machinery/synthesizer/proc/synthesize(var/what, var/temp, var/mob/living/user)
	var/atom/food

	/var/list/order = list(
	order["activator"] = activator
	order["menu_order"] = menu_order
	order["temp_or_name"] = temp_or_name)

	tgui_act("add_order", order)

*/
