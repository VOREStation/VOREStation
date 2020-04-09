// Field Medic Suit - Someone who can sprite should probably reskin this
/obj/item/clothing/suit/storage/hooded/explorer/medic
	starting_accessories = list(/obj/item/clothing/accessory/armband/med/cross)

/obj/item/clothing/suit/storage/hooded/techpriest
	name = "tech priest robe"
	desc = "Praise be to the Omnissiah."
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	icon_state = "techpriest"
	hoodtype = /obj/item/clothing/head/hood/techpriest
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 25, bio = 50, rad = 25)
	item_state_slots = list(slot_r_hand_str = "engspace_suit", slot_l_hand_str = "engspace_suit")
