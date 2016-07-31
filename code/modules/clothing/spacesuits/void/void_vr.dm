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
