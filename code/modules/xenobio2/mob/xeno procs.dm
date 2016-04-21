/*
Basic definition of creatures for Xenobiology

Includes:
Proc for metabolism
Proc for mutating
Procs for copying speech, if applicable
Procs for targeting
*/
/mob/living/simple_animal/xeno/proc/ProcessTraits()
	if(maleable >= MAX_MALEABLE)
		maxHealth = traitdat.traits[TRAIT_XENO_HEALTH]
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
	if(!(chromatic))
		hostile = 0	//No. No laser-reflecting hostile creatures. Bad.
	else
		hostile = traitdat.traits[TRAIT_XENO_HOSTILE]
	
	speed = traitdat.traits[TRAIT_XENO_SPEED]
	
	if(traitdat.traits[TRAIT_XENO_CANSPEAK])
		speak_chance = traitdat.traits[TRAIT_XENO_SPEAKCHANCE]
	else
		speak_chance = 0
	
	melee_damage_lower = traitdat.traits[TRAIT_XENO_STRENGTH] - traitdat.traits[TRAIT_XENO_STR_RANGE]
	melee_damage_upper = traitdat.traits[TRAIT_XENO_STRENGTH] + traitdat.traits[TRAIT_XENO_STR_RANGE]
	
	
	
//Metabolism proc, simplified for xenos. Heavily based on botanical metabolism.
/mob/living/simple_animal/xeno/proc/handle_reagents()
	if(!stasis)
		if(!reagents)
			return
		if(reagents.total_volume <= 0)
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
			
			if(reagent_response["toxic"])
				adjustToxLoss(reagent_response["toxic"] * reagent_total)
				
			if(reagent_response["heal"])
				heal_overall_damage(reagent_response["heal"] * reagent_total)
				
			if(reagent_response["nutr"])
				nutrition += reagent_response["nutr"] * reagent_total
				
			if(reagent_response["mut"])
				mut_level += reagent_response["mut"] * reagent_total
			
		temp_chem_holder.reagents.clear_reagents()
		
		return 1 //Everything worked out okay.
			
	return 0
	
/mob/living/simple_animal/xeno/proc/Mutate()
	nameVar = "mutated"
	if((COLORMUT & mutable))
		traitdat.traits[TRAIT_XENO_COLOR] = "#"
		for(var/i=0, i<6, i++)
			traitdat.traits[TRAIT_XENO_COLOR] += pick(hexNums)
			
	traitdat.chems.reagents.clear_reagents()
	for(var/R in default_chems)
		traitdat.chems.reagents.add_reagent("[R]", default_chems[R])
	var/amount_of_chems = rand(1,6)
	for(var/i = 0,i <= amount_of_chems, i++)
		var/datum/reagent/R = pick(xenoChemList)
		traitdat.chems.reagents.add_reagent(R, round(rand(1,10)))
	//if(SPECIESMUT & mutable)
		//Placeholder, currently no xenos that have species mutations.
	RandomizeTraits()
	ProcessTraits()
	return 1
	
/mob/living/simple_animal/xeno/proc/RandomizeTraits()
	return
	
// I'm not positive if this even works, but

/mob/living/simple_animal/xeno/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	log_debug("[src] heard a message.")
	if(traitdat.traits[TRAIT_XENO_CANLEARN])
		var/learned_message = parse_language(message)
		if(!message)
			return
		if(learned_message)	//Is it understood?
			var/language_key = language.key + " "
			var/complete_message = language_key + learned_message
			speech_buffer.Add(complete_message)
			log_debug("Adding [learned_message] to speech_buffer.")
		else
			speech_buffer.Add(message)
			log_debug("Adding [message] to speech_buffer.")
	..(message,verb,language,alt_name,italics,speaker)

/mob/living/simple_animal/xeno/proc/ProcessSpeechBuffer()
	if(speech_buffer.len)
		if(prob(traitdat.traits[TRAIT_XENO_LEARNCHANCE]) && traitdat.traits[TRAIT_XENO_CANLEARN])
			var/chosen = pick(speech_buffer)
			speak.Add(chosen)
			log_debug("Added [chosen] to speak list.")
		log_debug("Speechlist cut.")
		speech_buffer.Cut()
//
/mob/living/simple_animal/xeno/proc/BuildReagentLists()
	return
	
/mob/living/simple_animal/xeno/attacked_with_item(var/obj/item/O, var/mob/user)
	//Shamelessly stolen from ablative armor.
	if((traitdat.traits[TRAIT_XENO_CHROMATIC]) && istype(O, /obj/item/projectile/beam))
		var/obj/item/projectile/P = O
		visible_message("<span class='danger')\The beam reflects off of the [src]!</span>")
		// Find a turf near or on the original location to bounce to
		var/new_x = P.starting.x + pick(0, -1, 1, -2, 2)
		var/new_y = P.starting.y + pick(0, -1, 1, -2, 2)
		var/turf/curloc = get_turf(user)

		// redirect the projectile
		P.redirect(new_x, new_y, curloc, user)
		return
	else
		..()
		

