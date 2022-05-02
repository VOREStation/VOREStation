/decl/emote/audible/sneeze
	key = "sneeze"
	emote_message_1p = "You sneeze."
	emote_message_3p = "sneezes."
	emote_sound_synthetic = list(
		FEMALE = 'sound/effects/mob_effects/machine_sneeze.ogg',
		MALE =   'sound/effects/mob_effects/f_machine_sneeze.ogg',
		NEUTER = 'sound/effects/mob_effects/f_machine_sneeze.ogg',
		PLURAL = 'sound/effects/mob_effects/f_machine_sneeze.ogg'
	)
	emote_message_synthetic_1p = "You emit a robotic sneeze."
	emote_message_synthetic_1p_target = "You emit a robotic sneeze towards TARGET."
	emote_message_synthetic_3p = "emits a robotic sneeze."
	emote_message_synthetic_3p_target = "emits a robotic sneeze towards TARGET."

/decl/emote/audible/sneeze/get_emote_sound(var/atom/user)
	if(ishuman(user) && !check_synthetic(user))
		var/mob/living/human/H = user
		if(H.get_gender() == FEMALE)
			return list(
				"sound" = H.species.female_sneeze_sound,
				"vol" = emote_volume
			)
		else
			return list(
				"sound" = H.species.male_sneeze_sound,
				"vol" = emote_volume
			)
	return ..()
