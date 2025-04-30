/decl/emote/audible/scream/get_emote_sound(var/atom/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/vol = H.species.scream_volume
		return list(
				"sound" = get_species_sound(get_gendered_sound(H))["scream"],
				"vol" = vol,
				"exr" = 20,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)

/decl/emote/audible/malehumanscream
	key = "malehumanscream"
	emote_message_3p = "screams!"
	emote_sound = 'sound/voice/malescream_2.ogg'
