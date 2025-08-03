/datum/component/pollen_disability
	var/mob/living/carbon/human/owner
	var/allergy_chance = 35

/datum/component/pollen_disability/Initialize()
	if (!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	RegisterSignal(owner, COMSIG_HANDLE_DISABILITIES, PROC_REF(process_component))

/datum/component/pollen_disability/proc/process_component()
	SIGNAL_HANDLER

	if(QDELETED(parent))
		return
	if(!prob(allergy_chance))
		return
	if(!isturf(owner.loc))
		return
	if(owner.stat != CONSCIOUS)
		return
	if(owner.transforming)
		return

	// Check for masks or internals
	if(istype(owner.head,/obj/item/clothing/head/helmet/space) && owner.internal) // Hardsuits
		return
	if(owner.wear_mask) // masks block it entirely
		if(owner.wear_mask.item_flags & AIRTIGHT)
			if(owner.internal) // gas on
				return
		if(owner.wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT)
			return

	// Time to ENGAGE THE ALLERGY
	if(prob(5) && istype(owner.loc,/turf/simulated/floor/grass))
		trigger_allergy()
		return

	// Hand check
	var/things = list()
	if(prob(32))
		if(!isnull(owner.r_hand))
			things += owner.r_hand
		if(!isnull(owner.l_hand))
			things += owner.l_hand

	// terrain tests
	things += owner.loc.contents
	if(prob(25)) // ranged check
		things += orange(2,owner.loc)

	// scan irritants!
	if(things.len)
		if(/obj/structure/flora in things)
			trigger_allergy()
			return
		if(/obj/effect/plant/irritant in things)
			trigger_allergy()
			return
		if(/obj/item/toy/bouquet/irritant in things)
			trigger_allergy()
			return
		for(var/obj/machinery/portable_atmospherics/hydroponics/irritanttray in things)
			if(!irritanttray.dead && !isnull(irritanttray.seed))
				trigger_allergy()
				return

/datum/component/pollen_disability/proc/trigger_allergy()
	to_chat(src, span_danger("[pick("The air feels itchy!","Your face feels uncomfortable!","Your body tingles!")]"))
	owner.add_chemical_effect(CE_ALLERGEN, rand(5,20) * REM)

/datum/component/pollen_disability/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_HANDLE_DISABILITIES)
	owner = null
	. = ..()
