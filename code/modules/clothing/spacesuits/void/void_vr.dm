//
// Because of our custom change in update_icons, we cannot rely upon the normal
// method of switching sprites when refitting (which is to have the referitter
// set the value of icon_override).  Therefore we use the sprite sheets method
// instead.
//

/obj/item/clothing/head/helmet/space/void
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/helmet.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/helmet.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/helmet.dmi',
		"Teshari"				= 'icons/mob/species/seromi/head.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/helmet_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/helmet_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/helmet_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/helmet_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/helmet_vr.dmi',
		"Vulpkanin"				= 'icons/mob/species/vulpkanin/helmet.dmi',
		"Promethean"			= 'icons/mob/species/skrell/helmet.dmi',
		"Xenomorph Hybrid"		= 'icons/mob/species/unathi/helmet.dmi'
		)

	sprite_sheets_obj = list(
		"Tajara" 			= 'icons/obj/clothing/species/tajaran/hats.dmi', // Copied from void.dm
		"Skrell"			= 'icons/obj/clothing/species/skrell/hats.dmi',  // Copied from void.dm
		"Unathi"			= 'icons/obj/clothing/species/unathi/hats.dmi',  // Copied from void.dm
		"Teshari"			= 'icons/obj/clothing/species/seromi/hats.dmi',  // Copied from void.dm
		"Nevrean"			= 'icons/obj/clothing/species/nevrean/hats.dmi',
		"Akula"				= 'icons/obj/clothing/species/akula/hats.dmi',
		"Sergal"			= 'icons/obj/clothing/species/sergal/hats.dmi',
		"Flatland Zorren"	= 'icons/obj/clothing/species/fennec/hats.dmi',
		"Highlander Zorren"	= 'icons/obj/clothing/species/fox/hats.dmi',
		"Vulpkanin"			= 'icons/obj/clothing/species/vulpkanin/hats.dmi',
		"Promethean"		= 'icons/obj/clothing/species/skrell/hats.dmi',
		"Xenomorph Hybrid"	= 'icons/obj/clothing/species/unathi/hats.dmi'
		)

/obj/item/clothing/suit/space/void
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/suit.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/suit.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/suit.dmi',
		"Teshari"				= 'icons/mob/species/seromi/suit.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/suit_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/suit_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/suit_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/suit_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/suit_vr.dmi',
		"Vulpkanin"				= 'icons/mob/species/vulpkanin/suit.dmi',
		"Promethean"			= 'icons/mob/species/skrell/suit.dmi',
		"Xenomorph Hybrid"		= 'icons/mob/species/unathi/suit.dmi'
		)



	sprite_sheets_obj = list(
		"Tajara"			= 'icons/obj/clothing/species/tajaran/suits.dmi', // Copied from void.dm
		"Skrell"			= 'icons/obj/clothing/species/skrell/suits.dmi',  // Copied from void.dm
		"Unathi"			= 'icons/obj/clothing/species/unathi/suits.dmi',  // Copied from void.dm
		"Teshari"			= 'icons/obj/clothing/species/seromi/suits.dmi',  // Copied from void.dm
		"Nevrean"			= 'icons/obj/clothing/species/nevrean/suits.dmi',
		"Akula"				= 'icons/obj/clothing/species/akula/suits.dmi',
		"Sergal"			= 'icons/obj/clothing/species/sergal/suits.dmi',
		"Flatland Zorren"	= 'icons/obj/clothing/species/fennec/suits.dmi',
		"Highlander Zorren"	= 'icons/obj/clothing/species/fox/suits.dmi',
		"Vulpkanin"			= 'icons/obj/clothing/species/vulpkanin/suits.dmi',
		"Promethean"		= 'icons/obj/clothing/species/skrell/suits.dmi'
		)

	// This is a hack to prevent the item_state variable on the suits from taking effect
	// when the item is equipped in outer clothing slot.
	// This variable is normally used to set the icon_override when the suit is refitted,
	// however the species spritesheet now means we no longer need that anyway!
	sprite_sheets_refit = list()



/obj/item/clothing/suit/space/void/merc/taur
	name = "taur specific blood-red voidsuit"
	desc = "A high-tech space suit. It says has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	species_restricted = null //Species restricted since all it cares about is a taur half
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "syndie-horse"
				item_state = "syndie-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "syndie-wolf"
				item_state = "syndie-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "syndie-naga"
				item_state = "syndie-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

/obj/item/clothing/suit/space/void/medical/taur
	name = "taur specific medical voidsuit"
	desc = "A high-tech space suit. It says has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical-horse"
				item_state = "medical-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical-wolf"
				item_state = "medical-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical-naga"
				item_state = "medical-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0


/obj/item/clothing/suit/space/void/engineering/taur
	name = "taur specific engineering voidsuit"
	desc = "A high-tech space suit. It says has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "engineering-horse"
				item_state = "engineering-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "engineering-wolf"
				item_state = "engineering-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "engineering-naga"
				item_state = "engineering-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0


/obj/item/clothing/suit/space/void/security/taur
	name = "taur specific security voidsuit"
	desc = "A high-tech space suit. It says has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "security-horse"
				item_state = "security-horse"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "security-wolf"
				item_state = "security-wolf"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "security-naga"
				item_state = "security-naga"
				pixel_x = -16
				update_icon()
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

/obj/item/clothing/suit/space/void/atmos/taur
	name = "taur specific atmospherics voidsuit"
	desc = "A high-tech space suit. It says has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "atmos-horse"
				item_state = "atmos-horse"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "atmos-wolf"
				item_state = "atmos-wolf"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "atmos-naga"
				item_state = "atmos-naga"
				pixel_x = -16
				update_icon()
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

/obj/item/clothing/suit/space/void/mining/taur
	name = "taur specific mining voidsuit"
	desc = "A high-tech space suit. It says has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "mining-horse"
				item_state = "mining-horse"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "mining-wolf"
				item_state = "mining-wolf"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "mining-naga"
				item_state = "mining-naga"
				pixel_x = -16
				update_icon()
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0
