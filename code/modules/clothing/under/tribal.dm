/* Tribal Clothing
 * Contains:
 *		Primitive Clothing
 *		Tribal Clothing
 */

/*
 * Primitive Clothing
 */
/obj/item/clothing/under/primitive
	name = "primitive clothes"
	desc = "Some patched together rags. Better than being naked."
	force = 0
	icon_state = "rag"
	worn_state = "rag"

/obj/item/clothing/shoes/primitive
	name = "primitive shoes"
	desc = "Some patched together rags. Better than being barefoot."
	icon_state = "rag"
	force = 0
	drop_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/clothing.ogg'

/*
 * Tribal Clothing
 */
/obj/item/clothing/under/permit/natureist_talisman //Tribal version of the Nudity Permit
	name = "naturist talisman"
	desc = "This ancient talisman gives rights to those that wish to be closer to nature by casting their constricting clothes aside."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_override = 'icons/inventory/accessory/mob.dmi'
	icon_state = "talisman"
	item_state = "talisman"
	worn_state = "talisman"

/obj/item/clothing/under/tribalwear
	item_state_slots = list(slot_r_hand_str = "tribalwear", slot_l_hand_str = "tribalwear")

/obj/item/clothing/under/tribalwear/common1
	name = "tribalwear"
	desc = "A traditionally woven robe made with locally sourced material."
	icon_state = "tribal_common1"

/obj/item/clothing/under/tribalwear/common2
	name = "tribalwear"
	desc = "A traditionally woven outfit made with locally sourced material."
	icon_state = "tribal_common2"

/obj/item/clothing/under/tribalwear/hunter
	name = "hunting tribalwear"
	desc = "Dusty rags decorated with strips of leather and small pieces of cyan colored stones."
	icon_state = "tribal_hunter"

/obj/item/clothing/under/tribalwear/chief
	name = "chief's tribalwear"
	desc = "Well maintained robe adorned with fine leather and polished cyan stones."
	icon_state = "tribal_chief"

/obj/item/clothing/under/tribalwear/shaman
	name = "shaman robes"
	desc = "Carefully hand wozen cloth robes with heavy colored stones jewelry drapped over top."
	icon_state = "tribal_shaman"

/obj/item/clothing/shoes/tribalwear
	name = "tribal sandals"
	desc = "Traditionally made sandals made with local materials."
	icon_state = "tribal_sandals"
	species_restricted = null
	body_parts_covered = 0