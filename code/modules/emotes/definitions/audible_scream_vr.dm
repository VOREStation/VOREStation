/decl/emote/audible/scream/get_emote_sound(var/atom/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_gender() == FEMALE)
			return list(
				"sound" = H.species.female_scream_sound,
				"vol" = emote_volume
			)
		else
			return list(
				"sound" = H.species.male_scream_sound,
				"vol" = emote_volume
			)
