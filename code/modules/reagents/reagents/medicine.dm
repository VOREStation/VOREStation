/* General medicine */

/datum/reagent/inaprovaline
	name = REAGENT_INAPROVALINE
	id = REAGENT_ID_INAPROVALINE
	description = REAGENT_INAPROVALINE + " is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients. Also counteracts allergic reactions."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.2
	scannable = 1

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 10 * M.species.chem_strength_pain)
		M.remove_chemical_effect(CE_ALLERGEN)

/datum/reagent/inaprovaline/topical
	name = REAGENT_INAPROVALAZE
	id = REAGENT_ID_INAPROVALAZE
	description = REAGENT_INAPROVALAZE + " is a topical variant of Inaprovaline."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.2
	scannable = 1
	touch_met = REM * 0.3
	can_overdose_touch = TRUE

/datum/reagent/inaprovaline/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		..()
		M.adjustToxLoss(2 * removed)

/datum/reagent/inaprovaline/topical/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 20)
		M.add_chemical_effect(CE_PAINKILLER, 12 * M.species.chem_strength_pain)

/datum/reagent/bicaridine
	name = REAGENT_BICARIDINE
	id = REAGENT_ID_BICARIDINE
	description = REAGENT_BICARIDINE + " is an analgesic medication and can be used to treat blunt trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
	overdose_mod = 0.25
	scannable = 1

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(4 * removed * chem_effective, 0) //VOREStation Edit

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/wound_heal = 2.5 * removed
	M.eye_blurry = min(M.eye_blurry + wound_heal, 250)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

/datum/reagent/bicaridine/topical
	name = REAGENT_BICARIDAZE
	id = REAGENT_ID_BICARIDAZE
	description = REAGENT_BICARIDAZE + " is a topical variant of the chemical Bicaridine."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE * 0.75
	scannable = 1
	touch_met = REM * 0.75
	can_overdose_touch = TRUE

/datum/reagent/bicaridine/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		..(M, alien, removed * chem_effective)
		M.adjustToxLoss(2 * removed)

/datum/reagent/bicaridine/topical/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(6 * removed * chem_effective, 0)

/datum/reagent/calciumcarbonate
	name = REAGENT_CALCIUMCARBONATE
	id = REAGENT_ID_CALCIUMCARBONATE
	description = "Calcium carbonate is a calcium salt commonly used as an antacid."
	taste_description = "chalk"
	reagent_state = SOLID
	color = "#eae6e3"
	overdose = REAGENTS_OVERDOSE * 0.8
	metabolism = REM * 0.4
	scannable = 1

/datum/reagent/calciumcarbonate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) // Why would you inject this.
	if(alien != IS_DIONA)
		M.adjustToxLoss(3 * removed)

/datum/reagent/calciumcarbonate/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_ANTACID, 3)

/datum/reagent/kelotane
	name = REAGENT_KELOTANE
	id = REAGENT_ID_KELOTANE
	description = REAGENT_KELOTANE + " is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.5
		M.adjustBruteLoss(2 * removed) //Mends burns, but has negative effects with a Promethean's skeletal structure.
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 4 * removed * chem_effective) //VOREStation edit

/datum/reagent/dermaline
	name = REAGENT_DERMALINE
	id = REAGENT_ID_DERMALINE
	name = REAGENT_DERMALINE
	description = REAGENT_DERMALINE + " is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 8 * removed * chem_effective) //VOREStation edit

/datum/reagent/dermaline/topical
	name = REAGENT_DERMALAZE
	id = REAGENT_ID_DERMALAZE
	description = REAGENT_DERMALAZE + " is a topical variant of the chemical Dermaline."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.4
	scannable = 1
	touch_met = REM * 0.75
	can_overdose_touch = TRUE

/datum/reagent/dermaline/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		..(M, alien, removed * chem_effective)
		M.adjustToxLoss(2 * removed)

/datum/reagent/dermaline/topical/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 12 * removed * chem_effective)

/datum/reagent/dylovene
	name = REAGENT_ANTITOXIN
	id = REAGENT_ID_ANTITOXIN
	description = REAGENT_ANTITOXIN + " is a broad-spectrum antitoxin."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00A000"
	scannable = 1

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.66
		if(dose >= 15)
			M.druggy = max(M.druggy, 5)
	if(alien != IS_DIONA)
		M.drowsyness = max(0, M.drowsyness - 6 * removed * chem_effective)
		M.hallucination = max(0, M.hallucination - 9 * removed * chem_effective)
		M.adjustToxLoss(-4 * removed * chem_effective)
		if(prob(10))
			M.remove_a_modifier_of_type(/datum/modifier/poisoned)

/datum/reagent/carthatoline
	name = REAGENT_CARTHATOLINE
	id = REAGENT_ID_CARTHATOLINE
	description = REAGENT_CARTHATOLINE + " is strong evacuant used to treat severe poisoning."
	reagent_state = LIQUID
	color = "#225722"
	scannable = 1
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 0 // Not used, but it shouldn't deal toxin damage anyways. Carth heals toxins!

/datum/reagent/carthatoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.getToxLoss() && prob(10))
		M.vomit(1)
	M.adjustToxLoss(-8 * removed * M.species.chem_strength_heal)
	if(prob(30))
		M.remove_a_modifier_of_type(/datum/modifier/poisoned)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
		if(istype(L))
			if(L.robotic >= ORGAN_ROBOT)
				return
			if(L.damage > 0)
				L.damage = max(L.damage - 2 * removed, 0)
		if(alien == IS_SLIME)
			H.druggy = max(M.druggy, 5)

/datum/reagent/carthatoline/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustHalLoss(2)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/internal/stomach/st = H.internal_organs_by_name[O_STOMACH]
	st?.take_damage(removed * 2) // Causes stomach contractions, makes sense for an overdose to make it much worse.

/datum/reagent/dexalin
	name = REAGENT_DEXALIN
	id = REAGENT_ID_DEXALIN
	description = REAGENT_DEXALIN + " is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM * 0.25 //VOREStation Edit

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 24) //VOREStation Edit
	else if(alien == IS_SLIME && dose >= 15)
		M.add_chemical_effect(CE_PAINKILLER, 15 * M.species.chem_strength_pain)
		if(prob(15))
			to_chat(M, span_notice("You have a moment of clarity as you collapse."))
			M.adjustBrainLoss(-20 * removed) //VOREStation Edit
			M.Weaken(6)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-15 * removed * M.species.chem_strength_heal)

	holder.remove_reagent(REAGENT_ID_LEXORIN, 8 * removed) //VOREStation Edit

/datum/reagent/dexalinp
	name = REAGENT_DEXALINP
	id = REAGENT_ID_DEXALINP
	description = REAGENT_DEXALINP + " is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 1.25
	scannable = 1

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else if(alien == IS_SLIME && dose >= 10)
		M.add_chemical_effect(CE_PAINKILLER, 25 * M.species.chem_strength_pain)
		if(prob(25))
			to_chat(M, span_notice("You have a moment of clarity, as you feel your tubes lose pressure rapidly."))
			M.adjustBrainLoss(-8 * removed)
			M.Weaken(3)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-150 * removed * M.species.chem_strength_heal)

	holder.remove_reagent(REAGENT_ID_LEXORIN, 3 * removed)

/datum/reagent/tricordrazine
	name = REAGENT_TRICORDRAZINE
	id = REAGENT_ID_TRICORDRAZINE
	description = REAGENT_TRICORDRAZINE + " is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#8040FF"
	scannable = 1

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		var/chem_effective = 1 * M.species.chem_strength_heal
		if(alien == IS_SLIME)
			chem_effective = 0.5
		M.adjustOxyLoss(-3 * removed * chem_effective)
		M.heal_organ_damage(1.5 * removed, 1.5 * removed * chem_effective)
		M.adjustToxLoss(-1.5 * removed * chem_effective)

/datum/reagent/tricordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		affect_blood(M, alien, removed * 0.4)

/datum/reagent/tricorlidaze
	name = REAGENT_TRICORLIDAZE
	id = REAGENT_ID_TRICORLIDAZE
	description = REAGENT_TRICORLIDAZE + " is a topical gel produced with tricordrazine and sterilizine."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#B060FF"
	scannable = 1
	can_overdose_touch = TRUE

/datum/reagent/tricorlidaze/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		var/chem_effective = 1 * M.species.chem_strength_heal
		if(alien == IS_SLIME)
			chem_effective = 0.5
		M.adjustOxyLoss(-2 * removed * chem_effective)
		M.heal_organ_damage(1 * removed, 1 * removed * chem_effective)
		M.adjustToxLoss(-2 * removed * chem_effective)

/datum/reagent/tricorlidaze/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(3 * removed)

/datum/reagent/tricorlidaze/touch_obj(var/obj/O)
	..()
	if(istype(O, /obj/item/stack/medical/bruise_pack) && round(volume) >= 5)
		var/obj/item/stack/medical/bruise_pack/C = O
		var/packname = C.name
		var/to_produce = min(C.get_amount(), round(volume / 5))

		var/obj/item/stack/medical/M = C.upgrade_stack(to_produce)

		if(M && M.get_amount())
			holder.my_atom.visible_message(span_infoplain(span_bold("\The [packname]") + " bubbles."))
			remove_self(to_produce * 5)

/datum/reagent/cryoxadone
	name = REAGENT_CRYOXADONE
	id = REAGENT_ID_CRYOXADONE
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "overripe bananas"
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		var/chem_effective = 1 * M.species.chem_strength_heal
		if(alien == IS_SLIME)
			chem_effective = 0.25
			to_chat(M, span_danger("It's cold. Something causes your cellular mass to harden occasionally, resulting in vibration."))
			M.Weaken(10)
			M.silent = max(M.silent, 10)
			M.make_jittery(4)
		M.adjustCloneLoss(-10 * removed * chem_effective)
		M.adjustOxyLoss(-10 * removed * chem_effective)
		M.heal_organ_damage(10 * removed, 10 * removed * chem_effective)
		M.adjustToxLoss(-10 * removed * chem_effective)

/datum/reagent/clonexadone
	name = REAGENT_CLONEXADONE
	id = REAGENT_ID_CLONEXADONE
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "rotten bananas"
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		var/chem_effective = 1 * M.species.chem_strength_heal
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, span_danger("It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching."))
			chem_effective = 0.5
			M.Weaken(20)
			M.silent = max(M.silent, 20)
			M.make_jittery(4)
		M.adjustCloneLoss(-30 * removed * chem_effective)
		M.adjustOxyLoss(-30 * removed * chem_effective)
		M.heal_organ_damage(30 * removed, 30 * removed * chem_effective)
		M.adjustToxLoss(-30 * removed * chem_effective)

/datum/reagent/mortiferin
	name = REAGENT_MORTIFERIN
	id = REAGENT_ID_MORTIFERIN
	description = "A liquid compound based upon those used in cloning. Utilized in cases of toxic shock. May cause liver damage."
	taste_description = "meat"
	reagent_state = LIQUID
	color = "#6b4de3"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1

/datum/reagent/mortiferin/on_mob_life(var/mob/living/carbon/M, var/alien, var/datum/reagents/metabolism/location)
	if(M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse))
		affects_dead = TRUE
	else
		affects_dead = FALSE

	. = ..(M, alien, location)

/datum/reagent/mortiferin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < (T0C - 10) || (M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse)))
		var/chem_effective = 1 * M.species.chem_strength_heal
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, span_danger("It's so cold. Something causes your cellular mass to solidify sporadically, resulting in uncontrollable twitching."))
			chem_effective = 0.5
			M.Weaken(10)
			M.silent = max(M.silent, 10)
			M.make_jittery(4)
		if(M.stat != DEAD)
			M.adjustCloneLoss(-5 * removed * chem_effective)
		M.adjustOxyLoss(-10 * removed * chem_effective)
		M.adjustToxLoss(-20 * removed * chem_effective)

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
			if(istype(L) && prob(5))
				if(L.robotic >= ORGAN_ROBOT)
					return

				L.take_damage(rand(1,3) * removed)

/datum/reagent/necroxadone
	name = REAGENT_NECROXADONE
	id = REAGENT_ID_NECROXADONE
	description = "A liquid compound based upon that which is used in the cloning process. Utilized primarily in severe cases of toxic shock."
	taste_description = "meat"
	reagent_state = LIQUID
	color = "#94B21C"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1
	affects_dead = TRUE

/datum/reagent/necroxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(M.bodytemperature < 170 || (M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse)))
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, span_danger("It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching."))
			chem_effective = 0.5
			M.Weaken(20)
			M.silent = max(M.silent, 20)
			M.make_jittery(4)
		if(M.stat != DEAD)
			M.adjustCloneLoss(-5 * removed * chem_effective)
		M.adjustOxyLoss(-20 * removed * chem_effective)
		M.adjustToxLoss(-40 * removed * chem_effective)
		M.adjustCloneLoss(-15 * removed * chem_effective)

	else
		M.adjustToxLoss(-25 * removed * chem_effective)
		M.adjustOxyLoss(-10 * removed * chem_effective)
		M.adjustCloneLoss(-7 * removed * chem_effective)

/* Painkillers */

/datum/reagent/paracetamol
	name = REAGENT_PARACETAMOL
	id = REAGENT_ID_PARACETAMOL
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE * 2
	overdose_mod = 0.75
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_pain
	if(alien == IS_SLIME)
		chem_effective = 0.75
	M.add_chemical_effect(CE_PAINKILLER, 25 * chem_effective)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	if(alien == IS_SLIME)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/tramadol
	name = REAGENT_TRAMADOL
	id = REAGENT_ID_TRAMADOL
	description = "A simple, yet effective painkiller."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = REAGENTS_OVERDOSE
	overdose_mod = 0.75
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_pain
	if(alien == IS_SLIME)
		chem_effective = 0.8
		M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.add_chemical_effect(CE_PAINKILLER, 80 * chem_effective)

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/oxycodone
	name = REAGENT_OXYCODONE
	id = REAGENT_ID_OXYCODONE
	description = "An effective and very addictive painkiller."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#800080"
	overdose = 20
	overdose_mod = 0.75
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/oxycodone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_pain
	if(alien == IS_SLIME)
		chem_effective = 0.75
		M.stuttering = min(50, max(0, M.stuttering + 5)) //If you can't feel yourself, and your main mode of speech is resonation, there's a problem.
	M.add_chemical_effect(CE_PAINKILLER, 200 * chem_effective)
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.eye_blurry = min(M.eye_blurry + 10, 250 * chem_effective)

/datum/reagent/oxycodone/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 10)
	M.hallucination = max(M.hallucination, 3)

/* Other medicine */

/datum/reagent/synaptizine
	name = REAGENT_SYNAPTIZINE
	id = REAGENT_ID_SYNAPTIZINE
	description = REAGENT_SYNAPTIZINE + " is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_DIONA)
		return
	if(alien == IS_SLIME)
		if(dose >= 5) //Not effective in small doses, though it causes toxloss at higher ones, it will make the regeneration for brute and burn more 'efficient' at the cost of more nutrition.
			M.adjust_nutrition(removed * 2)
			M.adjustBruteLoss(-2 * removed)
			M.adjustFireLoss(-1 * removed)
		chem_effective = 0.5
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent(REAGENT_ID_MINDBREAKER, 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.adjustToxLoss(10 * removed * chem_effective) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 20 * chem_effective * M.species.chem_strength_pain)

/datum/reagent/hyperzine
	name = REAGENT_HYPERZINE
	id = REAGENT_ID_HYPERZINE
	description = REAGENT_HYPERZINE + " is a highly effective, long lasting, muscle stimulant."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF3300"
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 0.25

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	if(alien == IS_SLIME)
		M.make_jittery(4) //Hyperactive fluid pumping results in unstable 'skeleton', resulting in vibration.
		if(dose >= 5)
			M.adjust_nutrition(-removed * 2) // Sadly this movement starts burning food in higher doses.
	..()
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/hyperzine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(5)) // 1 in 20
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/ht = H.internal_organs_by_name[O_HEART]
		ht?.take_damage(1)
		to_chat(M, span_warning("Huh... Is this what a heart attack feels like?"))

/datum/reagent/alkysine
	name = REAGENT_ALKYSINE
	id = REAGENT_ID_ALKYSINE
	description = REAGENT_ALKYSINE + " is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.25
		if(M.brainloss >= 10)
			M.Weaken(5)
		if(dose >= 10 && M.paralysis < 40)
			M.AdjustParalysis(1) //Messing with the core with a simple chemical probably isn't the best idea.
	M.adjustBrainLoss(-8 * removed * chem_effective) //VOREStation Edit
	M.add_chemical_effect(CE_PAINKILLER, 10 * chem_effective * M.species.chem_strength_pain)

/datum/reagent/imidazoline
	name = REAGENT_IMIDAZOLINE
	id = REAGENT_ID_IMIDAZOLINE
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.AdjustBlinded(-5)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(istype(E))
			if(E.robotic >= ORGAN_ROBOT)
				return
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)
			if(E.damage <= 5 && E.organ_tag == O_EYES)
				H.sdisabilities &= ~BLIND

/datum/reagent/peridaxon
	name = REAGENT_PERIDAXON
	id = REAGENT_ID_PERIDAXON
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 10
	overdose_mod = 1.5
	scannable = 1

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT)
				continue
			if(I.damage > 0) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)
				H.Confuse(5)
			if(I.damage <= 5 && I.organ_tag == O_EYES)
				H.eye_blurry = min(M.eye_blurry + 10, 250) //Eyes need to reset, or something
				H.sdisabilities &= ~BLIND
		if(alien == IS_SLIME)
			H.add_chemical_effect(CE_PAINKILLER, 20 * M.species.chem_strength_pain)
			if(prob(33))
				H.Confuse(10)

/datum/reagent/peridaxon/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustHalLoss(5)
	M.hallucination = max(M.hallucination, 10)

/datum/reagent/osteodaxon
	name = REAGENT_OSTEODAXON
	id = REAGENT_ID_OSTEODAXON
	description = "An experimental drug used to heal bone fractures."
	reagent_state = LIQUID
	color = "#C9BCE3"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 1.5
	scannable = 1

/datum/reagent/osteodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(3 * removed, 0)	//Gives the bones a chance to set properly even without other meds
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()		//Only works if the bone won't rebreak, as usual
				H.custom_pain("You feel a terrible agony tear through your bones!",60)
				H.AdjustWeakened(1)		//Bones being regrown will knock you over

/datum/reagent/myelamine
	name = REAGENT_MYELAMINE
	id = REAGENT_ID_MYELAMINE
	description = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	reagent_state = LIQUID
	color = "#4246C7"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 1.5
	scannable = 1
	var/repair_strength = 5

/datum/reagent/myelamine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.eye_blurry = min(M.eye_blurry + (repair_strength * removed), 250)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/wound_heal = removed * repair_strength
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

/datum/reagent/myelamine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	// Copypaste of affect_blood with slight adjustment. Heals slightly faster at the cost of high toxins
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/wound_heal = removed * repair_strength / 2
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

/datum/reagent/respirodaxon
	name = REAGENT_RESPIRODAXON
	id = REAGENT_ID_RESPIRODAXON
	description = "Used to repair the tissue of the lungs and similar organs."
	taste_description = "metallic"
	reagent_state = LIQUID
	color = "#4444FF"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

/datum/reagent/respirodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LUNGS, O_VOICE, O_GBLADDER)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent(REAGENT_ID_GASTIRODAXON) || M.reagents.has_reagent(REAGENT_ID_PERIDAXON))
			if(H.losebreath >= 15 && prob(H.losebreath))
				H.Stun(2)
			else
				H.losebreath = CLAMP(H.losebreath + 3, 0, 20)
		else
			H.losebreath = max(H.losebreath - 4, 0)

/datum/reagent/gastirodaxon
	name = REAGENT_GASTIRODAXON
	id = REAGENT_ID_GASTIRODAXON
	description = "Used to repair the tissues of the digestive system."
	taste_description = "chalk"
	reagent_state = LIQUID
	color = "#8B4513"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

/datum/reagent/gastirodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_APPENDIX, O_STOMACH, O_INTESTINE, O_NUTRIENT, O_PLASMA, O_POLYP)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent(REAGENT_ID_HEPANEPHRODAXON) || M.reagents.has_reagent(REAGENT_ID_PERIDAXON))
			if(prob(10))
				H.vomit(1)
			else if(H.nutrition > 30)
				M.adjust_nutrition(-removed * 30)
		else
			H.adjustToxLoss(-10 * removed) // Carthatoline based, considering cost.

/datum/reagent/hepanephrodaxon
	name = REAGENT_HEPANEPHRODAXON
	id = REAGENT_ID_HEPANEPHRODAXON
	description = "Used to repair the common tissues involved in filtration."
	taste_description = "glue"
	reagent_state = LIQUID
	color = "#D2691E"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

/datum/reagent/hepanephrodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.4
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LIVER, O_KIDNEYS, O_APPENDIX, O_ACID, O_HIVE)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent(REAGENT_ID_CORDRADAXON) || M.reagents.has_reagent(REAGENT_ID_PERIDAXON))
			if(prob(5))
				H.vomit(1)
			else if(prob(5))
				to_chat(H, span_danger("Something churns inside you."))
				H.adjustToxLoss(10 * removed)
				H.vomit(0, 1)
		else
			H.adjustToxLoss(-12 * removed) // Carthatoline based, considering cost.

/datum/reagent/cordradaxon
	name = REAGENT_CORDRADAXON
	id = REAGENT_ID_CORDRADAXON
	description = "Used to repair the specialized tissues involved in the circulatory system."
	taste_description = "rust"
	reagent_state = LIQUID
	color = "#FF4444"
	metabolism = REM * 1.5
	overdose = 10
	overdose_mod = 1.75
	scannable = 1

/datum/reagent/cordradaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_HEART, O_SPLEEN, O_RESPONSE, O_ANCHOR, O_EGG)))
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 4 * removed * repair_strength, 0)
				H.Confuse(2)
		if(M.reagents.has_reagent(REAGENT_ID_HYRONALIN) || M.reagents.has_reagent(REAGENT_ID_PERIDAXON))
			H.losebreath = CLAMP(H.losebreath + 1, 0, 10)
		else
			H.adjustOxyLoss(-30 * removed) // Deals with blood oxygenation.

/datum/reagent/immunosuprizine
	name = REAGENT_IMMUNOSUPRIZINE
	id = REAGENT_ID_IMMUNOSUPRIZINE
	description = "An experimental powder believed to have the ability to prevent any organ rejection."
	taste_description = "flesh"
	reagent_state = SOLID
	color = "#7B4D4F"
	overdose = 20
	overdose_mod = 1.5
	scannable = 1

/datum/reagent/immunosuprizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/strength_mod = 1 * M.species.chem_strength_heal

	if(alien == IS_DIONA)	// It's a tree.
		strength_mod = 0.25

	if(alien == IS_SLIME)	// Diffculty bonding with internal cellular structure.
		strength_mod = 0.75

	if(alien == IS_SKRELL)	// Natural inclination toward toxins.
		strength_mod = 1.5

	if(alien == IS_UNATHI)	// Natural regeneration, robust biology.
		strength_mod = 1.75

	if(alien == IS_TAJARA)	// Highest metabolism.
		strength_mod = 2

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_DIONA)
			H.adjustToxLoss((30 / strength_mod) * removed)

		var/list/organtotal = list()
		organtotal |= H.organs
		organtotal |= H.internal_organs

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))	// Reset the rejection process, toggle it to not reject.
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents.has_reagent(REAGENT_ID_SPACEACILLIN) || H.reagents.has_reagent(REAGENT_ID_COROPHIZINE))	// Chemicals that increase your immune system's aggressiveness make this chemical's job harder.
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((15 / strength_mod))
						I.take_damage(1)

/datum/reagent/skrellimmuno
	name = REAGENT_MALISHQUALEM
	id = REAGENT_ID_MALISHQUALEM
	description = "A strange, oily powder used by Malish-Katish to prevent organ rejection."
	taste_description = "mordant"
	reagent_state = SOLID
	color = "#84B2B0"
	metabolism = REM * 0.75
	overdose = 20
	overdose_mod = 1.5
	scannable = 1

/datum/reagent/skrellimmuno/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/strength_mod = 0.5 * M.species.chem_strength_heal

	if(alien == IS_SKRELL)
		strength_mod = 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_SKRELL)
			H.adjustToxLoss(20 * removed)

		var/list/organtotal = list()
		organtotal |= H.organs
		organtotal |= H.internal_organs

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents.has_reagent(REAGENT_ID_SPACEACILLIN) || H.reagents.has_reagent(REAGENT_ID_COROPHIZINE))
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((10 / strength_mod))
						I.take_damage(1)

/datum/reagent/ryetalyn
	name = REAGENT_RYETALYN
	id = REAGENT_ID_RYETALYN
	description = REAGENT_RYETALYN + " can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	var/mob/living/carbon/human/H = M
	if(alien == IS_SLIME && istype(H)) //Shifts them toward white, faster than Rezadone does toward grey.
		if(prob(50))
			if(H.r_skin)
				H.r_skin = round((H.r_skin + 510)/3)
			if(H.r_hair)
				H.r_hair = round((H.r_hair + 510)/3)
			if(H.r_facial)
				H.r_facial = round((H.r_facial + 510)/3)
			H.adjustToxLoss(6 * removed)
		if(prob(50))
			if(H.g_skin)
				H.g_skin = round((H.g_skin + 510)/3)
			if(H.g_hair)
				H.g_hair = round((H.g_hair + 510)/3)
			if(H.g_facial)
				H.g_facial = round((H.g_facial + 510)/3)
			H.adjustToxLoss(6 * removed)
		if(prob(50))
			if(H.b_skin)
				H.b_skin = round((H.b_skin + 510)/3)
			if(H.b_hair)
				H.b_hair = round((H.b_hair + 510)/3)
			if(H.b_facial)
				H.b_facial = round((H.b_facial + 510)/3)
			H.adjustToxLoss(6 * removed)

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		H.update_mutations()

/datum/reagent/ethylredoxrazine
	name = REAGENT_ETHYLREDOXRAZINE
	id = REAGENT_ID_ETHYLREDOXRAZINE
	description = "A powerful oxidizer that reacts with ethanol."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#605048"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ethylredoxrazine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.SetConfused(0)
	if(M.ingested)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 30)

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.SetConfused(0)
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 20)

/datum/reagent/hyronalin
	name = REAGENT_HYRONALIN
	id = REAGENT_ID_HYRONALIN
	description = REAGENT_HYRONALIN + " is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.radiation = max(M.radiation - 30 * removed * M.species.chem_strength_heal, 0)
	M.accumulated_rads = max(M.accumulated_rads - 30 * removed * M.species.chem_strength_heal, 0)

/datum/reagent/arithrazine
	name = REAGENT_ARITHRAZINE
	id = REAGENT_ID_ARITHRAZINE
	description = REAGENT_ARITHRAZINE + " is an unstable medication used for the most extreme cases of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	overdose_mod = 1.25
	scannable = 1

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.radiation = max(M.radiation - 70 * removed * M.species.chem_strength_heal, 0)
	M.accumulated_rads = max(M.accumulated_rads - 70 * removed * M.species.chem_strength_heal, 0)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

/datum/reagent/spaceacillin
	name = REAGENT_SPACEACILLIN
	id = REAGENT_ID_SPACEACILLIN
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.25
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	data = 0

/datum/reagent/spaceacillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, span_notice("You regain focus..."))
		else
			var/delay = (5 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, span_warning("Your senses feel unfocused, and divided."))
	M.add_chemical_effect(CE_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)

/datum/reagent/spaceacillin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.8) // Not 100% as effective as injections, though still useful.

/datum/reagent/corophizine
	name = REAGENT_COROPHIZINE
	id = REAGENT_ID_COROPHIZINE
	description = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	taste_description = "burnt toast"
	reagent_state = LIQUID
	color = "#FFB0B0"
	mrate_static = TRUE
	overdose = 10
	overdose_mod = 1.5
	scannable = 1
	data = 0

/datum/reagent/corophizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ANTIBIOTIC, ANTIBIO_SUPER)

	var/mob/living/carbon/human/H = M

	if(ishuman(M) && alien == IS_SLIME) //Everything about them is treated like a targetted organism. Widespread bodily function begins to fail.
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, span_notice("Your body ceases its revolt."))
		else
			var/delay = (3 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, span_critical("It feels like your body is revolting!"))
		M.Confuse(7)
		M.adjustFireLoss(removed * 2)
		M.adjustToxLoss(removed * 2)
		if(dose >= 5 && M.toxloss >= 10) //It all starts going wrong.
			M.adjustBruteLoss(removed * 3)
			M.eye_blurry = min(20, max(0, M.eye_blurry + 10))
			if(prob(25))
				if(prob(25))
					to_chat(M, span_danger("Your pneumatic fluids seize for a moment."))
				M.Stun(2)
				spawn(30)
					M.Weaken(2)
		if(dose >= 10 || M.toxloss >= 25) //Internal skeletal tubes are rupturing, allowing the chemical to breach them.
			M.adjustToxLoss(removed * 4)
			M.make_jittery(5)
		if(dose >= 20 || M.toxloss >= 60) //Core disentigration, cellular mass begins treating itself as an enemy, while maintaining regeneration. Slime-cancer.
			M.adjustBrainLoss(2 * removed)
			M.adjust_nutrition(-20)
		if(M.bruteloss >= 60 && M.toxloss >= 60 && M.brainloss >= 30) //Total Structural Failure. Limbs start splattering.
			var/obj/item/organ/external/O = pick(H.organs)
			if(prob(20) && !istype(O, /obj/item/organ/external/chest/unbreakable/slime) && !istype(O, /obj/item/organ/external/groin/unbreakable/slime))
				to_chat(M, span_critical("You feel your [O] begin to dissolve, before it sloughs from your body."))
				O.droplimb() //Splat.
		return

	//Based roughly on Levofloxacin's rather severe side-effects
	if(prob(20))
		M.Confuse(5)
	if(prob(20))
		M.Weaken(5)
	if(prob(20))
		M.make_dizzy(5)
	if(prob(20))
		M.hallucination = max(M.hallucination, 10)

	//One of the levofloxacin side effects is 'spontaneous tendon rupture', which I'll immitate here. 1:1000 chance, so, pretty darn rare.
	if(ishuman(M) && rand(1,10000) == 1) //VOREStation Edit (more rare)
		var/obj/item/organ/external/eo = pick(H.organs) //Misleading variable name, 'organs' is only external organs
		eo.fracture()

/datum/reagent/spacomycaze
	name = REAGENT_SPACOMYCAZE
	id = REAGENT_ID_SPACOMYCAZE
	description = "An all-purpose painkilling antibiotic gel."
	taste_description = "oil"
	reagent_state = SOLID
	color = "#C1C1C8"
	metabolism = REM * 0.4
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	data = 0
	can_overdose_touch = TRUE

/datum/reagent/spacomycaze/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 10 * M.species.chem_strength_pain)
	M.adjustToxLoss(3 * removed)

/datum/reagent/spacomycaze/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.8)

/datum/reagent/spacomycaze/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, span_notice("The itching fades..."))
		else
			var/delay = (2 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, span_warning("Your skin itches."))

	M.add_chemical_effect(CE_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)
	M.add_chemical_effect(CE_PAINKILLER, 20 * M.species.chem_strength_pain) // 5 less than paracetamol.

/datum/reagent/spacomycaze/touch_obj(var/obj/O)
	..()
	if(istype(O, /obj/item/stack/medical/crude_pack) && round(volume) >= 1)
		var/obj/item/stack/medical/crude_pack/C = O
		var/packname = C.name
		var/to_produce = min(C.get_amount(), round(volume))

		var/obj/item/stack/medical/M = C.upgrade_stack(to_produce)

		if(M && M.get_amount())
			holder.my_atom.visible_message(span_infoplain(span_bold("\The [packname]") + " bubbles."))
			remove_self(to_produce)

/datum/reagent/sterilizine
	name = REAGENT_STERILIZINE
	id = REAGENT_ID_STERILIZINE
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5

/datum/reagent/sterilizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed)
		M.adjustToxLoss(2 * removed)
	return

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed)
		M.adjustToxLoss(2 * removed)

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	..()
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	..()
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

	//VOREstation edit. Floor polishing.
	if(istype(T, /turf/simulated))
		var/turf/simulated/S = T
		S.dirt = -50
	//VOREstation edit end

/datum/reagent/sterilizine/touch_mob(var/mob/living/L, var/amount)
	..()
	if(istype(L))
		if(istype(L, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = L
			S.adjustToxLoss(rand(15, 25) * amount)	// Does more damage than water.
			S.visible_message(span_warning("[S]'s flesh sizzles where the fluid touches it!"), span_danger("Your flesh burns in the fluid!"))
		remove_self(amount)

/datum/reagent/leporazine
	name = REAGENT_LEPORAZINE
	id = REAGENT_ID_LEPORAZINE
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/temp = 310
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		temp = H.species.body_temperature
	if(M.bodytemperature > temp)
		M.bodytemperature = max(temp, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < temp+1)
		M.bodytemperature = min(temp, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/rezadone
	name = REAGENT_REZADONE
	id = REAGENT_ID_REZADONE
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	overdose_mod = 2
	scannable = 1

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/mob/living/carbon/human/H = M
	if(alien == IS_SLIME && istype(H))
		if(prob(50))
			if(H.r_skin)
				H.r_skin = round((H.r_skin + 50)/2)
			if(H.r_hair)
				H.r_hair = round((H.r_hair + 50)/2)
			if(H.r_facial)
				H.r_facial = round((H.r_facial + 50)/2)
		if(prob(50))
			if(H.g_skin)
				H.g_skin = round((H.g_skin + 50)/2)
			if(H.g_hair)
				H.g_hair = round((H.g_hair + 50)/2)
			if(H.g_facial)
				H.g_facial = round((H.g_facial + 50)/2)
		if(prob(50))
			if(H.b_skin)
				H.b_skin = round((H.b_skin + 50)/2)
			if(H.b_hair)
				H.b_hair = round((H.b_hair + 50)/2)
			if(H.b_facial)
				H.b_facial = round((H.b_facial + 50)/2)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

// This exists to cut the number of chemicals a merc borg has to juggle on their hypo.
/datum/reagent/healing_nanites
	name = REAGENT_HEALINGNANITES
	id = REAGENT_ID_HEALINGNANITES
	description = "Miniature medical robots that swiftly restore bodily damage."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#555555"
	metabolism = REM * 4 // Nanomachines gotta go fast.
	scannable = 1
	affects_robots = TRUE

/datum/reagent/healing_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustOxyLoss(-4 * removed)
	M.adjustToxLoss(-2 * removed)
	M.adjustCloneLoss(-2 * removed)

/datum/reagent/menthol
	name = REAGENT_MENTHOL
	id = REAGENT_ID_MENTHOL
	description = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#80af9c"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/earthsblood
	name = REAGENT_EARTHSBLOOD
	id = REAGENT_ID_EARTHSBLOOD
	description = "A rare plant extract with immense, almost magical healing capabilities. Induces a potent psychoactive state, damaging neurons with prolonged use."
	taste_description = "honey and sunlight"
	reagent_state = LIQUID
	color = "#ffb500"
	overdose = REAGENTS_OVERDOSE * 0.50


/datum/reagent/earthsblood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage (4 * removed, 4 * removed)
	M.adjustOxyLoss(-10 * removed)
	M.adjustToxLoss(-4 * removed)
	M.adjustCloneLoss(-2 * removed)
	M.druggy = max(M.druggy, 20)
	M.hallucination = max(M.hallucination, 3)
	M.adjustBrainLoss(1 * removed) //your life for your mind. The Earthmother's Tithe.
