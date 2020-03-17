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
				to_chat(H, "<span class='warning'>[no_message]</span>")
				return 0

/* If anyone wants to make some... this is how you would.
/obj/item/weapon/storage/backpack/saddlebag/spider
	name = "Drider Saddlebags"
	item_state = "saddlebag_drider"
	icon_state = "saddlebag_drider"
	var/taurtype = /datum/sprite_accessory/tail/taur/spider
*/

/obj/item/weapon/storage/backpack/saddlebag_common //Shared bag for other taurs with sturdy backs
	name = "Taur Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/storage_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	var/icon_base = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	var/no_message = "You aren't the appropriate taur type to wear this!"

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			var/datum/sprite_accessory/tail/taur/TT = H.tail_style
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/horse))
				item_state = "[icon_base]_Horse"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/wolf))
				item_state = "[icon_base]_Wolf"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/cow))
				item_state = "[icon_base]_Cow"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/lizard))
				item_state = "[icon_base]_Lizard"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/feline))
				item_state = "[icon_base]_Feline"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/drake))
				item_state = "[icon_base]_Drake"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/otie))
				item_state = "[icon_base]_Otie"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/deer))
				item_state = "[icon_base]_Deer"
				if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
					slowdown = 0
				else
					slowdown = initial(slowdown)
				return 1
			else
				to_chat(H, "<span class='warning'>[no_message]</span>")
				return 0

/obj/item/weapon/storage/backpack/saddlebag_common/robust //Shared bag for other taurs with sturdy backs
	name = "Robust Saddlebags"
	desc = "A saddle that holds items. Seems robust."
	icon = 'icons/obj/storage_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	item_state = "robustsaddle"
	icon_state = "robustsaddle"
	icon_base = "robustsaddle"

/obj/item/weapon/storage/backpack/saddlebag_common/vest //Shared bag for other taurs with sturdy backs
	name = "Taur Duty Vest"
	desc = "An armored vest with the armor modules replaced with various handy compartments with decent storage capacity. Useless for protection though."
	icon = 'icons/obj/storage_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	item_state = "taurvest"
	icon_state = "taurvest"
	icon_base = "taurvest"
	max_storage_space = INVENTORY_STANDARD_SPACE
	slowdown = 0

/obj/item/weapon/storage/backpack/dufflebag/fluff //Black dufflebag without syndie buffs.
	name = "plain black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon_state = "duffle_syndie"

/obj/item/weapon/storage/backpack
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/back.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/back.dmi')

/obj/item/weapon/storage/backpack/ert
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE
