/*
Basic definition of creatures for Xenobiology

Includes:
Proc for metabolism
Proc for mutating
Procs for copying speech, if applicable
Procs for targeting
Divergence proc, used in mutation to make unique datums.
*/
/mob/living/simple_mob/xeno/proc/ProcessTraits()
	if(maleable >= MAX_MALEABLE)
		maxHealth = traitdat.get_trait(TRAIT_XENO_HEALTH)
		health = maxHealth
		if(traitdat.chemlist.len)	//Let's make sure that this has a length.
			chemreact = traitdat.chemlist
		else
			traitdat.chemlist = chemreact
		chromatic = traitdat.traits[TRAIT_XENO_CHROMATIC]
	if(maleable >= MINOR_MALEABLE)
		if(colored)
			color = traitdat.traits[TRAIT_XENO_COLOR]
		speed = traitdat.traits[TRAIT_XENO_SPEED]
		hunger_factor = traitdat.traits[TRAIT_XENO_HUNGER]
		starve_damage = traitdat.traits[TRAIT_XENO_STARVEDAMAGE]
		minbodytemp = T20C - traitdat.traits[TRAIT_XENO_COLDRES]
		maxbodytemp = T20C + traitdat.traits[TRAIT_XENO_HEATRES]

	if(traitdat.traits[TRAIT_XENO_BIOLUMESCENT])
		set_light(traitdat.traits[TRAIT_XENO_GLOW_RANGE], traitdat.traits[TRAIT_XENO_GLOW_STRENGTH], traitdat.traits[TRAIT_XENO_BIO_COLOR])
	else
		set_light(0, 0, "#000000")	//Should kill any light that shouldn't be there.

	hostile = traitdat.traits[TRAIT_XENO_HOSTILE]

	speed = traitdat.traits[TRAIT_XENO_SPEED]

	if(traitdat.traits[TRAIT_XENO_CANSPEAK])
		speak_chance = traitdat.traits[TRAIT_XENO_SPEAKCHANCE]
	else
		speak_chance = 0

	melee_damage_lower = traitdat.get_trait(TRAIT_XENO_STRENGTH) - traitdat.get_trait(TRAIT_XENO_STR_RANGE)
	melee_damage_upper = traitdat.traits[TRAIT_XENO_STRENGTH] + traitdat.get_trait(TRAIT_XENO_STR_RANGE)



//Metabolism proc, simplified for xenos. Heavily based on botanical metabolism.
/mob/living/simple_mob/xeno/proc/handle_reagents()
	if(!stasis)
		if(!reagents)
			return

		//Let's handle some chemical smoke, for scientific smoke bomb purposes.
		for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
			if(smoke.reagents.total_volume)
				smoke.reagents.trans_to_mob(src, 10, CHEM_BLOOD, copy = 1)

		reagents.trans_to_obj(temp_chem_holder, min(reagents.total_volume,rand(1,4)))
		var/reagent_total
		var/list/reagent_response = list()
		for(var/datum/reagent/R in temp_chem_holder.reagents.reagent_list)

			reagent_total = temp_chem_holder.reagents.get_reagent_amount(R.id)

			reagent_response = chemreact[R.id]

			if(!reagent_response)
				continue // just skip this reagent, rather than clearing the whole thing

			if(reagent_response["toxic"])
				adjustToxLoss(reagent_response["toxic"] * reagent_total)

			if(reagent_response["heal"])
				heal_overall_damage(reagent_response["heal"] * reagent_total)

			if(reagent_response["nutr"])
				adjust_nutrition(reagent_response["nutr"] * reagent_total)

			if(reagent_response["mut"])
				mut_level += reagent_response["mut"] * reagent_total

		temp_chem_holder.reagents.clear_reagents()

		return 1 //Everything worked out okay.

	return 0

/mob/living/simple_mob/xeno/proc/diverge()
	var/datum/xeno/traits/newtraits = new()
	newtraits.copy_traits(traitdat)
	return newtraits

/mob/living/simple_mob/xeno/proc/Mutate()
	traitdat = diverge()
	nameVar = "mutated"
	if((COLORMUT & mutable))
		traitdat.traits[TRAIT_XENO_COLOR] = "#"
		for(var/i=0, i<6, i++)
			traitdat.traits[TRAIT_XENO_COLOR] += pick(hexNums)
		traitdat.traits[TRAIT_XENO_BIO_COLOR] = "#"
		for(var/i=0, i<6, i++)
			traitdat.traits[TRAIT_XENO_BIO_COLOR] += pick(hexNums)

	RandomChemicals()
	//if(SPECIESMUT & mutable)
		//Placeholder, currently no xenos that have species mutations.
	RandomizeTraits()
	ProcessTraits()
	return 1

/mob/living/simple_mob/xeno/proc/RandomizeTraits()
	return

/mob/living/simple_mob/xeno/hear_say(var/list/message_pieces, var/verb = "says", var/italics = 0, var/mob/speaker = null)
	if(traitdat.traits[TRAIT_XENO_CANLEARN])
		if(!(message in speak))
			speech_buffer.Add(multilingual_to_message(message_pieces))
	. = ..()

/mob/living/simple_mob/xeno/proc/ProcessSpeechBuffer()
	if(speech_buffer.len)
		if(prob(traitdat.get_trait(TRAIT_XENO_LEARNCHANCE)) && traitdat.get_trait(TRAIT_XENO_CANLEARN))
			var/chosen = pick(speech_buffer)
			speak.Add(chosen)
		/*	Uncoment for logging of speech list.
			log_debug("Added [chosen] to speak list.")
		log_debug("Speechlist cut.") */
		speech_buffer.Cut()
//
/mob/living/simple_mob/xeno/proc/BuildReagentLists()
	return

/mob/living/simple_mob/xeno/bullet_act(var/obj/item/projectile/P)
	//Shamelessly stolen from ablative armor.
	if((traitdat.traits[TRAIT_XENO_CHROMATIC]) && istype(P, /obj/item/projectile/beam))
		visible_message(span_danger(")\The beam reflects off of the [src]!"))
		// Find a turf near or on the original location to bounce to
		var/new_x = P.starting.x + pick(0, -1, 1, -2, 2)
		var/new_y = P.starting.y + pick(0, -1, 1, -2, 2)
		var/turf/curloc = get_turf(src)

		// redirect the projectile
		P.redirect(new_x, new_y, curloc, src)
		P.reflected = 1

		return -1

	else
		..()

/mob/living/simple_mob/xeno/proc/RandomChemicals()
	traitdat.chems.Cut()	//Clear the amount first.

	var/num_chems = round(rand(1,4))
	var/list/chemchoices = xenoChemList

	for(var/i = 1 to num_chems)
		var/chemtype = pick(chemchoices)
		chemchoices -= chemtype
		var/chemamount = rand(1,5)
		traitdat.chems[chemtype] = chemamount

	traitdat.chems += default_chems
