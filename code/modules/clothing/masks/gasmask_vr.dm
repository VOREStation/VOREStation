// Our clear gas masks don't hide faces, but changing the var on mask/gas would require un-chaging it on all children. This is nicer.
/obj/item/clothing/mask/gas/New()
	if(type == /obj/item/clothing/mask/gas)
		flags_inv &= ~HIDEFACE
	..()

// Since we changed the gas mask sprite, if we want the old one for some reason use this.
/obj/item/clothing/mask/gas/wwii
	icon = 'icons/inventory/face/item.dmi'
	icon_override = 'icons/inventory/face/mob.dmi'
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/gas/plaguedoctor
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/face/mob_vr_teshari.dmi'
		)