/obj/item/clothing/head/helmet/space/void/refurb
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/head.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/helmet_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/obj/clothing/species/tajaran/hats.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/hats.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/helmets_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/vulpkanin/helmets_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/helmets_vr.dmi'
		)
	sprite_sheets_refit = list()	//have to nullify this as well just to be thorough

/obj/item/clothing/suit/space/void/refurb
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/spacesuit.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/suit.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/suit_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ				= 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/suits.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/spacesuits_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/vulpkanin/spacesuits_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/spacesuits_vr.dmi'
		)

/obj/item/clothing/head/helmet/space/void/refurb/talon
	name = "talon crew voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum."
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/talon
	name = "talon crew voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor."

/obj/item/clothing/head/helmet/space/void/refurb/engineering/talon
	name = "talon engineering voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. This one in particular must be several decades old, but the insulation and radiation proofing are top-notch. Don't mind the grease marks."
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/engineering/talon
	name = "talon engineering voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. This one in particular must be several decades old, but the insulation and radiation proofing are top-notch. The chestplate has a simple gear logo on it."

/obj/item/clothing/head/helmet/space/void/refurb/medical/talon
	name = "talon medical voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/head/helmet/space/void/refurb/medical/alt/talon
	name = "talon medical voidsuit bubble helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/medical/talon
	name = "talon medical voidsuit"

/obj/item/clothing/head/helmet/space/void/refurb/marine/talon
	name = "talon marine's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. The blue markings indicate this as the marine/guard variant. \"ITV TALON\" has been stamped onto the sides of the helmet."
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/marine/talon
	name = "talon marine's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer marines swear by these old things, even if new powered hardsuits have more features and better armor. The blue markings indicate this as the marine/guard variant, with \"ITV TALON\" stamped under the shield design."

/obj/item/clothing/head/helmet/space/void/refurb/officer/talon
	name = "talon officer's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/officer/talon
	name = "talon officer's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. This variant appears to be an officer's, and has the best protection of all the old models. \"ITV TALON\" is stamped across the left side of the breastplate in faded faux-gold."

/obj/item/clothing/head/helmet/space/void/refurb/pilot/talon
	name = "talon pilot voidsuit bubble helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/head/helmet/space/void/refurb/pilot/alt/talon
	name = "talon pilot voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/pilot/talon
	name = "talon pilot voidsuit"

/obj/item/clothing/head/helmet/space/void/refurb/research/talon
	name = "talon scientific voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/head/helmet/space/void/refurb/research/alt/talon
	name = "talon scientific voidsuit bubble helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/research/talon
	name = "talon scientific voidsuit"

/obj/item/clothing/head/helmet/space/void/refurb/mercenary/talon
	name = "talon mercenary's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. The red markings indicate this as the mercenary variant. \"ITV TALON\" is stamped across the back of the helmet."
	camera_networks = list(NETWORK_TALON_HELMETS)

/obj/item/clothing/suit/space/void/refurb/mercenary/talon
	name = "talon mercenary's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer mercs swear by these old things, even if new powered hardsuits have more features and better armor. The red markings indicate this as the mercenary variant. \"ITV TALON\" has been stamped onto each pauldron and the right side of the breastplate."