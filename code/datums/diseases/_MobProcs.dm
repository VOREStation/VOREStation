/mob/proc/HasDisease(datum/disease/D)
	for(var/thing in GetViruses())
		var/datum/disease/DD = thing
		if(DD.IsSame(D))
			return TRUE
	return FALSE

/mob/proc/CanContractDisease(datum/disease/D)
	if(stat == DEAD && !D.allow_dead)
		return FALSE

	if(D.GetDiseaseID() in GetResistances())
		return FALSE

	if(HasDisease(D))
		return FALSE

	if(istype(D, /datum/disease/advance) && count_by_type(GetViruses(), /datum/disease/advance) > 0)
		return FALSE

	if(!(type in D.viable_mobtypes))
		return -1

	if(isSynthetic())
		if(D.infect_synthetics)
			return TRUE
		return FALSE

	return TRUE

/mob/proc/ContractDisease(datum/disease/D)
	if(!CanContractDisease(D))
		return 0
	AddDisease(D)
	return TRUE

/mob/proc/AddDisease(datum/disease/D, respect_carrier = FALSE)
	var/datum/disease/DD = new D.type(1, D, 0)
	viruses += DD
	DD.affected_mob = src
	active_diseases += DD

	var/list/skipped = list("affected_mob", "holder", "carrier", "stage", "type", "parent_type", "vars", "transformed")
	if(respect_carrier)
		skipped -= "carrier"
	for(var/V in DD.vars)
		if(V in skipped)
			continue
		if(istype(DD.vars[V],/list))
			var/list/L = D.vars[V]
			DD.vars[V] = L.Copy()
		else
			DD.vars[V] = D.vars[V]

	log_admin("[key_name(usr)] has contracted the virus \"[DD]\"")

/mob/living/carbon/ContractDisease(datum/disease/D)
	if(!CanContractDisease(D))
		return 0

	var/obj/item/clothing/Cl = null
	var/passed = 1

	var/head_ch = 100
	var/body_ch = 100
	var/hands_ch = 25
	var/feet_ch = 25

	if(D.spread_flags & CONTACT_HANDS)
		head_ch = 0
		body_ch = 0
		hands_ch = 100
		feet_ch = 0
	if(D.spread_flags & CONTACT_FEET)
		head_ch = 0
		body_ch = 0
		hands_ch = 0
		feet_ch = 100

	if(prob(15/D.permeability_mod))
		return

	if(nutrition > 300 && prob(nutrition/10))
		return

	var/list/zone_weights = list(
		1 = head_ch,
		2 = body_ch,
		3 = hands_ch,
		4 = feet_ch
		)

	var/target_zone = pick(zone_weights)

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		switch(target_zone)
			if(1)
				if(isobj(H.head) && !istype(H.head, /obj/item/paper))
					Cl = H.head
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.wear_mask))
					Cl = H.wear_mask
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(2)
				if(isobj(H.wear_suit))
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.w_uniform))
					Cl = H.w_uniform
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(3)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered & HANDS)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.gloves))
					Cl = H.gloves
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(4)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered & FEET)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.shoes))
					Cl = H.shoes
					passed = prob((Cl.permeability_coefficient*100) - 1)
	if(!passed && (D.spread_flags & AIRBORNE) && !internal)
		passed = (prob((50*D.permeability_mod) -1))

	if(passed)
		AddDisease(D)
	return passed

/mob/proc/ForceContractDisease(datum/disease/D, respect_carrier)
	if(!CanContractDisease(D))
		return FALSE

	AddDisease(D, respect_carrier)
	return TRUE

/mob/living/carbon/human/CanContractDisease(datum/disease/D)
	if(species.virus_immune && !D.bypasses_immunity)
		return FALSE

	for(var/organ in D.required_organs)
		if(locate(organ) in internal_organs)
			continue
		if(locate(organ) in organs)
			continue
		return FALSE
	return ..()

/mob/living/carbon/human/monkey/CanContractDisease(datum/disease/D)
	. = ..()
	if(. == -1)
		if(D.viable_mobtypes.Find(/mob/living/carbon/human))
			return 1

/mob/living/proc/handle_diseases()
	return

/mob/proc/GetViruses()
	LAZYINITLIST(viruses)
	return viruses

/mob/proc/GetResistances()
	LAZYINITLIST(resistances)
	return resistances

/client/proc/ReleaseVirus()
	set category = "Fun.Event Kit"
	set name = "Release Virus"
	set desc = "Release a pre-set virus."

	if(!is_admin())
		return FALSE

	var/datum/disease/D = tgui_input_list(usr, "Choose virus", "Viruses", subtypesof(/datum/disease), subtypesof(/datum/disease))
	var/mob/living/carbon/human/H = null

	if(isnull(D))
		return FALSE

	for(var/thing in shuffle(human_mob_list))
		H = thing
		if(H.stat == DEAD)
			continue
		if(!H.HasDisease(D))
			H.ForceContractDisease(D)
			break

	message_admins("[key_name_admin(usr)] has triggered a virus outbreak of [D.name]! Affected mob: [key_name_admin(H)]")
	log_admin("[key_name_admin(usr)] infected [key_name_admin(H)] with [D.name]")
