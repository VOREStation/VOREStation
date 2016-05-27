/obj/item/clothing/head/helmet/space/void
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/helmet.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/helmet.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/helmet.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/helmet_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/helmet_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/helmet_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/helmet_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/helmet_vr.dmi'
		)



/obj/item/clothing/suit/space/void
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/suit.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/suit.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/suit.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/suit_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/suit_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/suit_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/suit_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/suit_vr.dmi'
		)
	// This is a hack to prevent the item_state variable on the suits from taking effect
	// when the item is equipped in outer clothing slot.
	// This variable is normally used to set the icon_override when the suit is refitted,
	// however the species spritesheet now means we no longer need that anyway!
	sprite_sheets_refit = list()
