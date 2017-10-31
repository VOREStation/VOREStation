// ### Wooo, inheritance. Basically copying everything I don't need to edit from prometheans, because they mostly work already.
// ### Any and all of this is open to change for balance or whatever.
// ###
// ###
// Species definition follows.
/datum/species/shapeshifter/promethean/avatar

	name =             "Virtual Reality Avatar"
	name_plural =      "Virtual Reality Avatars"
	blurb =            "A 3-dimensional representation of some sort of animate object used to display the presence and actions of some-one or -thing using a virtual reality program."
	show_ssd =         "eerily still"
	death_message =    "flickers briefly, their gear falling in a heap on the floor around their motionless body."
	knockout_message = "has been knocked unconscious!"

	spawn_flags =		SPECIES_IS_RESTRICTED

	speech_bubble_appearance = "cyber"

	male_cough_sounds = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg')
	female_cough_sounds = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg')
	male_sneeze_sound = 'sound/effects/mob_effects/sneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/f_sneeze.ogg'

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	has_organ =     list(O_BRAIN = /obj/item/organ/internal/brain/slime, O_EYES = /obj/item/organ/internal/eyes) // Slime core.
	heal_rate = 0		// Avatars don't naturally heal like prometheans, at least not for now

/datum/species/shapeshifter/promethean/avatar/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/shapeshifter/promethean/avatar/handle_environment_special(var/mob/living/carbon/human/H)
	return