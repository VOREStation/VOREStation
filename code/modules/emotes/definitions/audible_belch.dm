/decl/emote/audible/belch
	key = "belch"
	emote_message_3p = "belches."
	message_type = AUDIBLE_MESSAGE
	sound_preferences = list(/datum/client_preference/emote_noises,/datum/client_preference/belch_noises)

/decl/emote/audible/belch/get_emote_sound(var/atom/user)
	return list(
			"sound" = sound(get_sfx("belches")),
			"vol" = emote_volume / 2
		)
