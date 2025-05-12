/*
Ideas for the subtle effects of hallucination:

Light up oxygen/phoron indicators (done)
Cause health to look critical/dead, even when standing (done)
Characters silently watching you
Brief flashes of fire/space/bombs/c4/dangerous shit (done)
Items that are rare/traitorous/don't exist appearing in your inventory slots (done)
Strange audio (should be rare) (done)
Gunshots/explosions/opening doors/less rare audio (done)
*/

/datum/component/hallucinations
	dupe_mode = COMPONENT_DUPE_UNIQUE // First come first serve

	VAR_PRIVATE/mob/living/carbon/human/our_human = null
	VAR_PRIVATE/datum/weakref/halimage
	VAR_PRIVATE/datum/weakref/halbody
	VAR_PRIVATE/list/halitem = list() // weakref pair of obj-key, client-value

	VAR_PRIVATE/hal_crit = FALSE
	VAR_PRIVATE/hal_screwyhud = HUD_HALLUCINATION_NONE

/datum/component/hallucinations/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	our_human = parent
	make_timer()

/datum/component/hallucinations/Destroy(force)
	if(halitem.len)
		remove_hallucination_item()
	our_human = null
	. = ..()

/datum/component/hallucinations/proc/make_timer()
	PROTECTED_PROC(TRUE)
	addtimer(CALLBACK(src, PROC_REF(trigger)), ((rand(20,50) SECONDS) / (min(our_human.hallucination,100)/25)), TIMER_DELETE_ME)

/datum/component/hallucinations/proc/get_fakecrit()
	SHOULD_NOT_OVERRIDE(TRUE)
	return hal_crit

/datum/component/hallucinations/proc/get_hud_state()
	SHOULD_NOT_OVERRIDE(TRUE)
	return hal_screwyhud

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Traditional hallucinations
/////////////////////////////////////////////////////////////////////////////////////////////////////
/mob/living/carbon/proc/handle_hallucinations()
	if(get_hallucination_component() || !client)
		return
	LoadComponent(/datum/component/hallucinations)

/mob/living/carbon/proc/get_hallucination_component()
	RETURN_TYPE(/datum/component/hallucinations)
	return GetComponent(/datum/component/hallucinations)

/datum/component/hallucinations/proc/trigger()
	PROTECTED_PROC(TRUE)
	if(QDELETED(our_human))
		qdel(src)
		return
	if(!our_human.client)
		qdel(src)
		return
	if(our_human.hallucination < HALLUCINATION_THRESHOLD)
		qdel(src)
		return
	handle_hallucinating()
	make_timer()

/datum/component/hallucinations/proc/handle_hallucinating()
	PROTECTED_PROC(TRUE)
	var/halpick = rand(1,100)
	switch(halpick)
		if(0 to 15)
			event_hudscrew()
		if(16 to 25)
			event_fake_item()
		if(26 to 40)
			event_flash_environmental_threats()
		if(41 to 65)
			event_strange_sound()
		if(66 to 70)
			if(prob(20) && our_human.nutrition < 100)
				event_hunger() // Hungi, meant for xenochi but this is too funny to pass up
			else
				event_flash_monsters()
		if(71 to 72)
			event_sleeping()
		if(73 to 75) // If you don't want hallucination beatdowns, comment this out
			event_attacker()
		if(76 to 80)
			event_painmessage()

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Xenochimera hallucinations
// Unlike normal hallucinations this one is triggered from handle_feral randomly.
// So it destroys itself after it triggers, freeing up space for the next run of it.
/////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/hallucinations/xenochimera/make_timer()
	var/datum/component/xenochimera/XC = our_human.GetComponent(/datum/component/xenochimera)
	var/F = XC ? (XC.feral / 10) : 1
	addtimer(CALLBACK(src, PROC_REF(trigger)), ((rand(20,50) SECONDS) / F), TIMER_DELETE_ME)

/datum/component/hallucinations/xenochimera/trigger()
	if(QDELETED(our_human))
		qdel(src)
		return
	if(!our_human.client)
		qdel(src)
		return
	var/datum/component/xenochimera/XC = our_human.GetComponent(/datum/component/xenochimera)
	if(!XC || XC.feral < XENOCHIFERAL_THRESHOLD)
		qdel(src)
		return
	handle_hallucinating()
	QDEL_IN(src,rand(3,9)SECONDS)

/datum/component/hallucinations/xenochimera/handle_hallucinating()
	var/halpick = rand(1,100)
	switch(halpick)
		if(0 to 15) //15% chance
			//Screwy HUD
			event_hudscrew()
		if(16 to 25) //10% chance
			event_fake_item()
		if(26 to 35) //10% chance
			event_flash_environmental_threats()
		if(36 to 55) //20% chance
			event_strange_sound()
		if(56 to 60) //5% chance
			event_flash_monsters()
		if(61 to 85) //25% chance
			event_hunger()
		if(86 to 100) //15% chance
			event_hear_voices()
