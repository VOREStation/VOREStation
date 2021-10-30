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
	action_button_name = "Toggle Knight Headgear"

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
	action_button_name = "Toggle Knight Headgear"

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
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "taloncoat"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/talon
