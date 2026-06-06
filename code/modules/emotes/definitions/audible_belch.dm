/datum/decl/emote/audible/belch
	key = "belch"
	emote_message_3p = "belches."
	emote_message_mute_3p = "acts out a belch."
	message_type = AUDIBLE_MESSAGE
	sound_preferences = list(/datum/preference/toggle/emote_noises, /datum/preference/toggle/belch_noises)

/datum/decl/emote/audible/belch/get_emote_sound(atom/user)
	return list(
			"sound" = sound(get_sfx("belches")),
			"vol" = emote_volume / 2
		)
