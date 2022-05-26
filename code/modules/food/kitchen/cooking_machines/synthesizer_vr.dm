//Poojy's miracle 'I don't want generic pizza' / there's noone working kitchen machine
//Yes it's a generic food 3d printer. ~
// in here because makes sense, if really it's just a refillable autolathe of food

/obj/machinery/synthesizer
	name = "food synthesizer"
	desc = "a device able to produce an incredible array of conventional foods. Although only the most ascetic of users claim it produces truly good tasting products."
	icon = 'icons/obj/machines/synthisizer_vr.dmi'
	icon_state = "synthesizer_off"
	pixel_y = 32 //So it glues to the wall
	density = TRUE
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

	light_system = STATIC_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE

	var/menu_grade //how tasty is it?
	var/speed_grade //how fast can it be?

	circuit = /obj/item/weapon/circuitboard/synthesizer
	var/obj/item/weapon/reagent_containers/synth_disp_cartridge/cart
	var/cart_type = /obj/item/weapon/reagent_containers/synth_disp_cartridge
	var/datum/wires/synthesizer/wires
	var/static/datum/category_collection/synthesizer_recipes

	//Voice activation stuff
	var/activator = "computer"
	var/list/voicephrase


/obj/machinery/synthesizer/Initialize()
	Initialize()
	. = ..()
	if(cart_type)
		cart = cart_type
	wires = new(src)

	default_apply_parts()
	RefreshParts()
	update_icon()

/obj/machinery/synthesizer/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/synthesizer/examine(mob/user)
	. = ..()
	if(panel_open)
		. += "The cartridge is [cart ? "installed" : "missing"]."
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

/obj/machinery/synthesizer/update_icon()
	cut_overlays()
	icon_state = initial(icon_state)
	if(panel_open)
		icon_state = "[icon_state]_off"
		if(!NOPOWER)
			add_overlay("[icon_state]_ppanel")
		else
			add_overlay("[icon_state]_panel")
		if(cart)
			if(cart.reagents.total_volume)
				var/mutable_appearance/filling_overlay = mutable_appearance(icon, "cartfill_", layer = src.layer - 0.1) //just under it so the glass effect looks nice
				var/percent = cart.percent()
				switch(percent)
					if(0 to 9)
						filling_overlay.icon_state = "cartfill_0"
					if(10 to 35)
						filling_overlay.icon_state = "cartfill_25"
					if(36 to 74)
						filling_overlay.icon_state = "cartfill_50"
					if(75 to 90)
						filling_overlay.icon_state = "cartfill_75"
					if(91 to INFINITY)
						filling_overlay.icon_state = "cartfill_100"
				add_overlay(filling_overlay)
			add_overlay("[icon_state]_cart")

	if(stat & NOPOWER)
		icon_state = "[icon_state]_off"
		set_light_on(FALSE)
		return

	if(busy)
		icon_state = "[icon_state]_busy"
		set_light_color("#faebd7") // "antique white"
		set_light_on(TRUE)
	else
		set_light_on(FALSE)

/obj/machinery/synthesizer/proc/add_cart(obj/item/weapon/reagent_containers/synth_disp_cartridge/C, mob/user)
	if(!panel_open) //just in case
		to_chat(user, "The hatch must be open to insert a [C].")
		return

	if(!istype(C)) //Never. Trust. Byond.
		if(user)
			to_chat(user, "<span class='warning'>\The [src] only accepts synthiziser cartridges.</span>")
		return

	if(cart) // let's hot swap that bad boy.
		remove_cart(C, user)
		return

	else if(!cart)
		user.drop_from_inventory(C)
		cart = C
		C.loc = src
		C.add_fingerprint(user)
		to_chat(user, "<span class='notice'>You add the canister to \the [src].</span>")
		SStgui.update_uis(src)
		return

/obj/machinery/synthesizer/proc/remove_cart(obj/item/weapon/reagent_containers/synth_disp_cartridge/C, mob/user)
	for(var/obj/item/weapon/reagent_containers/synth_disp_cartridge/old in src)
		if(old in cart)
			old.loc = get_turf(src.loc)
			cart--
			C.loc = src
			C.add_fingerprint(user)
			cart = C
			user.put_in_hands(old)
			to_chat(user, "<span class='notice'>You remove [old] and insert the new [C] to \the [src].</span>")
		else
			to_chat(user, "<span class='notice'>There's no cartridge here...</span>") //Sanity checks aren't ever a bad thing
			return
		SStgui.update_uis(src)

/obj/machinery/synthesizer/attackby(obj/item/W, mob/user)
	if(busy)
		audible_message("<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>", runemessage = "BUZZ")
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(stat)
		return
	if(panel_open)
		if(W.is_multitool() || W.is_wirecutter())
			wires.Interact(user)
			return
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

	if(W.is_screwdriver())
		panel_open = !panel_open
		playsound(src, W.usesound, 50, 1)
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon()

	else
		return ..()

/obj/machinery/synthesizer/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	if(panel_open)
		return wires.Interact(user)
	user.set_machine(src)
	tgui_interact(user)

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


// TGUI to do.
/obj/machinery/synthesizer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Food Synthesizer", name)
		ui.open()

/obj/machinery/synthesizer/tgui_status(mob/user)
	if(disabled)
		return STATUS_CLOSE
	return ..()

/obj/machinery/synthesizer/tgui_static_data(mob/user)
	var/list/data = ..()
	var/list/categories
	var/list/recipes
	for(var/datum/category_group/synthesizer_recipes/A in synthesizer_recipes.categories)
		categories += A.name
		for(var/datum/category_item/synthesizer/F in A)
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
	var/list/data = ..(
	"Cartstatus" = cart ? cart.percent() : null,)
	data["busy"] = busy
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	data["materials"] = materials.tgui_data()
	return data

/obj/machinery/synthesizer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='notice'>The synthesizer is busy. Please wait for completion of previous operation.</span>")
		return
	switch(action)
		if("make")
			var/datum/category_item/synthesizer/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return


			//Check if we still have the materials.
			if(!cart)
				to_chat(usr, "<span class='notice'>The synthesizer cartridge is nonexistant.</span>")
				return
			if(cart && (!(cart.reagents) || (cart.reagents.total_volume <= 0)))
				to_chat(usr, "<span class='notice'>The synthesizer cartridge is empty.</span>")
				return

			else if(cart && cart.reagents && (cart.reagents.total_volume >= 1))
				//Sanity check.
				if(!making || !src)
					return
				//Create the desired item.
				var/obj/item/weapon/reagent_containers/food/snacks/synthsized_meal/meal = new making.path(src.loc)
				for(var/obj/item/weapon/reagent_containers/food/snacks/F in making.path)

					//Begin mimicking the food
					meal.name = F.name
					meal.desc = F.desc
					meal.icon = F.icon
					meal.icon_state = F.icon_state
					meal.nutriment_desc = list(F?.nutriment_desc + meal.nutriment_desc) //there's always a bland aftertaste, especially if the meal isn't programmed with 'em
					meal.bitesize = F?.bitesize //suffer your aerogel like 1 Nutriment turkey, nerds.
					meal.filling_color = F?.filling_color
					meal.trash = F?.trash	//If this can lead to exploits then we'll remove it, but.

			/*	for(var/obj/item/weapon/holder/micro/M in making.path) //Soylent Agent Green is People!!!!!
					//Begin mimicking the snackrifice
					meal.name = M.name
					meal.icon = getFlatIcon(M,0)
					meal.nutriment_desc = M?.vore_taste	*/

				busy = TRUE
				update_use_power(USE_POWER_ACTIVE)
				update_icon() // light up time
				src.cart.reagents.remove_reagent("synthsoygreen", 5)
				sleep(speed_grade)

				playsound(src, 'DS13/sound/effects/replicator.ogg', 100, 1)
				usr.put_in_any_hand_if_possible(meal)
				return TRUE

	return FALSE


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

/obj/item/weapon/circuitboard/synthesizer
	name = "Food Replicator (Machine Board)"
	build_path = /obj/machinery/synthesizer
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/reagent_containers/synth_disp_cartridge
	name = "Synthisizer cartridge"
	desc = "This goes in a food synthisizer."
	icon = 'icons/obj/machines/synthisizer_vr.dmi'
	icon_state = "bigcart"

	w_class = ITEMSIZE_NORMAL

	volume = 250 //enough for feeding folk, but not so much it won't be needing replacment
	possible_transfer_amounts = null

/obj/item/weapon/reagent_containers/synth_disp_cartridge/small
	name = "Portable Synthisizer Cartridge"
	icon_state = "Scart"
	w_class = ITEMSIZE_NORMAL
	volume = 100

/obj/item/weapon/reagent_containers/synth_disp_cartridge/Initialize()
	. = ..()
	reagents.add_reagent("synthsoygreen", volume)

/obj/item/weapon/reagent_containers/synth_disp_cartridge/proc/percent()		// return % filling for lazy tgui things
	return round((reagents.total_volume / volume) * 100)

/obj/item/weapon/reagent_containers/synth_disp_cartridge/update_icon()
	cut_overlays()
	icon_state = initial(icon_state)
	if(reagents.total_volume)
		var/mutable_appearance/filling_overlay = mutable_appearance(icon, "[icon_state]fill_", layer = src.layer - 0.1) //just under it so the glass effect looks nice
		var/percent = percent()
		switch(percent)
			if(0 to 9)
				filling_overlay.icon_state = "[icon_state]fill_0"
			if(10 to 35)
				filling_overlay.icon_state = "[icon_state]fill_25"
			if(36 to 74)
				filling_overlay.icon_state = "[icon_state]fill_50"
			if(75 to 90)
				filling_overlay.icon_state = "[icon_state]fill_75"
			if(91 to INFINITY)
				filling_overlay.icon_state = "[icon_state]fill_100"
		add_overlay(filling_overlay)
