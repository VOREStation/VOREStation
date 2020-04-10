//
// Because of our custom change in update_icons, we cannot rely upon the normal
// method of switching sprites when refitting (which is to have the referitter
// set the value of icon_override).  Therefore we use the sprite sheets method
// instead.
//

/obj/item/clothing/head/helmet/space/void
	species_restricted = list(SPECIES_HUMAN, SPECIES_NEVREAN, SPECIES_RAPALA, SPECIES_VASILISSAN, SPECIES_ALRAUNE, SPECIES_PROMETHEAN, SPECIES_XENOCHIMERA)
	sprite_sheets = list(
		SPECIES_TAJ 				= 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL 				= 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_UNATHI 				= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_TESHARI				= 'icons/mob/species/seromi/head.dmi',
		SPECIES_XENOHYBRID 				= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_AKULA				= 'icons/mob/species/akula/helmet_vr.dmi',
		SPECIES_SERGAL				= 'icons/mob/species/sergal/helmet_vr.dmi',
		SPECIES_VULPKANIN				= 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_ZORREN_HIGH				= 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_FENNEC				= 'icons/mob/species/vulpkanin/helmet.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/obj/clothing/species/tajaran/hats.dmi', // Copied from void.dm
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/hats.dmi',  // Copied from void.dm
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/hats.dmi',  // Copied from void.dm
		SPECIES_TESHARI			= 'icons/obj/clothing/species/seromi/hats.dmi',  // Copied from void.dm
		SPECIES_XENOHYBRID			= 'icons/obj/clothing/species/unathi/hats.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/akula/hats.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/sergal/hats.dmi',
		SPECIES_VULPKANIN			= 'icons/obj/clothing/species/vulpkanin/hats.dmi',
		SPECIES_ZORREN_HIGH			= 'icons/obj/clothing/species/vulpkanin/hats.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/hats.dmi'
		)

/obj/item/clothing/suit/space/void
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_NEVREAN, SPECIES_RAPALA, SPECIES_VASILISSAN, SPECIES_ALRAUNE, SPECIES_PROMETHEAN, SPECIES_XENOCHIMERA)
	sprite_sheets = list(
		SPECIES_TAJ 				= 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_SKRELL 				= 'icons/mob/species/skrell/suit.dmi',
		SPECIES_UNATHI 				= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_TESHARI				= 'icons/mob/species/seromi/suit.dmi',
		SPECIES_XENOHYBRID 				= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_AKULA				= 'icons/mob/species/akula/suit_vr.dmi',
		SPECIES_SERGAL				= 'icons/mob/species/sergal/suit_vr.dmi',
		SPECIES_VULPKANIN				= 'icons/mob/species/vulpkanin/suit.dmi',
		SPECIES_ZORREN_HIGH				= 'icons/mob/species/vulpkanin/suit.dmi',
		SPECIES_FENNEC				= 'icons/mob/species/vulpkanin/suit.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ			= 'icons/obj/clothing/species/tajaran/suits.dmi', // Copied from void.dm
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/suits.dmi',  // Copied from void.dm
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/suits.dmi',  // Copied from void.dm
		SPECIES_TESHARI			= 'icons/obj/clothing/species/seromi/suits.dmi',  // Copied from void.dm
		SPECIES_XENOHYBRID			= 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/akula/suits.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/sergal/suits.dmi',
		SPECIES_VULPKANIN			= 'icons/obj/clothing/species/vulpkanin/suits.dmi',
		SPECIES_ZORREN_HIGH			= 'icons/obj/clothing/species/vulpkanin/suits.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/suits.dmi'
		)

	// This is a hack to prevent the item_state variable on the suits from taking effect
	// when the item is equipped in outer clothing slot.
	// This variable is normally used to set the icon_override when the suit is refitted,
	// however the species spritesheet now means we no longer need that anyway!
	sprite_sheets_refit = list()
