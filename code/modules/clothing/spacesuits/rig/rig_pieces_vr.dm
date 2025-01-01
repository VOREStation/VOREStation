/obj/item/clothing/head/helmet/space/rig
	sprite_sheets = list(
		SPECIES_TAJARAN 			= 'icons/inventory/head/mob_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/head/mob_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_AKULA 			= 'icons/inventory/head/mob_vr_akula.dmi',
		SPECIES_SERGAL			= 'icons/inventory/head/mob_vr_sergal.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/head/mob_vr_sergal.dmi',
		SPECIES_VULPKANIN 		= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH 	= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC 			= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_PROMETHEAN		= 'icons/inventory/head/mob_skrell.dmi',
		SPECIES_VOX 			= 'icons/inventory/head/mob_vox.dmi',
		SPECIES_TESHARI 		= 'icons/inventory/head/mob_teshari.dmi',
		SPECIES_ALTEVIAN 		= 'icons/inventory/head/mob_vr_altevian.dmi'
		)

/obj/item/clothing/suit/space/rig
	sprite_sheets = list(
		SPECIES_TAJARAN 			= 'icons/inventory/suit/mob_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/suit/mob_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_AKULA 			= 'icons/inventory/suit/mob_vr_akula.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/mob_vr_sergal.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/suit/mob_vr_sergal.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_PROMETHEAN		= 'icons/inventory/suit/mob_skrell.dmi',
		SPECIES_VOX 			= 'icons/inventory/suit/mob_vox.dmi',
		SPECIES_TESHARI 		= 'icons/inventory/suit/mob_teshari.dmi',
		SPECIES_ALTEVIAN 		= 'icons/inventory/suit/mob_vr_altevian.dmi'
		)

/obj/item/clothing/head/helmet/space/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID, SPECIES_ALTEVIAN)

/obj/item/clothing/gloves/gauntlets/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID, SPECIES_ALTEVIAN)

/obj/item/clothing/shoes/magboots/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID, SPECIES_ALTEVIAN)

/obj/item/clothing/suit/space/rig
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_FENNEC, SPECIES_XENOHYBRID, SPECIES_ALTEVIAN)

/obj/item/clothing/shoes/magboots/rig/ce
	name = "advanced boots"
/obj/item/clothing/shoes/magboots/rig/ce/set_slowdown()
	if(magpulse)
		slowdown = shoes ? max(SHOES_SLOWDOWN, shoes.slowdown) : SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	else if(shoes)
		slowdown = shoes.slowdown
	else
		slowdown = SHOES_SLOWDOWN
