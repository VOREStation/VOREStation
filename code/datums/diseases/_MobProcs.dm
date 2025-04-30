/mob/proc/HasDisease(datum/disease/D)
	for(var/thing in GetViruses())
		var/datum/disease/DD = thing
		if(DD.IsSame(D))
			return TRUE
	return FALSE

/mob/proc/RemoveDisease(datum/disease/D)
	viruses -= D
	return TRUE

/mob/proc/HasResistance(resistance)
	if(resistances.Find(resistance))
		return TRUE
	return FALSE

/mob/proc/IsInfected()
	if(isemptylist(GetViruses()))
		return FALSE
	return TRUE

/mob/proc/CanContractDisease(datum/disease/D)
	if(stat == DEAD && !global_flag_check(D.virus_modifiers, SPREAD_DEAD))
		return FALSE

	if(D.GetDiseaseID() in GetResistances())
		return FALSE

	if(HasDisease(D))
		return FALSE

	if(istype(D, /datum/disease/advance) && count_by_type(GetViruses(), /datum/disease/advance) > 0)
		return FALSE

	var/compatible_type = FALSE
	for(var/type_to_test in D.viable_mobtypes)
		if(ispath(type, type_to_test))
			compatible_type = TRUE
			break
	if(!compatible_type)
		return FALSE

	if(isSynthetic())
		if(global_flag_check(D.virus_modifiers, INFECT_SYNTHETICS))
			return TRUE
		return FALSE

	return TRUE

/mob/proc/ContractDisease(datum/disease/D, var/target_zone)
	if(!CanContractDisease(D))
		return 0
	AddDisease(D)
	return TRUE

/mob/proc/AddDisease(datum/disease/D, respect_carrier = FALSE)
	var/datum/disease/DD = new D.type(1, D, 0)
	DD.start_cure_timer()
	viruses += DD
	DD.affected_mob = src
	GLOB.active_diseases += DD

	var/list/skipped = list("affected_mob", "holder", "carrier", "stage", "type", "parent_type", "vars", "transformed", "_active_timers")
	if(respect_carrier)
		skipped -= "carrier"
	for(var/V in DD.vars)
		if(V in skipped)
			continue
		if(istype(DD.vars[V],/list))
			var/list/L = D.vars[V]
			if(islist(L))
				DD.vars[V] = L.Copy()
		else
			DD.vars[V] = D.vars[V]

	log_admin("[key_name(src)] has contracted the virus \"[DD]\"")

/mob/living/carbon/human/ContractDisease(datum/disease/D, target_zone)
	if(!CanContractDisease(D))
		return FALSE

	var/obj/item/clothing/Cl = null
	var/passed = TRUE

	var/head_chance = 80
	var/body_chance = 100
	var/hands_chance = 35/2
	var/feet_chance = 15/2

	if(prob(15/D.permeability_mod))
		return

	if(nutrition > 300 && prob(nutrition/50))
		return

	if(!target_zone)
		target_zone = pick(list(
			BP_HEAD = head_chance,
			BP_TORSO = body_chance,
			BP_R_HAND = hands_chance,
			BP_L_HAND = hands_chance,
			BP_R_FOOT = feet_chance,
			BP_L_FOOT = feet_chance
		))
	else
		target_zone = check_zone(target_zone)

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		switch(target_zone)
			if(BP_HEAD)
				if(isobj(H.head) && !istype(H.head, /obj/item/paper))
					Cl = H.head
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.wear_mask))
					Cl = H.wear_mask
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(BP_TORSO)
				if(isobj(H.wear_suit))
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.w_uniform))
					Cl = H.w_uniform
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(BP_L_HAND, BP_R_HAND)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered & HANDS)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.gloves))
					Cl = H.gloves
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(BP_L_FOOT, BP_R_FOOT)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered & FEET)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.shoes))
					Cl = H.shoes
					passed = prob((Cl.permeability_coefficient*100) - 1)

	if(passed)
		AddDisease(D)

/mob/living/proc/AirborneContractDisease(datum/disease/D, force_spread)
	if(((D.spread_flags & DISEASE_SPREAD_AIRBORNE) || force_spread) && prob(50*D.spreading_modifier) - 1)
		ForceContractDisease(D)

/mob/living/carbon/AirborneContractDisease(datum/disease/D, force_spread)
	if(internal)
		return
	if(mNobreath in mutations)
		return
	..()

/mob/proc/ForceContractDisease(datum/disease/D, respect_carrier)
	if(!CanContractDisease(D))
		return FALSE

	AddDisease(D, respect_carrier)
	return TRUE

/mob/living/carbon/human/CanContractDisease(datum/disease/D)
	for(var/organ in D.required_organs)
		if(!((locate(organ) in organs) || (locate(organ) in internal_organs)))
			return FALSE

	if(species.virus_immune && !global_flag_check(D.virus_modifiers, BYPASSES_IMMUNITY))
		D.virus_modifiers |= CARRIER
	else
		D.virus_modifiers &= ~CARRIER

	return ..()

/mob/living/carbon/human/monkey/CanContractDisease(datum/disease/D)
	. = ..()
	if(. == -1)
		if(D.viable_mobtypes.Find(/mob/living/carbon/human))
			return

/mob/living/proc/CanSpreadAirborneDisease()
	return !is_mouth_covered()

/mob/living/proc/handle_diseases()
	return

/mob/proc/GetViruses()
	LAZYINITLIST(viruses)
	return viruses

/mob/proc/GetSpreadableViruses()
	LAZYINITLIST(viruses)
	var/list/viruses_to_return = list()
	for(var/datum/disease/D in viruses)
		if(D.spread_flags & (DISEASE_SPREAD_SPECIAL | DISEASE_SPREAD_NON_CONTAGIOUS))
			continue
		viruses_to_return += D
	return viruses_to_return

/mob/proc/GetResistances()
	LAZYINITLIST(resistances)
	return resistances

/mob/proc/AddResistances(var/list/resistance)
	LAZYINITLIST(resistances)
	resistances |= resistance
	return TRUE

/client/proc/ReleaseVirus()
	set category = "Fun.Event Kit"
	set name = "Release Virus"
	set desc = "Release a pre-set virus."

	if(!check_rights(R_FUN|R_EVENT))
		return FALSE

	var/disease = tgui_input_list(usr, "Choose virus", "Viruses", subtypesof(/datum/disease), subtypesof(/datum/disease))

	if(isnull(disease))
		return FALSE

	var/mob/living/carbon/human/H = tgui_input_list(usr, "Choose infectee", "Characters", human_mob_list)

	if(isnull(H))
		return FALSE

	var/datum/disease/D = new disease

	if(!H.HasDisease(D))
		H.ForceContractDisease(D)

		message_admins("[key_name_admin(usr)] has triggered a virus outbreak of [D.name]! Affected mob: [key_name_admin(H)]")
		log_admin("[key_name_admin(usr)] infected [key_name_admin(H)] with [D.name]")

		if(!GLOB.archive_diseases[D.GetDiseaseID()])
			GLOB.archive_diseases[D.GetDiseaseID()] = D

		return TRUE
