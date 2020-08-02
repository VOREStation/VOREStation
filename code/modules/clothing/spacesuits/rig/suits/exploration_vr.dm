/obj/item/weapon/rig/exploration
	name = "heavy exploration HCM"
	suit_type = "heavy exploration hardsuit"
	desc = "Exoplanet Exploration Armored Unit, A-Unit for short. This advanced, heavy-duty hardsuit is built for more hostile (and hungry) environments. It features additional armor and a powered exoskeleton for easier movement than other hardsuits." //VOREStation Edit
	icon = 'icons/obj/rig_modules_vr.dmi'
	onmob_back_icon = 'icons/mob/rig_back_vr.dmi'
	taur_back_icon = 'icons/mob/rig_back_taur_vr.dmi'
	icon_state = "exploration_rig"
	armor = list(
		melee = 50, 
		bullet = 25, 
		laser = 25, 
		energy = 40, 
		bomb = 10, 
		bio = 100, 
		rad = 100
		)

	helm_type = /obj/item/clothing/head/helmet/space/rig/exploration
	chest_type = /obj/item/clothing/suit/space/rig/exploration
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/exploration
	boot_type = /obj/item/clothing/shoes/magboots/rig/exploration

	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit
		)

	slowdown = 0.50
	offline_slowdown = 4
	offline_vision_restriction = TINT_BLIND

/obj/item/clothing/head/helmet/space/rig/exploration
	icon = 'icons/obj/clothing/helmets_vr.dmi'
	light_overlay = "hardhat_light_dual"
	camera_networks = list(NETWORK_EXPLORATION)
	brightness_on = 5
	update_icon_define = null // AYY WHO DID DIS
	sprite_sheets_refit = list()
	sprite_sheets =  list(
		SPECIES_HUMAN			= 'icons/mob/head_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/helmet_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/akula/helmet_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/sergal/helmet_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/helmet_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_HUMAN			= 'icons/obj/clothing/helmets_vr.dmi',
		SPECIES_TAJ				= 'icons/obj/clothing/species/tajaran/hats_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/hats_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/species/unathi/hats_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/akula/hats_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/sergal/hats_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/hats_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/vulpkanin/hats_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/hats_vr.dmi'
		)

/obj/item/clothing/suit/space/rig/exploration
	icon = 'icons/obj/clothing/spacesuits_vr.dmi'
	update_icon_define = null
	sprite_sheets_refit = list()
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/spacesuit_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/suit_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/akula/suit_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/sergal/suit_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/suit_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_HUMAN			= 'icons/obj/clothing/spacesuits_vr.dmi',
		SPECIES_TAJ				= 'icons/obj/clothing/species/tajaran/suits_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/suits_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/species/unathi/suits_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/akula/suits_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/sergal/suits_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/suits_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/vulpkanin/suits_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/suits_vr.dmi'
		)

/obj/item/clothing/gloves/gauntlets/rig/exploration
	icon = 'icons/obj/clothing/gloves_vr.dmi'
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/hands_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/hands_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/hands_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/hands_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/hands_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/hands_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/hands_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/hands_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/hands_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_HUMAN			= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_TAJ				= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/gloves_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/gloves_vr.dmi'
		)
	update_icon_define = null

/obj/item/clothing/shoes/magboots/rig/exploration
	icon = 'icons/obj/clothing/shoes_vr.dmi'
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/feet_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/feet_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/feet_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/feet_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/feet_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/feet_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/feet_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/feet_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/feet_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_HUMAN			= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_TAJ				= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/shoes_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/shoes_vr.dmi'
		)
	update_icon_define = null

/obj/item/weapon/rig/exploration/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/grenade_launcher/light
		)
