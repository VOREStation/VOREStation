/obj/item/weapon/beartrap
	slot_flags = SLOT_MASK
	item_icons = list(
		slot_wear_mask_str = 'icons/mob/mask_vr.dmi'
		)

/obj/item/weapon/beartrap/equipped()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.wear_mask == src)
			H.verbs |= /mob/living/proc/shred_limb_temp
		else
			H.verbs -= /mob/living/proc/shred_limb_temp
	..()

/obj/item/weapon/beartrap/dropped(var/mob/user)
	user.verbs -= /mob/living/proc/shred_limb_temp
	..()