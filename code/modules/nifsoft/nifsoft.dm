//Please see the comment above the main NIF definition before
//trying to call any of these procs directly.

//A single piece of NIF software
/datum/nifsoft
	var/name = "Prototype"
	var/desc = "Contact a dev!"

	var/obj/item/device/nif/nif	//The NIF that the software is stored in

	var/list_pos				// List position in the nifsoft list

	var/cost = 1000				// Cost in cash of buying this software from a terminal

	var/vended = TRUE			// This is available in NIFSoft Shops at the start of the game
	var/wear = 1				// The wear (+/- 10% when applied) that this causes to the NIF
	var/access					// What access they need to buy it, can only set one for ~reasons~
	var/illegal = FALSE			// If this is a black-market nifsoft (emag option)

	var/active = FALSE			// Whether the active mode of this implant is on
	var/p_drain = 0				// Passive power drain, can be used in various ways from the software
	var/a_drain = 0				// Active power drain, same purpose as above, software can treat however
	var/activates = TRUE		// Whether or not this has an active power consumption mode
	var/tick_flags = 0			// Flags to tell when we'd like to be ticked

	var/empable = TRUE			// If the implant can be destroyed via EMP attack

	var/expiring = FALSE		// Trial software! Or self-deleting illegal ones!
	var/expires_at				// World.time for when they expire

	var/applies_to = (NIF_ORGANIC|NIF_SYNTHETIC) // Who this software is useful for

	var/vision_flags = 0	// Various flags for fast lookups that are settable on the NIF
	var/health_flags = 0	// These are added as soon as the implant is activated
	var/combat_flags = 0	// Otherwise use set_flag/clear_flag in one of your own procs for tricks
	var/other_flags = 0

	var/vision_flags_mob = 0
	var/darkness_view = 0

	var/can_uninstall = TRUE

	var/list/planes_enabled = null	// List of vision planes this nifsoft enables when active

	var/vision_exclusive = FALSE	//Whether or not this NIFSoft provides exclusive vision modifier

	var/list/incompatible_with = null // List of NIFSofts that are disabled when this one is enabled

//Constructor accepts the NIF it's being loaded into
/datum/nifsoft/New(var/obj/item/device/nif/nif_load)
	ASSERT(nif_load)

	nif = nif_load
	if(!install(nif))
		qdel(src)

//Destructor cleans up the software and nif reference
/datum/nifsoft/Destroy()
	if(nif)
		uninstall()
		nif = null
	return ..()

//Called when the software is installed in the NIF
/datum/nifsoft/proc/install()
	if(!nif)
		return
	return nif.install(src)

//Called when the software is removed from the NIF
/datum/nifsoft/proc/uninstall()
	if(!can_uninstall)
		return nif.uninstall(src)
	if(nif)
		if(active)
			deactivate()
		. = nif.uninstall(src)
		nif = null
	if(!QDESTROYING(src))
		qdel(src)

//Called every life() tick on a mob on active implants
/datum/nifsoft/proc/life(var/mob/living/carbon/human/human)
	return TRUE

//Called when attempting to activate an implant (could be a 'pulse' activation or toggling it on)
/datum/nifsoft/proc/activate(var/force = FALSE)
	if(active && !force)
		return
	var/nif_result = nif.activate(src)

	//If the NIF was fine with it, or we're forcing it
	if(nif_result || force)
		active = TRUE

		//If we enable vision planes
		if(planes_enabled)
			nif.add_plane(planes_enabled)
			nif.vis_update()

		//If we have other NIFsoft we need to turn off
		if(incompatible_with)
			nif.deactivate_these(incompatible_with)

		//Set all our activation flags
		nif.set_flag(vision_flags,NIF_FLAGS_VISION)
		nif.set_flag(health_flags,NIF_FLAGS_HEALTH)
		nif.set_flag(combat_flags,NIF_FLAGS_COMBAT)
		nif.set_flag(other_flags,NIF_FLAGS_OTHER)

		if(vision_exclusive)
			var/mob/living/carbon/human/H = nif.human
			if(H && istype(H))
				H.recalculate_vis()

	return nif_result

//Called when attempting to deactivate an implant
/datum/nifsoft/proc/deactivate(var/force = FALSE)
	if(!active && !force)
		return
	var/nif_result = nif.deactivate(src)

	//If the NIF was fine with it or we're forcing it
	if(nif_result || force)
		active = FALSE

		//If we enable vision planes, disable them
		if(planes_enabled)
			nif.del_plane(planes_enabled)
			nif.vis_update()

		//Clear all our activation flags
		nif.clear_flag(vision_flags,NIF_FLAGS_VISION)
		nif.clear_flag(health_flags,NIF_FLAGS_HEALTH)
		nif.clear_flag(combat_flags,NIF_FLAGS_COMBAT)
		nif.clear_flag(other_flags,NIF_FLAGS_OTHER)

		if(vision_exclusive)
			var/mob/living/carbon/human/H = nif.human
			if(H && istype(H))
				H.recalculate_vis()

	return nif_result

//Called when an implant expires
/datum/nifsoft/proc/expire()
	uninstall()
	return

//Called when installed from a disk
/datum/nifsoft/proc/disk_install(var/mob/living/carbon/human/target,var/mob/living/carbon/human/user)
	return TRUE

//Status text for menu
/datum/nifsoft/proc/stat_text()
	if(activates)
		return "[active ? "Active" : "Disabled"]"

	return "Always On"

//////////////////////
//A package of NIF software
/datum/nifsoft/package
	var/list/software = list()
	wear = 0 //Packages don't cause wear themselves, the software does

//Constructor accepts a NIF and loads all the software
/datum/nifsoft/package/New(var/obj/item/device/nif/nif_load)
	ASSERT(nif_load)

	for(var/P in software)
		new P(nif_load)

	qdel(src)

//Clean self up
/datum/nifsoft/package/Destroy()
	software.Cut()
	software = null
	return ..()

/////////////////
// A NIFSoft Uploader
/obj/item/weapon/disk/nifsoft
	name = "NIFSoft Uploader"
	desc = "It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""
	icon = 'icons/obj/nanomods.dmi'
	icon_state = "medical"
	item_state = "nanomod"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
		)
	w_class = ITEMSIZE_SMALL
	var/datum/nifsoft/stored_organic = null
	var/datum/nifsoft/stored_synthetic = null

/obj/item/weapon/disk/nifsoft/afterattack(var/A, mob/user, flag, params)
	if(!in_range(user, A))
		return

	if(!ishuman(user) || !ishuman(A))
		return

	var/mob/living/carbon/human/Ht = A
	var/mob/living/carbon/human/Hu = user

	if(!Ht.nif || Ht.nif.stat != NIF_WORKING)
		to_chat(user,"<span class='warning'>Either they don't have a NIF, or the uploader can't connect.</span>")
		return

	var/extra = extra_params()
	if(A == user)
		to_chat(user,"<span class='notice'>You upload [src] into your NIF.</span>")
	else
		Ht.visible_message("<span class='warning'>[Hu] begins uploading [src] into [Ht]!</span>","<span class='danger'>[Hu] is uploading [src] into you!</span>")

	icon_state = "[initial(icon_state)]-animate"	//makes it play the item animation upon using on a valid target
	update_icon()

	if(A == user && do_after(Hu,1 SECONDS,Ht))
		if(Ht.isSynthetic())
			new stored_synthetic(Ht.nif,extra)
			qdel(src)
		else
			new stored_organic(Ht.nif,extra)
			qdel(src)
	else if(A != user && do_after(Hu,10 SECONDS,Ht))
		if(Ht.isSynthetic())
			new stored_synthetic(Ht.nif,extra)
			qdel(src)
		else
			new stored_organic(Ht.nif,extra)
			qdel(src)
	else
		icon_state = "[initial(icon_state)]"	//If it fails to apply to a valid target and doesn't get deleted, reset its icon state
		update_icon()

//So disks can pass fancier stuff.
/obj/item/weapon/disk/nifsoft/proc/extra_params()
	return null


// Compliance Disk //
/obj/item/weapon/disk/nifsoft/compliance
	name = "NIFSoft Uploader (Compliance)"
	desc = "Wow, adding laws to people? That seems illegal. It probably is. Okay, it really is."
	icon_state = "compliance"
	item_state = "healthanalyzer"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
		)
	stored_organic = /datum/nifsoft/compliance
	stored_synthetic = /datum/nifsoft/compliance
	var/laws

/obj/item/weapon/disk/nifsoft/compliance/afterattack(var/A, mob/user, flag, params)
	if(!ishuman(A))
		return
	if(!laws)
		to_chat(user,"<span class='warning'>You haven't set any laws yet. Use the disk in-hand first.</span>")
		return
	..(A,user,flag,params)

/obj/item/weapon/disk/nifsoft/compliance/attack_self(mob/user)
	var/newlaws = tgui_input_text(user, "Please Input Laws", "Compliance Laws", laws, multiline = TRUE, prevent_enter = TRUE)
	newlaws = sanitize(newlaws,2048)
	if(newlaws)
		to_chat(user,"You set the laws to: <br><span class='notice'>[newlaws]</span>")
		laws = newlaws

/obj/item/weapon/disk/nifsoft/compliance/extra_params()
	return laws

// Security Disk //
/obj/item/weapon/disk/nifsoft/security
	name = "NIFSoft Uploader - Security"
	desc = "Contains free NIFSofts useful for security members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	icon_state = "security"
	stored_organic = /datum/nifsoft/package/security
	stored_synthetic = /datum/nifsoft/package/security

/datum/nifsoft/package/security
	software = list(/datum/nifsoft/ar_sec,/datum/nifsoft/flashprot)

/obj/item/weapon/storage/box/nifsofts_security
	name = "security nifsoft uploaders"
	desc = "A box of free nifsofts for security employees."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "nifsoft_kit_sec"

/obj/item/weapon/storage/box/nifsofts_security/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/security(src)

// Engineering Disk //
/obj/item/weapon/disk/nifsoft/engineering
	name = "NIFSoft Uploader - Engineering"
	desc = "Contains free NIFSofts useful for engineering members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	icon_state = "engineering"
	stored_organic = /datum/nifsoft/package/engineering
	stored_synthetic = /datum/nifsoft/package/engineering

/datum/nifsoft/package/engineering
	software = list(/datum/nifsoft/ar_eng,/datum/nifsoft/alarmmonitor,/datum/nifsoft/uvblocker)

/obj/item/weapon/storage/box/nifsofts_engineering
	name = "engineering nifsoft uploaders"
	desc = "A box of free nifsofts for engineering employees."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "nifsoft_kit_eng"

/obj/item/weapon/storage/box/nifsofts_engineering/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/engineering(src)

// Medical Disk //
/obj/item/weapon/disk/nifsoft/medical
	name = "NIFSoft Uploader - Medical"
	desc = "Contains free NIFSofts useful for medical members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	stored_organic = /datum/nifsoft/package/medical
	stored_synthetic = /datum/nifsoft/package/medical

/datum/nifsoft/package/medical
	software = list(/datum/nifsoft/ar_med,/datum/nifsoft/crewmonitor)

/obj/item/weapon/storage/box/nifsofts_medical
	name = "medical nifsoft uploaders"
	desc = "A box of free nifsofts for medical employees."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "nifsoft_kit_med"

/obj/item/weapon/storage/box/nifsofts_medical/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/medical(src)

// Mining Disk //
/obj/item/weapon/disk/nifsoft/mining
	name = "NIFSoft Uploader - Mining"
	desc = "Contains free NIFSofts useful for mining members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	icon_state = "mining"
	stored_organic = /datum/nifsoft/package/mining
	stored_synthetic = /datum/nifsoft/package/mining_synth

/datum/nifsoft/package/mining
	software = list(/datum/nifsoft/material,/datum/nifsoft/spare_breath)

/datum/nifsoft/package/mining_synth
	software = list(/datum/nifsoft/material,/datum/nifsoft/pressure,/datum/nifsoft/heatsinks)

/obj/item/weapon/storage/box/nifsofts_mining
	name = "mining nifsoft uploaders"
	desc = "A box of free nifsofts for mining employees."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "nifsoft_kit_mining"

/obj/item/weapon/storage/box/nifsofts_mining/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/mining(src)
