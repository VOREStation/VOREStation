/obj/item/clothing/head/helmet/solgov
	name = "peacekeeper helmet"
	desc = "A helmet painted in Peacekeeper blue. Stands out like a sore thumb."

/obj/item/clothing/head/helmet/solgov/command
	name = "peacekeeper commander helmet"
	desc = "A more sophisticated helmet painted in Peacekeeper blue. Stands out like a sore thumb."

/obj/item/clothing/head/helmet/combat/USDF
	name = "marine helmet"
	desc = "If you wanna to keep your brain inside yo' head, you'd best put this on!"
	icon_state = "unsc_helm"
	item_state = "unsc_helm"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/helmet/combat/imperial
	name = "imperial soldier helmet"
	desc = "Veni, vidi, vici; I came, I saw, I conquered."
	icon_state = "ge_helm"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/helmet/combat/imperial/centurion
	name = "imperial centurion helmet"
	desc = "Vendi, vidi, visa; I came, I saw, I realised this hat was too expensive."
	icon_state = "ge_helmcent"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/helmet/space/void/ascent
	name = "\improper Ascent voidsuit helmet"
	desc = "An articulated spacesuit helmet of mantid manufacture."
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_state = "ascent_general"
	armor = list(melee = 40, bullet = 40, laser = 15, energy = 15, bomb = 50, bio = 100, rad = 100)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	species_restricted = list(SPECIES_MANTID_ALATE)
	sprite_sheets = list(SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/head_alate.dmi')
