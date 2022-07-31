//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////

/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = TRUE
	density = TRUE
	var/mob/living/carbon/human/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/suit_type = null
	var/obj/item/clothing/head/helmet/space/HELMET = null
	var/helmet_type = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/mask_type = null //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/isopen = 0
	var/islocked = 0
	var/isUV = 0
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/issuperUV = 0
	var/panelopen = 0
	var/safetieson = 1
	var/cycletime_left = 0

//The units themselves/////////////////

/obj/machinery/suit_storage_unit/standard_unit
	suit_type = /obj/item/clothing/suit/space
	helmet_type = /obj/item/clothing/head/helmet/space
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/Initialize()
	. = ..()
	if(suit_type)
		SUIT = new suit_type(src)
	if(helmet_type)
		HELMET = new helmet_type(src)
	if(mask_type)
		MASK = new mask_type(src)

/obj/machinery/suit_storage_unit/update_icon()
	var/hashelmet = 0
	var/hassuit = 0
	var/hashuman = 0
	if(HELMET)
		hashelmet = 1
	if(SUIT)
		hassuit = 1
	if(OCCUPANT)
		hashuman = 1
	icon_state = text("suitstorage[][][][][][][][][]", hashelmet, hassuit, hashuman, isopen, islocked, isUV, ispowered, isbroken, issuperUV)

/obj/machinery/suit_storage_unit/power_change()
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			islocked = 0
			isopen = 1
			dump_everything()
			update_icon()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
		if(2.0)
			if(prob(50))
				dump_everything()
				qdel(src)

/obj/machinery/suit_storage_unit/attack_hand(mob/user)
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	tgui_interact(user)

/obj/machinery/suit_storage_unit/tgui_state(mob/user)
	return GLOB.tgui_notcontained_state

/obj/machinery/suit_storage_unit/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuitStorageUnit", name)
		ui.open()

/obj/machinery/suit_storage_unit/tgui_data()
	var/list/data = list()

	data["broken"] = isbroken
	data["panelopen"] = panelopen

	data["locked"] = islocked
	data["open"] = isopen
	data["safeties"] = safetieson
	data["uv_active"] = isUV
	data["uv_super"] = issuperUV
	if(HELMET)
		data["helmet"] = HELMET.name
	else
		data["helmet"] = null
	if(SUIT)
		data["suit"] = SUIT.name
	else
		data["suit"] = null
	if(MASK)
		data["mask"] = MASK.name
	else
		data["mask"] = null
	data["storage"] = null
	if(OCCUPANT)
		data["occupied"] = TRUE
	else
		data["occupied"] = FALSE
	return data

/obj/machinery/suit_storage_unit/tgui_act(action, params) //I fucking HATE this proc
	if(..() || isUV || isbroken)
		return TRUE

	switch(action)
		if("door")
			toggle_open(usr)
			. = TRUE
		if("dispense")
			switch(params["item"])
				if("helmet")
					dispense_helmet(usr)
				if("mask")
					dispense_mask(usr)
				if("suit")
					dispense_suit(usr)
			. = TRUE
		if("uv")
			start_UV(usr)
			. = TRUE
		if("lock")
			toggle_lock(usr)
			. = TRUE
		if("eject_guy")
			eject_occupant(usr)
			. = TRUE

	// Panel Open stuff
	if(!. && panelopen)
		switch(action)
			if("toggleUV")
				toggleUV(usr)
				. = TRUE
			if("togglesafeties")
				togglesafeties(usr)
				. = TRUE

	update_icon()
	add_fingerprint(usr)


/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
	if(!panelopen)
		return

	else  //welp, the guy is protected, we can continue
		if(issuperUV)
			to_chat(user, "You slide the dial back towards \"185nm\".")
			issuperUV = 0
		else
			to_chat(user, "You crank the dial all the way up to \"15nm\".")
			issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
	if(!panelopen) //Needed check due to bugs
		return

	else
		to_chat(user, "You push the button. The coloured LED next to it changes.")
		safetieson = !safetieson


/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	if(!HELMET)
		return //Do I even need this sanity check? Nyoro~n
	else
		HELMET.loc = src.loc
		HELMET = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	if(!SUIT)
		return
	else
		SUIT.loc = src.loc
		SUIT = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	if(!MASK)
		return
	else
		MASK.loc = src.loc
		MASK = null
		return


/obj/machinery/suit_storage_unit/proc/dump_everything()
	islocked = 0 //locks go free
	if(SUIT)
		SUIT.loc = src.loc
		SUIT = null
	if(HELMET)
		HELMET.loc = src.loc
		HELMET = null
	if(MASK)
		MASK.loc = src.loc
		MASK = null
	if(OCCUPANT)
		eject_occupant(OCCUPANT)
	return


/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(islocked || isUV)
		to_chat(user, "<font color='red'>Unable to open unit.</font>")
		return
	if(OCCUPANT)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(OCCUPANT && safetieson)
		to_chat(user, "<font color='red'>The Unit's safety protocols disallow locking when a biological form is detected inside its compartments.</font>")
		return
	if(isopen)
		return
	islocked = !islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(OCCUPANT && safetieson)
		to_chat(user, "<font color='red'><B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</font>")
		return
	if(!HELMET && !MASK && !SUIT && !OCCUPANT) //shit's empty yo
		to_chat(user, "<font color='red'>Unit storage bays empty. Nothing to disinfect -- Aborting.</font>")
		return
	to_chat(user, "You start the Unit's cauterisation cycle.")
	cycletime_left = 20
	isUV = 1
	if(OCCUPANT && !islocked)
		islocked = 1 //Let's lock it for good measure
	update_icon()
	updateUsrDialog()

	var/i //our counter
	for(i=0,i<4,i++)
		sleep(50)
		if(OCCUPANT)
			OCCUPANT.apply_effect(50, IRRADIATE)
			var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in OCCUPANT.internal_organs
			if(!rad_organ)
				if(OCCUPANT.can_feel_pain())
					OCCUPANT.emote("scream")
				if(issuperUV)
					var/burndamage = rand(28,35)
					OCCUPANT.take_organ_damage(0,burndamage)
				else
					var/burndamage = rand(6,10)
					OCCUPANT.take_organ_damage(0,burndamage)
		if(i==3) //End of the cycle
			if(!issuperUV)
				if(HELMET)
					HELMET.clean_blood()
				if(SUIT)
					SUIT.clean_blood()
				if(MASK)
					MASK.clean_blood()
			else //It was supercycling, destroy everything
				if(HELMET)
					HELMET = null
				if(SUIT)
					SUIT = null
				if(MASK)
					MASK = null
				visible_message("<font color='red'>With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber.</font>", 3)
				isbroken = 1
				isopen = 1
				islocked = 0
				eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.
			isUV = 0 //Cycle ends
	update_icon()
	updateUsrDialog()
	return

/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(cycletime_left >= 1)
		cycletime_left--
	return cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if(islocked)
		return

	if(!OCCUPANT)
		return

	if(OCCUPANT.client)
		if(user != OCCUPANT)
			to_chat(OCCUPANT, "<font color='blue'>The machine kicks you out!</font>")
		if(user.loc != src.loc)
			to_chat(OCCUPANT, "<font color='blue'>You leave the not-so-cozy confines of the SSU.</font>")

		OCCUPANT.client.eye = OCCUPANT.client.mob
		OCCUPANT.client.perspective = MOB_PERSPECTIVE
	OCCUPANT.loc = src.loc
	OCCUPANT = null
	if(!isopen)
		isopen = 1
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	eject_occupant(usr)
	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	if(!isopen)
		to_chat(usr, "<font color='red'>The unit's doors are shut.</font>")
		return
	if(!ispowered || isbroken)
		to_chat(usr, "<font color='red'>The unit is not operational.</font>")
		return
	if((OCCUPANT) || (HELMET) || (SUIT))
		to_chat(usr, "<font color='red'>It's too cluttered inside for you to fit in!</font>")
		return
	visible_message("[usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
		OCCUPANT = usr
		isopen = 0 //Close the thing after the guy gets inside
		update_icon()

		add_fingerprint(usr)
		updateUsrDialog()
		return
	else
		OCCUPANT = null //Testing this as a backup sanity test
	return


/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(!ispowered)
		return
	if(I.is_screwdriver())
		panelopen = !panelopen
		playsound(src, I.usesound, 100, 1)
		to_chat(user, "<font color='blue'>You [panelopen ? "open up" : "close"] the unit's maintenance panel.</font>")
		updateUsrDialog()
		return
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!(ismob(G.affecting)))
			return
		if(!isopen)
			to_chat(user, "<font color='red'>The unit's doors are shut.</font>")
			return
		if(!ispowered || isbroken)
			to_chat(user, "<font color='red'>The unit is not operational.</font>")
			return
		if((OCCUPANT) || (HELMET) || (SUIT)) //Unit needs to be absolutely empty
			to_chat(user, "<font color='red'>The unit's storage area is too cluttered.</font>")
			return
		visible_message("[user] starts putting [G.affecting.name] into the Suit Storage Unit.", 3)
		if(do_after(user, 20))
			if(!G || !G.affecting) return //derpcheck
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			OCCUPANT = M
			isopen = 0 //close ittt

			add_fingerprint(user)
			qdel(G)
			updateUsrDialog()
			update_icon()
			return
		return
	if(istype(I,/obj/item/clothing/suit/space))
		if(!isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(SUIT)
			to_chat(user, "<font color='blue'>The unit already contains a suit.</font>")
			return
		to_chat(user, "You load the [S.name] into the storage compartment.")
		user.drop_item()
		S.loc = src
		SUIT = S
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/head/helmet))
		if(!isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(HELMET)
			to_chat(user, "<font color='blue'>The unit already contains a helmet.</font>")
			return
		to_chat(user, "You load the [H.name] into the storage compartment.")
		user.drop_item()
		H.loc = src
		HELMET = H
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/mask))
		if(!isopen)
			return
		var/obj/item/clothing/mask/M = I
		if(MASK)
			to_chat(user, "<font color='blue'>The unit already contains a mask.</font>")
			return
		to_chat(user, "You load the [M.name] into the storage compartment.")
		user.drop_item()
		M.loc = src
		MASK = M
		update_icon()
		updateUsrDialog()
		return
	update_icon()
	updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return attack_hand(user)

//////////////////////////////REMINDER: Make it lock once you place some fucker inside.

//God this entire file is fucking awful //Yes
//Suit painter for Bay's special snowflake aliums.

GLOBAL_LIST_EMPTY(suit_cycler_typecache)
/obj/machinery/suit_cycler

	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = TRUE
	density = TRUE

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100"

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

	wires = new(src)
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

/obj/machinery/suit_cycler/refit_only
	name = "Suit cycler"
	desc = "A dedicated industrial machine that can refit voidsuits for different species, but not change the suit's overall appearance or departmental scheme."
	model_text = "General Access"
	req_access = null
	limit_departments = list()

/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	limit_departments = list(
		/datum/suit_cycler_choice/department/eng
	)

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	limit_departments = list(
		/datum/suit_cycler_choice/department/crg
	)

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	limit_departments = list(
		/datum/suit_cycler_choice/department/sec
	)

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	limit_departments = list(
		/datum/suit_cycler_choice/department/med
	)

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	limit_departments = list(
		/datum/suit_cycler_choice/department/emag
	)
	can_repair = 1

/obj/machinery/suit_cycler/exploration
	name = "Explorer suit cycler"
	model_text = "Exploration"
	limit_departments = list(
		/datum/suit_cycler_choice/department/exp
	)

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	limit_departments = list(
		/datum/suit_cycler_choice/department/pil
	)

/obj/machinery/suit_cycler/vintage
	name = "Vintage Crew suit cycler"
	model_text = "Vintage"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/crew
	)
	req_access = null

/obj/machinery/suit_cycler/vintage/pilot
	name = "Vintage Pilot suit cycler"
	model_text = "Vintage Pilot"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/pilot
	)

/obj/machinery/suit_cycler/vintage/medsci
	name = "Vintage MedSci suit cycler"
	model_text = "Vintage MedSci"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/research,
		/datum/suit_cycler_choice/department/vintage/med
	)

/obj/machinery/suit_cycler/vintage/rugged
	name = "Vintage Ruggedized suit cycler"
	model_text = "Vintage Ruggedized"

	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/eng,
		/datum/suit_cycler_choice/department/vintage/marine,
		/datum/suit_cycler_choice/department/vintage/officer,
		/datum/suit_cycler_choice/department/vintage/merc
	)

/obj/machinery/suit_cycler/vintage/omni
	name = "Vintage Master suit cycler"
	model_text = "Vintage Master"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage
	)

/obj/machinery/suit_cycler/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(istype(I, /obj/item/multitool) || I.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(contents.len > 0)
			to_chat(user, "<span class='danger'>There is no room inside the cycler for [G.affecting.name].</span>")
			return

		visible_message("<span class='notice'>[user] starts putting [G.affecting.name] into the suit cycler.</span>", 3)

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
	else if(I.is_screwdriver())

		panel_open = !panel_open
		playsound(src, I.usesound, 50, 1)
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/head/helmet/space/void) && !istype(I, /obj/item/clothing/head/helmet/space/rig))
		var/obj/item/clothing/head/helmet/space/void/IH = I

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(helmet)
			to_chat(user, "<span class='danger'>The cycler already contains a helmet.</span>")
			return

		if(IH.no_cycle)
			to_chat(user, "<span class='danger'>That item is not compatible with the cycler's protocols.</span>")
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
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(suit)
			to_chat(user, "<span class='danger'>The cycler already contains a voidsuit.</span>")
			return

		if(IS.no_cycle)
			to_chat(user, "<span class='danger'>That item is not compatible with the cycler's protocols.</span>")
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
		to_chat(user, "<span class='danger'>The cycler has already been subverted.</span>")
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, "<span class='danger'>You run the sequencer across the interface, corrupting the operating protocols.</span>")

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

/obj/machinery/suit_cycler/tgui_act(action, params)
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
			if(allowed(usr))
				locked = !locked
				to_chat(usr, "You [locked ? "" : "un"]lock \the [src].")
			else
				to_chat(usr, "<span class='danger'>Access denied.</span>")
			. = TRUE

		if("eject_guy")
			eject_occupant(usr)
			. = TRUE

		if("uv")
			if(safeties && occupant)
				to_chat(usr, "<span class='danger'>The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle.</span>")
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
		finished_job()
		irradiating = 0
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
	T.visible_message("\icon[src][bicon(src)]<span class='notice'>The [src] beeps several times.</span>")
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
		to_chat(user, "<span class='warning'>The cycler is locked.</span>")
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
		visible_message("\icon[src][bicon(src)]<span class='warning'>Unable to apply specified cosmetics with specified species. Please try again with a different species or cosmetic option selected.</span>")
		return
