/datum/artifact_effect/cannibalfeeling
	name = "cannibalfeeling"
	effect_type = EFFECT_PSIONIC
	var/list/messages = list("You feel peckish.",
		"Something doesn't feel right.",
		"You get a strange feeling in your gut.",
		"You feel particularly hungry.",
		"You taste blood.",
		"There's a strange feeling in the air.",
		"There's a strange smell in the air.",
		"The tips of your fingers feel tingly.",
		"You feel twitchy.",
		"You feel empty.",
		"You've got a good feeling about this.",
		"Your tongue prickles.",
		"Are they clean?",
		"You feel weak.",
		"The ground is getting closer.",
		"Something is missing.")

	var/list/drastic_messages = list("They look delicious.",
		"They'll take what's yours!",
		"They're full of meat.",
		"What's happening to you?",
		"Butcher them!",
		"Feast!")

	effect_state = "summoning"
	effect_color = "#c50303"

/datum/artifact_effect/cannibalfeeling/DoEffectTouch(var/mob/user)
	if(user)
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.is_sentient())
				if(prob(50))
					if(prob(75))
						to_chat(H, "<b><font color='red' size='[num2text(rand(1,5))]'>[pick(drastic_messages)]</b></font>")
					else
						to_chat(H, "<font color='red'>[pick(messages)]</font>")

				if(prob(50))
					H.dizziness += rand(3,5)
					H.nutrition = H.nutrition / 1.5

/datum/artifact_effect/cannibalfeeling/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(H.is_sentient())
				if(prob(5))
					if(prob(75))
						to_chat(H, "<font color='red'>[pick(messages)]</font>")
					else
						to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")

				if(prob(10))
					H.dizziness += rand(3,5)
					H.nutrition = H.nutrition / 2
		return 1

/datum/artifact_effect/cannibalfeeling/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(H.is_sentient())
				if(prob(50))
					if(prob(95))
						to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
					else
						to_chat(H, "<font color='red'>[pick(messages)]</font>")

				if(prob(50))
					H.dizziness += rand(3,5)
				else if(prob(25))
					H.dizziness += rand(5,15)
					H.nutrition = H.nutrition / 4
		return 1
