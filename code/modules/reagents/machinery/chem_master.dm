/obj/machinery/chem_master
	name = "ChemMaster 3000"
	desc = "Used to separate and package chemicals in to patches, pills, or bottles. Warranty void if used to create Space Drugs."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/circuitboard/chem_master
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	var/obj/item/reagent_containers/beaker = null
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
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

/obj/machinery/chem_master/Initialize(mapload)
	. = ..()
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

/obj/machinery/chem_master/attackby(var/obj/item/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/reagent_containers/glass) || istype(B, /obj/item/reagent_containers/food))

		if(src.beaker)
			to_chat(user, "\A [beaker] is already loaded into the machine.")
			return
		src.beaker = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add \the [B] to the machine.")
		update_icon()

	else if(istype(B, /obj/item/storage/pill_bottle))

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
		get_asset_datum(/datum/asset/spritesheet/chem_master),
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
						choices += "chem_master32x32 pill[i]"
					tgui_modal_bento_spritesheet(src, id, "Please select the new style for pills:", null, arguments, pillsprite, choices)
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
				if("create_bottle", "create_bottle_two")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					if(id == "create_bottle_two")
						num = 2
					arguments["num"] = num
					var/amount_per_bottle = CLAMP(reagents.total_volume / num, 0, MAX_UNITS_PER_BOTTLE)
					var/default_name = "[reagents.get_master_reagent_name()]"
					var/bottles_text = num == 1 ? "new bottle" : "[num] new bottles"
					tgui_modal_input(src, id, "Please name your [bottles_text] ([amount_per_bottle]u in bottle):", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_bottle_multiple")
					if(condi || !reagents.total_volume)
						return
					tgui_modal_input(src, id, "Please enter the amount of bottles to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, pillamount / 5, 5)
				if("change_bottle_style")
					var/list/choices = list()
					for(var/i = 1 to MAX_BOTTLE_SPRITE)
						choices += "chem_master32x32 bottle-[i]"
					tgui_modal_bento_spritesheet(src, id, "Please select the new style for bottles:", null, arguments, bottlesprite, choices)
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
					var/obj/item/reagent_containers/pill/P = new(loc)
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
							to_chat(ui.user, span_notice("Not enough reagents to create these pills!"))
							return

						var/obj/item/reagent_containers/pill/P = new(loc)
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
							to_chat(ui.user, span_notice("Not enough reagents to create these patches!"))
							return

						var/obj/item/reagent_containers/pill/patch/P = new(loc)
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
				if("create_bottle", "create_bottle_two")
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
							to_chat(ui.user, span_notice("Not enough reagents to create these bottles!"))
							return
						var/obj/item/reagent_containers/glass/bottle/P = new(loc)
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

	add_fingerprint(ui.user)
	ui.user.set_machine(src)

	. = TRUE
	switch(action)
		if("toggle")
			mode = !mode
		if("ejectp")
			if(loaded_pill_bottle)
				loaded_pill_bottle.forceMove(get_turf(src))
				if(Adjacent(ui.user) && !issilicon(ui.user))
					ui.user.put_in_hands(loaded_pill_bottle)
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
			visible_message(span_notice("[src] rattles and prints out a sheet of paper."))
			// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)

			var/obj/item/paper/P = new /obj/item/paper(loc)
			P.info = "<center><b>Chemical Analysis</b></center><br>"
			P.info += span_bold("Time of analysis:") + " [worldtime2stationtime(world.time)]<br><br>"
			P.info += span_bold("Chemical name:") + " [R.name]<br>"
			if(istype(R, /datum/reagent/blood))
				var/datum/reagent/blood/B = R
				P.info += span_bold("Description:") + " N/A<br><b>Blood Type:</b> [B.data["blood_type"]]<br><b>DNA:</b> [B.data["blood_DNA"]]"
			else
				P.info += span_bold("Description:") + " [R.description]"
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
			if(Adjacent(ui.user) && !issilicon(ui.user))
				ui.user.put_in_hands(beaker)
			beaker = null
			reagents.clear_reagents()
			update_icon()
		if("create_condi_bottle")
			if(!condi || !reagents.total_volume)
				return
			var/obj/item/reagent_containers/food/condiment/P = new(loc)
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
