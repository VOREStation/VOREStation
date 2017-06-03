//A single piece of NIF software
/datum/nifsoft
	var/name = "Prototype"
	var/desc = "Contact a dev!"

	var/obj/item/device/nif/nif	//The NIF that the software is stored in

	var/list_pos				// List position in the nifsoft list

	var/cost = 1000				// Cost in cash of buying this software from a terminal
	//TODO - While coding
	var/initial = TRUE			// This is available in NIFSoft Shops at the start of the game
	var/wear = 1				// The wear (+/- 10% when applied) that this causes to the NIF
	var/list/req_one_access		// What access they need to buy it
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
		uninstall(nif)
		nif = null
	qdel(stat_line)
	stat_line = null
	..()

//Called when the software is installed in the NIF
/datum/nifsoft/proc/install()
	return nif.install(src)

//Called when the software is removed from the NIF
/datum/nifsoft/proc/uninstall()
	if(active)
		deactivate()
	if(nif)
		. = nif.uninstall(src)
	qdel(src)

//Called every life() tick on a mob on active implants
/datum/nifsoft/proc/life(var/mob/living/carbon/human/human)
	return TRUE

//Called when attempting to activate an implant (could be a 'pulse' activation or toggling it on)
/datum/nifsoft/proc/activate()
	var/nif_result = nif.activate(src)
	if(nif_result)
		active = TRUE
	return nif_result

//Called when attempting to deactivate an implant
/datum/nifsoft/proc/deactivate()
	var/nif_result = nif.deactivate(src)
	if(nif_result)
		active = FALSE
	return nif_result

//Called when an implant expires
/datum/nifsoft/proc/expire()
	uninstall()
	return

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
	..()
