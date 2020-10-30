#define SOLID 1
#define LIQUID 2
#define GAS 3

#define MAX_PILL_SPRITE 24 //max icon state of the pill sprites
#define MAX_BOTTLE_SPRITE 4 //max icon state of the pill sprites
#define MAX_MULTI_AMOUNT 20 // Max number of pills/patches that can be made at once
#define MAX_UNITS_PER_PILL 60 // Max amount of units in a pill
#define MAX_UNITS_PER_PATCH 60 // Max amount of units in a patch
#define MAX_UNITS_PER_BOTTLE 60 // Max amount of units in a bottle (it's volume)
#define MAX_CUSTOM_NAME_LEN 64 // Max length of a custom pill/condiment/whatever




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "ChemMaster 3000"
	desc = "Used to seperate and package chemicals in to patches, pills, or bottles. Warranty void if used to create Space Drugs."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/weapon/circuitboard/chem_master
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	var/obj/item/weapon/reagent_containers/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 15 // Last used amount
	var/pillamount = 10
	var/list/bottle_styles
	var/bottlesprite = 1
	var/pillsprite = 1
	var/max_pill_count = 20
	var/printing = FALSE
	flags = OPENCONTAINER
	clicksound = "button"

/obj/machinery/chem_master/New()
	..()
	var/datum/reagents/R = new/datum/reagents(900)	//Just a huge random number so the buffer should (probably) never dump your reagents.
	reagents = R	//There should be a nano ui thingy to warn of this.
	R.my_atom = src

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/update_icon()
	icon_state = "mixer[beaker ? "1" : "0"]"

/obj/machinery/chem_master/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/weapon/reagent_containers/glass) || istype(B, /obj/item/weapon/reagent_containers/food))

		if(src.beaker)
			to_chat(user, "\A [beaker] is already loaded into the machine.")
			return
		src.beaker = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add \the [B] to the machine.")
		update_icon()

	else if(istype(B, /obj/item/weapon/storage/pill_bottle))

		if(src.loaded_pill_bottle)
			to_chat(user, "A \the [loaded_pill_bottle] s already loaded into the machine.")
			return

		src.loaded_pill_bottle = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add \the [loaded_pill_bottle] into the dispenser slot.")

	else if(default_unfasten_wrench(user, B, 20))
		return
	if(default_deconstruction_screwdriver(user, B))
		return
	if(default_deconstruction_crowbar(user, B))
		return

	return

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	tgui_interact(user)

/obj/machinery/chem_master/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/chem_master),
	)

/obj/machinery/chem_master/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemMaster", name)
		ui.open()

/**
 *  Display the NanoUI window for the chem master.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/chem_master/tgui_data(mob/user)
	var/list/data = list()

	data["condi"] = condi

	data["loaded_pill_bottle"] = !!loaded_pill_bottle
	if(loaded_pill_bottle)
		data["loaded_pill_bottle_name"] = loaded_pill_bottle.name
		data["loaded_pill_bottle_contents_len"] = loaded_pill_bottle.contents.len
		data["loaded_pill_bottle_storage_slots"] = loaded_pill_bottle.max_storage_space

	data["beaker"] = !!beaker
	if(beaker)
		var/list/beaker_reagents_list = list()
		data["beaker_reagents"] = beaker_reagents_list
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beaker_reagents_list[++beaker_reagents_list.len] = list("name" = R.name, "volume" = R.volume, "description" = R.description, "id" = R.id)

		var/list/buffer_reagents_list = list()
		data["buffer_reagents"] = buffer_reagents_list
		for(var/datum/reagent/R in reagents.reagent_list)
			buffer_reagents_list[++buffer_reagents_list.len] = list("name" = R.name, "volume" = R.volume, "id" = R.id, "description" = R.description)

	data["pillsprite"] = pillsprite
	data["bottlesprite"] = bottlesprite
	data["mode"] = mode
	data["printing"] = printing

	// Transfer modal information if there is one
	data["modal"] = tgui_modal_data(src)

	return data

/**
  * Called in tgui_act() to process modal actions
  *
  * Arguments:
  * * action - The action passed by tgui
  * * params - The params passed by tgui
  */
/obj/machinery/chem_master/proc/tgui_act_modal(action, params, datum/tgui/ui, datum/tgui_state/state)
	. = TRUE
	var/id = params["id"] // The modal's ID
	var/list/arguments = istext(params["arguments"]) ? json_decode(params["arguments"]) : params["arguments"]
	switch(tgui_modal_act(src, action, params))
		if(TGUI_MODAL_OPEN)
			switch(id)
				if("analyze")
					var/idx = text2num(arguments["idx"]) || 0
					var/from_beaker = text2num(arguments["beaker"]) || FALSE
					var/reagent_list = from_beaker ? beaker.reagents.reagent_list : reagents.reagent_list
					if(idx < 1 || idx > length(reagent_list))
						return

					var/datum/reagent/R = reagent_list[idx]
					var/list/result = list("idx" = idx, "name" = R.name, "desc" = R.description)
					if(!condi && istype(R, /datum/reagent/blood))
						var/datum/reagent/blood/B = R
						result["blood_type"] = B.data["blood_type"]
						result["blood_dna"] = B.data["blood_DNA"]

					arguments["analysis"] = result
					tgui_modal_message(src, id, "", null, arguments)
				// if("change_pill_bottle_style")
				// 	if(!loaded_pill_bottle)
				// 		return
				// 	if(!pill_bottle_wrappers)
				// 		pill_bottle_wrappers = list(
				// 			"CLEAR" = "Default",
				// 			COLOR_RED = "Red",
				// 			COLOR_GREEN = "Green",
				// 			COLOR_PALE_BTL_GREEN = "Pale green",
				// 			COLOR_BLUE = "Blue",
				// 			COLOR_CYAN_BLUE = "Light blue",
				// 			COLOR_TEAL = "Teal",
				// 			COLOR_YELLOW = "Yellow",
				// 			COLOR_ORANGE = "Orange",
				// 			COLOR_PINK = "Pink",
				// 			COLOR_MAROON = "Brown"
				// 		)
				// 	var/current = pill_bottle_wrappers[loaded_pill_bottle.wrapper_color] || "Default"
				// 	tgui_modal_choice(src, id, "Please select a pill bottle wrapper:", null, arguments, current, pill_bottle_wrappers)
				if("addcustom")
					if(!beaker || !beaker.reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please enter the amount to transfer to buffer:", null, arguments, useramount)
				if("removecustom")
					if(!reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please enter the amount to transfer to [mode ? "beaker" : "disposal"]:", null, arguments, useramount)
				if("create_condi_pack")
					if(!condi || !reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please name your new condiment pack:", null, arguments, reagents.get_master_reagent_name(), MAX_CUSTOM_NAME_LEN)
				if("create_pill")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_pill = CLAMP(reagents.total_volume / num, 0, MAX_UNITS_PER_PILL)
					var/default_name = "[reagents.get_master_reagent_name()] ([amount_per_pill]u)"
					var/pills_text = num == 1 ? "new pill" : "[num] new pills"
					tgui_modal_input(src, id, "Please name your [pills_text]:", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_pill_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please enter the amount of pills to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, pillamount, 5)
				if("change_pill_style")
					var/list/choices = list()
					for(var/i = 1 to MAX_PILL_SPRITE)
						choices += "pill[i].png"
					tgui_modal_bento(src, id, "Please select the new style for pills:", null, arguments, pillsprite, choices)
				if("create_patch")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_patch = CLAMP(reagents.total_volume / num, 0, MAX_UNITS_PER_PATCH)
					var/default_name = "[reagents.get_master_reagent_name()] ([amount_per_patch]u)"
					var/patches_text = num == 1 ? "new patch" : "[num] new patches"
					tgui_modal_input(src, id, "Please name your [patches_text]:", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_patch_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please enter the amount of patches to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, pillamount, 5)
				if("create_bottle")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_bottle = CLAMP(reagents.total_volume / num, 0, MAX_UNITS_PER_BOTTLE)
					var/default_name = "[reagents.get_master_reagent_name()]"
					var/bottles_text = num == 1 ? "new bottle" : "[num] new bottles"
					tgui_modal_input(src, id, "Please name your [bottles_text] ([amount_per_bottle]u in bottle):", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_bottle_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please enter the amount of bottles to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, pillamount, 5)
				if("change_bottle_style")
					var/list/choices = list()
					for(var/i = 1 to MAX_BOTTLE_SPRITE)
						choices += "bottle-[i].png"
					tgui_modal_bento(src, id, "Please select the new style for bottles:", null, arguments, bottlesprite, choices)
				else
					return FALSE
		if(TGUI_MODAL_ANSWER)
			var/answer = params["answer"]
			switch(id)
				// if("change_pill_bottle_style")
				// 	if(!pill_bottle_wrappers || !loaded_pill_bottle) // wat?
				// 		return
				// 	var/color = "CLEAR"
				// 	for(var/col in pill_bottle_wrappers)
				// 		var/col_name = pill_bottle_wrappers[col]
				// 		if(col_name == answer)
				// 			color = col
				// 			break
				// 	if(length(color) && color != "CLEAR")
				// 		loaded_pill_bottle.wrapper_color = color
				// 		loaded_pill_bottle.apply_wrap()
				// 	else
				// 		loaded_pill_bottle.wrapper_color = null
				// 		loaded_pill_bottle.cut_overlays()
				if("addcustom")
					var/amount = isgoodnumber(text2num(answer))
					if(!amount || !arguments["id"])
						return
					tgui_act("add", list("id" = arguments["id"], "amount" = amount), ui, state)
				if("removecustom")
					var/amount = isgoodnumber(text2num(answer))
					if(!amount || !arguments["id"])
						return
					tgui_act("remove", list("id" = arguments["id"], "amount" = amount), ui, state)
				if("create_condi_pack")
					if(!condi || !reagents.total_volume)
						return
					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/obj/item/weapon/reagent_containers/pill/P = new(loc)
					P.name = "[answer] pack"
					P.desc = "A small condiment pack. The label says it contains [answer]."
					P.icon_state = "bouilloncube"//Reskinned monkey cube
					reagents.trans_to_obj(P, 10)
				if("create_pill")
					if(condi || !reagents.total_volume)
						return
					var/count = CLAMP(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_pill = CLAMP(reagents.total_volume / count, 0, MAX_UNITS_PER_PILL)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these pills!</span>")
							return

						var/obj/item/weapon/reagent_containers/pill/P = new(loc)
						P.name = "[answer] pill"
						P.pixel_x = rand(-7, 7) // Random position
						P.pixel_y = rand(-7, 7)
						P.icon_state = "pill[pillsprite]"
						if(P.icon_state in list("pill1", "pill2", "pill3", "pill4")) // if using greyscale, take colour from reagent
							P.color = reagents.get_color()
						reagents.trans_to_obj(P, amount_per_pill)
						// Load the pills in the bottle if there's one loaded
						if(istype(loaded_pill_bottle) && length(loaded_pill_bottle.contents) < loaded_pill_bottle.max_storage_space)
							P.forceMove(loaded_pill_bottle)
				if("create_pill_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_act("modal_open", list("id" = "create_pill", "arguments" = list("num" = answer)), ui, state)
				if("change_pill_style")
					var/new_style = CLAMP(text2num(answer) || 0, 0, MAX_PILL_SPRITE)
					if(!new_style)
						return
					pillsprite = new_style
				if("create_patch")
					if(condi || !reagents.total_volume)
						return
					var/count = CLAMP(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_patch = CLAMP(reagents.total_volume / count, 0, MAX_UNITS_PER_PATCH)
					// var/is_medical_patch = chemical_safety_check(reagents)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these patches!</span>")
							return

						var/obj/item/weapon/reagent_containers/pill/patch/P = new(loc)
						P.name = "[answer] patch"
						P.pixel_x = rand(-7, 7) // random position
						P.pixel_y = rand(-7, 7)
						reagents.trans_to_obj(P, amount_per_patch)
						// if(is_medical_patch)
							// P.instant_application = TRUE
							// P.icon_state = "bandaid_med"
				if("create_patch_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_act("modal_open", list("id" = "create_patch", "arguments" = list("num" = answer)), ui, state)
				if("create_bottle")
					if(condi || !reagents.total_volume)
						return
					var/count = CLAMP(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_bottle = CLAMP(reagents.total_volume / count, 0, MAX_UNITS_PER_BOTTLE)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these bottles!</span>")
							return
						var/obj/item/weapon/reagent_containers/glass/bottle/P = new(loc)
						P.name = "[answer] bottle"
						P.pixel_x = rand(-7, 7) // random position
						P.pixel_y = rand(-7, 7)
						P.icon_state = "bottle-[bottlesprite]" || "bottle-1"
						reagents.trans_to_obj(P, amount_per_bottle)
						P.update_icon()
				if("create_bottle_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_act("modal_open", list("id" = "create_bottle", "arguments" = list("num" = answer)), ui, state)
				if("change_bottle_style")
					var/new_style = CLAMP(text2num(answer) || 0, 0, MAX_BOTTLE_SPRITE)
					if(!new_style)
						return
					bottlesprite = new_style
				else
					return FALSE
		else
			return FALSE

/obj/machinery/chem_master/tgui_act(action, params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(tgui_act_modal(action, params, ui, state))
		return TRUE

	add_fingerprint(usr)
	usr.set_machine(src)

	. = TRUE
	switch(action)
		if("toggle")
			mode = !mode
		if("ejectp")
			if(loaded_pill_bottle)
				loaded_pill_bottle.forceMove(get_turf(src))
				if(Adjacent(usr) && !issilicon(usr))
					usr.put_in_hands(loaded_pill_bottle)
				loaded_pill_bottle = null
		if("print")
			if(printing || condi)
				return

			var/idx = text2num(params["idx"]) || 0
			var/from_beaker = text2num(params["beaker"]) || FALSE
			var/reagent_list = from_beaker ? beaker.reagents.reagent_list : reagents.reagent_list
			if(idx < 1 || idx > length(reagent_list))
				return

			var/datum/reagent/R = reagent_list[idx]

			printing = TRUE
			visible_message("<span class='notice'>[src] rattles and prints out a sheet of paper.</span>")
			// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)

			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(loc)
			P.info = "<center><b>Chemical Analysis</b></center><br>"
			P.info += "<b>Time of analysis:</b> [worldtime2stationtime(world.time)]<br><br>"
			P.info += "<b>Chemical name:</b> [R.name]<br>"
			if(istype(R, /datum/reagent/blood))
				var/datum/reagent/blood/B = R
				P.info += "<b>Description:</b> N/A<br><b>Blood Type:</b> [B.data["blood_type"]]<br><b>DNA:</b> [B.data["blood_DNA"]]"
			else
				P.info += "<b>Description:</b> [R.description]"
			P.info += "<br><br><b>Notes:</b><br>"
			P.name = "Chemical Analysis - [R.name]"
			spawn(50)
				printing = FALSE
		else
			. = FALSE

	if(. || !beaker)
		return

	. = TRUE
	var/datum/reagents/R = beaker.reagents
	switch(action)
		if("add")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			if(!id || !amount)
				return
			R.trans_id_to(src, id, amount)
		if("remove")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			if(!id || !amount)
				return
			if(mode)
				reagents.trans_id_to(beaker, id, amount)
			else
				reagents.remove_reagent(id, amount)
		if("eject")
			if(!beaker)
				return
			beaker.forceMove(get_turf(src))
			if(Adjacent(usr) && !issilicon(usr))
				usr.put_in_hands(beaker)
			beaker = null
			reagents.clear_reagents()
			update_icon()
		if("create_condi_bottle")
			if(!condi || !reagents.total_volume)
				return
			var/obj/item/weapon/reagent_containers/food/condiment/P = new(loc)
			reagents.trans_to_obj(P, 50)
		else
			return FALSE

/obj/machinery/chem_master/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/chem_master/proc/isgoodnumber(num)
	if(isnum(num))
		if(num > 200)
			num = 200
		else if(num < 0)
			num = 1
		return num
	else
		return FALSE

// /obj/machinery/chem_master/proc/chemical_safety_check(datum/reagents/R)
// 	var/all_safe = TRUE
// 	for(var/datum/reagent/A in R.reagent_list)
// 		if(!GLOB.safe_chem_list.Find(A.id))
// 			all_safe = FALSE
// 	return all_safe

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "All-In-One Grinder"
	desc = "Grinds stuff into itty bitty bits."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	density = 0
	anchored = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	circuit = /obj/item/weapon/circuitboard/grinder
	var/inuse = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/sheet_reagents = list( //have a number of reageents divisible by REAGENTS_PER_SHEET (default 20) unless you like decimals,
		/obj/item/stack/material/iron = list("iron"),
		/obj/item/stack/material/uranium = list("uranium"),
		/obj/item/stack/material/phoron = list("phoron"),
		/obj/item/stack/material/gold = list("gold"),
		/obj/item/stack/material/silver = list("silver"),
		/obj/item/stack/material/platinum = list("platinum"),
		/obj/item/stack/material/mhydrogen = list("hydrogen"),
		/obj/item/stack/material/steel = list("iron", "carbon"),
		/obj/item/stack/material/plasteel = list("iron", "iron", "carbon", "carbon", "platinum"), //8 iron, 8 carbon, 4 platinum,
		/obj/item/stack/material/snow = list("water"),
		/obj/item/stack/material/sandstone = list("silicon", "oxygen"),
		/obj/item/stack/material/glass = list("silicon"),
		/obj/item/stack/material/glass/phoronglass = list("platinum", "silicon", "silicon", "silicon"), //5 platinum, 15 silicon,
		)

	var/static/radial_examine = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine")
	var/static/radial_eject = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject")
	var/static/radial_grind = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_grind")
	// var/static/radial_juice = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_juice")
	// var/static/radial_mix = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_mix")

/obj/machinery/reagentgrinder/Initialize()
	. = ..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	default_apply_parts()

/obj/machinery/reagentgrinder/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += "<span class='warning'>You're too far away to examine [src]'s contents and display!</span>"
		return

	if(inuse)
		. += "<span class='warning'>\The [src] is operating.</span>"
		return

	if(beaker || length(holdingitems))
		. += "<span class='notice'>\The [src] contains:</span>"
		if(beaker)
			. += "<span class='notice'>- \A [beaker].</span>"
		for(var/i in holdingitems)
			var/obj/item/O = i
			. += "<span class='notice'>- \A [O.name].</span>"

	if(!(stat & (NOPOWER|BROKEN)))
		. += "<span class='notice'>The status display reads:</span>\n"
		if(beaker)
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				. += "<span class='notice'>- [R.volume] units of [R.name].</span>"

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(beaker)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return

	//vorestation edit start - for solargrubs
	if (istype(O, /obj/item/device/multitool))
		return ..()
	//vorestation edit end


	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			update_icon()
			src.updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The machine cannot hold anymore items.")
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0

	if(istype(O,/obj/item/weapon/gripper))
		var/obj/item/weapon/gripper/B = O	//B, for Borg.
		if(!B.wrapped)
			to_chat(user, "\The [B] is not holding anything.")
			return 0
		else
			var/B_held = B.wrapped
			to_chat(user, "You use \the [B] to load \the [src] with \the [B_held].")

		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for blending.")
		return 1

	user.remove_from_mob(O)
	O.loc = src
	holdingitems += O
	return 0

/obj/machinery/reagentgrinder/AltClick(mob/user)
	. = ..()
	if(user.incapacitated() || !Adjacent(user))
		return
	replace_beaker(user)

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu //I am reasonably certain that this is not a microwave
	if(inuse || user.incapacitated())
		return

	var/list/options = list()

	if(beaker || length(holdingitems))
		options["eject"] = radial_eject

	if(isAI(user))
		if(stat & NOPOWER)
			return
		options["examine"] = radial_examine

	// if there is no power or it's broken, the procs will fail but the buttons will still show
	if(length(holdingitems))
		options["grind"] = radial_grind

	var/choice
	if(length(options) < 1)
		return
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	// post choice verification
	if(inuse || (isAI(user) && stat & NOPOWER) || user.incapacitated())
		return

	switch(choice)
		if("eject")
			eject(user)
		if("grind")
			grind(user)
		if("examine")
			examine(user)

/obj/machinery/reagentgrinder/proc/eject(mob/user)
	if(user.incapacitated())
		return
	for(var/obj/item/O in holdingitems)
		O.loc = src.loc
		holdingitems -= O
	holdingitems.Cut()
	if(beaker)
		replace_beaker(user)

/obj/machinery/reagentgrinder/proc/grind()

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0

	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/list/sheet_components = sheet_reagents[stack.type]
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					if(islist(sheet_components))
						amount_to_take = (amount_to_take/(sheet_components.len))
						for(var/i in sheet_components)
							beaker.reagents.add_reagent(i, (amount_to_take*REAGENTS_PER_SHEET))
					else
						beaker.reagents.add_reagent(sheet_components, (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to_obj(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

/obj/machinery/reagentgrinder/proc/replace_beaker(mob/living/user, obj/item/weapon/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		if(!user.incapacitated() && Adjacent(user))
			user.put_in_hands(beaker)
		else
			beaker.forceMove(drop_location())
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_icon()
	return TRUE

///////////////
///////////////
// Detects reagents inside most containers, and acts as an infinite identification system for reagent-based unidentified objects.

/obj/machinery/chemical_analyzer
	name = "chem analyzer"
	desc = "Used to precisely scan chemicals and other liquids inside various containers. \
	It may also identify the liquid contents of unknown objects."
	description_info = "This machine will try to tell you what reagents are inside of something capable of holding reagents. \
	It is also used to 'identify' specific reagent-based objects with their properties obscured from inspection by normal means."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "chem_analyzer"
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 20
	clicksound = "button"
	var/analyzing = FALSE

/obj/machinery/chemical_analyzer/update_icon()
	icon_state = "chem_analyzer[analyzing ? "-working":""]"

/obj/machinery/chemical_analyzer/attackby(obj/item/I, mob/living/user)
	if(!istype(I))
		return ..()

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(istype(I,/obj/item/weapon/reagent_containers))
		analyzing = TRUE
		update_icon()
		to_chat(user, span("notice", "Analyzing \the [I], please stand by..."))

		if(!do_after(user, 2 SECONDS, src))
			to_chat(user, span("warning", "Sample moved outside of scan range, please try again and remain still."))
			analyzing = FALSE
			update_icon()
			return

		// First, identify it if it isn't already.
		if(!I.is_identified(IDENTITY_FULL))
			var/datum/identification/ID = I.identity
			if(ID.identification_type == IDENTITY_TYPE_CHEMICAL) // This only solves chemical-based mysteries.
				I.identify(IDENTITY_FULL, user)

		// Now tell us everything that is inside.
		if(I.reagents && I.reagents.reagent_list.len)
			to_chat(user, "<br>") // To add padding between regular chat and the output.
			for(var/datum/reagent/R in I.reagents.reagent_list)
				if(!R.name)
					continue
				to_chat(user, span("notice", "Contains [R.volume]u of <b>[R.name]</b>.<br>[R.description]<br>"))

		// Last, unseal it if it's an autoinjector.
		if(istype(I,/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector) && !(I.flags & OPENCONTAINER))
			I.flags |= OPENCONTAINER
			to_chat(user, span("notice", "Sample container unsealed.<br>"))

		to_chat(user, span("notice", "Scanning of \the [I] complete."))
		analyzing = FALSE
		update_icon()
		return

#undef MAX_PILL_SPRITE
#undef MAX_BOTTLE_SPRITE
#undef MAX_MULTI_AMOUNT
#undef MAX_UNITS_PER_PILL
#undef MAX_UNITS_PER_PATCH
#undef MAX_UNITS_PER_BOTTLE
#undef MAX_CUSTOM_NAME_LEN
