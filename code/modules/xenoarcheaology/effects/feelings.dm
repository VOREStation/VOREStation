/// Verified to work with the Artifact Harvester
#define GOOD_FEELING 1
#define BAD_FEELING 2
#define CANNIBAL_FEELING 3
/datum/artifact_effect/feelings
	name = "Feelings"
	effect_type = EFFECT_FEELINGS
	var/feeling_type = 1 //If we're good, bad, or cannibalistic feelings. Defaults to good. Changed in init.
	var/list/messages = list()

	var/list/drastic_messages = list()

	effect_state = "summoning"
	effect_color = "#69008f"

/datum/artifact_effect/feelings/New()
	..()
	feeling_type = pick(GOOD_FEELING, BAD_FEELING, CANNIBAL_FEELING)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA, EFFECT_PULSE)
	switch(feeling_type)
		if(GOOD_FEELING)
			messages = list("You feel good.",
				"Everything seems to be going alright",
				"You've got a good feeling about this",
				"Your instincts tell you everything is going to be getting better.",
				"There's a good feeling in the air.",
				"Something smells... good.",
				"The tips of your fingers feel tingly.",
				"You've got a good feeling about this.",
				"You feel happy.",
				"You fight the urge to smile.",
				"Your scalp prickles.",
				"All the colours seem a bit more vibrant.",
				"Everything seems a little lighter.",
				"The troubles of the world seem to fade away.")

			drastic_messages = list("You want to hug everyone you meet!",
				"Everything is going so well!",
				"You feel euphoric.",
				"You feel giddy.",
				"You're so happy suddenly, you almost want to dance and sing.",
				"You feel like the world is out to help you.")
		if(BAD_FEELING)
			messages = list("You feel worried.",
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
				"Something is wrong")

			drastic_messages = list("You've got to get out of here!",
				"Someone's trying to kill you!",
				"There's something out there!",
				"What's happening to you?",
				"OH GOD!",
				"HELP ME!")
		else
			messages = list("You feel peckish.",
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

			drastic_messages = list("They look delicious.",
				"They'll take what's yours!",
				"They're full of meat.",
				"What's happening to you?",
				"Butcher them!",
				"Feast!")



/datum/artifact_effect/feelings/DoEffectTouch(var/mob/user)
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(prob(50))
				if(prob(75))
					to_chat(H, span_red(span_bold("<font size='[num2text(rand(1,5))]'>[pick(drastic_messages)]") + "</font>"))
				else
					to_chat(H, span_red("[pick(messages)]"))

			if(prob(50))
				H.dizziness += rand(3,5)
				if(feeling_type == CANNIBAL_FEELING)
					H.nutrition = H.nutrition / 1.5

/datum/artifact_effect/feelings/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(5))
				if(prob(75))
					to_chat(H, span_red("[pick(messages)]"))
				else
					to_chat(H, span_red("<font size='[num2text(rand(1,5))]'> " + span_bold("[pick(drastic_messages)]") + " </font>"))

				if(prob(10))
					H.dizziness += rand(3,5)
					if(feeling_type == CANNIBAL_FEELING)
						H.nutrition = H.nutrition / 2
		return 1

/datum/artifact_effect/feelings/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(50))
				if(prob(95))
					to_chat(H, span_red("<font size='[num2text(rand(1,5))]'> " + span_bold("[pick(drastic_messages)]") + " </font>"))
				else
					to_chat(H, span_red("[pick(messages)]"))

			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
				if(feeling_type == CANNIBAL_FEELING)
					H.nutrition = H.nutrition / 4
		return 1

#undef GOOD_FEELING
#undef BAD_FEELING
#undef CANNIBAL_FEELING
