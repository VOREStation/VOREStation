/datum/species/golem
	name = SPECIES_GOLEM
	name_plural = "golems"

	icobase = 'icons/mob/human_races/r_golem.dmi'
	deform = 'icons/mob/human_races/r_golem.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags = NO_PAIN | NO_DNA | NO_SLEEVE | NO_POISON | NO_MINOR_CUT | NO_DEFIB
	spawn_flags = SPECIES_IS_RESTRICTED
	siemens_coefficient = 0

	assisted_langs = list()

	breath_type = null
	poison_type = null

	blood_color = "#515573"
	flesh_color = "#137E8F"

	virus_immune = 1

	has_organ = list(
		"brain" = /obj/item/organ/internal/brain/golem
		)

	death_message = "becomes completely motionless..."

	genders = list(NEUTER)

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = JOB_GOLEM
		H.mind.special_role = JOB_GOLEM
	H.real_name = "adamantine golem ([rand(1, 1000)])"
	H.name = H.real_name
	..()
