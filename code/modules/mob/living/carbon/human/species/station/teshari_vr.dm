/datum/species/teshari
	mob_size = MOB_MEDIUM //To allow normal mob swapping
	spawn_flags = SPECIES_CAN_JOIN
	icobase = 'icons/mob/human_races/r_teshari_vr.dmi'
	deform = 'icons/mob/human_races/r_teshari_vr.dmi'
	icobase_tail = 1
	color_mult = 1
	min_age = 18
	push_flags = ~HEAVY //Allows them to use micro step code.
	swap_flags = ~HEAVY
	gluttonous = 0
	genders = list(MALE, FEMALE, PLURAL, NEUTER)
	descriptors = list()
	wikilink="https://wiki.vore-station.net/Teshari"
	agility = 90

	male_sneeze_sound = list('sound/effects/mob_effects/tesharisneeze.ogg','sound/effects/mob_effects/tesharisneezeb.ogg')
	female_sneeze_sound = list('sound/effects/mob_effects/tesharisneeze.ogg','sound/effects/mob_effects/tesharisneezeb.ogg')

	vore_belly_default_variant = "T" //Teshari belly sprite

	inherent_verbs = list(
		///mob/living/carbon/human/proc/sonar_ping,
		/mob/living/proc/hide,
		/mob/living/proc/toggle_pass_table
		)
