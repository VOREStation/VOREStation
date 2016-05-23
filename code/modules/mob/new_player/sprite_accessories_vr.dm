////////////////////////
// For sergals and stuff
////////////////////////
// Note: Creating a sub-datum to group all vore stuff together
// would require us to exclude that datum from the global list.

/datum/sprite_accessory/hair

	species_allowed = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin") //This lets all races use the default hairstyles.

	sergal_plain
		name = "Sergal Plain"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_plain"
		species_allowed = list("Sergal")

	sergal_medicore
		name = "Sergal Medicore"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_medicore"
		species_allowed = list("Sergal")

	sergal_tapered
		name = "Sergal Tapered"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_tapered"
		species_allowed = list("Sergal")

	sergal_fairytail
		name = "Sergal Fairytail"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_fairytail"
		species_allowed = list("Sergal")

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin") //Lets all the races be bald if they want.

// Vulpa stuffs

	vulp_hair_none
		name = "None"
		icon_state = "bald"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_kajam
		name = "Kajam"
		icon_state = "kajam"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_keid
		name = "Keid"
		icon_state = "keid"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_adhara
		name = "Adhara"
		icon_state = "adhara"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_kleeia
		name = "Kleeia"
		icon_state = "kleeia"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_mizar
		name = "Mizar"
		icon_state = "mizar"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_apollo
		name = "Apollo"
		icon_state = "apollo"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_belle
		name = "Belle"
		icon_state = "belle"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_bun
		name = "Bun"
		icon_state = "bun"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_jagged
		name = "Jagged"
		icon_state = "jagged"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_curl
		name = "Curl"
		icon_state = "curl"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_hawk
		name = "Hawk"
		icon_state = "hawk"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_anita
		name = "Anita"
		icon_state = "anita"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_short
		name = "Short"
		icon_state = "short"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_spike
		name = "Spike"
		icon_state = "spike"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

/datum/sprite_accessory/facial_hair

	vulp_blaze
		name = "Blaze"
		icon_state = "vulp_facial_blaze"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_vulpine
		name = "Vulpine"
		icon_state = "vulp_facial_vulpine"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_earfluff
		name = "Earfluff"
		icon_state = "vulp_facial_earfluff"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_mask
		name = "Mask"
		icon_state = "vulp_facial_mask"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_patch
		name = "Patch"
		icon_state = "vulp_facial_patch"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_ruff
		name = "Ruff"
		icon_state = "vulp_facial_ruff"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_kita
		name = "Kita"
		icon_state = "vulp_facial_kita"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_swift
		name = "Swift"
		icon_state = "vulp_facial_swift"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulpkanin
		name = "Default Vulpkanin skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_vulpkanin.dmi'
		species_allowed = list("Vulpkanin")