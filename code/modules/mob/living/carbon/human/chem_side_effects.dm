// MEDICAL SIDE EFFECT BASE
// ========================
/datum/medical_effect
	var/name = "None"
	var/strength = 0
	var/start = 0
	var/list/cures
	var/cure_message

/// Begin processing the side effect
/datum/medical_effect/proc/manifest(mob/living/carbon/human/H, strength)
	if(cure(H, FALSE))
		return
	src.strength = strength
	start = H.life_tick
	LAZYADD(H.side_effects, src)

/// Finish processing the side effect
/datum/medical_effect/proc/subside(mob/living/carbon/human/H)
	LAZYREMOVE(H.side_effects, src)
	qdel(src)

/// Performs the effect, has large gaps between being triggered
/datum/medical_effect/proc/on_life(mob/living/carbon/human/H, strength)
	return

/// Checks the mob's body for a cure reagent, returns true if any are present
/datum/medical_effect/proc/cure(mob/living/carbon/human/H, show_message)
	for(var/R in cures)
		if(!H.bloodstr.has_reagent(R))
			continue
		if(H.ingested.has_reagent(R))
			continue
		if (show_message && cure_message)
			to_chat(H, span_blue("[cure_message]"))
		return TRUE
	return FALSE


// MOB HELPERS
// ===========
/mob/living/carbon/human
	var/list/datum/medical_effect/side_effects = null

/mob/proc/add_side_effect(effect_path, strength = 0)
	return

/mob/living/carbon/human/add_side_effect(effect_path, strength = 0)
	if(length(side_effects)) // Find an effect already active on our mob
		for(var/datum/medical_effect/effect in side_effects)
			if(!istype(effect, effect_path))
				continue
			effect.strength = max(effect.strength, strength)
			effect.start = life_tick
			return
	// Add the effect if it didn't exist
	var/datum/medical_effect/created_effect = new effect_path()
	created_effect.manifest(src, strength)

/mob/living/carbon/human/proc/handle_medical_side_effects()
	//Going to handle those things only every few ticks.
	if(life_tick % 15 != 0)
		return
	if(!length(side_effects))
		return
	// One full cycle(in terms of strength) every 10 minutes
	for (var/datum/medical_effect/M in side_effects)
		// Only do anything if the effect is currently strong enough
		var/strength_percent = sin((life_tick - M.start) / 2)
		if(strength_percent < 0.4)
			continue
		// End the effect after a long enough time has passed, or it is cured
		M.strength += 0.08
		if (M.cure(src,TRUE) || M.strength > 50)
			M.subside(src)
			continue
		if(life_tick % 45 == 0)
			M.on_life(src, strength_percent * M.strength)

// HEADACHE
// ========
/datum/medical_effect/headache
	name = "Headache"
	// triggers = list(REAGENT_ID_CRYOXADONE = 10, REAGENT_ID_BICARIDINE = 15, REAGENT_ID_TRICORDRAZINE = 15)
	cures = list(REAGENT_ID_ALKYSINE, REAGENT_ID_TRAMADOL, REAGENT_ID_PARACETAMOL, REAGENT_ID_OXYCODONE)
	cure_message = "Your head stops throbbing..."

/datum/medical_effect/headache/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a light pain in your head.",0)
		if(11 to 30)
			H.custom_pain("You feel a throbbing pain in your head!",1)
		if(31 to INFINITY)
			H.custom_pain("You feel an excrutiating pain in your head!",1)

// BAD STOMACH
// ===========
/datum/medical_effect/bad_stomach
	name = "Bad Stomach"
	// triggers = list(REAGENT_ID_KELOTANE = 30, REAGENT_ID_DERMALINE = 15)
	cures = list(REAGENT_ID_ANTITOXIN)
	cure_message = "Your stomach feels a little better now..."

/datum/medical_effect/bad_stomach/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a bit light around the stomach.",0)
		if(11 to 30)
			H.custom_pain("Your stomach hurts.",0)
		if(31 to INFINITY)
			H.custom_pain("You feel sick.",1)

// CRAMPS
// ======
/datum/medical_effect/cramps
	name = "Cramps"
	// triggers = list(REAGENT_ID_ANTITOXIN = 30, REAGENT_ID_TRAMADOL = 15)
	cures = list(REAGENT_ID_INAPROVALINE)
	cure_message = "The cramps let up..."

/datum/medical_effect/cramps/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("The muscles in your body hurt a little.",0)
		if(11 to 30)
			H.custom_pain("The muscles in your body cramp up painfully.",0)
		if(31 to INFINITY)
			H.automatic_custom_emote(VISIBLE_MESSAGE, "flinches as all the muscles in their body cramp up.", check_stat = TRUE)
			H.custom_pain("There's pain all over your body.",1)

// ITCH
// ====
/datum/medical_effect/itch
	name = "Itch"
	// triggers = list(REAGENT_ID_BLISS = 10)
	cures = list(REAGENT_ID_INAPROVALINE)
	cure_message = "The itching stops..."

/datum/medical_effect/itch/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a slight itch.",0)
		if(11 to 30)
			H.custom_pain("You want to scratch your itch badly.",0)
		if(31 to INFINITY)
			H.automatic_custom_emote(VISIBLE_MESSAGE, "shivers slightly.", check_stat = TRUE)
			H.custom_pain("This itch makes it really hard to concentrate.",1)
