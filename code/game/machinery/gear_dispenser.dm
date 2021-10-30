//////////////////////////////////////
// GEAR DISPENSER UNIT ///////////////
//////////////////////////////////////

#define GD_BUSY			1		// the dispenser is busy.
#define GD_ONEITEM		2		// only one type of suit comes out of this dispenser.
#define GD_NOGREED		4		// no-one is allowed more than one item from this TYPE of dispenser unless emagged
#define GD_UNLIMITED	8		// will not deplete amount when gear is taken
#define GD_UNIQUE		16		// each instance of this will allow people to take 1 thing

var/list/dispenser_presets = list()

// Standard generic item list
/datum/gear_disp
	var/name = "gear"
	var/list/to_spawn
	var/amount = 0
	var/list/req_one_access

/datum/gear_disp/proc/allowed(var/mob/living/carbon/human/user)
	if(LAZYLEN(req_one_access))
		var/accesses = user.GetAccess()
		return has_access(null, req_one_access, accesses)
	
	return 1	

/datum/gear_disp/proc/spawn_gear(var/turf/T, var/mob/living/carbon/human/user)
	var/list/spawned = list()
	for(var/O in to_spawn)
		spawned += new O(T)
	return spawned

// For fluff/custom items
/datum/gear_disp/custom
	name = "custom"
	// Can do either/or of these
	var/ckey_allowed
	var/character_allowed

/datum/gear_disp/custom/allowed(var/mob/living/carbon/human/user)
	if(ckey_allowed && user.ckey != ckey_allowed)
		return 0
	
	if(character_allowed && user.real_name != character_allowed)
		return 0

	return ..()

/datum/gear_disp/trash
	name = "???"
	to_spawn = list(/obj/random/trash)
	amount = 50

// Voidsuits can have bits jammed onto them
/datum/gear_disp/voidsuit
	//var/list/to_spawn // Put other stuff that ISN'T one of the below
	var/voidsuit_type
	var/voidhelmet_type
	var/magboots_type
	var/life_support = TRUE // try to spawn a tank or suit cooler
	var/refit = TRUE // should we adapt this to the user's species

/datum/gear_disp/voidsuit/spawn_gear(var/turf/T, var/mob/living/carbon/human/user)
	ASSERT(voidsuit_type)
	. = ..()
	if(voidsuit_type && !ispath(voidsuit_type, /obj/item/clothing/suit/space/void))
		error("[src] can't spawn type [voidsuit_type] as a voidsuit")
		return
	if(voidhelmet_type && !ispath(voidhelmet_type, /obj/item/clothing/head/helmet/space/void))
		error("[src] can't spawn type [voidsuit_type] as a voidhelmet")
		return
	if(magboots_type && !ispath(magboots_type, /obj/item/clothing/shoes/magboots))
		error("[src] can't spawn type [magboots_type] as magboots")
		return

	var/obj/item/clothing/suit/space/void/voidsuit
	var/obj/item/clothing/head/helmet/space/void/voidhelmet
	var/obj/item/clothing/shoes/magboots/magboots

	var/spawned = list()

	voidsuit = new voidsuit_type(T)
	spawned += voidsuit // We only add the voidsuit so the game doesn't try to put the tank/helmet/boots etc into their hands
	
	// If we're supposed to make a helmet
	if(voidhelmet_type)
		// The coder may not have realized this type spawns its own helmet
		if(voidsuit.helmet)
			error("[src] created a voidsuit [voidsuit] and wants to add a helmet but it already has one")
		else
			voidhelmet = new voidhelmet_type()
			voidsuit.attach_helmet(voidhelmet)
	// If we're supposed to make boots
	if(magboots_type)
		// The coder may not have realized thist ype spawns its own boots
		if(voidsuit.boots)
			error("[src] created a voidsuit [voidsuit] and wants to add a helmet but it already has one")
		else
			magboots = new magboots_type(voidsuit)
			voidsuit.boots = magboots
	
	if(refit)
		voidsuit.refit_for_species(user.species?.get_bodytype()) // does helmet and boots if they're attached

	if(life_support)
		if(user.isSynthetic())
			if(voidsuit.cooler)
				error("[src] created a voidsuit [voidsuit] and wants to add a suit cooler but it already has one")
			else
				var/obj/item/life_support = new /obj/item/device/suit_cooling_unit(voidsuit)
				voidsuit.cooler = life_support
		else if(user.species?.breath_type)
			if(voidsuit.tank)
				error("[src] created a voidsuit [voidsuit] and wants to add a tank but it already has one")
			else	
				//Create a tank (if such a thing exists for this species)
				var/tanktext = "/obj/item/weapon/tank/" + "[user.species?.breath_type]"
				var/obj/item/weapon/tank/tankpath = text2path(tanktext)

				if(tankpath)
					var/obj/item/life_support = new tankpath(voidsuit)
					voidsuit.tank = life_support
				else
					voidsuit.audible_message("Dispenser warning: Unable to locate suitable airtank for user.")

	. += spawned

// For fluff/custom voidsuits
/datum/gear_disp/voidsuit/custom
	name = "custom voidsuit"
	// Can do either/or of these
	var/ckey_allowed
	var/character_allowed

/datum/gear_disp/voidsuit/custom/allowed(var/mob/living/carbon/human/user)
	if(ckey_allowed && user.ckey != ckey_allowed)
		return 0
	
	if(character_allowed && user.real_name != character_allowed)
		return 0

	return ..()

// The dispenser itself
/obj/machinery/gear_dispenser
	name = "gear dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch all kinds of equipment."
	icon = 'icons/obj/suitdispenser.dmi'
	icon_state = "geardispenser"
	anchored = TRUE
	density = TRUE
	var/list/dispenses = list(/datum/gear_disp/trash) // put your gear datums here!
	var/datum/gear_disp/one_setting
	var/global/list/gear_distributed_to = list()
	var/dispenser_flags = GD_NOGREED|GD_UNLIMITED
	var/unique_dispense_list = list()
	var/needs_power = 0
	//req_one_access = list(whatever) // Note that each gear datum can have access, too.

/obj/machinery/gear_dispenser/custom/emag_act(remaining_charges, mob/user, emag_source)
	to_chat(user, "<span class='warning'>Your moral standards prevent you from emagging this machine!</span>")
	return -1 // Letting people emag this one would be bad times

/obj/machinery/gear_dispenser/Initialize()
	. = ..()
	if(!gear_distributed_to["[type]"] && (dispenser_flags & GD_NOGREED))
		gear_distributed_to["[type]"] = list()
	var/list/real_gear_list = list()
	for(var/gear in dispenses)
		var/datum/gear_disp/S = new gear
		real_gear_list[S.name] = S
	if(one_setting)
		one_setting = new one_setting
	dispenses = real_gear_list
	

/obj/machinery/gear_dispenser/attack_hand(var/mob/living/carbon/human/user)
	if(!can_use(user))
		return
	dispenser_flags |= GD_BUSY
	if(!(dispenser_flags & GD_ONEITEM))
		var/list/gear_list = get_gear_list(user)
		
		if(!LAZYLEN(gear_list))
			to_chat(user, "<span class='warning'>\The [src] doesn't have anything to dispense for you!</span>")
			dispenser_flags &= ~GD_BUSY
			return
		
		var/choice = tgui_input_list(usr, "Select equipment to dispense.", "Equipment Dispenser", gear_list)
		
		if(!choice)
			dispenser_flags &= ~GD_BUSY
			return
		
		dispense(gear_list[choice],user)
	else
		dispense(one_setting,user)


/obj/machinery/gear_dispenser/proc/can_use(var/mob/living/carbon/human/user)
	var/list/used_by = gear_distributed_to["[type]"]
	if(needs_power && inoperable())
		to_chat(user,"<span class='warning'>The machine does not respond to your prodding.</span>")
		return 0
	if(!istype(user))
		to_chat(user,"<span class='warning'>You can't use this!</span>")
		return 0
	if((dispenser_flags & GD_BUSY))
		to_chat(user,"<span class='warning'>Someone else is using this!</span>")
		return 0
	if((dispenser_flags & GD_ONEITEM) && !(dispenser_flags & GD_UNLIMITED) && !one_setting.amount)
		to_chat(user,"<span class='warning'>There's nothing in here!</span>")
		return 0
	if (!emagged)
		if ((dispenser_flags & GD_NOGREED) && (user.ckey in used_by))
			to_chat(user,"<span class='warning'>You've already picked up your gear!</span>")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return 0
		if ((dispenser_flags & GD_UNIQUE) && (user.ckey in unique_dispense_list))
			to_chat(user,"<span class='warning'>You've already picked up your gear!</span>")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return 0
	else
		audible_message("!'^&YouVE alreaDY pIC&$!Ked UP yOU%r Ge^!ar.")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 100, 0)
		return 1	
	// And finally
	if(allowed(user))
		return 1
	else
		to_chat(user,"<span class='warning'>Your access is rejected!</span>")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 100, 0)
		return 0


/obj/machinery/gear_dispenser/proc/get_gear_list(var/mob/living/carbon/human/user)
	if(emagged)
		return dispenses

	var/list/choices = list()
	for(var/choice in dispenses)
		var/datum/gear_disp/G = dispenses[choice]
		if(G.allowed(user))
			choices[choice] = G
	return choices

/obj/machinery/gear_dispenser/proc/dispense(var/datum/gear_disp/S,var/mob/living/carbon/human/user,var/greet=TRUE)
	if(!S.amount && !(dispenser_flags & GD_UNLIMITED))
		to_chat(user,"<span class='warning'>There are no more [S.name]s left!</span>")
		dispenser_flags &= ~GD_BUSY
		return 1
	else if(!(dispenser_flags & GD_UNLIMITED))
		S.amount--
	if((dispenser_flags & GD_NOGREED) && !emagged)
		gear_distributed_to["[type]"] |= user.ckey
	if((dispenser_flags & GD_UNIQUE) && !emagged)
		unique_dispense_list |= user.ckey

	animate_dispensing() // Blocks here until animation is done

	var/turf/T = get_turf(src)
	if(!(S && T)) // in case we got destroyed while we slept
		return 1
	
	S.spawn_gear(T, user)

	if(emagged)
		emagged = FALSE
	if(greet && user && !user.stat) // in case we got destroyed while we slept
		to_chat(user,"<span class='notice'>[S.name] dispensing processed. Have a good day.</span>")

/obj/machinery/gear_dispenser/proc/animate_dispensing()
	flick("[icon_state]-scan",src)
	visible_message("\The [src] scans its user.", runemessage = "hums")
	sleep(30)
	flick("[icon_state]-dispense",src)
	dispenser_flags |= GD_BUSY
	sleep(15)
	dispenser_flags &= ~GD_BUSY

/obj/machinery/gear_dispenser/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(!emagged)
		emagged = TRUE
		visible_message("<span class='warning'>\The [user] slides a weird looking ID into \the [src]!</span>","<span class='warning'>You temporarily short the safety mechanisms.</span>")
		return 1


// Just a different sprite
/obj/machinery/gear_dispenser/suit
	name = "suit dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch all kinds of space suits."
	icon_state = "suitdispenser2"

/obj/machinery/gear_dispenser/suit_old
	name = "suit dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch all kinds of space suits. An older model."
	icon_state = "suitdispenser"

/obj/machinery/gear_dispenser/suit_fancy
	name = "suit dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch all kinds of space suits. A newer model."
	icon_state = "suit_storage_map"
	var/obj/effect/overlay/vis/door
	var/datum/gear_disp/held_gear_disp
	var/special_frame

/obj/machinery/gear_dispenser/suit_fancy/Initialize(mapload)
	. = ..()
	door = add_vis_overlay("closed", layer = 4, unique = TRUE)
	icon_state = "suit_storage"
	if(special_frame)
		add_overlay(special_frame)

/obj/machinery/gear_dispenser/suit_fancy/Destroy()
	qdel_null(door)
	held_gear_disp = null
	return ..()

/obj/machinery/gear_dispenser/suit_fancy/power_change()
	. = ..()
	update_icon()

/obj/machinery/gear_dispenser/suit_fancy/update_icon()
	cut_overlays()
	
	if(special_frame)
		add_overlay(special_frame)
	
	if(needs_power && inoperable())
		add_overlay("nopower")
	else
		add_overlay("light1")
	
	if(held_gear_disp)
		add_overlay("fullsuit")
		if(operable())
			add_overlay("light2")

/obj/machinery/gear_dispenser/suit_fancy/attack_hand(var/mob/living/carbon/human/user)
	if(held_gear_disp)
		var/turf/T = get_turf(user)
		var/list/spawned = held_gear_disp.spawn_gear(T, user)
		for(var/obj/item/I in spawned)
			user.put_in_hands(I)
		to_chat(user, "<span class='notice'>You remove the equipment from [src].</span>")
		held_gear_disp = null
		animate_close()
		return
	return ..()

/obj/machinery/gear_dispenser/suit_fancy/dispense(var/datum/gear_disp/S,var/mob/living/carbon/human/user,var/greet=TRUE)
	if(!S.amount && !(dispenser_flags & GD_UNLIMITED))
		to_chat(user,"<span class='warning'>There are no more [S.name]s left!</span>")
		dispenser_flags &= ~GD_BUSY
		return 1
	else if(!(dispenser_flags & GD_UNLIMITED))
		S.amount--
	if((dispenser_flags & GD_NOGREED) && !emagged)
		gear_distributed_to["[type]"] |= user.ckey
	if((dispenser_flags & GD_UNIQUE) && !emagged)
		unique_dispense_list |= user.ckey

	held_gear_disp = S

	animate_dispensing()
	dispenser_flags &= ~GD_BUSY

	if(emagged)
		emagged = FALSE
	if(greet && user && !user.stat) // in case we got destroyed while we slept
		to_chat(user,"<span class='notice'>[S.name] dispensing processed. Have a good day.</span>")

/obj/machinery/gear_dispenser/suit_fancy/animate_dispensing()
	add_overlay("working")
	sleep(5 SECONDS)
	add_overlay("fullsuit")
	door.icon_state = "open"
	flick("anim_open", door)
	sleep(10.5)
	add_overlay("light2")
	cut_overlay("working")

/obj/machinery/gear_dispenser/suit_fancy/proc/animate_close()
	cut_overlay("fullsuit")
	cut_overlay("light2")
	door.icon_state = "closed"
	flick("anim_close", door)

// For fluff/custom items
/obj/machinery/gear_dispenser/custom
	name = "personal gear dispenser"

/obj/machinery/gear_dispenser/custom/Initialize()
	dispenses = subtypesof(/datum/gear_disp/custom)
	. = ..()


////////////////////////////// ERT SUIT DISPENSERS ///////////////////////////
// Non-sealed armor
/datum/gear_disp/ert/security_armor
	name = "Security (Armor)"
	to_spawn = list(/obj/item/clothing/suit/armor/vest/ert/security,/obj/item/clothing/head/helmet/ert/security)

/datum/gear_disp/ert/medical_armor
	name = "Medical (Armor)"
	to_spawn = list(/obj/item/clothing/suit/armor/vest/ert/medical,/obj/item/clothing/head/helmet/ert/medical)

/datum/gear_disp/ert/engineer_armor
	name = "Engineering (Armor)"
	to_spawn = list(/obj/item/clothing/suit/armor/vest/ert/engineer,/obj/item/clothing/head/helmet/ert/engineer)
/*
/datum/gear_disp/ert/commander_armor
	name = "Commander (Armor)"
	to_spawn = list(/obj/item/clothing/suit/armor/vest/ert/command,/obj/item/clothing/head/helmet/ert/command)
	amount = 1
*/
// Voidsuit versions
/datum/gear_disp/voidsuit/ert/security_void
	name = "Security (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/responseteam/security
	refit = TRUE
	magboots_type = /obj/item/clothing/shoes/magboots/adv

/datum/gear_disp/voidsuit/ert/medical_void
	name = "Medical (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/responseteam/medical
	refit = TRUE
	magboots_type = /obj/item/clothing/shoes/magboots/adv

/datum/gear_disp/voidsuit/ert/engineer_void
	name = "Engineering (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/responseteam/engineer
	refit = TRUE
	magboots_type = /obj/item/clothing/shoes/magboots/adv
/*
/datum/gear_disp/ert/commander_void
	name = "Commander (Voidsuit)"
	to_spawn = list(/obj/item/clothing/suit/space/void/responseteam/command)
	refit = TRUE
	amount = 1
*/
// Hardsuit versions
/datum/gear_disp/ert/security_rig
	name = "Security (Hardsuit)"
	to_spawn = list(/obj/item/weapon/rig/ert/security)

/datum/gear_disp/ert/medical_rig
	name = "Medical (Hardsuit)"
	to_spawn = list(/obj/item/weapon/rig/ert/medical)

/datum/gear_disp/ert/engineer_rig
	name = "Engineering (Hardsuit)"
	to_spawn = list(/obj/item/weapon/rig/ert/engineer)
/*
/datum/gear_disp/ert/commander_rig
	name = "Commander (Hardsuit)"
	to_spawn = list(/obj/item/weapon/rig/ert)
	amount = 1
*/


/obj/machinery/gear_dispenser/suit/ert
	name = "ERT Suit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch all kinds of space suits. This one distribributes Emergency Responder space suits."
	icon_state = "suitdispenserERT"
	dispenses = list(
		/datum/gear_disp/ert/security_armor,
		/datum/gear_disp/ert/medical_armor,
		/datum/gear_disp/ert/engineer_armor,
		/datum/gear_disp/voidsuit/ert/security_void,
		/datum/gear_disp/voidsuit/ert/medical_void,
		/datum/gear_disp/voidsuit/ert/engineer_void,
		/datum/gear_disp/ert/security_rig,
		/datum/gear_disp/ert/medical_rig,
		/datum/gear_disp/ert/engineer_rig,
	)
	req_one_access = list(access_cent_specops)


////////////////////////////// STATION SUIT DISPENSERS ///////////////////////////
/datum/gear_disp/station/standard
	name = "Standard (Softsuit)"
	to_spawn = list(/obj/item/clothing/head/helmet/space, /obj/item/clothing/suit/space)

/datum/gear_disp/voidsuit/station/security
	name = "Security (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/security
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/security
	refit = TRUE
	req_one_access = list(access_brig)

/datum/gear_disp/voidsuit/station/engineering
	name = "Engineering (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/engineering
	refit = TRUE
	magboots_type = /obj/item/clothing/shoes/magboots
	req_one_access = list(access_engine)

/datum/gear_disp/voidsuit/station/medical
	name = "Medical (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/medical
	refit = TRUE
	req_one_access = list(access_medical)

/datum/gear_disp/voidsuit/station/atmos
	name = "Atmos Technician (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/atmos
	refit = TRUE
	req_one_access = list(access_atmospherics)

/datum/gear_disp/voidsuit/station/paramedic
	name = "Paramedic (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical/emt
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/medical/emt
	refit = TRUE
	req_one_access = list(access_medical) // we don't have separate paramedic access

/datum/gear_disp/voidsuit/station/mining
	name = "Mining (Voidsuit)"
	voidsuit_type = /obj/item/clothing/suit/space/void/mining
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/mining
	refit = TRUE
	req_one_access = list(access_mining)

/obj/machinery/gear_dispenser/suit/station
	name = "Station Suit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch all kinds of space suits. This one is specialised towards station workers."
	dispenses = list(
		/datum/gear_disp/station/standard,
		/datum/gear_disp/voidsuit/station/security,
		/datum/gear_disp/voidsuit/station/engineering,
		/datum/gear_disp/voidsuit/station/medical,
		/datum/gear_disp/voidsuit/station/atmos,
		/datum/gear_disp/voidsuit/station/paramedic
	)

////////////////////////////// SOFT SUIT DISPENSERS ///////////////////////////
/obj/machinery/gear_dispenser/suit/standard
	name = "Soft Suit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch a specific mass produced suit."
	dispenser_flags = GD_ONEITEM|GD_NOGREED|GD_UNLIMITED
	one_setting = /datum/gear_disp/station/standard

////////////////////////////// AUTOLOK SUIT DISPENSERS ///////////////////////////
/datum/gear_disp/voidsuit/autolok
	name = "AutoLok Voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/autolok
	refit = FALSE // it autofits

/obj/machinery/gear_dispenser/suit/autolok
	name = "AutoLok Suit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch a specific AutoLok mass produced suit."
	icon_state = "suitdispenserAL"
	dispenser_flags = GD_ONEITEM|GD_NOGREED|GD_UNLIMITED
	one_setting = /datum/gear_disp/voidsuit/autolok

/obj/machinery/gear_dispenser/suit_fancy/autolok
	name = "AutoLok Suit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch a specific AutoLok mass produced suit."
	dispenser_flags = GD_ONEITEM|GD_NOGREED|GD_UNLIMITED
	one_setting = /datum/gear_disp/voidsuit/autolok
	special_frame = "frame_grey"

////////////////////////////// MOEBIUS SUIT DISPENSERS ///////////////////////////
/datum/gear_disp/voidsuit/aether
	name = "Aether Voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/aether
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/aether

/obj/machinery/gear_dispenser/suit/aether
	name = "\improper Aether Voidsuit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch a specific Aether-produced high-end suit."
	icon_state = "suitdispenserMB"
	dispenser_flags = GD_ONEITEM|GD_NOGREED|GD_UNLIMITED
	one_setting = /datum/gear_disp/voidsuit/aether

/obj/machinery/gear_dispenser/suit_fancy/aether
	name = "\improper Aether Voidsuit Dispenser"
	desc = "A commercial U-Tak-It Dispenser unit designed to fetch a specific Aether-produced high-end suit."
	dispenser_flags = GD_ONEITEM|GD_NOGREED|GD_UNLIMITED
	one_setting = /datum/gear_disp/voidsuit/aether
	special_frame = "frame_purple"

////////////////////////////// COMMONWEALTH SUIT DISPENSERS ///////////////////////////
/datum/gear_disp/voidsuit/com_mining
	name = "Commonwealth mining voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/mining/alt2
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/mining/alt2

/datum/gear_disp/voidsuit/com_riot
	name = "Commonwealth crowd control voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/security/riot/alt
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/security/riot/alt

/datum/gear_disp/voidsuit/com_pilot
	name = "Commonwealth pilot voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/pilot/alt2
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/pilot/alt2

/datum/gear_disp/voidsuit/com_medical
	name = "Commonwealth medical voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical/alt2
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/medical/alt2

/datum/gear_disp/voidsuit/com_explorer
	name = "Commonwealth explorer voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/exploration/alt2
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/exploration/alt2

/datum/gear_disp/voidsuit/com_engineering
	name = "Commonwealth engineering voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering/alt2
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/engineering/alt2

/datum/gear_disp/voidsuit/com_atmos
	name = "Commonwealth atmos voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos/alt2
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/atmos/alt2

/datum/gear_disp/voidsuit/com_command
	name = "Commonwealth command voidsuit"
	voidsuit_type = /obj/item/clothing/suit/space/void/captain/alt
	voidhelmet_type = /obj/item/clothing/head/helmet/space/void/captain/alt

/obj/machinery/gear_dispenser/suit/commonwealth
	name = "\improper Commonwealth Voidsuit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch surplus Commonwealth voidsuits."
	icon_state = "suitdispenserMB"
	dispenser_flags = GD_NOGREED|GD_UNLIMITED
	dispenses = list(
		/datum/gear_disp/voidsuit/com_mining,
		/datum/gear_disp/voidsuit/com_riot,
		/datum/gear_disp/voidsuit/com_pilot,
		/datum/gear_disp/voidsuit/com_medical,
		/datum/gear_disp/voidsuit/com_explorer,
		/datum/gear_disp/voidsuit/com_engineering,
		/datum/gear_disp/voidsuit/com_atmos,
		/datum/gear_disp/voidsuit/com_command
	)

/obj/machinery/gear_dispenser/suit_fancy/commonwealth
	name = "\improper Commonwealth Voidsuit Dispenser"
	desc = "A commercial U-Tak-It Dispenser unit designed to fetch surplus Commonwealth voidsuits."
	dispenser_flags = GD_NOGREED|GD_UNLIMITED
	one_setting = /datum/gear_disp/voidsuit/aether
	special_frame = "frame_red"
	dispenses = list(
		/datum/gear_disp/voidsuit/com_mining,
		/datum/gear_disp/voidsuit/com_riot,
		/datum/gear_disp/voidsuit/com_pilot,
		/datum/gear_disp/voidsuit/com_medical,
		/datum/gear_disp/voidsuit/com_explorer,
		/datum/gear_disp/voidsuit/com_engineering,
		/datum/gear_disp/voidsuit/com_atmos,
		/datum/gear_disp/voidsuit/com_command
	)

// Adminbuse
/obj/machinery/gear_dispenser/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION("admin_add", "Add New Gear")

/obj/machinery/gear_dispenser/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION("admin_add")
		admin_add()
		href_list["datumrefresh"] = "\ref[src]"

/obj/machinery/gear_dispenser/proc/admin_add()
	if(!check_rights(R_DEBUG|R_FUN))
		return

	var/example = @{"[
	{
		"menuoption": "Cool suit one",
		"gearlist": ["/obj/item/clothing/suit/space", "/obj/item/clothing/head/helmet/space"],
		"req_one_access": [5,63]
	},
	{
		"menuoption": "Selection two",
		"gearlist": ["/obj/random/trash"]
	}
]"}
	
	/**
	 * Needs to be valid json with keys of:
	 * "menuoption" = string for the name
	 * "gearlist" = array of types (yes the types are not valid json, byond parses them into real types.)
	 * "req_one_access" = array of numbers (accesses)
	 */
	var/input = input(usr, "Paste new gear pack JSON below. See example/code comments.", "Admin-load Dispenser", example) as null|message
	if(!input)
		return
	
	var/list/parsed = json_decode(input)
	
	if(!islist(parsed))
		return
	
	var/list/running = list()
	for(var/entry in parsed)
		if(!islist(entry))
			continue
		var/list/this_entry = entry
		var/option_name = this_entry["menuoption"]
		var/list/types = this_entry["gearlist"]
		var/list/access = this_entry["req_one_access"]
	
		if(!option_name || !islist(types))
			continue

		for(var/t in types)
			if(ispath(t))
				continue
			types -= t
			var/tnew = text2path(t)
			if(ispath(tnew))
				types += tnew
	
		var/datum/gear_disp/G = new()
	
		G.name = option_name
		G.to_spawn = types
	
		if(LAZYLEN(access))
			G.req_one_access = access
		
		running[option_name] = G
	to_chat(usr, "[src] added [running.len] entries")
	dispenses = running

////////////////////////////// RANDOM SUIT AND WEAPON DISPENSERS ///////////////////////////

/obj/machinery/gear_dispenser/randomvoidsuit
	name = "Suit Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch voidsuits."
	icon_state = "suitdispenserAL"
	dispenser_flags = GD_ONEITEM|GD_NOGREED
	one_setting = /datum/gear_disp/voidsuit/random

/datum/gear_disp/voidsuit/random
	name = "Voidsuit"
	to_spawn = list()
	amount = 4

/datum/gear_disp/voidsuit/random/spawn_gear(var/turf/T, var/mob/living/carbon/user)
	// I copied these from the /obj/random/multiple/voidsuit, but added the "suit" and "helmet"
	var/list/choice = pick(
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void,
			"helmet" = /obj/item/clothing/head/helmet/space/void
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/atmos,
			"helmet" = /obj/item/clothing/head/helmet/space/void/atmos
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/atmos/alt,
			"helmet" = /obj/item/clothing/head/helmet/space/void/atmos/alt
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/engineering,
			"helmet" = /obj/item/clothing/head/helmet/space/void/engineering
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/engineering/alt,
			"helmet" = /obj/item/clothing/head/helmet/space/void/engineering/alt
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/engineering/hazmat,
			"helmet" = /obj/item/clothing/head/helmet/space/void/engineering/hazmat
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/engineering/construction,
			"helmet" = /obj/item/clothing/head/helmet/space/void/engineering/construction
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/engineering/salvage,
			"helmet" = /obj/item/clothing/head/helmet/space/void/engineering/salvage
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/medical,
			"helmet" = /obj/item/clothing/head/helmet/space/void/medical
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/medical/alt,
			"helmet" = /obj/item/clothing/head/helmet/space/void/medical/alt
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/medical/bio,
			"helmet" = /obj/item/clothing/head/helmet/space/void/medical/bio
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/medical/emt,
			"helmet" = /obj/item/clothing/head/helmet/space/void/medical/emt
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/merc,
			"helmet" = /obj/item/clothing/head/helmet/space/void/merc
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/merc/fire,
			"helmet" = /obj/item/clothing/head/helmet/space/void/merc/fire
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/mining,
			"helmet" = /obj/item/clothing/head/helmet/space/void/mining
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/mining/alt,
			"helmet" = /obj/item/clothing/head/helmet/space/void/mining/alt
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/security,
			"helmet" = /obj/item/clothing/head/helmet/space/void/security
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/security/alt,
			"helmet" = /obj/item/clothing/head/helmet/space/void/security/alt
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/security/riot,
			"helmet" = /obj/item/clothing/head/helmet/space/void/security/riot
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/exploration,
			"helmet" = /obj/item/clothing/head/helmet/space/void/exploration
		),
		prob(5);list(
			"suit" = /obj/item/clothing/suit/space/void/pilot,
			"helmet" = /obj/item/clothing/head/helmet/space/void/pilot
		))
	voidsuit_type = choice["suit"]
	voidhelmet_type = choice["helmet"]
	return ..()

/obj/machinery/gear_dispenser/randomweapons
	name = "Weapon Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch weapons."
	dispenser_flags = GD_ONEITEM|GD_NOGREED
	one_setting = /datum/gear_disp/randomweapons

/datum/gear_disp/randomweapons
	name = "Weapon"
	amount = 2

/datum/gear_disp/randomweapons/spawn_gear(var/turf/T, var/mob/living/carbon/user)
	var/choice = pick(
					prob(3);/obj/random/multiple/gun/projectile/handgun,
					prob(2);/obj/random/multiple/gun/projectile/smg,
					prob(2);/obj/random/multiple/gun/projectile/shotgun,
					prob(1);/obj/random/multiple/gun/projectile/rifle)
	to_spawn = list(choice)
	return ..()

///////////////////Adventure Box//////////////////////////

/obj/machinery/gear_dispenser/adventure_box
	name = "Dispenser"
	desc = "An industrial U-Tak-It Dispenser unit designed to fetch items that one might need in dangerous scenarios!"
	dispenser_flags = GD_UNIQUE
	dispenses = list(
		/datum/gear_disp/adventure_box/awayloot,
		/datum/gear_disp/adventure_box/food,
		/datum/gear_disp/adventure_box/medical,
		/datum/gear_disp/adventure_box/tools,
		/datum/gear_disp/adventure_box/armor,
		/datum/gear_disp/adventure_box/light
		)
	var/chance_to_delete = 0

/obj/machinery/gear_dispenser/adventure_box/Initialize()
	. = ..()
	if(prob(chance_to_delete))
		return INITIALIZE_HINT_QDEL

/datum/gear_disp/adventure_box/medical
	name = "Medkit"
	to_spawn = list(/obj/random/firstaid)
	amount = 2

/datum/gear_disp/adventure_box/awayloot
	name = "Curious Item"
	to_spawn = list(/obj/random/awayloot/nofail)
	amount = 5

/datum/gear_disp/adventure_box/food
	name = "Food Plate"
	to_spawn = list(
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar,
					/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
					/obj/item/weapon/reagent_containers/food/drinks/tea
					)
	amount = 10

/datum/gear_disp/adventure_box/tools
	name = "Tools"
	to_spawn = list(
					/obj/random/tool,
					/obj/random/tool,
					/obj/random/tool,
					/obj/item/weapon/storage/belt/utility
					)
	amount = 5

/datum/gear_disp/adventure_box/armor
	name = "Armor"
	to_spawn = list(
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/head/helmet/bulletproof,
					/obj/item/clothing/shoes/boots/jackboots
					)
	amount = 1

/datum/gear_disp/adventure_box/light
	name = "Flashlight"
	to_spawn = list(/obj/item/device/flashlight/maglight)
	amount = 2

/datum/gear_disp/adventure_box/weapon
	name = "Ranged Weapon"
	amount = 1
//from /obj/random/projectile/random
/datum/gear_disp/adventure_box/weapon/spawn_gear(var/turf/T, var/mob/living/carbon/user)
	var/choice = pick(
					prob(3);/obj/random/multiple/gun/projectile/handgun,
					prob(2);/obj/random/multiple/gun/projectile/smg,
					prob(2);/obj/random/multiple/gun/projectile/shotgun,
					prob(1);/obj/random/multiple/gun/projectile/rifle)
	to_spawn = list(choice)
	return ..()


/obj/machinery/gear_dispenser/adventure_box/weapon
	dispenses = list(
		/datum/gear_disp/adventure_box/awayloot,
		/datum/gear_disp/adventure_box/food,
		/datum/gear_disp/adventure_box/medical,
		/datum/gear_disp/adventure_box/tools,
		/datum/gear_disp/adventure_box/armor,
		/datum/gear_disp/adventure_box/light,
		/datum/gear_disp/adventure_box/weapon
		)