// Field Medic Suit - Someone who can sprite should probably reskin this
/obj/item/clothing/suit/storage/hooded/explorer/medic
	starting_accessories = list(/obj/item/clothing/accessory/armband/med/cross)

/obj/item/clothing/suit/storage/hooded/techpriest
	name = "tech priest robe"
	desc = "Praise be to the Omnissiah."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "techpriest"
	hoodtype = /obj/item/clothing/head/hood/techpriest
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 25, bio = 50, rad = 25)
	item_state_slots = list(slot_r_hand_str = "engspace_suit", slot_l_hand_str = "engspace_suit")

// Regular armor versions here, costumes below
/obj/item/clothing/suit/storage/hooded/knight
	name = "crusader's armor"
	desc = "ye olde knight, risen again."
	icon_state = "galahad"
	icon = 'icons/obj/clothing/knights_vr.dmi'
	icon_override = 'icons/obj/clothing/knights_vr.dmi'
	hoodtype = /obj/item/clothing/head/hood/galahad
	armor = list(melee = 80, bullet = 50, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 2
	actions_types = list(/datum/action/item_action/toggle_knight_headgear)

/obj/item/clothing/suit/storage/hooded/knight/galahad
	name = "crusader's armor"
	desc = "ye olde knight, risen again."
	icon_state = "galahad"
	hoodtype = /obj/item/clothing/head/hood/galahad

/obj/item/clothing/suit/storage/hooded/knight/lancelot
	name = "crusader's armor"
	desc = "ye olde knight, risen again."
	icon_state = "lancelot"
	hoodtype = /obj/item/clothing/head/hood/lancelot

/obj/item/clothing/suit/storage/hooded/knight/robin
	name = "crusader's armor"
	desc = "ye olde knight, risen again. This one seems slightly faster than the rest, but weaker."
	icon_state = "robin"
	hoodtype = /obj/item/clothing/head/hood/robin
	armor = list(melee = 70, bullet = 40, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	slowdown = -1
	siemens_coefficient = 3

// Costume Knight Gear Here
/obj/item/clothing/suit/storage/hooded/knight_costume
	name = "crusader's costume armor"
	desc = "ye olde knight, risen again."
	icon_state = "galahad"
	icon = 'icons/obj/clothing/knights_vr.dmi'
	icon_override = 'icons/obj/clothing/knights_vr.dmi'
	hoodtype = /obj/item/clothing/head/hood/galahad_costume
	actions_types = list(/datum/action/item_action/toggle_knight_headgear)

/obj/item/clothing/suit/storage/hooded/knight_costume/galahad
	icon_state = "galahad"
	hoodtype = /obj/item/clothing/head/hood/galahad_costume

/obj/item/clothing/suit/storage/hooded/knight_costume/lancelot
	icon_state = "lancelot"
	hoodtype = /obj/item/clothing/head/hood/lancelot_costume

/obj/item/clothing/suit/storage/hooded/knight_costume/robin
	name = "crusader's armor"
	desc = "ye olde knight, risen again. This one seems slightly faster than the rest, but weaker."
	icon_state = "robin"
	hoodtype = /obj/item/clothing/head/hood/robin_costume

// Talon Winter Coat
/obj/item/clothing/suit/storage/hooded/wintercoat/talon
	name = "Talon winter coat"
	desc = "A cozy winter coat, covered in thick fur and baring the colors of ITV Talon."
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "taloncoat"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/talon

// Food costumes
/obj/item/clothing/suit/storage/hooded/foodcostume	//Separate type of costume that does not cover arms and legs. Similar to a cheap mascot costume. <Guy>
	name = DEVELOPER_WARNING_NAME
	body_parts_covered = CHEST
	flags_inv = HIDETIE|HIDEHOLSTER
	cold_protection = CHEST
	actions_types = list(/datum/action/item_action/toggle_hood)

/obj/item/clothing/suit/storage/hooded/foodcostume/hotdog	//Belly filler uniform :^).
	name = "hotdog costume"
	desc = "A giant hotdog costume, comes with authentic artificial hotdog scent."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "hotdog"
	item_state_slots = list(slot_r_hand_str = "hotdog", slot_l_hand_str = "hotdog")
	hoodtype = /obj/item/clothing/head/hood_vr/hotdog_hood

/obj/item/clothing/suit/storage/hooded/foodcostume/turnip	//Honey wake up, new vorny jail uniform just dropped.
	name = "turnip costume"
	desc = "A giant turnip costume, extra padding helps the wearer stand in the same spot for hours."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "turnip"
	item_state_slots = list(slot_r_hand_str = "turnip", slot_l_hand_str = "turnip")
	hoodtype = /obj/item/clothing/head/hood_vr/turnip_hood

//Functional hoodie

/obj/item/clothing/suit/storage/hooded/hoodie
	name = "hoodie"
	desc = "A warm jacket, now featuring a hood!"
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "hoodie_plain"
	item_state_slots = list(slot_r_hand_str = "grey_hoodie", slot_l_hand_str = "grey_hoodie")
	body_parts_covered = CHEST|ARMS|LEGS
	flags_inv = HIDEHOLSTER
	cold_protection = CHEST|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	hoodtype = /obj/item/clothing/head/hood/hoodie
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/hooded/hoodie/redtrim
	name = "red-trimmed hoodie"
	desc = "A warm jacket, now featuring a hood and a bold red trim!"
	icon_state = "hoodie_redtrim"

/obj/item/clothing/suit/storage/hooded/hoodie/bluetrim
	name = "blue-trimmed hoodie"
	desc = "A warm jacket, now featuring a hood and a cool blue trim!"
	icon_state = "hoodie_bluetrim"

/obj/item/clothing/suit/storage/hooded/hoodie/greentrim
	name = "green-trimmed hoodie"
	desc = "A warm jacket, now featuring a hood and a chilled green trim!"
	icon_state = "hoodie_greentrim"

/obj/item/clothing/suit/storage/hooded/hoodie/purpletrim
	name = "purple-trimmed hoodie"
	desc = "A warm jacket, now featuring a hood and a smart purple trim!"
	icon_state = "hoodie_purpletrim"

/obj/item/clothing/suit/storage/hooded/hoodie/yellowtrim
	name = "yellow-trimmed hoodie"
	desc = "A warm jacket, now featuring a hood and an eye-catching yellow trim!"
	icon_state = "hoodie_yellowtrim"

// CC Winter Coat
/obj/item/clothing/suit/storage/hooded/wintercoat/centcom
	name = "centcom winter coat"
	desc = "A cozy winter coat, covered in green fur and the colors of CentCom. Armored for extra protection."
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "coatcentcom"
	armor = list(melee = 40, bullet = 45, laser = 45, energy = 35, bomb = 40, bio = 25, rad = 25, fire = 35, acid = 50) //there is no cc armor here to base it off so, here's the values from the original cc coat
	hoodtype = /obj/item/clothing/head/hood/winter/centcom

/obj/item/clothing/suit/storage/hooded/wintercoat
	sprite_sheets = list(	SPECIES_TESHARI = 'icons/inventory/suit/mob_vr_teshari.dmi',
							SPECIES_VOX = 'icons/inventory/suit/mob_vox.dmi')

//Hoodies worth their weight in gold (as in you can unbutton them and toggle the hood independently)
/obj/item/clothing/suit/storage/hooded/toggle/colorable
	name = "hoodie"
	desc = "A rather plain hoodie. If you can't find it in your closet, chances are your significant other is borrowing it."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "choodie"
	hoodtype = /obj/item/clothing/head/hood/toggleable/colorable
	open = FALSE

/obj/item/clothing/suit/storage/hooded/toggle/colorable/sleeveless
	name = "sleeveless hoodie"
	desc = "Either your arms were too hot or the sleeves vaporized when you gave someone a 'gunshow' with your muscles. Either way, the sleeves are missing."
	icon_state = "choodie_sleeveless"

/obj/item/clothing/suit/storage/hooded/toggle/colorable/cropped
	name = "cropped hoodie"
	desc = "It's not that this is a size too small, you just like showing off your tum. I guess."
	icon_state = "choodie_crop"

/obj/item/clothing/suit/storage/hooded/toggle/colorable/shortsleeve
	name = "shortsleeve hoodie"
	desc = "For the times you can't decide between having sleeves and not having them."
	icon_state = "choodie_shortsleeve"
