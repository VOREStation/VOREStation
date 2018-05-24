/obj/item/organ/internal/brain/slime
	flags = OPENCONTAINER

/obj/item/organ/internal/brain/slime/New()
	..()
	create_reagents(50)

/obj/item/organ/internal/brain/slime/proc/reviveBody()
	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna = brainmob.dna
	R.ckey = brainmob.ckey
	R.id = copytext(md5(brainmob.real_name), 2, 6)
	R.name = R.dna.real_name
	R.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages = brainmob.languages
	R.flavor = list()
	for(var/datum/modifier/mod in brainmob.modifiers)
		if(mod.flags & MODIFIER_GENETIC)
			R.genetic_modifiers.Add(mod.type)

	var/datum/mind/clonemind = brainmob.mind

	if(!istype(clonemind, /datum/mind))	//not a mind
		return 0
	if(clonemind.current && clonemind.current.stat != DEAD)	//mind is associated with a non-dead body
		return 0
	if(clonemind.active)	//somebody is using that mind
		if(ckey(clonemind.key) != R.ckey)
			return 0
	else
		for(var/mob/observer/dead/G in player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return 0

	for(var/modifier_type in R.genetic_modifiers)	//Can't be revived. Probably won't happen...?
		if(istype(modifier_type, /datum/modifier/no_clone))
			return 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(get_turf(src), R.dna.species)

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna

	H.UpdateAppearance()
	H.sync_organ_dna()
	if(!R.dna.real_name)	//to prevent null names
		R.dna.real_name = "promethean ([rand(0,999)])"
	H.real_name = R.dna.real_name

	H.nutrition = 260 //Enough to try to regenerate ONCE.
	H.adjustBruteLoss(40)
	H.adjustFireLoss(40)
	H.Paralyse(4)
	H.updatehealth()
	for(var/obj/item/organ/external/E in H.organs) //They've still gotta congeal, but it's faster than the clone sickness they'd normally get.
		if(E && E.organ_tag == BP_L_ARM || E.organ_tag == BP_R_ARM || E.organ_tag == BP_L_LEG || E.organ_tag == BP_R_LEG)
			E.removed()
			qdel(E)
			E = null
	H.regenerate_icons()
	clonemind.transfer_to(H)
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	for(var/datum/language/L in R.languages)
		H.add_language(L.name)
	H.flavor_texts = R.flavor.Copy()
	qdel(src)
	return 1

/datum/chemical_reaction/promethean_brain_revival
	name = "Promethean Revival"
	id = "prom_revival"
	result = null
	required_reagents = list("phoron" = 40)
	result_amount = 1

/datum/chemical_reaction/promethean_brain_revival/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/organ/internal/brain/slime))
		return ..()
	return FALSE

/datum/chemical_reaction/promethean_brain_revival/on_reaction(var/datum/reagents/holder)
	var/obj/item/organ/internal/brain/slime/brain = holder.my_atom
	if(brain.reviveBody())
		brain.visible_message("<span class='notice'>[brain] bubbles, surrounding itself with a rapidly expanding mass of slime!</span>")
	else
		brain.visible_message("<span class='warning'>[brain] shifts strangely, but falls still.</span>")