//Security

/obj/item/clothing/suit/armor/pcarrier/light/nt/cynosure
	name = "security armor"
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/nt)

//Pilot

/obj/item/clothing/suit/storage/toggle/bomber/pilot
	name = "pilot jacket"
	desc = "A thick, blue bomber jacket."
	icon_state = "pilot_bomber"
	item_icons = list(slot_wear_suit_str = 'maps/cynosure/icons/mob/cyno_suit.dmi')
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	icon = 'maps/cynosure/icons/obj/cyno_suit.dmi'
	sprite_sheets = list(
			"Teshari" = 'maps/cynosure/icons/mob/species/teshari/cyno_suit.dmi'
			)
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

//Misc

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	name = "search and rescue winter coat"
	desc = "A heavy winter jacket. A white star of life is emblazoned on the back, with the words search and rescue written underneath."
	icon_state = "coatsar"
	item_icons = list(slot_wear_suit_str = 'maps/cynosure/icons/mob/cyno_suit.dmi')
	icon = 'maps/cynosure/icons/obj/cyno_suit.dmi'
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 5)
	valid_accessory_slots = (ACCESSORY_SLOT_INSIGNIA)
	allowed = list (/obj/item/weapon/gun,/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes,
	/obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask, /obj/item/device/suit_cooling_unit, /obj/item/device/analyzer,/obj/item/stack/medical,
	/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,
	/obj/item/device/healthanalyzer,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,
	/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle)