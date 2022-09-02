/datum/artifact_effect/badfeeling
	name = "badfeeling"
	effect_type = EFFECT_PSIONIC
	effect_state = "summoning"
	effect_color = "#643232"
	var/list/messages = list(
		"You feel worried.",
		"Something doesn't feel right.",
		"You get a strange feeling in your gut.",
		"Your instincts are trying to warn you about something.",
		"Someone just walked over your grave.",
		"There's a strange feeling in the air.",
		"There's a strange smell in the air.",
		"The tips of your fingers feel tingly.",
		"You feel witchy.",
		"You have a terrible sense of foreboding.",
		"You've got a bad feeling about this.",
		"Your scalp prickles.",
		"The light seems to flicker.",
		"The shadows seem to lengthen.",
		"The walls are getting closer.",
		"Something is wrong."
	)
	var/list/drastic_messages = list(
		"You've got to get out of here!",
		"Someone's trying to kill you!",
		"There's something out there!",
		"What's happening to you?",
		"OH GOD!",
		"HELP ME!"
	)


<<<<<<< HEAD
/datum/artifact_effect/badfeeling/DoEffectTouch(var/mob/user)
	if(user)
=======
/datum/artifact_effect/common/badfeeling/DoEffectTouch(mob/living/user)
	if (user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if (prob(50))
				if (prob(75))
					to_chat(H, "<b><font color='red' size='[num2text(rand(1,5))]'>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<font color='red'>[pick(messages)]</font>")
			if (prob(50))
				H.dizziness += rand(3,5)

<<<<<<< HEAD
/datum/artifact_effect/badfeeling/DoEffectAura()
=======

/datum/artifact_effect/common/badfeeling/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if (prob(5))
				if (prob(75))
					to_chat(H, "<font color='red'>[pick(messages)]</font>")
				else
					to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
			if (prob(10))
				H.dizziness += rand(3,5)


/datum/artifact_effect/badfeeling/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if (prob(50))
				if (prob(95))
					to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<font color='red'>[pick(messages)]</font>")
			if (prob(50))
				H.dizziness += rand(3,5)
			else if (prob(25))
				H.dizziness += rand(5,15)
