/decl/emote/audible/belch
	key = "belch"
	emote_message_3p = "belches."
	message_type = AUDIBLE_MESSAGE

/decl/emote/audible/belch/get_emote_sound(var/atom/user)
	return list(
			"sound" = sound(get_sfx("belches")),
			"vol" = emote_volume / 2
		)
