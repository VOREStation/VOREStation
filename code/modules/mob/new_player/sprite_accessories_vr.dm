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
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "kajam"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_keid
		name = "Keid"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "keid"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_adhara
		name = "Adhara"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "adhara"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_kleeia
		name = "Kleeia"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "kleeia"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_mizar
		name = "Mizar"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "mizar"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_apollo
		name = "Apollo"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "apollo"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_belle
		name = "Belle"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "belle"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_bun
		name = "Bun"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "bun"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_jagged
		name = "Jagged"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "jagged"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_curl
		name = "Curl"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "curl"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_hawk
		name = "Hawk"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "hawk"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_anita
		name = "Anita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "anita"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_short
		name = "Short"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "short"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_spike
		name = "Spike"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "spike"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

/* BODY MARKINGS */

/datum/sprite_accessory/body_markings
	icon = 'icons/mob/vore/body_markings_vr.dmi'
	species_allowed = list("Unathi", "Tajaran", "Vulpkanin")
	icon_state = "accessory_none"

/datum/sprite_accessory/body_markings/none
	name = "None"
	species_allowed = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin")
	icon_state = "accessory_none"

/datum/sprite_accessory/body_markings/stripe
	name = "Stripe"
	species_allowed = list("Unathi")
	icon_state = "markings_stripe"

/datum/sprite_accessory/body_markings/tiger
	name = "Tiger Body"
	species_allowed = list("Unathi", "Tajaran", "Vulpkanin")
	icon_state = "markings_tiger"

/datum/sprite_accessory/body_markings/tigerhead
	name = "Tiger Body + Head"
	species_allowed = list("Unathi", "Tajaran", "Vulpkanin")
	icon_state = "markings_tigerhead"

/datum/sprite_accessory/body_markings/tigerheadface_taj
	name = "Tajaran Tiger Body + Head + Face"
	species_allowed = list("Tajaran")
	icon_state = "markings_tigerheadface_taj"

/datum/sprite_accessory/body_markings/tigerheadface_vulp
	name = "Vulpkanin Tiger Body + Head + Face"
	species_allowed = list("Vulpkanin")
	icon_state = "markings_tigerheadface_vulp"

/datum/sprite_accessory/body_markings/tigerheadface_una
	name = "Unathi Tiger Body + Head + Face"
	species_allowed = list("Unathi")
	icon_state = "markings_tigerheadface_una"
	vulpkanin
		name = "Default Vulpkanin skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_vulpkanin.dmi'
		species_allowed = list("Vulpkanin")


