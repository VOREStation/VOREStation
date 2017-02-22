/obj/item/weapon/storage/backpack/saddlebag
	name = "Saddlebag"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/storage_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				if(H.size_multiplier >= 1.5 && slowdown == 1) //Are they a macro? Is the slowdown set to 1?
					slowdown = 0
				if(H.size_multiplier < 1.5 && slowdown == 0) //Are they a micro/not a macro? Is the slowdown set to 0?
					slowdown = 1
				return 1
			else
				H << "<span class='warning'>You need to have a horse half to wear this.</span>"
				return 0