/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	desc = "Automagically fabricates chemicals from electricity."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	clicksound = "switch"

	var/list/spawn_cartridges = null // Set to a list of types to spawn one of each on New()

	var/list/cartridges = list() // Associative, label -> cartridge
	var/obj/item/weapon/reagent_containers/container = null

	var/ui_title = "Chemical Dispenser"

	var/accept_drinking = 0
	var/amount = 30
	var/max_catriges = 30

	use_power = USE_POWER_IDLE
	idle_power_usage = 100
	anchored = TRUE
	unacidable = TRUE

/obj/machinery/chemical_dispenser/Initialize()
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

/obj/machinery/chemical_dispenser/proc/add_cartridge(obj/item/weapon/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, "<span class='warning'>\The [C] will not fit in \the [src]!</span>")
		return

	if(cartridges.len >= max_catriges)
		if(user)
			to_chat(user, "<span class='warning'>\The [src] does not have any slots open for \the [C] to fit into!</span>")
		return

	if(!C.label)
		if(user)
			to_chat(user, "<span class='warning'>\The [C] does not have a label!</span>")
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, "<span class='warning'>\The [src] already contains a cartridge with that label!</span>")
		return

	if(user)
		user.drop_from_inventory(C)
		to_chat(user, "<span class='notice'>You add \the [C] to \the [src].</span>")

	C.loc = src
	cartridges[C.label] = C
	cartridges = sortAssoc(cartridges)
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/attackby(obj/item/weapon/W, mob/user)
	if(W.has_tool_quality(TOOL_WRENCH))
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

	else if(istype(W, /obj/item/weapon/reagent_containers/chem_disp_cartridge))
		add_cartridge(W, user)

	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		var/label = tgui_input_list(user, "Which cartridge would you like to remove?", "Chemical Dispenser", cartridges)
		if(!label) return
		var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, "<span class='notice'>You remove \the [C] from \the [src].</span>")
			C.loc = loc
			playsound(src, W.usesound, 50, 1)

	else if(istype(W, /obj/item/weapon/reagent_containers/glass) || istype(W, /obj/item/weapon/reagent_containers/food))
		if(container)
			to_chat(user, "<span class='warning'>There is already \a [container] on \the [src]!</span>")
			return

		var/obj/item/weapon/reagent_containers/RC = W

		if(!accept_drinking && istype(RC,/obj/item/weapon/reagent_containers/food))
			to_chat(user, "<span class='warning'>This machine only accepts beakers!</span>")
			return

		if(!RC.is_open_container())
			to_chat(user, "<span class='warning'>You don't see how \the [src] could dispense reagents into \the [RC].</span>")
			return

		container =  RC
		user.drop_from_inventory(RC)
		RC.loc = src
		to_chat(user, "<span class='notice'>You set \the [RC] on \the [src].</span>")
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
		var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals.Add(list(list("name" = label, "id" = label, "volume" = C.reagents.total_volume))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals
	return data

/obj/machinery/chemical_dispenser/tgui_act(action, params)
	if(..())
		return TRUE

	. = TRUE
	switch(action)
		if("amount")
			amount = clamp(round(text2num(params["amount"]), 1), 0, 120) // round to nearest 1 and clamp 0 - 120
		if("dispense")
			var/label = params["reagent"]
			if(cartridges[label] && container && container.is_open_container())
				var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C = cartridges[label]
				playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
				C.reagents.trans_to(container, amount)
		if("remove")
			var/amount = text2num(params["amount"])
			if(!container || !amount)
				return
			var/datum/reagents/R = container.reagents
			var/id = params["reagent"]
			if(amount > 0)
				R.remove_reagent(id, amount)
			else if(amount == -1) // Isolate
				R.isolate_reagent(id)
		if("ejectBeaker")
			if(container)
				container.forceMove(get_turf(src))

				if(Adjacent(usr)) // So the AI doesn't get a beaker somehow.
					usr.put_in_hands(container)

				container = null
		else
			return FALSE

	add_fingerprint(usr)

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
