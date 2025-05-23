/datum/disease/lycan
	name = "Lycancoughy"
	form = "Infection"
	max_stages = 4
	spread_text = "On contact"
	spread_flags = CONTACT_GENERAL
	cure_text = REAGENT_ETHANOL
	cures = list(REAGENT_ID_ETHANOL)
	agent = "Excess Snuggles"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/human/monkey)
	desc = "If left untreated subject will regurgitate... puppies."
	severity = HARMFUL
	var/barklimit
	var/list/puppy_types = list(/mob/living/simple_mob/animal/passive/dog/corgi/puppy)
	var/list/plush_types = list(/obj/item/toy/plushie/orange_fox, /obj/item/toy/plushie/corgi, /obj/item/toy/plushie/robo_corgi, /obj/item/toy/plushie/pink_fox)

/datum/disease/lycan/stage_act()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = affected_mob

	switch(stage)
		if(2)
			if(prob(2))
				H.emote("cough")
			if(prob(3))
				to_chat(H, span_notice("You itch."))
				H.adjustBruteLoss(rand(4, 6))
		if(3)
			var/obj/item/organ/external/stomach = H.organs_by_name[pick("torso", "groin")]

			if(prob(3))
				H.emote("cough")
				stomach.take_damage(BRUTE, rand(0, 5))
			if(prob(3))
				to_chat(H, span_notice("You hear a faint barking."))
				stomach.take_damage(BRUTE, rand(4, 6))
			if(prob(2))
				to_chat(H, span_notice("You crave meat."))
			if(prob(3))
				to_chat(H, span_danger("Your stomach growls!"))
				stomach.take_damage(BRUTE, rand(5, 10))
		if(4)
			var/obj/item/organ/external/stomach = H.organs_by_name[pick("torso", "groin")]

			if(prob(5))
				H.emote("cough")
				stomach.take_damage(BRUTE, rand(0, 5))
			if(prob(5))
				H.emote("awoo2")
				H.Confuse(rand(12, 16))
				stomach.take_damage(rand(0, 5))
			if(prob(5))
				if(!barklimit)
					to_chat(H, span_danger("Your stomach growls!"))
					stomach.take_damage(BRUTE, rand(5, 10))
				else
					var/atom/hairball = pick(prob(50) ? puppy_types : plush_types)
					H.visible_message(span_danger("[H] coughs up \a [initial(hairball.name)]!"), span_userdanger("You cough up \a [initial(hairball.name)]?!"))
					H.emote("cough")
					new hairball(H.loc)
					barklimit--
					stomach.take_damage(BRUTE, rand(10, 15))
