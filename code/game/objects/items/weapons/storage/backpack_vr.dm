/obj/item/weapon/storage/backpack/saddlebag
	name = "Horse Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/storage_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	var/taurtype = /datum/sprite_accessory/tail/taur/horse //Acceptable taur type to be wearing this
	var/no_message = "You aren't the appropriate taur type to wear this!"

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, taurtype))
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			else
				H << "<span class='warning'>[no_message]</span>"
				return 0

/* If anyone wants to make some... this is how you would.
/obj/item/weapon/storage/backpack/saddlebag/spider
	name = "Drider Saddlebags"
	item_state = "saddlebag_drider"
	icon_state = "saddlebag_drider"
	var/taurtype = /datum/sprite_accessory/tail/taur/spider
*/
