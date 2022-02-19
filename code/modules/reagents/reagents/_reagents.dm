


/datum/reagent
	var/name = "Reagent"
	var/id = "reagent"
	var/description = "A non-descript chemical."
	var/taste_description = "bitterness"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/list/data = null
	var/volume = 0
	var/metabolism = REM // This would be 0.2 normally
	var/list/filtered_organs = list()	// Organs that will slow the processing of this chemical.
	var/mrate_static = FALSE	//If the reagent should always process at the same speed, regardless of species, make this TRUE
	var/ingest_met = 0
	var/touch_met = 0
	var/dose = 0
	var/max_dose = 0
	var/overdose = 0		//Amount at which overdose starts
	var/overdose_mod = 1	//Modifier to overdose damage
	var/can_overdose_touch = FALSE	// Can the chemical OD when processing on touch?
	var/scannable = 0 // Shows up on health analyzers.

	var/affects_dead = 0	// Does this chem process inside a corpse?
	var/affects_robots = 0	// Does this chem process inside a Synth?
	
	var/allergen_type		// What potential allergens does this contain?
	var/allergen_factor = 1	// If the potential allergens are mixed and low-volume, they're a bit less dangerous. Needed for drinks because they're a single reagent compared to food which contains multiple seperate reagents.

	var/cup_icon_state = null
	var/cup_name = null
	var/cup_desc = null
	var/cup_center_of_mass = null

	var/color = "#000000"
	var/color_weight = 1

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

/datum/reagent/proc/remove_self(var/amount) // Shortcut
	if(holder)
		holder.remove_reagent(id, amount)

// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/datum/reagent/proc/touch_mob(var/mob/M, var/amount)
	SEND_SIGNAL(M, COMSIG_REAGENTS_TOUCH, src, amount)
	return

/datum/reagent/proc/touch_obj(var/obj/O, var/amount) // Acid melting, cleaner cleaning, etc
	SEND_SIGNAL(O, COMSIG_REAGENTS_TOUCH, src, amount)
	return

/datum/reagent/proc/touch_turf(var/turf/T, var/amount) // Cleaner cleaning, lube lubbing, etc, all go here
	SEND_SIGNAL(T, COMSIG_REAGENTS_TOUCH, src, amount)
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/datum/reagents/metabolism/location) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(!istype(M))
		return
	if(!affects_dead && M.stat == DEAD)
		return
	if(!affects_robots && M.isSynthetic())
		return
	if(!istype(location))
		return

	var/datum/reagents/metabolism/active_metab = location
	var/removed = metabolism

	var/ingest_rem_mult = 1
	var/ingest_abs_mult = 1

	if(!mrate_static == TRUE)
		// Modifiers
		for(var/datum/modifier/mod in M.modifiers)
			if(!isnull(mod.metabolism_percent))
				removed *= mod.metabolism_percent
				ingest_rem_mult *= mod.metabolism_percent
		// Species
		removed *= M.species.metabolic_rate
		ingest_rem_mult *= M.species.metabolic_rate
		// Metabolism
		removed *= active_metab.metabolism_speed
		ingest_rem_mult *= active_metab.metabolism_speed

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.isSynthetic())
				if(H.species.has_organ[O_HEART] && (active_metab.metabolism_class == CHEM_BLOOD))
					var/obj/item/organ/internal/heart/Pump = H.internal_organs_by_name[O_HEART]
					if(!Pump)
						removed *= 0.1
					else if(Pump.standard_pulse_level == PULSE_NONE)	// No pulse normally means chemicals process a little bit slower than normal.
						removed *= 0.8
					else	// Otherwise, chemicals process as per percentage of your current pulse, or, if you have no pulse but are alive, by a miniscule amount.
						removed *= max(0.1, H.pulse / Pump.standard_pulse_level)

				if(H.species.has_organ[O_STOMACH] && (active_metab.metabolism_class == CHEM_INGEST))
					var/obj/item/organ/internal/stomach/Chamber = H.internal_organs_by_name[O_STOMACH]
					if(Chamber)
						ingest_rem_mult *= max(0.1, 1 - (Chamber.damage / Chamber.max_damage))
					else
						ingest_rem_mult = 0.1

				if(H.species.has_organ[O_INTESTINE] && (active_metab.metabolism_class == CHEM_INGEST))
					var/obj/item/organ/internal/intestine/Tube = H.internal_organs_by_name[O_INTESTINE]
					if(Tube)
						ingest_abs_mult *= max(0.1, 1 - (Tube.damage / Tube.max_damage))
					else
						ingest_abs_mult = 0.1

			else
				var/obj/item/organ/internal/heart/machine/Pump = H.internal_organs_by_name[O_PUMP]
				var/obj/item/organ/internal/stomach/machine/Cycler = H.internal_organs_by_name[O_CYCLER]

				if(active_metab.metabolism_class == CHEM_BLOOD)
					if(Pump)
						removed *= 1.1 - Pump.damage / Pump.max_damage
					else
						removed *= 0.1

				else if(active_metab.metabolism_class == CHEM_INGEST)	// If the pump is damaged, we waste chems from the tank.
					if(Pump)
						ingest_abs_mult *= max(0.25, 1 - Pump.damage / Pump.max_damage)

					else
						ingest_abs_mult *= 0.2

					if(Cycler)	// If we're damaged, we empty our tank slower.
						ingest_rem_mult = max(0.1, 1 - (Cycler.damage / Cycler.max_damage))

					else
						ingest_rem_mult = 0.1

				else if(active_metab.metabolism_class == CHEM_TOUCH)	// Machines don't exactly absorb chemicals.
					removed *= 0.5

			if(filtered_organs && filtered_organs.len)
				for(var/organ_tag in filtered_organs)
					var/obj/item/organ/internal/O = H.internal_organs_by_name[organ_tag]
					if(O && !O.is_broken() && prob(max(0, O.max_damage - O.damage)))
						removed *= 0.8
						if(active_metab.metabolism_class == CHEM_INGEST)
							ingest_rem_mult *= 0.8

	if(ingest_met && (active_metab.metabolism_class == CHEM_INGEST))
		removed = ingest_met * ingest_rem_mult
	if(touch_met && (active_metab.metabolism_class == CHEM_TOUCH))
		removed = touch_met
	removed = min(removed, volume)
	max_dose = max(volume, max_dose)
	dose = min(dose + removed, max_dose)
	if(removed >= (metabolism * 0.1) || removed >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(active_metab.metabolism_class)
			if(CHEM_BLOOD)
				affect_blood(M, alien, removed)
			if(CHEM_INGEST)
				affect_ingest(M, alien, removed * ingest_abs_mult)
			if(CHEM_TOUCH)
				affect_touch(M, alien, removed)
	if(overdose && (volume > overdose * M?.species.chemOD_threshold) && (active_metab.metabolism_class != CHEM_TOUCH && !can_overdose_touch))
		overdose(M, alien, removed)
	if(M.species.allergens & allergen_type)	//uhoh, we can't handle this!	
		var/damage_severity = M.species.allergen_damage_severity*allergen_factor
		var/disable_severity = M.species.allergen_disable_severity*allergen_factor	
		if(M.species.allergen_reaction & AG_TOX_DMG)
			M.adjustToxLoss(damage_severity)
		if(M.species.allergen_reaction & AG_OXY_DMG)
			M.adjustOxyLoss(damage_severity*1.5) //VOREStation Edit
			if(prob(2.5*disable_severity))
				M.emote(pick("cough","gasp","choke"))
		if(M.species.allergen_reaction & AG_EMOTE)
			if(prob(2.5*disable_severity))	//this has a higher base chance, but not *too* high
				M.emote(pick("pale","shiver","twitch"))
		if(M.species.allergen_reaction & AG_PAIN)
			M.adjustHalLoss(disable_severity*2) //VOREStation Edit
		if(M.species.allergen_reaction & AG_WEAKEN)
			M.Weaken(disable_severity)
		if(M.species.allergen_reaction & AG_BLURRY)
			M.eye_blurry = max(M.eye_blurry, disable_severity)
		if(M.species.allergen_reaction & AG_SLEEPY)
			M.drowsyness = max(M.drowsyness, disable_severity)
		if(M.species.allergen_reaction & AG_CONFUSE) //VOREStation Addition
			M.Confuse(disable_severity/4) //VOREStation Addition
	remove_self(removed)
	return

/datum/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.bloodstr.add_reagent(id, removed)
	return

/datum/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/overdose(var/mob/living/carbon/M, var/alien, var/removed) // Overdose effect.
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		overdose_mod *= H.species.chemOD_mod
	// 6 damage per unit at minimum, scales with excessive reagents. Rounding should help keep damage consistent between ingest / inject, but isn't perfect.
	// Hardcapped at 3.6 damage per tick, or 18 damage per unit at 0.2 metabolic rate so that you can't instakill people with overdoses by feeding them infinite periadaxon.
	// Overall, max damage is slightly less effective than hydrophoron, and 1/5 as effective as cyanide.
	M.adjustToxLoss(min(removed * overdose_mod * round(3 + 3 * volume / overdose), 3.6))

/datum/reagent/proc/initialize_data(var/newdata) // Called when the reagent is created.
	if(!isnull(newdata))
		data = newdata
	return

/datum/reagent/proc/mix_data(var/newdata, var/newamount) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently.
	if(data && istype(data, /list))
		return data.Copy()
	else if(data)
		return data
	return null

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	holder = null
	. = ..()

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(var/turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(var/obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(var/mob/target)
	touch_mob(target)

/// Called by [/datum/reagents/proc/conditional_update]
/datum/reagent/proc/on_update(atom/A)
	return
