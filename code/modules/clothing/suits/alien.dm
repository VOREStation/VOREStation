//Unathi clothing.
/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	flags_inv = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Taj clothing.
/obj/item/clothing/suit/tajaran/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

/obj/item/clothing/head/tajaran/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	item_state_slots = list(slot_r_hand_str = "beret_white", slot_l_hand_str = "beret_white")
	body_parts_covered = HEAD|FACE