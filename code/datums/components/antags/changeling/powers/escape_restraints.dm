/datum/power/changeling/escape_restraints
	name = "Escape Restraints"
	desc = "We evolve more complex joints"
	helptext = "We can instantly escape from most restraints and bindings, but we cannot do it often."
	enhancedtext = "More frequent escapes."
	ability_icon_state = "ling_escape_restraints"
	genomecost = 2
	verbpath = /mob/proc/changeling_escape_restraints

//Escape Cuffs. By design this does not escape from straight jackets
/mob/proc/changeling_escape_restraints()
	set category = "Changeling"
	set name = "Escape Restraints (40)"
	set desc = "Removes handcuffs and legcuffs instantly."

	var/escape_cooldown = 5 MINUTES		//This is used later to prevent spamming
	var/mob/living/carbon/human/C = src
	var/datum/component/antag/changeling/changeling = changeling_power(40,0,100,CONSCIOUS)
	if(!changeling)
		return FALSE
	if(changeling.is_on_cooldown(ESCAPE_RESTRAINTS))
		to_chat(src, span_notice("We are still recovering from our last escape. We will be able to escape again in [(changeling.get_cooldown(ESCAPE_RESTRAINTS) - world.time)/10] seconds."))
		return FALSE
	if(!(C.handcuffed || C.legcuffed || istype(C.wear_suit,/obj/item/clothing/suit/straight_jacket)))	// No need to waste chems if there's nothing to break out of
		to_chat(C, span_warning("We are are not restrained in a way we can escape..."))
		return FALSE

	changeling.chem_charges -= 40

	to_chat(C,span_notice("We contort our extremities and slip our cuffs."))
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	if(C.handcuffed)
		var/obj/item/W = C.handcuffed
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_handcuffed()
		if (C.client)
			C.client.screen -= W
		W.forceMove(C.loc)
		W.dropped(C)
		if(W)
			W.layer = initial(W.layer)
	if(C.legcuffed)
		var/obj/item/W = C.legcuffed
		C.legcuffed = null
		C.update_inv_legcuffed()
		if(C.client)
			C.client.screen -= W
		W.forceMove(C.loc)
		W.dropped(C)
		if(W)
			W.layer = initial(W.layer)
	if(istype(C.wear_suit, /obj/item/clothing/suit/straight_jacket))
		var/obj/item/clothing/suit/straight_jacket/SJ = C.wear_suit
		SJ.forceMove(C.loc)
		SJ.dropped(C)
		C.wear_suit = null
		escape_cooldown *= 1.5	// Straight jackets are tedious compared to cuffs.

	if(changeling.recursive_enhancement)
		escape_cooldown *= 0.5

	changeling.set_cooldown(ESCAPE_RESTRAINTS, escape_cooldown)
	addtimer(CALLBACK(src, PROC_REF(changeling_escape_restraints_ready)), escape_cooldown, TIMER_DELETE_ME)

	feedback_add_details("changeling_powers","ESR")
	return TRUE

/mob/proc/changeling_escape_restraints_ready()
	to_chat(src, span_notice("We are able to escape our restraints once more."))
