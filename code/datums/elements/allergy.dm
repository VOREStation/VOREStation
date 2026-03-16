// Element for handling allergic reactions. This is only added to humans with allergies actually set in their species datum.
// Is added to the mob in species.produceCopy() after all traits have been resolved.
/datum/element/allergy/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_HANDLE_ALLERGENS, PROC_REF(handle_allergic_reaction), override = TRUE)

/datum/element/allergy/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_HANDLE_ALLERGENS)

/datum/element/allergy/proc/handle_allergic_reaction(datum/source,var/allergen_CE_amount)
	SIGNAL_HANDLER
	if(allergen_CE_amount <= 0)
		return
	//first, multiply the basic species-level value by our allergen effect rating, so consuming multiple seperate allergen typess simultaneously hurts more
	var/mob/living/carbon/human/H = source
	var/datum/species/species = H.species
	var/damage_severity = species.allergen_damage_severity * allergen_CE_amount
	var/disable_severity = species.allergen_disable_severity * allergen_CE_amount

	if(species.allergen_reaction & AG_PHYS_DMG)
		H.adjustBruteLoss(damage_severity)

	if(species.allergen_reaction & AG_BURN_DMG)
		H.adjustFireLoss(damage_severity)

	if(species.allergen_reaction & AG_TOX_DMG)
		H.adjustToxLoss(damage_severity)

	if(species.allergen_reaction & AG_OXY_DMG)
		H.adjustOxyLoss(damage_severity)
		if(prob(disable_severity/2))
			H.emote(pick("cough","gasp","choke"))

	if(species.allergen_reaction & AG_EMOTE)
		if(prob(disable_severity/2))
			H.emote(pick("pale","shiver","twitch"))

	if(species.allergen_reaction & AG_PAIN)
		H.adjustHalLoss(disable_severity)

	if(species.allergen_reaction & AG_WEAKEN)
		H.Weaken(disable_severity)

	if(species.allergen_reaction & AG_BLURRY)
		H.eye_blurry = max(H.eye_blurry, disable_severity)

	if(species.allergen_reaction & AG_SLEEPY)
		H.drowsyness = max(H.drowsyness, disable_severity)

	if(species.allergen_reaction & AG_CONFUSE)
		H.Confuse(disable_severity/4)

	if(species.allergen_reaction & AG_GIBBING)
		if(prob(disable_severity / 6))
			addtimer(CALLBACK(src, PROC_REF(allergy_gib), H), rand(3,6), TIMER_DELETE_ME)
		else if(prob(disable_severity))
			H.emote(pick(list("whimper","belch","belch","belch","choke","shiver")))
			H.Weaken(disable_severity / 3)

	if(species.allergen_reaction & AG_SNEEZE)
		if(prob(disable_severity/3))
			if(prob(20))
				to_chat(H, span_warning("You go to sneeze, but it gets caught in your sinuses!"))
			else if(prob(80))
				if(prob(30))
					to_chat(H, span_warning("You feel like you are about to sneeze!"))
				addtimer(CALLBACK(src, PROC_REF(allergy_sneeze), H), rand(0.75,3) SECOND, TIMER_DELETE_ME)

	if(species.allergen_reaction & AG_COUGH)
		if(prob(disable_severity/2))
			H.emote(pick(list("cough","cough","cough","gasp","choke")))
			if(prob(10))
				H.drop_item()

// Helpers for delayed actions
/datum/element/allergy/proc/allergy_sneeze(var/mob/living/carbon/human/H)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	H.emote("sneeze")
	if(prob(23))
		H.drop_item()

/datum/element/allergy/proc/allergy_gib(var/mob/living/carbon/human/H,var/remaining)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(remaining > 0)
		H.emote(pick(list("whimper","belch","shiver")))
		remaining--
		addtimer(CALLBACK(src, PROC_REF(allergy_gib), H, remaining), rand(1,1.2) SECOND, TIMER_DELETE_ME)
		return
	H.emote("belch")
	H.gib()
