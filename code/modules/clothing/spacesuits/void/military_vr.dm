/obj/item/clothing/head/helmet/space/void/captain
	name = "\improper manager helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. This model sacrifices mobility for even more armor."
	icon_state = "capvoid"
	item_state_slots = list(slot_r_hand_str = "sec_helm", slot_l_hand_str = "sec_helm")
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/suit/space/void/captain
	name = "\improper manager armor"
	desc = "A special suit that protects against hazardous, low pressure environments. This model sacrifices mobility for even more armor."
	icon_state = "capsuit_void"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuit", slot_l_hand_str = "sec_voidsuit")
	slowdown = 1.5
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored

/obj/item/clothing/head/helmet/space/void/security/prototype
	name = "\improper security prototype voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. It's a little ostentatious, but it gets the job done."
	icon_state = "hosproto"

/obj/item/clothing/suit/space/void/security/prototype
	name = "\improper security prototype voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. It's a little ostentatious, but it gets the job done."
	icon_state = "hosproto_void"
