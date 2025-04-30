/decl/emote/audible/scream
	key = "scream"
	emote_message_1p = "You scream!"
	emote_message_3p = "screams!"

/decl/emote/audible/scream/get_emote_sound(var/atom/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/vol = H.species.scream_volume
		return list(
				"sound" = get_species_sound(get_gendered_sound(H))["scream"],
				"vol" = vol,
				"exr" = 20,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)

/decl/emote/audible/scream/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		return "You [H.species.scream_verb_1p]!"
	. = ..()

/decl/emote/audible/scream/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		return "[H.species.scream_verb_3p]!"
	. = ..()
