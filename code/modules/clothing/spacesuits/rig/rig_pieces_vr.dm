/obj/item/clothing/head/helmet/space/rig
	sprite_sheets = list(
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_AKULA 			= 'icons/mob/species/akula/helmet_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/sergal/helmet_vr.dmi',
		SPECIES_NEVREAN			= 'icons/mob/species/sergal/helmet_vr.dmi',
		SPECIES_VULPKANIN 		= 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_ZORREN_HIGH 	= 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_FENNEC 			= 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_PROMETHEAN		= 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_VOX 			= 'icons/mob/species/vox/head.dmi',
		SPECIES_TESHARI 		= 'icons/mob/species/teshari/head.dmi'
		)



/obj/item/clothing/suit/space/rig
	sprite_sheets = list(
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/suit.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/suit.dmi',
		SPECIES_AKULA 			= 'icons/mob/species/akula/suit_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/sergal/suit_vr.dmi',
		SPECIES_NEVREAN			= 'icons/mob/species/sergal/suit_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/suit.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/suit.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/suit.dmi',
		SPECIES_PROMETHEAN		= 'icons/mob/species/skrell/suit.dmi',
		SPECIES_VOX 			= 'icons/mob/species/vox/suit.dmi',
		SPECIES_TESHARI 		= 'icons/mob/species/teshari/suit.dmi'
		)

/obj/item/clothing/head/helmet/space/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJ, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID)

/obj/item/clothing/gloves/gauntlets/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJ, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID)

/obj/item/clothing/shoes/magboots/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJ, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID)

/obj/item/clothing/suit/space/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJ, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID)

/obj/item/clothing/shoes/magboots/rig/ce
	name = "advanced boots"
/obj/item/clothing/shoes/magboots/rig/ce/set_slowdown()
	if(magpulse)
		slowdown = shoes ? max(SHOES_SLOWDOWN, shoes.slowdown) : SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	else if(shoes)
		slowdown = shoes.slowdown
	else
		slowdown = SHOES_SLOWDOWN