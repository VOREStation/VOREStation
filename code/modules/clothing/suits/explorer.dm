/obj/item/clothing/suit/storage/explorer
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_DETECTIVE, /obj/item/clothing/head/beret)

/obj/item/clothing/suit/storage/explorer/crew
	name = "\improper Explorer jacket"
	desc = "A exploration jacket belonging to the the Explorer's association. It has silver buttons."
	icon_state = "blackservice"

/obj/item/clothing/suit/storage/explorer/medical
	name = "\improper Explorer medical jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has silver buttons and blue trim."
	icon_state = "blackservice_med"

/obj/item/clothing/suit/storage/explorer/medical/command
	name = "\improper Explorer medical command jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has gold buttons and blue trim."
	icon_state = "blackservice_medcom"

/obj/item/clothing/suit/storage/explorer/engineering
	name = "\improper Explorer engineering jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has silver buttons and orange trim."
	icon_state = "blackservice_eng"

/obj/item/clothing/suit/storage/explorer/engineering/command
	name = "\improper Explorer engineering command jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has gold buttons and orange trim."
	icon_state = "blackservice_engcom"

/obj/item/clothing/suit/storage/explorer/supply
	name = "\improper Explorer supply jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has silver buttons and brown trim."
	icon_state = "blackservice_sup"

/obj/item/clothing/suit/storage/explorer/security
	name = "\improper Explorer security jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has silver buttons and red trim."
	icon_state = "blackservice_sec"

/obj/item/clothing/suit/storage/explorer/security/command
	name = "\improper Explorer security command jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has gold buttons and red trim."
	icon_state = "blackservice_seccom"

/obj/item/clothing/suit/storage/explorer/command
	name = "\improper Explorer command jacket"
	desc = "A exploration jacket belonging to the Explorer's association. It has gold buttons and gold trim."
	icon_state = "blackservice_com"
