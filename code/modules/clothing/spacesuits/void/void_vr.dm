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

/obj/item/clothing/head/helmet/space/void/heck
	name = "\improper H.E.C.K. helmet"
	desc = "Hostile Environiment Cross-Kinetic Helmet: A helmet designed to withstand the wide variety of hazards from \[REDACTED\]. It wasn't enough for its last owner."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/void/heck/Initialize()
	. = ..()
	var/mutable_appearance/glass_overlay = mutable_appearance(icon, "hostile_env_glass")
	glass_overlay.appearance_flags = RESET_COLOR
	add_overlay(glass_overlay)

/obj/item/clothing/head/helmet/space/void/heck/apply_accessories(var/image/standing)
	. = ..()
	var/mutable_appearance/glass_overlay = mutable_appearance(icon_override, "hostile_env_glass")
	glass_overlay.appearance_flags = KEEP_APART|RESET_COLOR
	standing.add_overlay(glass_overlay)
	return standing

/obj/item/clothing/suit/space/void/heck
	name = "\improper H.E.C.K. suit"
	desc = "Hostile Environment Cross-Kinetic Suit: A suit designed to withstand the wide variety of hazards from \[REDACTED\]. It wasn't enough for its last owner."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	slowdown = 1.5
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/void/syndicate_contract
	name = "syndicate contract helmet"
	desc = "A free helmet, gifted you by your new not-quite-corporate master!"
	icon_state = "syndicate-contract"
	item_state = "syndicate-contract"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)

/obj/item/clothing/suit/space/void/syndicate_contract
	name = "syndicate contract suit"
	desc = "A free suit, gifted you by your new not-quite-corporate master!"
	icon_state = "syndicate-contract"
	item_state = "syndicate-contract"
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/space/void/chrono
	name = "chrono-helmet"
	desc = "From out of space and time, this helmet will protect you while you perform your duties."
	icon_state = "chronohelmet"
	item_state = "chronohelmet"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/suit/space/void/chrono
	name = "chrono-suit"
	desc = "From out of space and time, this helmet will protect you while you perform your duties."
	icon_state = "chronosuit"
	item_state = "chronosuit"
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'