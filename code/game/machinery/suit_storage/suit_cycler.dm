GLOBAL_LIST_EMPTY(suit_cycler_typecache)

/obj/machinery/suit_cycler
	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = TRUE
	density = TRUE

	icon = 'icons/obj/suit_cycler.dmi'
	icon_state = "suit_cycler"

	req_access = list(access_captain,access_heads)

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair          // If set, the cycler can repair voidsuits.
	var/electrified = 0

	/// Departments that the cycler can paint suits to look like. Null assumes all except specially excluded ones.
	/// No idea why these particular suits are the default cycler's options.
	var/list/limit_departments = list(
		/datum/suit_cycler_choice/department/eng/standard,
		/datum/suit_cycler_choice/department/crg/mining,
		/datum/suit_cycler_choice/department/med/standard,
		/datum/suit_cycler_choice/department/sec/standard,
		/datum/suit_cycler_choice/department/eng/atmospherics,
		/datum/suit_cycler_choice/department/eng/hazmat,
		/datum/suit_cycler_choice/department/eng/construction,
		/datum/suit_cycler_choice/department/med/biohazard,
		/datum/suit_cycler_choice/department/med/emt,
		/datum/suit_cycler_choice/department/sec/riot,
		/datum/suit_cycler_choice/department/sec/eva
	)

	/// Species that the cycler can refit suits for. Null assumes all except specially excluded ones.
	var/list/limit_species

	var/list/departments
	var/list/species
	var/list/emagged_departments

	var/datum/suit_cycler_choice/department/target_department
	var/datum/suit_cycler_choice/species/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

	var/datum/wires/suit_storage_unit/wires = null

/obj/machinery/suit_cycler/Initialize()
	. = ..()

	departments = load_departments()
	species = load_species()
	emagged_departments = load_emagged()
	limit_departments = null // just for mem

	target_department = departments["No Change"]
	target_species = species["No Change"]

	if(!target_department || !target_species)
		stat |= BROKEN

	wires = new(src)

/obj/machinery/suit_cycler/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/suit_cycler/proc/load_departments()
	var/list/typecache = GLOB.suit_cycler_typecache[type]
	// First of our type
	if(!typecache)
		typecache = list()
		GLOB.suit_cycler_typecache[type] = typecache
	var/list/loaded = typecache["departments"]
	// No departments loaded
	if(!loaded)
		loaded = list()
		typecache["departments"] = loaded
		for(var/datum/suit_cycler_choice/department/thing as anything in GLOB.suit_cycler_departments)
			if(istype(thing, /datum/suit_cycler_choice/department/noop))
				loaded[thing.name] = thing
				continue
			if(limit_departments && !is_type_in_list(thing, limit_departments))
				continue
			loaded[thing.name] = thing

	return loaded

/obj/machinery/suit_cycler/proc/load_species()
	var/list/typecache = GLOB.suit_cycler_typecache[type]
	// First of our type
	if(!typecache)
		typecache = list()
		GLOB.suit_cycler_typecache[type] = typecache
	var/list/loaded = typecache["species"]
	// No species loaded
	if(!loaded)
		loaded = list()
		typecache["species"] = loaded
		for(var/datum/suit_cycler_choice/species/thing as anything in GLOB.suit_cycler_species)
			if(istype(thing, /datum/suit_cycler_choice/species/noop))
				loaded[thing.name] = thing
				continue
			if(limit_species && !is_type_in_list(thing, limit_species))
				continue
			loaded[thing.name] = thing

	return loaded

/obj/machinery/suit_cycler/proc/load_emagged()
	var/list/typecache = GLOB.suit_cycler_typecache[type]
	// First of our type
	if(!typecache)
		typecache = list()
		GLOB.suit_cycler_typecache[type] = typecache
	var/list/loaded = typecache["emagged"]
	// No emagged loaded
	if(!loaded)
		loaded = list()
		typecache["emagged"] = loaded
		for(var/datum/suit_cycler_choice/department/thing as anything in GLOB.suit_cycler_emagged)
			loaded[thing.name] = thing

	return loaded

/obj/machinery/suit_cycler/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(istype(I, /obj/item/multitool) || I.has_tool_quality(TOOL_WIRECUTTER))
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(locked)
			to_chat(user, span_danger("The suit cycler is locked."))
			return

		if(contents.len > 0)
			to_chat(user, span_danger("There is no room inside the cycler for [G.affecting.name]."))
			return

		visible_message(span_notice("[user] starts putting [G.affecting.name] into the suit cycler."), 3)

		if(do_after(user, 20))
			if(!G || !G.affecting) return
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			occupant = M

			add_fingerprint(user)
			qdel(G)

			updateUsrDialog()

			return
	else if(I.has_tool_quality(TOOL_SCREWDRIVER))

		panel_open = !panel_open
		playsound(src, I.usesound, 50, 1)
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/head/helmet/space/void) && !istype(I, /obj/item/clothing/head/helmet/space/rig))
		var/obj/item/clothing/head/helmet/space/void/IH = I

		if(locked)
			to_chat(user, span_danger("The suit cycler is locked."))
			return

		if(helmet)
			to_chat(user, span_danger("The cycler already contains a helmet."))
			return

		if(IH.no_cycle)
			to_chat(user, span_danger("That item is not compatible with the cycler's protocols."))
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return

		//VOREStation Edit BEGINS
		//Make it so autolok suits can't be refitted in a cycler
		if(istype(I,/obj/item/clothing/head/helmet/space/void/autolok))
			to_chat(user, "You cannot refit an autolok helmet. In fact you shouldn't even be able to remove it in the first place. Inform an admin!")
			return

		//Ditto the Mk7
		if(istype(I,/obj/item/clothing/head/helmet/space/void/responseteam))
			to_chat(user, "The cycler indicates that the Mark VII Emergency Response Helmet is not compatible with the refitting system. How did you manage to detach it anyway? Inform an admin!")
			return
		//VOREStation Edit ENDS

		to_chat(user, "You fit \the [I] into the suit cycler.")
		user.drop_item()
		I.loc = src
		helmet = I

		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/suit/space/void))
		var/obj/item/clothing/suit/space/void/IS = I

		if(locked)
			to_chat(user, span_danger("The suit cycler is locked."))
			return

		if(suit)
			to_chat(user, span_danger("The cycler already contains a voidsuit."))
			return

		if(IS.no_cycle)
			to_chat(user, span_danger("That item is not compatible with the cycler's protocols."))
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return

		//VOREStation Edit BEGINS
		//Make it so autolok suits can't be refitted in a cycler
		if(istype(I,/obj/item/clothing/suit/space/void/autolok))
			to_chat(user, "You cannot refit an autolok suit.")
			return

		//Ditto the Mk7
		if(istype(I,/obj/item/clothing/suit/space/void/responseteam))
			to_chat(user, "The cycler indicates that the Mark VII Emergency Response Suit is not compatible with the refitting system.")
			return
		//VOREStation Edit ENDS

		to_chat(user, "You fit \the [I] into the suit cycler.")
		user.drop_item()
		I.loc = src
		suit = I

		update_icon()
		updateUsrDialog()
		return

	..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, span_danger("The cycler has already been subverted."))
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, span_danger("You run the sequencer across the interface, corrupting the operating protocols."))

	emagged = 1
	safeties = 0
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(electrified != 0)
		if(shock(user, 100))
			return

	tgui_interact(user)

/obj/machinery/suit_cycler/tgui_state(mob/user)
	return GLOB.tgui_notcontained_state

/obj/machinery/suit_cycler/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuitCycler", name)
		ui.open()

/obj/machinery/suit_cycler/tgui_data(mob/user)
	var/list/data = list()

	data["model_text"] = model_text
	data["can_repair"] = can_repair
	data["userHasAccess"] = allowed(user)

	data["locked"] = locked
	data["active"] = active
	data["safeties"] = safeties
	data["uv_active"] = (active && irradiating > 0)
	data["uv_level"] = radiation_level
	data["max_uv_level"] = emagged ? 5 : 3
	if(helmet)
		data["helmet"] = helmet.name
	else
		data["helmet"] = null
	if(suit)
		data["suit"] = suit.name
		if(istype(suit) && can_repair)
			data["damage"] = suit.damage
	else
		data["suit"] = null
		data["damage"] = null
	if(occupant)
		data["occupied"] = TRUE
	else
		data["occupied"] = FALSE

	return data

/obj/machinery/suit_cycler/tgui_static_data(mob/user)
	var/list/data = list()

	// tgui gets angy if you pass values too
	var/list/department_keys = list()
	for(var/key in departments)
		department_keys += key

	// emagged at the bottom
	if(emagged)
		for(var/key in emagged_departments)
			department_keys += key

	var/list/species_keys = list()
	for(var/key in species)
		species_keys += key

	data["departments"] = department_keys
	data["species"] = species_keys

	return data

/obj/machinery/suit_cycler/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("dispense")
			switch(params["item"])
				if("helmet")
					helmet.forceMove(get_turf(src))
					helmet = null
				if("suit")
					suit.forceMove(get_turf(src))
					suit = null
			. = TRUE

		if("department")
			var/choice = params["department"]
			if(choice in departments)
				target_department = departments[choice]
			else if(emagged && (choice in emagged_departments))
				target_department = emagged_departments[choice]
				. = TRUE

		if("species")
			var/choice = params["species"]
			if(choice in species)
				target_species = species[choice]
				. = TRUE

		if("radlevel")
			radiation_level = clamp(params["radlevel"], 1, emagged ? 5 : 3)
			. = TRUE

		if("repair_suit")
			if(!suit || !can_repair)
				return
			active = 1
			spawn(100)
				repair_suit()
				finished_job()
			. = TRUE

		if("apply_paintjob")
			if(!suit && !helmet)
				return
			active = 1
			spawn(100)
				apply_paintjob()
				finished_job()
			. = TRUE

		if("lock")
			if(allowed(ui.user))
				locked = !locked
				to_chat(ui.user, "You [locked ? "" : "un"]lock \the [src].")
			else
				to_chat(ui.user, span_danger("Access denied."))
			. = TRUE

		if("eject_guy")
			eject_occupant(ui.user)
			. = TRUE

		if("uv")
			if(safeties && occupant)
				to_chat(ui.user, span_danger("The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
				return

			active = 1
			irradiating = 10

			sleep(10)

			if(helmet)
				if(radiation_level > 2)
					helmet.decontaminate()
				if(radiation_level > 1)
					helmet.clean_blood()

			if(suit)
				if(radiation_level > 2)
					suit.decontaminate()
				if(radiation_level > 1)
					suit.clean_blood()

			. = TRUE

/obj/machinery/suit_cycler/process()

	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && stat & (BROKEN|NOPOWER))
		active = 0
		irradiating = 0
		electrified = 0
		return

	if(irradiating == 1)
		add_overlay("decon")
		finished_job()
		irradiating = 0
		cut_overlays()
		return

	irradiating--

	if(occupant)
		if(prob(radiation_level*2)) occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0,radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0,radiation_level + rand(1,3))
		occupant.apply_effect(radiation_level*10, IRRADIATE)

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message("[icon2html(src,viewers(src))]" + span_notice("The [src] beeps several times."))
	icon_state = initial(icon_state)
	active = 0
	playsound(src, 'sound/machines/boobeebeep.ogg', 50)
	updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

	return

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user as mob)

	if(locked || active)
		to_chat(user, span_warning("The cycler is locked."))
		return

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.loc = get_turf(occupant)
	occupant = null

	add_fingerprint(user)
	updateUsrDialog()
	update_icon()

	return

// "Streamlined" before? Ok. -Aro
/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_species || !target_department)
		return

	// Helmet to new paint
	if(target_department.can_refit_helmet(helmet))
		target_department.do_refit_helmet(helmet)
	// Suit to new paint
	if(target_department.can_refit_suit(suit))
		target_department.do_refit_suit(suit)
	// Attached voidsuit helmet to new paint
	if(target_department.can_refit_helmet(suit?.helmet))
		target_department.do_refit_helmet(suit.helmet)

	// Species fitting for all 3 potential changes
	if(target_species.can_refit_to(helmet, suit, suit?.helmet))
		target_species.do_refit_to(helmet, suit, suit?.helmet)
	else
		visible_message("[icon2html(src,viewers(src))]" + span_warning("Unable to apply specified cosmetics with specified species. Please try again with a different species or cosmetic option selected."))
		return
