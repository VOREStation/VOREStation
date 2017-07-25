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
	var/health_flags = 0	// These are added as soon as the implant is installed
	var/combat_flags = 0	// Otherwise use set_flag on the nif in your activate/deactivate
	var/other_flags = 0

	var/obj/effect/nif_stat/stat_line


//Constructor accepts the NIF it's being loaded into
/datum/nifsoft/New(var/obj/item/device/nif/nif_load)
	ASSERT(nif_load)

	nif = nif_load
	stat_line = new(src)
	if(!install(nif))
		qdel(src)

//Destructor cleans up the software and nif reference
/datum/nifsoft/Destroy()
	if(nif)
		uninstall()
		nif = null
	qdel_null(stat_line)
	return ..()

//Called when the software is installed in the NIF
/datum/nifsoft/proc/install()
	return nif.install(src)

//Called when the software is removed from the NIF
/datum/nifsoft/proc/uninstall()
	if(active)
		deactivate()
	if(nif)
		. = nif.uninstall(src)
		nif = null
	if(!QDESTROYING(src))
		qdel(src)

//Called every life() tick on a mob on active implants
/datum/nifsoft/proc/life(var/mob/living/carbon/human/human)
	return TRUE

//Called when attempting to activate an implant (could be a 'pulse' activation or toggling it on)
/datum/nifsoft/proc/activate()
	if(active)
		return
	var/nif_result = nif.activate(src)
	if(nif_result)
		active = TRUE
	return nif_result

//Called when attempting to deactivate an implant
/datum/nifsoft/proc/deactivate()
	if(!active)
		return
	var/nif_result = nif.deactivate(src)
	if(nif_result)
		active = FALSE
	return nif_result

//Called when an implant expires
/datum/nifsoft/proc/expire()
	uninstall()
	return

//Called when installed from a disk
/datum/nifsoft/proc/disk_install(var/mob/living/carbon/human/target,var/mob/living/carbon/human/user)
	return TRUE

//Stat-line clickable text
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
// A NIFSoft Disk
/obj/item/weapon/disk/nifsoft
	name = "NIFSoft Disk"
	desc = "It has a small label: \n\
	\"Portable NIFSoft Disk. \n\
	Insert directly into brain.\""
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	var/datum/nifsoft/stored = null
	var/laws = ""

/obj/item/weapon/disk/nifsoft/afterattack(var/A, mob/user, flag, params)
	if(!in_range(user, A))
		return

	if(!ishuman(user) || !ishuman(A))
		return

	var/mob/living/carbon/human/Ht = A
	var/mob/living/carbon/human/Hu = user

	if(!Ht.nif || Ht.nif.stat != NIF_WORKING)
		to_chat(user,"<span class='warning'>Either they don't have a NIF, or the disk can't connect.</span>")
		return

	Ht.visible_message("<span class='warning'>[Hu] begins uploading new NIFSoft into [Ht]!</span>","<span class='danger'>[Hu] is uploading new NIFSoft into you!</span>")
	if(do_after(Hu,10 SECONDS,Ht))
		var/extra = extra_params()
		new stored(Ht.nif,extra)
		qdel(src)

//So disks can pass fancier stuff.
/obj/item/weapon/disk/nifsoft/proc/extra_params()
	return null


// Compliance Disk //
/obj/item/weapon/disk/nifsoft/compliance
	name = "NIFSoft Disk (Compliance)"
	desc = "Wow, adding laws to people? That seems illegal. It probably is. Okay, it really is."
	stored = /datum/nifsoft/compliance

/obj/item/weapon/disk/nifsoft/compliance/afterattack(var/A, mob/user, flag, params)
	if(!laws)
		to_chat(user,"<span class='warning'>You haven't set any laws yet. Use the disk in-hand first.</span>")
		return
	..(A,user,flag,params)

/obj/item/weapon/disk/nifsoft/compliance/attack_self(mob/user)
	var/newlaws = input(user,"Please Input Laws","Compliance Laws",laws) as message
	newlaws = sanitize(newlaws,2048)
	if(newlaws)
		to_chat(user,"You set the laws to: <br><span class='notice'>[newlaws]</span>")
		laws = newlaws

/obj/item/weapon/disk/nifsoft/compliance/extra_params()
	return laws

// Security Disk //
/obj/item/weapon/disk/nifsoft/security
	name = "NIFSoft Disk - Security"
	desc = "Contains free NIFSofts useful for security members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Disk. \n\
	Insert directly into brain.\""

	stored = /datum/nifsoft/package/security

/datum/nifsoft/package/security
	software = list(/datum/nifsoft/ar_sec,/datum/nifsoft/flashprot)

/obj/item/weapon/storage/box/nifsofts_security
	name = "security nifsoft disks"
	desc = "A box of free nifsofts for security employees."
	icon_state = "disk_kit"

/obj/item/weapon/storage/box/nifsofts_security/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/security(src)

// Engineering Disk //
/obj/item/weapon/disk/nifsoft/engineering
	name = "NIFSoft Disk - Engineering"
	desc = "Contains free NIFSofts useful for engineering members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Disk. \n\
	Insert directly into brain.\""

	stored = /datum/nifsoft/package/engineering

/datum/nifsoft/package/engineering
	software = list(/datum/nifsoft/ar_eng,/datum/nifsoft/uvblocker)

/obj/item/weapon/storage/box/nifsofts_engineering
	name = "engineering nifsoft disks"
	desc = "A box of free nifsofts for engineering employees."
	icon_state = "disk_kit"

/obj/item/weapon/storage/box/nifsofts_engineering/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/engineering(src)

// Medical Disk //
/obj/item/weapon/disk/nifsoft/medical
	name = "NIFSoft Disk - Medical"
	desc = "Contains free NIFSofts useful for medical members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Disk. \n\
	Insert directly into brain.\""

	stored = /datum/nifsoft/package/medical

/datum/nifsoft/package/medical
	software = list(/datum/nifsoft/ar_med,/datum/nifsoft/crewmonitor)

/obj/item/weapon/storage/box/nifsofts_medical
	name = "medical nifsoft disks"
	desc = "A box of free nifsofts for medical employees."
	icon_state = "disk_kit"

/obj/item/weapon/storage/box/nifsofts_medical/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/medical(src)

// Mining Disk //
/obj/item/weapon/disk/nifsoft/mining
	name = "NIFSoft Disk - Mining"
	desc = "Contains free NIFSofts useful for mining members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Disk. \n\
	Insert directly into brain.\""

	stored = /datum/nifsoft/package/mining

/datum/nifsoft/package/mining
	software = list(/datum/nifsoft/material,/datum/nifsoft/spare_breath)

/obj/item/weapon/storage/box/nifsofts_mining
	name = "mining nifsoft disks"
	desc = "A box of free nifsofts for mining employees."
	icon_state = "disk_kit"

/obj/item/weapon/storage/box/nifsofts_mining/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/mining(src)