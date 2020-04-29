// Our clear gas masks don't hide faces, but changing the var on mask/gas would require un-chaging it on all children. This is nicer.
/obj/item/clothing/mask/gas/New()
	if(type == /obj/item/clothing/mask/gas)
		flags_inv &= ~HIDEFACE
	..()

// Since we changed the gas mask sprite, if we want the old one for some reason use this.
/obj/item/clothing/mask/gas/wwii
	icon = 'icons/obj/clothing/masks.dmi'
	icon_override = 'icons/mob/mask.dmi'
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/gas/imperial
	name = "imperial soldier facemask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "ge_visor"
	icon = 'icons/obj/clothing/masks_vr.dmi'
	icon_override = 'icons/mob/mask_vr.dmi'
	body_parts_covered = FACE|EYES
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/gas/ascent
	name = "mantid facemask"
	desc = "An alien facemask with chunky gas filters and a breathing valve."
	icon_state = "ascent_mask"
	item_state = "ascent_mask"
	sprite_sheets = list(
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_mask_alate.dmi'
	)
	species_restricted = list(SPECIES_MANTID_ALATE)
	flags_inv = 0
