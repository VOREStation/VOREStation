/decl/emote/audible/pain
	key = "pain"
	emote_message_1p = "You yell in pain!"
	emote_message_3p = "yells in pain!"

/decl/emote/audible/pain/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		return "You [pick(H.species.pain_verb_1p)] in pain!"
	else
		var/mob/living/M = user
		if(M.pain_emote_1p) // Sanity
			return "You [pick(M.pain_emote_1p)]!"
	. = ..()

/decl/emote/audible/pain/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		return "[pick(H.species.pain_verb_3p)] in pain!"
	else
		var/mob/living/M = user
		if(M.pain_emote_3p) // Sanity
			return "[pick(M.pain_emote_3p)]!"
	. = ..()

/decl/emote/audible/pain/get_emote_sound(var/atom/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/vol = H.species.pain_volume
		return list(
				"sound" = get_species_sound(get_gendered_sound(H))["pain"],
				"vol" = vol,
				"exr" = 20,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)
	else
		var/mob/living/M = user
		return list(
				"sound" = get_species_sound(get_gendered_sound(M))["pain"],
				"vol" = 50,
				"exr" = 20,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)
