/obj/item/weapon/storage/backpack/saddlebag
	name = "Saddlebag"
	desc = "A saddle that holds items."
	icon = 'icons/obj/storage_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
			return 1
		else
			H << "<span class='warning'>You need to have a horse half to wear this.</span>"
			return 0
