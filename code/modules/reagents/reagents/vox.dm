// Solvent - used in vox chemistry and stomachs.
/datum/reagent/acid/voxenzyme
	name = "alkahest"
	id = "voxenzyme"
	description = "A seething slurry of pseudo-living proteins, acids and enzymes, utterly alien in composition and capable of dissolving almost anything."
	taste_description = "salt and burning"
	reagent_state = LIQUID
	color = COLOR_CYAN
	power = 12
	meltdose = 1
	scannable = FALSE

// Vox slurry - used to fuel machines, feed vox and gear, and as an ingredient in the biofoundry
/datum/reagent/toxin/voxslurry
	name = "protoslurry"
	id = "voxslurry"
	taste_description = "coppery slime"
	description = "A complex slurry of lipids, proteins, metal particulate and long polymer chains. Ubiquitous to vox-inhabited stations and equipment."
	strength = 6
	scannable = FALSE
	taste_mult = 4
	metabolism = REM * 4
	ingest_met = REM * 4

/datum/reagent/toxin/voxslurry/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_VOX)
		return ..()
	M.adjust_nutrition(12 * removed)
	M.heal_organ_damage(0.5 * removed, 0.5 * removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/datum/reagent/toxin/voxslurry/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

// General-purpose vox medication
/datum/reagent/toxin/voxmeds
	name = "repair gel"
	id = "voxmeds"
	taste_description = "fizzing sweetness"
	description = "A complex serum composed of vox-manufactured nanomachines, complex protein chains and microscopic bundles of metallic fibers."
	strength = 8
	scannable = FALSE
	metabolism = REM * 4
	ingest_met = REM * 4

/datum/reagent/toxin/voxmeds/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

/datum/reagent/toxin/voxmeds/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_VOX)
		// Mostly copied from mutagen.
		. = ..()
		if(!M.dna)
			return
		if(prob(removed * 10))
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(M)
			to_chat(M, SPAN_WARNING("You feel odd!"))
		M.apply_effect(10 * removed, IRRADIATE, 0)
		return

	M.adjustOxyLoss(-3 * removed)
	M.heal_organ_damage(1.5 * removed, 1.5 * removed)
	M.adjustToxLoss(-1.5 * removed)

	// Copied from peridaxon for the time being.
	var/mob/living/carbon/human/H = M
	for(var/obj/item/organ/I in H.internal_organs)
		if(I.robotic >= ORGAN_ROBOT)
			continue
		if(I.damage > 0)
			I.damage = max(I.damage - removed, 0)
			H.Confuse(5)
		if(I.damage <= 5 && I.organ_tag == O_EYES)
			H.sdisabilities &= ~BLIND

/datum/reagent/ethanol/riaaak // Vox moonshine
	name = "riaaak"
	id = "voxbooze"
	description = "Vox clades brew this noxious concoction in half-empty fuel tanks using whatever dregs come to hand."
	taste_description = "burning, acrid foulness"
	taste_mult = 10 // hard to taste anything else over this
	color = "#22aa88"
	strength = 7

	glass_name = "riaaak"
	glass_desc = "An oily green brew that will knock even a Vox on its tail."

/datum/reagent/ethanol/riaaak/affect_ingest(mob/living/carbon/M, alien, removed)
	. = ..()
	if(alien != IS_VOX && alien != IS_DIONA)
		handle_nonvox_effects(M, removed, CHEM_INGEST)

/datum/reagent/ethanol/riaaak/affect_blood(mob/living/carbon/M, alien, removed)
	. = ..()
	if(alien != IS_VOX && alien != IS_DIONA)
		handle_nonvox_effects(M, removed, CHEM_BLOOD)

/datum/reagent/ethanol/riaaak/proc/handle_nonvox_effects(var/mob/living/carbon/M, var/removed, var/method)
	// todo: eye damage, stomach damage, poisoning?
	var/dam = removed * 5 * M.species.chem_strength_tox // arbitrary
	if(dam)
		M.adjustToxLoss(dam)
