/obj/item/clothing/accessory/knuckledusters
	name = "knuckle dusters"
	desc = "A pair of brass knuckles. Generally used to enhance the user's punches."
	icon_state = "knuckledusters"
	slot = ACCESSORY_SLOT_RING
	slot_flags = SLOT_GLOVES
	matter = list(MAT_STEEL = 500)
	attack_verb = list("punched", "beaten", "struck")
	siemens_coefficient = 1
	force = 10	//base punch strength is 5
	punch_force = 5	//added to base punch strength when added as a glove accessory
	icon = 'icons/inventory/hands/item.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
		)
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
