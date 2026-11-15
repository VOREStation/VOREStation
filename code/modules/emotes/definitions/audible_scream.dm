/datum/decl/emote/audible/scream
	key = "scream"
	emote_message_1p = "You scream!"
	emote_message_3p = "screams!"
	emote_message_mute_1p = "You scream silently!"
	emote_message_mute_3p = "screams silently!"

/datum/decl/emote/audible/scream/get_emote_sound(atom/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/vol = H.species.scream_volume
		return list(
				"sound" = get_species_sound(get_gendered_sound(H))["scream"],
				"vol" = vol,
				"exr" = 20,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)

/datum/decl/emote/audible/scream/get_emote_message_1p(atom/user, atom/target, extra_params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_MIND_TRAIT(H, TRAIT_MIMING))
			return emote_message_mute_1p
		return "You [H.species.scream_verb_1p]!"
	. = ..()

/datum/decl/emote/audible/scream/get_emote_message_3p(atom/user, atom/target, extra_params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_MIND_TRAIT(H, TRAIT_MIMING))
			return emote_message_mute_3p
		return "[H.species.scream_verb_3p]!"
	. = ..()
