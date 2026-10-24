// MEDICAL SIDE EFFECT BASE
// ========================
#define MAX_EFFECT_STRENGTH 50

#define STRENGTH_IND 1
#define STARTTIME_IND 2
#define DEFAULT_EFF_LIST list(0,0)
#define EFFECT_GROWTH_RATE 0.08

/datum/decl/medical_effect
	var/name = "None"
	var/list/triggers
	var/list/cures
	var/cure_message

/// Begin the side effect
/datum/decl/medical_effect/proc/manifest(mob/living/carbon/human/H)
	return

/// Finish the side effect
/datum/decl/medical_effect/proc/subside(mob/living/carbon/human/H)
	return

/// Performs the effect, has large gaps between being triggered
/datum/decl/medical_effect/proc/on_life(mob/living/carbon/human/H, strength)
	return

/// Checks the mob's body for a cure reagent, returns true if any are present
/datum/decl/medical_effect/proc/can_cure(mob/living/carbon/human/H)
	for(var/R in cures)
		if(H.bloodstr.has_reagent(R) || H.ingested.has_reagent(R))
			return TRUE
	return FALSE


// MOB HELPERS
// ===========
/mob/living/carbon/human
	var/list/side_effects = list()

/mob/proc/add_side_effect(effect_path, strength)
	return

/mob/living/carbon/human/add_side_effect(effect_path, strength)
	if(!effect_path)
		return FALSE
	if(strength > MAX_EFFECT_STRENGTH) // Effect would expire instantly
		return
	var/datum/decl/medical_effect/med_effect = GLOB.decls_repository.get_decl(effect_path)

	if(med_effect.can_cure(src))
		return FALSE
	// Check if it can manifest
	var/has_trigger = FALSE
	for(var/R in med_effect.triggers)
		if(bloodstr.has_reagent(R) || ingested.has_reagent(R))
			has_trigger = TRUE
			break
	if(!has_trigger)
		return FALSE
	side_effects[effect_path][STRENGTH_IND] = max(side_effects[effect_path][STRENGTH_IND], strength, EFFECT_GROWTH_RATE)
	side_effects[effect_path][STARTTIME_IND] = life_tick
	med_effect.manifest(src)
	return TRUE

/mob/living/carbon/human/proc/handle_medical_side_effects()
	//Going to handle those things only every few ticks.
	if(life_tick % 15 != 0)
		return

	// One full cycle(in terms of strength) every 10 minutes
	var/list/all_med_effects = GLOB.decls_repository.get_decls_of_subtype(/datum/decl/medical_effect)
	for (var/e_type in all_med_effects)
		var/datum/decl/medical_effect/med_effect = all_med_effects[e_type]
		if(!(e_type in side_effects))
			side_effects[e_type] = DEFAULT_EFF_LIST
		// Attempt to start the effect
		if(!side_effects[e_type][STRENGTH_IND] && !add_side_effect(e_type))
			continue
		// Only do anything if the effect is currently strong enough
		var/strength_percent = sin((life_tick - side_effects[e_type][STARTTIME_IND]) / 2)
		if(strength_percent < 0.4)
			continue
		// End the effect after a long enough time has passed, or it is cured
		side_effects[e_type][STRENGTH_IND] += EFFECT_GROWTH_RATE
		var/strength = side_effects[e_type][STRENGTH_IND]
		if (med_effect.can_cure(src) || strength > MAX_EFFECT_STRENGTH)
			med_effect.subside(src)
			if (med_effect.cure_message)
				to_chat(src, span_blue("[med_effect.cure_message]"))
			side_effects[e_type] = DEFAULT_EFF_LIST
			continue
		if(life_tick % 45 == 0)
			med_effect.on_life(src, strength_percent * strength)


#undef EFFECT_GROWTH_RATE
#undef DEFAULT_EFF_LIST
#undef STRENGTH_IND
#undef STARTTIME_IND
#undef MAX_EFFECT_STRENGTH
