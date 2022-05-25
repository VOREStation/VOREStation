//Poojy's miracle 'I don't want generic pizza' / there's noone working kitchen machine
//Yes it's a generic food 3d printer. ~
// in here because makes sense, if really it's just a refillable autolathe of food

/obj/machinery/synthesizer
	name = "food synthesizer"
	desc = "a device able to produce an incredible array of conventional foods. Although only the most ascetic of users claim it produces good tasting products."
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

	var/mat_efficiency = 1
	var/build_time = 50

	circuit = /obj/item/weapon/circuitboard/synthesizer
	var/obj/item/weapon/reagent_containers/synth_disp_cartridge/cart
	var/cart_type = /obj/item/weapon/reagent_containers/synth_disp_cartridge
	var/datum/wires/synthesizer/wires

	//Voice activation stuff
	var/activator = "computer"


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
			var/percent = round((cart.reagents.total_volume / cart.volume) * 100)
				switch(percent)
					if(0 to 9)
						filling_overlay.icon_state = "cartfill_0"
					if(10 to 24)
						filling_overlay.icon_state = "cartfill_10"
					if(25 to 49)
						filling_overlay.icon_state = "cartfill_25"
					if(50 to 74)
						filling_overlay.icon_state = "cartfill_50"
					if(75 to 79)
						filling_overlay.icon_state = "cartfill_75"
					if(80 to 90)
						filling_overlay.icon_state = "cartfill_80"
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

	switch(state)
		if(busy)
			set_light_color("#faebd7") // "antique white"
			set_light_on(TRUE)
		else if(!busy)
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
	SStgui.update_uis(src)

/obj/machinery/synthesizer/attackby(obj/item/W, mob/user)
	if(busy)
		audible_message("<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>", runemessage = "BUZZ")
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(stat)
		return
	if(panel_open)
		if(O.is_multitool() || O.is_wirecutter())
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

	if(is_robot_module(O))
		return FALSE

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
		playsound(src, I.usesound, 50, 1)
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon()

	else
		return ..()

/obj/machinery/synthesizer/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

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
	for(var/datum/category_group/synthesizer/A in synthesizer_recipes.categories)
		categories += A.name
		for(var/datum/category_item/synthesizer/F in A.items)
			if(F.hidden && !hacked)
				continue
			if(F.man_rating > man_rating)
				continue
			recipes.Add(list(list(
				"category" = A.name,
				"name" = F.name,
				"ref" = REF(F),
				"requirements" = F.resources,
				"hidden" = F.hidden,
				"coeff_applies" = !F.no_scale,
			)))
	data["recipes"] = recipes
	data["categories"] = categories

	return data

/obj/machinery/synthesizer/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/sheetmaterials)
	)

/obj/machinery/synthesizer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["busy"] = busy
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	data["materials"] = materials.tgui_data()
	data["mat_efficiency"] = mat_efficiency
	return data

/obj/machinery/synthesizer/interact(mob/user)
	if(panel_open)
		return wires.Interact(user)

	if(disabled)
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)

	tgui_interact(user)

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

			var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

			var/list/materials_used = list()

			var/multiplier = (params["multiplier"] || 1)

			if(making.is_stack)
				var/max_sheets
				for(var/material in making.resources)
					var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient
					var/sheets = round(materials.get_material_amount(material) / round(making.resources[material] * coeff))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(materials.get_material_amount(material)) && materials.get_material_amount(material) < round(making.resources[material] * coeff))
						max_sheets = 0
				//Build list of multipliers for sheets.
				multiplier = input(usr, "How many do you want to print? (0-[max_sheets])") as num|null
				if(!multiplier || multiplier <= 0 || multiplier > max_sheets || tgui_status(usr, state) != STATUS_INTERACTIVE)
					return FALSE

			//Check if we still have the materials.
			var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient

			for(var/datum/material/used_material as anything in making.resources)
				var/amount_needed = making.resources[used_material] * coeff * multiplier
				materials_used[used_material] = amount_needed

			if(LAZYLEN(materials_used))
				if(!materials.has_materials(materials_used))
					return

				materials.use_materials(materials_used)

			busy = making.name
			update_use_power(USE_POWER_ACTIVE)

			update_icon() // So lid closes

			sleep(build_time)

			busy = 0
			update_use_power(USE_POWER_IDLE)
			update_icon() // So lid opens

			//Sanity check.
			if(!making || !src)
				return

			//Create the desired item.
			var/obj/item/I = new making.path(src.loc)

			if(LAZYLEN(I.matter))	// Sadly we must obey the laws of equivalent exchange.
				I.matter.Cut()
			else
				I.matter = list()

			for(var/material in making.resources)	// Handle the datum's autoscaling for waste, so we're properly wasting material, but not so much if we have efficiency.
				I.matter[material] = round(making.resources[material] / (making.no_scale ? 1 : 1.25)) * (making.no_scale ? 1 : mat_efficiency)

			flick("[initial(icon_state)]_finish", src)
			if(multiplier > 1)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					S.set_amount(multiplier)
				else
					for(multiplier; multiplier > 1; --multiplier) // Create multiple items if it's not a stack.
						I = new making.path(src.loc)
						// We've already deducted the cost of multiple items. Process the matter the same.
						if(LAZYLEN(I.matter))
							I.matter.Cut()

						else
							I.matter = list()

						for(var/material in making.resources)
							I.matter[material] = round(making.resources[material] / (making.no_scale ? 1 : 1.25)) * (making.no_scale ? 1 : mat_efficiency)
			return TRUE
	return FALSE

//Updates overall lathe storage size.
/obj/machinery/synthesizer/RefreshParts()
	..()
	mb_rating = 0
	man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		speed_grade = M.rating
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		menu_grade = S.rating


	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.max_amount = mb_rating * 75000

	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.6. Maximum rating of parts is 5
	update_tgui_static_data(usr)

/obj/machinery/synthesizer/examine(mob/user)
	. = ..()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Storing up to <b>[materials.max_amount]</b> material units.<br>Material consumption at <b>[mat_efficiency*100]%</b>.</span>"

/obj/machinery/synthesizer/proc/synthesize(var/what, var/temp, var/mob/living/user)
	var/atom/food

/obj/item/weapon/circuitboard/synthesizer
	name = "Food Replicator (Machine Board)"
	build_path = /obj/machinery/synthesizer
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/weapon/reagent_containers/synth_disp_cartridge
	name = "Synthisizer cartridge"
	desc = "This goes in a food synthisizer."
	icon = 'icons/obj/machines/synthisizer_vr.dmi'
	icon_state = "synth_cartridge"

	w_class = ITEMSIZE_NORMAL

	volume = CARTRIDGE_VOLUME_MEDIUM //enough for feeding folk, but not so much it won't be needing replacment
	prefill = list("synthsoygreen" = CARTRIDGE_VOLUME_MEDIUM) //preloaded offstation
	possible_transfer_amounts = null

/obj/item/weapon/reagent_containers/synth_disp_cartridge/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/mutable_appearance/filling_overlay = mutable_appearance(icon, "bigcartfill_", layer = src.layer - 0.1) //just under it so the glass effect looks nice
		var/percent = round((cart.reagents.total_volume / cart.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling_overlay.icon_state = "bigcartfill_0"
				if(10 to 35)
					filling_overlay.icon_state = "bigcartfill_25"
				if(36 to 74)
					filling_overlay.icon_state = "bigcartfill_50"
				if(75 to 90)
					filling_overlay.icon_state = "bigcartfill_75"
				if(91 to INFINITY)
					filling_overlay.icon_state = "bigcartfill_100"
			add_overlay(filling_overlay)

/datum/reagent/nutriment/synthsyolent
	name = "Soylent Agent Green"
	id = "synthsoygreen"
	description = "An thick, horridly rubbery fluid that somehow can be synthisized into 'edible' meals."
	taste_description = "unrefined cloying oil"
	taste_mult = 1.3
	nutriment_factor = 1
	reagent_state = LIQUID
	color = "#faebd7"

