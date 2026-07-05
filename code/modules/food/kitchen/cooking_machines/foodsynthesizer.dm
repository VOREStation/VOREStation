//Poojy's miracle 'I don't want generic pizza' / there's noone working kitchen machine
//Yes it's a generic food 3d printer. ~
// in here because makes sense, if really it's just a refillable autolathe of food

//#define VOICE_ORDER(A, O, T) list(activator = A, order = O, temp = T)
// "Computer, Steak, Hot."

#define SYNTH_FOOD_COST 5

/obj/machinery/synthesizer
	name = "Food Synthesizer"
	desc = "Sabresnacks brand device able to produce an incredible array of conventional foods. Although only the most ascetic of users claim it produces truly good tasting products."
	icon = 'icons/obj/machines/foodsynthesizer.dmi'
	icon_state = "synthesizer"
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
	var/usage_amt = SYNTH_FOOD_COST

	light_system = STATIC_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE

	var/menu_grade //how tasty is it?
	var/speed_grade //how fast can it be?
	var/filtertext

	circuit = /obj/item/circuitboard/synthesizer

	//loaded cartridge
	var/obj/item/reagent_containers/synthdispcart/cart
	var/cart_type = ITEMSIZE_LARGE

	//all of our food
	var/static/datum/category_collection/synthesizer/synthesizer_recipes
	var/static/list/menucatagory_list
	var/active_menu = "appasnacc"
	var/activefood
	var/food_mimic_storage

	//Voice activation stuff
	var/activator = "computer"
	var/list/voicephrase

	//crew printing required stuff.
	var/tgui_icons
	var/icon/crewpicture
	var/activecrew
	var/refresh_delay = 10 SECONDS
	var/db_key
	var/datum/transcore_db/our_db


/obj/machinery/synthesizer/Initialize()
	. = ..()
	if(!synthesizer_recipes)
		synthesizer_recipes = new()
	our_db = SStranscore.db_by_key(db_key)
	cart = new /obj/item/reagent_containers/synthdispcart(src)
	wires = new(src)
	default_apply_parts()
	RefreshParts()
	update_icon()

	if(!pixel_x && !pixel_y)
		offset_synth()

/obj/machinery/synthesizer/mini
	name = "Mini Food Synthesizer"
	icon_state = "portsynth"
	cart_type = ITEMSIZE_NORMAL
	circuit = /obj/item/circuitboard/synthesizer/mini

/obj/machinery/synthesizer/mini/Initialize()
	. = ..()
	cart = new /obj/item/reagent_containers/synthdispcart/small(src)

/obj/machinery/synthesizer/Destroy()
	qdel(wires)
	wires = null

	for(var/obj/item/reagent_containers/synthdispcart/C in cart)
		C.loc = get_turf(src.loc)
		C = null
	clearTguiIcons()
	return ..()

/obj/machinery/synthesizer/examine(mob/user)
	. = ..()
	if(panel_open)
		. += "A cartridge is [cart ? "installed" : "missing"]."
	if(cart && (!(stat & (NOPOWER|BROKEN))))
		var/obj/item/reagent_containers/synthdispcart/C = cart
		if(istype(C) && C.reagents && C.reagents.total_volume)
			var/percent = round((C.reagents.total_volume / C.volume) * 100)
			. += "The installed cartridge has [percent]% remaining."

	return

//offsets to make the machine squish to a wall. They're all south facing so it looks weird but every other direction is AWFUL
/obj/machinery/synthesizer/proc/offset_synth()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -24 : 24)
	pixel_y = (dir & 3) ? (dir == 1 ? -22 : 30) : 0


// TGUI
// Crew Cookie backend stuff... I can't even fuckin' believe this is Janicart stuff
/obj/machinery/synthesizer/proc/setTguiIcon(var/mob/living/L)
	if(!isliving(L))
		return
	if(ishuman(L)) //Utilize the body records for humans to avoid metagaming problems
		var/mob/living/carbon/human/H = L
		var/datum/transcore_db/db = SStranscore.db_by_key(db_key)
		if(db)
			var/datum/transhuman/body_record/BR = our_db.body_scans[H.mind.name] //Access the Crew's stored cookieicon.
			crewpicture = BR.cookieicon
			tgui_icons = "'data:image/png;base64,[icon2base64(crewpicture)]'"

	else //Simple animals, Silicons, etc don't have records, so we'll just grab their current state.
		var/icon/F = getFlatIcon(L, defdir = SOUTH, no_anim = TRUE)
		crewpicture = F
		tgui_icons = "'data:image/png;base64,[icon2base64(F)]'"
	SStgui.update_uis(src)

/obj/machinery/synthesizer/proc/clearTguiIcons()
	tgui_icons = null
	crewpicture = null
	SStgui.update_uis(src)

// And literally this is all that's needed for conventional meals. lmao.
/obj/machinery/synthesizer/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/synthesizer),
	)

/obj/machinery/synthesizer/tgui_interact(mob/user, datum/tgui/ui)
	if(stat & (BROKEN|NOPOWER))
		return

	if(shocked)
		shock(user, 100)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FoodSynthesizer")
		ui.open()

/obj/machinery/synthesizer/tgui_status(mob/user)
	if(disabled)
		return STATUS_CLOSE
	return ..()

/obj/machinery/synthesizer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["busy"] = busy
	data["isThereCart"] = cart ? TRUE : FALSE
	data["active_menu"] = active_menu
	data["activefood"] = activefood
	data["activecrew"] = activecrew
	data["crewicon"] = tgui_icons
	//We probably want to dynamically check if there's a canister every time too.
	var/cartfilling[0]
	if(cart && cart.reagents && cart.reagents.reagent_list.len)
		for(var/datum/reagent/R in cart.reagents.reagent_list)
			cartfilling.Add(list(list(
				"volume" = R.volume
				)))
	data["cartfilling"] = cartfilling
	//Especially since we need to maintain a 'fill level'
	if(cart)
		var/percent = round((cart.reagents.total_volume / cart.reagents.maximum_volume) * 100)
		data["cartFillStatus"] = cart ? percent : null
	return data

/obj/machinery/synthesizer/tgui_static_data(mob/user)
	var/list/data = ..()
	var/list/menucatagories = list()
	var/list/recipes = list()
	for(var/datum/category_group/synthesizer/menulist in synthesizer_recipes.categories)
		menucatagories.Add(list(list(
			"name"		= menulist.name,
			"id"		= menulist.id,
			"sortorder"	= menulist.sortorder,
			"ref"		= "\ref[menulist]"
			)))
		for(var/datum/category_item/synthesizer/food in menulist.items)
			recipes.Add(list(list(
				"catagory" 		= menulist.id,
				"name" 			= food.name,
				"id"			= food.id,
				"desc" 			= food.desc,
				"voice_order"	= food.voice_order,
				"voice_temp"	= food.voice_temp,
				"hidden"		= food.hidden,
				"ref"			= "\ref[food]"
				)))

	data["menucatagories"] = menucatagories
	data["recipes"] = recipes

	var/list/crew_cookies = list()
	for(var/client/C in GLOB.clients)
		// Allow opt-out. For extra protection we'll refrain from including logged out folks.
		if(C?.mob?.mind && !C?.prefs?.synth_cookie)
			continue

		var/name = null
		var/species = null

		if(iscarbon(C.mob))
			var/mob/living/carbon/human/H = C.mob
			var/datum/transcore_db/db = SStranscore.db_by_key(db_key)
			if(db)
				var/datum/transhuman/body_record/BR = our_db.body_scans[H.mind.name]
				if(!BR) //extra check to make sure people have a body record, and no-one will immediately on start.
					continue
				if(BR && !BR.cookieunlock) //check if the person permits cookie printing in their Body record file too
					continue

			name = H.real_name
			species = "[H.custom_species ? H.custom_species : H.species.name]"

		if(issilicon(C.mob))
			if(isAI(C.mob))
				var/mob/living/silicon/ai/A = C.mob
				name = A.name
				species = "Artificial Intelligence"

			if(isrobot(C.mob))
				var/mob/living/silicon/robot/R = C.mob
				if(R.scrambledcodes || (R.module && R.module.hide_on_manifest)) //Not sure if admeme events want valid cookie print outs
					continue
				name = R.name
				species = "[R.modtype] [R.braintype]"

		if(isanimal(C.mob))
			var/mob/living/simple_mob/SM = C.mob
			name = SM.name
			species = initial(SM.name) //most mobs are simply named the species they are, so this ought to be useful for named critters.

		if(!name)
			continue

		// our crew cookies are only applicable on the crew menu, and we're reusing our catagory sorting as much as possible!
		crew_cookies.Add(list(list(
				"catagory" = "crew",
				"name" = name,
				"species" = species
		)))

	data["crew_cookies"] = crew_cookies
	return data

/obj/machinery/synthesizer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return
	if(..())
		return TRUE

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='notice'>The synthesizer is busy. Please wait for completion of previous operation.</span>")
		return

	switch(action)
		if("setactive_menu")
			active_menu = params["setactive_menu"]
			activecrew = null
			activefood = null
			if(tgui_icons)
				clearTguiIcons()
			return TRUE

		if("setactive_food")
			activefood = params["setactive_food"]
			return TRUE

		if("setactive_crew")
			activecrew = params["setactive_crew"]
			if(tgui_icons)
				clearTguiIcons()

			var/mob/found
			for(var/mob/living/L in GLOB.player_list)
				if(L.real_name == activecrew)
					found = L
					break

			if(found)
				if(!get_mob_for_picture(found))
					return FALSE
				setTguiIcon(found)
				return TRUE
			else
				return FALSE

		if("make")
			var/datum/category_item/synthesizer/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			//Check if we still have the materials.
			var/obj/item/reagent_containers/synthdispcart/C = cart
			if(src.check_cart(C, usr))
				//Sanity check.
				if(!making || !src)
					return
				busy = TRUE
				update_use_power(USE_POWER_ACTIVE)
				update_icon() // light up time
				C.reagents.remove_reagent(REAGENT_ID_NUTRIPASTE_SOYLENT, SYNTH_FOOD_COST) //Drain our fuel
				var/obj/item/reagent_containers/food/snacks/food_mimic = new making.build_path(src) //Let's get this on a tray
				food_mimic_storage = food_mimic //nice.
				sleep(speed_grade) //machine go brrr

				//Create the desired item.
				var/obj/item/reagent_containers/food/snacks/synthsized_meal/meal = new /obj/item/reagent_containers/food/snacks/synthsized_meal(src.loc)

				//Begin mimicking the food
				meal.name = food_mimic.name
				meal.desc = food_mimic.desc
				meal.icon = food_mimic.icon
				meal.icon_state = food_mimic.icon_state
				meal.center_of_mass_x = food_mimic.center_of_mass_x
				meal.center_of_mass_y = food_mimic.center_of_mass_y

				//flavor mixing
				var/taste_output = food_mimic.reagents.generate_taste_message()
				for(var/datum/reagent/F in meal.reagents.reagent_list)
					if(F.id == REAGENT_ID_NUTRIPASTE) //This should be the only reagent, actually.
						F.taste_description += " as well as [taste_output]"
						F.data = list(F.taste_description = 1)
						meal.nutriment_desc = list(F.taste_description = 1)

				if(src.menu_grade >= 2) //Is the machine upgraded?
					meal.reagents.add_reagent(REAGENT_ID_NUTRIPASTE, ((1 + src.menu_grade) - 1)) //add the missing Nutriment bonus, subtracting the one we've already added in.

				meal.bitesize = food_mimic?.bitesize //suffer your aerogel like 1 Nutriment turkey, nerds.
				meal.filling_color = food_mimic?.filling_color
				meal.trash = food_mimic?.trash	//If this can lead to exploits then we'll remove it, but I like the idea.
				qdel(food_mimic)
				src.food_mimic_storage = null
				src.audible_message("<span class='notice'>Please take your [meal.name].</span>", runemessage = "[meal.name] is complete!")
				if(Adjacent(usr))
					usr.put_in_any_hand_if_possible(meal) //Autoplace in hands to save a click
				else
					meal.loc = src.loc //otherwise we anti-clump layer onto the floor
					meal.randpixel_xy()
				busy = FALSE
				update_icon() //turn off lights, please.
			else
				src.audible_message("<span class='notice'>Error: Insufficent Materials. SabreSnacks recommends you have a genuine replacement cartridge available to install.</span>", runemessage = "Error: Insufficent Materials!")

			return TRUE

		if("refresh")
			update_tgui_static_data(usr, ui)
			return TRUE

		if("crewprint")
			var/active_crew = params["crewprint"]
			var/mob/found
			for(var/mob/living/L in GLOB.player_list)
				if(L.real_name == active_crew)
					found = L
					break

			if(found && !get_mob_for_picture(found)) //verify that we can still print this person
				to_chat(usr, "Warning: Invalid selection.")
				return FALSE

			//Check if we still have the materials.
			var/obj/item/reagent_containers/synthdispcart/C = cart
			if(src.check_cart(C, usr))
				//Sanity check.
				busy = TRUE
				update_use_power(USE_POWER_ACTIVE)
				update_icon() // light up time
				C.reagents.remove_reagent(REAGENT_ID_NUTRIPASTE_SOYLENT, SYNTH_FOOD_COST) //Drain our fuel
				sleep(speed_grade) //machine go brrr

				//Create the cookie base.
				var/obj/item/reagent_containers/food/snacks/synthsized_meal/crewblock/meal = new /obj/item/reagent_containers/food/snacks/synthsized_meal/crewblock(src.loc)

				//Begin mimicking the micro
				var/vore_flavor
				if(found?.vore_taste)
					vore_flavor = found.vore_taste
				else
					vore_flavor = "Something impalpable"

				meal.name = found.real_name
				meal.desc = "A tiny replica of a crewmate!"
				var/icon/F = crewpicture
				F.Scale(16, 16) //Half size
				meal.icon = F
				meal.icon_state = null

				//flavor mixing, make the cookie taste somewhat like the real thing!
				for(var/datum/reagent/foodpaste in meal.reagents.reagent_list)
					if(foodpaste.id == REAGENT_ID_NUTRIPASTE) //This should be the only reagent, actually.
						foodpaste.taste_description += " as well as [vore_flavor]"
						foodpaste.data = list(foodpaste.taste_description = 1)
						meal.nutriment_desc = list(foodpaste.taste_description = 1)

				if(src.menu_grade >= 2) //Is the machine upgraded?
					meal.reagents.add_reagent(REAGENT_ID_NUTRIPASTE, ((1 + src.menu_grade) - 1)) //add the missing Nutriment bonus, subtracting the one we've already added in.

				src.audible_message("<span class='notice'>Please take your miniature [meal.name].</span>", runemessage = "Minature [meal.name] is complete!")
				if(Adjacent(usr))
					usr.put_in_any_hand_if_possible(meal) //Autoplace in hands to save a click
				else
					meal.loc = src.loc //otherwise we anti-clump layer onto the floor
					meal.randpixel_xy()
				busy = FALSE
				update_icon() //turn off lights, please.
			else
				src.audible_message("<span class='notice'>Error: Insufficent Materials. SabreSnacks recommends you have a genuine replacement cartridge available to install.</span>", runemessage = "Error: Insufficent Materials!")
				return FALSE
			return TRUE

/obj/machinery/synthesizer/update_icon()
	cut_overlays()
	set_light_on(FALSE)
	icon_state = initial(icon_state) //we use this to reduce code bloat. It's nice.
	if(panel_open)
		 //add service panels just above our machine
		if(!(stat & (NOPOWER|BROKEN)))
			add_overlay("[initial(icon_state)]_ppanel")
		else
			add_overlay("[initial(icon_state)]_panel")
		if(cart)
			var/obj/item/reagent_containers/synthdispcart/C = cart
			if(C.reagents && C.reagents.total_volume)
				var/image/filling_overlay = image("[icon]", src, "[initial(icon_state)]fill_0")	//Modular filling
				var/percent = round((C.reagents.total_volume / C.volume) * 100)
				switch(percent)
					if(0 to 9)			filling_overlay.icon_state = "[initial(icon_state)]fill_0"
					if(10 to 35)		filling_overlay.icon_state = "[initial(icon_state)]fill_25"
					if(36 to 74)		filling_overlay.icon_state = "[initial(icon_state)]fill_50"
					if(75 to 90)		filling_overlay.icon_state = "[initial(icon_state)]fill_75"
					if(91 to INFINITY)	filling_overlay.icon_state = "[initial(icon_state)]fill_100"
				filling_overlay.color = C.reagents.get_color()
				//Add our filling, if any.
				add_overlay(filling_overlay)
			//Then add our cart so the filling is inside of the canister.
			add_overlay("[initial(icon_state)]_cart")
		return //don't stack additional panel screen states, please.

	if((stat && BROKEN))
		icon_state = "[initial(icon_state)]x"
		return

	if(stat & NOPOWER)
		return

	if(!cart)
		add_overlay("[initial(icon_state)]_error")
		return

	if(cart && !busy)
		var/obj/item/reagent_containers/synthdispcart/C = cart
		if(C.reagents && C.reagents.total_volume)
			add_overlay("[initial(icon_state)]_on")
		else
			add_overlay("[initial(icon_state)]_error")
		return

	if(busy)
		add_overlay("[initial(icon_state)]_busy")
		set_light_color("#faebd7") // "antique white"
		set_light_on(TRUE)

//Cartridge Interactions in Machine
/obj/machinery/synthesizer/proc/add_cart(obj/item/C, mob/user)
	if(!Adjacent(user))
		return //How did you even try?
	if(!panel_open) //just in case
		to_chat(user, "The hatch must be open to insert a [C].")
		return
	if(cart) // let's hot swap that bad boy.
		remove_cart(user)
		return
	else
		user.drop_from_inventory(C)
		cart = C
		C.loc = src
		C.add_fingerprint(user)
		to_chat(user, "<span class='notice'>You add [C] to \the [src].</span>")
	update_icon()
	SStgui.update_uis(src)
	return

/obj/machinery/synthesizer/proc/remove_cart(mob/user)
	var/obj/item/reagent_containers/synthdispcart/C = cart
	if(!C)
		to_chat(user, "<span class='notice'>There's no cartridge here...</span>") //Sanity checks aren't ever a bad thing
		return
	if(!Adjacent(user)) //gotta, y'know, be in touch range to pull a physical canister out
		return
	C.loc = get_turf(loc)
	C.update_icon()
	cart = null
	to_chat(user, "<span class='notice'>You remove [C] from  \the [src].</span>")

	if(Adjacent(user))
		user.put_in_hands(C) //pick up your trash, nerd. and don't hand it to the AI. They will be upset.
	update_icon()
	SStgui.update_uis(src)

/obj/machinery/synthesizer/proc/check_cart(obj/item/reagent_containers/synthdispcart/C, mob/user)
	if(!istype(C))
		to_chat(user, "<span class='notice'>The synthesizer cartridge is nonexistant.</span>")
		return FALSE
	if((!(C.reagents)) || (C.reagents.total_volume <= 0) || (!C.reagents.has_reagent(REAGENT_ID_NUTRIPASTE_SOYLENT)))
		to_chat(user, "<span class='notice'>The synthesizer cartridge depleted, replace with a genuine Sabresnack Co cartridge.</span>")
		return FALSE
	if((C.reagents) && (C.reagents.total_volume <= 0) && (!C.reagents.has_reagent(REAGENT_ID_NUTRIPASTE_SOYLENT)))
		to_chat(user, "<span class='notice'>Used or Counterfeit synthesizer cartridge detected.</span>")
		return FALSE
	else if(C.reagents && C.reagents.has_reagent(REAGENT_ID_NUTRIPASTE_SOYLENT) && (C.reagents.total_volume >= SYNTH_FOOD_COST))
		SStgui.update_uis(src)
		return TRUE

/obj/machinery/synthesizer/proc/get_mob_for_picture(var/mob/living/LM)
	if(!istype(LM))
		to_chat(usr, "Warning: Invalid selection. Please refresh the database.")
		return FALSE

	if(LM.client?.prefs?.synth_cookie)
		return TRUE

	to_chat(usr, "Warning: Invalid selection. Please refresh the database.")
	return FALSE

/obj/machinery/synthesizer/attackby(obj/item/W, mob/user)
	if(busy)
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
		if(istype(W, /obj/item/reagent_containers/synthdispcart))
			if(!anchored)
				to_chat(user, "<span class='warning'>Anchor its bolts first.</span>")
				return
			if(W.w_class > cart_type) //since we confirmed it's a Cart, make sure it fits!
				to_chat(user, "<span class='warning'>\The [src] only accepts smaller synthiziser cartridges.</span>")
				return
			if(cart)
				var/choice = alert(user, "Replace the loaded cartridge?", "", "Yes", "Cancel")
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
			update_icon()
		else
			to_chat(user, "<span class='notice'>You decide not to [anchored ? "un" : ""]fasten \the [src].</span>")

	if(default_deconstruction_crowbar(user, W))
		return

	else
		return ..()

/obj/machinery/synthesizer/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
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

	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		speed_grade = (10 SECONDS) / M.rating //let's try to make it worthwhile to upgrade 'em 10s, 5s, 3.3s, 2.5s
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		menu_grade = S.rating //how much bonus Nutriment is added to the printed food. the regular wafer is only 5.
		// Science parts will be of help if they bother.

#undef SYNTH_FOOD_COST
//Cartridge Item handling
/obj/item/reagent_containers/synthdispcart
	name = "Synthesizer cartridge"
	desc = "Genuine replacement cartridge for SabreSnacks brand Food Synthesizers. It's too large for the Portable models."
	icon = 'icons/obj/machines/foodsynthesizer.dmi'
	icon_state = "bigcart"

	w_class = ITEMSIZE_LARGE

	volume = 250 //enough for feeding folk, but not so much it won't be needing replacment
	//No way to refill or drain them. Like printer ink, it's only good in the machine!
	amount_per_transfer_from_this = 0
	max_transfer_amount = 0
	min_transfer_amount = 0
	flags = NONE

/obj/item/reagent_containers/synthdispcart/small
	name = "Portable Synthesizer Cartridge"
	desc = "Genuine replacement cartrifge SabreSnacks brand Portable Food Synthesizers. It can also fit within standard sized models."
	icon_state = "Scart"
	w_class = ITEMSIZE_NORMAL
	volume = 100

/obj/item/reagent_containers/synthdispcart/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIPASTE_SOYLENT, volume)
	update_icon()

/obj/item/reagent_containers/synthdispcart/update_icon()
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

/obj/item/reagent_containers/synthdispcart/examine(mob/user)
	. = ..()
	if(reagents && reagents.total_volume)
		var/percent = round((reagents.total_volume / volume) * 100)
		. += "The cartridge has [percent]% remaining."

	return

/obj/item/reagent_containers/synthdispcart/is_open_container()
	return FALSE //sealed, proprietary container. aka preventing alternative beaker memes.

//Circuits for contruction

/datum/design_techweb/board/synthesizer
	SET_CIRCUIT_DESIGN_NAMEDESC("food synthesizer")
	id = "food_synthesizer"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/synthesizer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/synthesizer/mini
	SET_CIRCUIT_DESIGN_NAMEDESC("compact food synthesizer")
	id = "compactfood_synthesizer"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/synthesizer/mini
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

// Physical Boards for Food Synthesizer Construction
/obj/item/circuitboard/synthesizer
	name = T_BOARD("Food Synthesizer")
	desc = "The circuitboard for a Food Synthesizer."
	build_path = /obj/machinery/synthesizer
	board_type = new /datum/frame/frame_types/foodsynthesizer
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/synthesizer/mini
	name = T_BOARD("Compact Food Synthesizer")
	desc = "The circuitboard for a compact food synthesizer."
	build_path = /obj/machinery/synthesizer/mini
	board_type = new /datum/frame/frame_types/foodsynthesizer/mini
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/scanning_module = 1)
