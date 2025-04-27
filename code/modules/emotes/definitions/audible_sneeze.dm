/decl/emote/audible/sneeze
	key = "sneeze"
	emote_message_1p = "You sneeze."
	emote_message_3p = "sneezes."
	emote_message_synthetic_1p = "You emit a robotic sneeze."
	emote_message_synthetic_1p_target = "You emit a robotic sneeze towards TARGET."
	emote_message_synthetic_3p = "emits a robotic sneeze."
	emote_message_synthetic_3p_target = "emits a robotic sneeze towards TARGET."

/decl/emote/audible/sneeze/get_emote_sound(var/atom/user)
	if(ishuman(user) && !check_synthetic(user))
		var/mob/living/carbon/human/H = user
		var/vol = H.species.sneeze_volume
		var/s = get_species_sound(get_gendered_sound(H))["sneeze"]
		if(!s && !(get_species_sound(H.species.species_sounds) == "None")) // Failsafe, so we always use the default sneeze/etc sounds. None will cancel out anyways.
			if(H.identifying_gender == FEMALE)
				s = get_species_sound("Human Female")["sneeze"]
			else // Update this if we ever get herm/etc sounds.
				s = get_species_sound("Human Male")["sneeze"]
		return list(
				"sound" = s,
				"vol" = vol,
				"exr" = 20,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)
	return ..()
