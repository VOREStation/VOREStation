//these need item states -S2-
/obj/item/clothing/under/syndicate //Merc Tactleneck
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "syndicate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	has_sensor = 0
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/combat //ERT tactleneck
	name = "combat turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "combat"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	has_sensor = 1
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/tacticool
	name = "\improper Tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon_state = "tactifool"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	siemens_coefficient = 1
	rolled_sleeves = 0
