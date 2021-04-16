//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////

/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = 1
	density = 1
	var/mob/living/carbon/human/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothing/head/helmet/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
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
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/New()
	update_icon()
	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)

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
			return
		if(2.0)
			if(prob(50))
				dump_everything()
				qdel(src)
			return
		else
			return
	return

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
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src, "sparks", 75, 1, -1)
		to_chat(user, "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>")
		return*/
	else  //welp, the guy is protected, we can continue
		if(issuperUV)
			to_chat(user, "You slide the dial back towards \"185nm\".")
			issuperUV = 0
		else
			to_chat(user, "You crank the dial all the way up to \"15nm\".")
			issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src, "sparks", 75, 1, -1)
		to_chat(user, "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>")
		return*/
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

/*	spawn(200) //Let's clean dat shit after 20 secs  //Eh, this doesn't work
		if(HELMET)
			HELMET.clean_blood()
		if(SUIT)
			SUIT.clean_blood()
		if(MASK)
			MASK.clean_blood()
		isUV = 0 //Cycle ends
		update_icon()
		updateUsrDialog()

	var/i
	for(i=0,i<4,i++) //Gradually give the guy inside some damaged based on the intensity
		spawn(50)
			if(OCCUPANT)
				if(issuperUV)
					OCCUPANT.take_organ_damage(0,40)
					to_chat(user, "Test. You gave him 40 damage")
				else
					OCCUPANT.take_organ_damage(0,8)
					to_chat(user, "Test. You gave him 8 damage")
	return*/


/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(cycletime_left >= 1)
		cycletime_left--
	return cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if(islocked)
		return

	if(!OCCUPANT)
		return
//	for(var/obj/O in src)
//		O.loc = src.loc

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
//		usr.metabslow = 1
		OCCUPANT = usr
		isopen = 0 //Close the thing after the guy gets inside
		update_icon()

//		for(var/obj/O in src)
//			qdel(O)

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
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
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

			//for(var/obj/O in src)
			//	O.loc = src.loc
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

//God this entire file is fucking awful
//Suit painter for Bay's special snowflake aliums.

/obj/machinery/suit_cycler

	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = 1
	density = 1

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

	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering","Mining","Medical","Security","Atmospherics","HAZMAT","Construction","Biohazard","Emergency Medical Response","Crowd Control","Security EVA")
	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJ, SPECIES_TESHARI)

	var/target_department
	var/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

	var/datum/wires/suit_storage_unit/wires = null

/obj/machinery/suit_cycler/New()
	..()

	wires = new(src)
	target_department = departments[1]
	target_species = species[1]
	if(!target_department || !target_species) qdel(src)

/obj/machinery/suit_cycler/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/suit_cycler/refit_only
	name = "Suit cycler"
	desc = "A dedicated industrial machine that can refit voidsuits for different species, but not change the suit's overall appearance or departmental scheme."
	model_text = "General Access"
	req_access = null
	departments = list("No Change")

/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	departments = list("Engineering","Atmospherics","HAZMAT","Construction","No Change")

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	departments = list("Mining","No Change")

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	departments = list("Security","Crowd Control","Security EVA","No Change")

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	departments = list("Medical","Biohazard","Emergency Medical Response","No Change")

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	departments = list("Mercenary", "Charring","No Change")
	can_repair = 1

/obj/machinery/suit_cycler/exploration
	name = "Explorer suit cycler"
	model_text = "Exploration"
	departments = list("Exploration","Expedition Medic","Old Exploration","No Change")

/obj/machinery/suit_cycler/exploration/Initialize()
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	departments = list("Pilot Blue","Pilot","No Change")

/obj/machinery/suit_cycler/vintage
	name = "Vintage Crew suit cycler"
	model_text = "Vintage"
	departments = list("Vintage Crew","No Change")
	req_access = null

/obj/machinery/suit_cycler/vintage/pilot
	name = "Vintage Pilot suit cycler"
	model_text = "Vintage Pilot"
	departments = list("Vintage Pilot (Bubble Helm)","Vintage Pilot (Closed Helm)","No Change")

/obj/machinery/suit_cycler/vintage/medsci
	name = "Vintage MedSci suit cycler"
	model_text = "Vintage MedSci"
	departments = list("Vintage Medical (Bubble Helm)","Vintage Medical (Closed Helm)","Vintage Research (Bubble Helm)","Vintage Research (Closed Helm)","No Change")

/obj/machinery/suit_cycler/vintage/rugged
	name = "Vintage Ruggedized suit cycler"
	model_text = "Vintage Ruggedized"
	departments = list("Vintage Engineering","Vintage Marine","Vintage Officer","Vintage Mercenary","No Change")

/obj/machinery/suit_cycler/vintage/omni
	name = "Vintage Master suit cycler"
	model_text = "Vintage Master"
	departments = list("Vintage Crew","Vintage Engineering","Vintage Pilot (Bubble Helm)","Vintage Pilot (Closed Helm)","Vintage Medical (Bubble Helm)","Vintage Medical (Closed Helm)","Vintage Research (Bubble Helm)","Vintage Research (Closed Helm)","Vintage Marine","Vintage Officer","Vintage Mercenary","No Change")

/obj/machinery/suit_cycler/vintage/Initialize()
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(istype(I, /obj/item/device/multitool) || I.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I

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
	departments = list("Engineering","Mining","Medical","Security","Atmospherics","HAZMAT","Construction","Biohazard","Crowd Control","Security EVA","Emergency Medical Response","^%###^%$", "Charring","No Change")
	species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_VULPKANIN) //VORESTATION EDIT

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

	data["departments"] = departments
	data["species"] = species
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
				target_department = choice
				. = TRUE

		if("species")
			var/choice = params["species"]
			if(choice in species)
				target_species = choice
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
	T.visible_message("[bicon(src)]<span class='notice'>The [src] beeps several times.</span>")
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

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
//hold onto your hat, this sumbitch just got streamlined -KK
/obj/machinery/suit_cycler/proc/apply_paintjob()
	var/obj/item/clothing/head/helmet/parent_helmet
	var/obj/item/clothing/suit/space/parent_suit
	var/turf/T = get_turf(src)
	if(!target_species || !target_department)
		return
	//Now "Complete" with most departmental and variant suits, and sorted by department. These aren't available in the standard or emagged cycler lists because they're incomplete for most species.
	switch(target_department)
		if("No Change")
			parent_helmet = helmet
			parent_suit = suit
		//Engineering and Engineering Variants
		if("Engineering")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering
			parent_suit = /obj/item/clothing/suit/space/void/engineering
		if("HAZMAT")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/hazmat
			parent_suit = /obj/item/clothing/suit/space/void/engineering/hazmat
		if("Construction")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/construction
			parent_suit = /obj/item/clothing/suit/space/void/engineering/construction
		if("Reinforced")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/alt
			parent_suit = /obj/item/clothing/suit/space/void/engineering/alt
		if("Salvager")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage
			parent_suit = /obj/item/clothing/suit/space/void/engineering/salvage
		if("Atmospherics")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/atmos
			parent_suit = /obj/item/clothing/suit/space/void/atmos
		if("Heavy Duty Atmospherics")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/atmos/alt
			parent_suit = /obj/item/clothing/suit/space/void/atmos/alt
		//Mining and Mining Variants
		if("Mining")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/mining
			parent_suit = /obj/item/clothing/suit/space/void/mining
		if("Frontier Miner")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/mining/alt
			parent_suit = /obj/item/clothing/suit/space/void/mining/alt
		//Medical and Medical Variants
		if("Medical")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical
			parent_suit = /obj/item/clothing/suit/space/void/medical
		if("Biohazard")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical/bio
			parent_suit = /obj/item/clothing/suit/space/void/medical/bio
		if("Emergency Medical Response")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical/emt
			parent_suit = /obj/item/clothing/suit/space/void/medical/emt
		if("Vey-Medical Streamlined")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical/alt
			parent_suit = /obj/item/clothing/suit/space/void/medical/alt
		//Security and Security Variants
		if("Security")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security
			parent_suit = /obj/item/clothing/suit/space/void/security
		if("Crowd Control")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security/riot
			parent_suit = /obj/item/clothing/suit/space/void/security/riot
		if("Security EVA")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security/alt
			parent_suit = /obj/item/clothing/suit/space/void/security/alt
		//Exploration Department
		if("Exploration")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/exploration
			parent_suit = /obj/item/clothing/suit/space/void/exploration
		if("Expedition Medic")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/expedition_medical
			parent_suit = /obj/item/clothing/suit/space/void/expedition_medical
		if("Old Exploration")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/exploration/alt
			parent_suit = /obj/item/clothing/suit/space/void/exploration/alt
		if("Pilot")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/pilot
			parent_suit = /obj/item/clothing/suit/space/void/pilot
		if("Pilot Blue")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/pilot/alt
			parent_suit = /obj/item/clothing/suit/space/void/pilot/alt
		//Antag Suits
		if("^%###^%$" || "Mercenary")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/merc
			parent_suit = /obj/item/clothing/suit/space/void/merc
		if("Charring")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/merc/fire
			parent_suit = /obj/item/clothing/suit/space/void/merc/fire
		if("Gem-Encrusted" || "Wizard")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/wizard
			parent_suit = /obj/item/clothing/suit/space/void/wizard
		//Special or Event suits
		if("Vintage Crew")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb
			parent_suit = /obj/item/clothing/suit/space/void/refurb
		if("Vintage Engineering")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/engineering
			parent_suit = /obj/item/clothing/suit/space/void/refurb/engineering
		if("Vintage Medical (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/medical/alt
			parent_suit = /obj/item/clothing/suit/space/void/refurb/medical
		if("Vintage Medical (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/medical
			parent_suit = /obj/item/clothing/suit/space/void/refurb/medical
		if("Vintage Marine")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/marine
			parent_suit = /obj/item/clothing/suit/space/void/refurb/marine
		if("Vintage Officer")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/officer
			parent_suit = /obj/item/clothing/suit/space/void/refurb/officer
		if("Vintage Pilot (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot
			parent_suit = /obj/item/clothing/suit/space/void/refurb/pilot
		if("Vintage Pilot (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot/alt
			parent_suit = /obj/item/clothing/suit/space/void/refurb/pilot
		if("Vintage Research (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/research/alt
			parent_suit = /obj/item/clothing/suit/space/void/refurb/research
		if("Vintage Research (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/research
			parent_suit = /obj/item/clothing/suit/space/void/refurb/research
		if("Vintage Mercenary")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/mercenary
			parent_suit = /obj/item/clothing/suit/space/void/refurb/mercenary
		//BEGIN: Space for additional downstream variants
		//VOREStation Addition Start
		if("Manager")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/captain
			parent_suit = /obj/item/clothing/suit/space/void/captain
		if("Prototype")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security/prototype
			parent_suit = /obj/item/clothing/suit/space/void/security/prototype
		if("Talon Crew")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/talon
		if("Talon Engineering")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/engineering/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/engineering/talon
		if("Talon Medical (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/medical/alt/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/medical/talon
		if("Talon Medical (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/medical/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/medical/talon
		if("Talon Marine")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/marine/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/marine/talon
		if("Talon Officer")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/officer/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/officer/talon
		if("Talon Pilot (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/pilot/talon
		if("Talon Pilot (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot/alt/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/pilot/talon
		if("Talon Research (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/research/alt/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/research/talon
		if("Talon Research (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/research/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/research/talon
		if("Talon Mercenary")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/mercenary/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/mercenary/talon
		//VOREStation Addition End
		//END: downstream variant space
	if(target_species)
		//Only run these checks if they have a sprite sheet defined, otherwise they use human's anyways, and there is almost definitely a sprite.
		if((helmet!=null&&(target_species in helmet.sprite_sheets_obj))||(suit!=null&&(target_species in suit.sprite_sheets_obj)))
			//Making sure all of our items have the sprites to be refitted.
			var/helmet_check = ((helmet!=null && (initial(parent_helmet.icon_state) in icon_states(helmet.sprite_sheets_obj[target_species],1))) || helmet==null)
			//If the helmet exists, only return true if there's also sprites for it. If the helmet doesn't exist, return true.
			var/suit_check = ((suit!=null && (initial(parent_suit.icon_state) in icon_states(suit.sprite_sheets_obj[target_species],1))) || suit==null)
			var/suit_helmet_check = ((suit!=null && suit.helmet!=null && (initial(parent_helmet.icon_state) in icon_states(suit.helmet.sprite_sheets_obj[target_species],1))) || suit==null || suit.helmet==null)
			if(helmet_check && suit_check && suit_helmet_check)
				if(helmet) 
					helmet.refit_for_species(target_species)
				if(suit) 
					suit.refit_for_species(target_species)
					if(suit.helmet)
						suit.helmet.refit_for_species(target_species)
			else
				//If they don't, alert the user and stop here.
				T.visible_message("[bicon(src)]<span class='warning'>Unable to apply specified cosmetics with specified species. Please try again with a different species or cosmetic option selected.</span>")
				return
		else
			if(helmet) 
				helmet.refit_for_species(target_species)
			if(suit) 
				suit.refit_for_species(target_species)
				if(suit.helmet)
					suit.helmet.refit_for_species(target_species)
	//look at this! isn't it beautiful? -KK (well ok not beautiful but it's a lot cleaner)
	if(helmet && target_department != "No Change")
		var/obj/item/clothing/H = new parent_helmet
		helmet.name = "refitted [initial(parent_helmet.name)]"
		helmet.desc = initial(parent_helmet.desc)
		helmet.icon_state = initial(parent_helmet.icon_state)
		helmet.item_state = initial(parent_helmet.item_state)
		helmet.light_overlay = initial(parent_helmet.light_overlay)
		helmet.item_state_slots = H.item_state_slots
		qdel(H)

	if(suit && target_department != "No Change")
		var/obj/item/clothing/S = new parent_suit
		suit.name = "refitted [initial(parent_suit.name)]"
		suit.desc = initial(parent_suit.desc)
		suit.icon_state = initial(parent_suit.icon_state)
		suit.item_state = initial(parent_suit.item_state)
		suit.item_state_slots = S.item_state_slots
		qdel(S)

		//can't believe I forgot to fix this- now helmets will properly cycle if they're attached to a suit -KK
		if(suit.helmet && target_department != "No Change")
			var/obj/item/clothing/AH = new parent_helmet
			suit.helmet.name = "refitted [initial(parent_helmet.name)]"
			suit.helmet.desc = initial(parent_helmet.desc)
			suit.helmet.icon_state = initial(parent_helmet.icon_state)
			suit.helmet.item_state = initial(parent_helmet.item_state)
			suit.helmet.light_overlay = initial(parent_helmet.light_overlay)
			suit.helmet.item_state_slots = AH.item_state_slots
			qdel(AH)
