/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	desc = "Automagically fabricates chemicals from electricity."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	clicksound = "switch"

	var/list/spawn_cartridges = null // Set to a list of types to spawn one of each on New()

	var/list/cartridges = list() // Associative, label -> cartridge
	var/obj/item/reagent_containers/container = null

	var/ui_title = "Chemical Dispenser"

	var/accept_drinking = 0
	var/amount = 30
	var/max_catriges = 30

	use_power = USE_POWER_IDLE
	idle_power_usage = 100
	anchored = TRUE
	unacidable = TRUE

	/// Records the reagents dispensed by the user if this list is not null
	var/list/recording_recipe
	/// Saves all the recipes recorded by the machine
	var/list/saved_recipes = list()

/obj/machinery/chemical_dispenser/Initialize(mapload)
	. = ..()
	if(spawn_cartridges)
		for(var/type in spawn_cartridges)
			add_cartridge(new type(src))

/obj/machinery/chemical_dispenser/examine(mob/user)
	. = ..()
	. += "It has [cartridges.len] cartridges installed, and has space for [max_catriges - cartridges.len] more."

/obj/machinery/chemical_dispenser/verb/rotate_clockwise()
	set name = "Rotate Dispenser Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened down!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

//VOREstation edit: counter-clockwise rotation
/obj/machinery/chemical_dispenser/verb/rotate_counterclockwise()
	set name = "Rotate Dispenser Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened down!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1
//VOREstation edit end

/obj/machinery/chemical_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, span_warning("\The [C] will not fit in \the [src]!"))
		return

	if(cartridges.len >= max_catriges)
		if(user)
			to_chat(user, span_warning("\The [src] does not have any slots open for \the [C] to fit into!"))
		return

	if(!C.label)
		if(user)
			to_chat(user, span_warning("\The [C] does not have a label!"))
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, span_warning("\The [src] already contains a cartridge with that label!"))
		return

	if(user)
		user.drop_from_inventory(C)
		to_chat(user, span_notice("You add \the [C] to \the [src]."))

	C.loc = src
	cartridges[C.label] = C
	cartridges = sortAssoc(cartridges)
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 50, 1)
		to_chat(user, span_notice("You begin to [anchored ? "un" : ""]fasten \the [src]."))
		if (do_after(user, 20 * W.toolspeed))
			user.visible_message(
				span_notice("\The [user] [anchored ? "un" : ""]fastens \the [src]."),
				span_notice("You have [anchored ? "un" : ""]fastened \the [src]."),
				"You hear a ratchet.")
			anchored = !anchored
		else
			to_chat(user, span_notice("You decide not to [anchored ? "un" : ""]fasten \the [src]."))

	else if(istype(W, /obj/item/reagent_containers/chem_disp_cartridge))
		add_cartridge(W, user)

	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		var/label = tgui_input_list(user, "Which cartridge would you like to remove?", "Chemical Dispenser", cartridges)
		if(!label) return
		var/obj/item/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, span_notice("You remove \the [C] from \the [src]."))
			C.loc = loc
			playsound(src, W.usesound, 50, 1)

	else if(istype(W, /obj/item/reagent_containers/glass) || istype(W, /obj/item/reagent_containers/food))
		if(container)
			to_chat(user, span_warning("There is already \a [container] on \the [src]!"))
			return

		var/obj/item/reagent_containers/RC = W

		if(!accept_drinking && istype(RC,/obj/item/reagent_containers/food))
			to_chat(user, span_warning("This machine only accepts beakers!"))
			return

		if(!RC.is_open_container())
			to_chat(user, span_warning("You don't see how \the [src] could dispense reagents into \the [RC]."))
			return

		if(istype(RC, /obj/item/reagent_containers/glass/cooler_bottle))
			to_chat(user, span_warning("You don't see how \the [RC] could fit into \the [src]."))
			return

		container =  RC
		user.drop_from_inventory(RC)
		RC.loc = src
		to_chat(user, span_notice("You set \the [RC] on \the [src]."))
	else
		return ..()

/obj/machinery/chemical_dispenser/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", ui_title) // 390, 655
		ui.open()

/obj/machinery/chemical_dispenser/tgui_data(mob/user)
	var/data[0]
	data["amount"] = amount
	data["isBeakerLoaded"] = container ? 1 : 0
	data["glass"] = accept_drinking

	var/beakerContents[0]
	if(container && container.reagents && container.reagents.reagent_list.len)
		for(var/datum/reagent/R in container.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "id" = R.id, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents

	if(container)
		data["beakerCurrentVolume"] = container.reagents.total_volume
		data["beakerMaxVolume"] = container.reagents.maximum_volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var/chemicals[0]
	for(var/label in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals.Add(list(list("name" = label, "id" = label, "volume" = C.reagents.total_volume))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	data["recipes"] = saved_recipes
	data["recordingRecipe"] = recording_recipe
	return data

/obj/machinery/chemical_dispenser/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	if(stat & BROKEN)
		return FALSE

	add_fingerprint(ui.user)

	switch(action)
		if("amount")
			amount = clamp(round(text2num(params["amount"]), 1), 0, 120) // round to nearest 1 and clamp 0 - 120
			. = TRUE

		if("dispense")
			var/label = params["reagent"]
			if(recording_recipe)
				recording_recipe += list(list("id" = label, "amount" = amount))
			else if(cartridges[label] && container && container.is_open_container())
				var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
				playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
				C.reagents.trans_to(container, amount)
			. = TRUE

		if("remove")
			var/amount = text2num(params["amount"])
			if(!container || !amount || recording_recipe)
				return
			var/datum/reagents/R = container.reagents
			var/id = params["reagent"]
			if(amount > 0)
				R.remove_reagent(id, amount)
			else if(amount == -1) // Isolate
				R.isolate_reagent(id)
			. = TRUE

		if("ejectBeaker")
			if(container)
				container.forceMove(get_turf(src))
				if(Adjacent(ui.user)) // So the AI doesn't get a beaker somehow.
					ui.user.put_in_hands(container)
				container = null
			. = TRUE

		if("record_recipe")
			recording_recipe = list()
			. = TRUE

		if("cancel_recording")
			recording_recipe = null
			. = TRUE

		if("clear_recipes")
			if(tgui_alert(ui.user, "Clear all recipes?", "Clear?", list("No", "Yes")) == "Yes")
				saved_recipes = list()
			. = TRUE

		if("save_recording")
			var/name = tgui_input_text(ui.user, "What do you want to name this recipe?", "Recipe Name?", "Recipe Name", MAX_NAME_LEN)
			if(tgui_status(ui.user, state) != STATUS_INTERACTIVE)
				return
			if(saved_recipes[name] && tgui_alert(ui.user, "\"[name]\" already exists, do you want to overwrite it?",, list("No", "Yes")) != "Yes")
				return
			if(name && recording_recipe)
				for(var/list/L in recording_recipe)
					var/label = L["id"]
					// Verify this dispenser can dispense every chemical
					if(!cartridges[label])
						visible_message(span_warning("[src] buzzes."), span_warning("You hear a faint buzz."))
						to_chat(ui.user, span_warning("[src] cannot find <b>[label]</b>!"))
						playsound(src, 'sound/machines/buzz-two.ogg', 50, TRUE)
						return
				saved_recipes[name] = recording_recipe
				recording_recipe = null
				. = TRUE

		if("dispense_recipe")
			var/list/chemicals_to_dispense = saved_recipes[params["recipe"]]
			if(!LAZYLEN(chemicals_to_dispense))
				return

			if(!recording_recipe)
				if(!container)
					to_chat(ui.user, span_warning("There is no beaker in [src]."))
					return

				for(var/list/L in chemicals_to_dispense)
					var/label = L["id"]
					var/dispense_amount = L["amount"]

					var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
					if(!C)
						visible_message(span_warning("[src] buzzes."), span_warning("You hear a faint buzz."))
						to_chat(ui.user, span_warning("[src] cannot find <b>[label]</b>!"))
						playsound(src, 'sound/machines/buzz-two.ogg', 50, TRUE)
						break

					// Allows copying recipes
					playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
					var/amount_actually_dispensed = C.reagents.trans_to(container, dispense_amount)
					if(dispense_amount != amount_actually_dispensed)
						visible_message(span_warning("[src] buzzes."), span_warning("You hear a faint buzz."))
						to_chat(ui.user, span_warning("[src] was only able to dispense [amount_actually_dispensed]u out of [dispense_amount]u requested of <b>[label]</b>!"))
						playsound(src, 'sound/machines/buzz-two.ogg', 50, TRUE)
						break
			else
				recording_recipe += chemicals_to_dispense
			. = TRUE
		if("remove_recipe")
			saved_recipes -= params["recipe"]
			. = TRUE

/obj/machinery/chemical_dispenser/attack_ghost(mob/user)
	if(stat & BROKEN)
		return
	tgui_interact(user)

/obj/machinery/chemical_dispenser/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/chemical_dispenser/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	tgui_interact(user)
