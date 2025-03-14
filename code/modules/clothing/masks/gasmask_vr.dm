// Our clear gas masks don't hide faces, but changing the var on mask/gas would require un-chaging it on all children. This is nicer.
/obj/item/clothing/mask/gas/Initialize(mapload)
	. = ..()
	if(type == /obj/item/clothing/mask/gas)
		flags_inv &= ~HIDEFACE

// Since we changed the gas mask sprite, if we want the old one for some reason use this.
/obj/item/clothing/mask/gas/wwii
	icon = 'icons/inventory/face/item.dmi'
	icon_override = 'icons/inventory/face/mob.dmi'
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/gas/imperial
	name = "imperial soldier facemask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "ge_visor"
	icon = 'icons/inventory/face/item_vr.dmi'
	icon_override = 'icons/inventory/face/mob_vr.dmi'
	body_parts_covered = FACE|EYES
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
