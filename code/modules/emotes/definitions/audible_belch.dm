/decl/emote/audible/belch
	key = "belch"
	emote_message_3p = "belches."
	message_type = AUDIBLE_MESSAGE
	sound_preferences = list(/datum/preference/toggle/emote_noises, /datum/preference/toggle/belch_noises)

/decl/emote/audible/belch/get_emote_sound(var/atom/user)
	return list(
			"sound" = SFX_BELCHES,
			"vol" = emote_volume / 2
		)
