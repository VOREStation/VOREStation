//Advanced Exploration 	Suit
/obj/item/rig/robotics
	name = "advanced suit control belt"
	suit_type = "advanced"
	desc = "A lightweight suit combining the utility of a RIG with the wearability of a voidsuit."
	icon_state = "void_explorer2"
	slot_flags = SLOT_BELT
	armor = list(melee = 40, bullet = 30, laser = 20, energy = 15, bomb = 30, bio = 100, rad = 50)
	slowdown = 0.5
	offline_slowdown = 1
	offline_vision_restriction = 0
	emp_protection = -20
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 8 * ONE_ATMOSPHERE
	rigsuit_min_pressure = 0

	chest_type = /obj/item/clothing/suit/space/rig/advsuit
	helm_type =  /obj/item/clothing/head/helmet/space/rig/advsuit
	boot_type =  null
	glove_type = null
	cell_type =  null

	allowed = list(
		/obj/item/flashlight,
		/obj/item/storage/box
		)

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/advsuit
	name = "suit helmet"

/obj/item/clothing/suit/space/rig/advsuit
	name = "voidsuit"
	body_parts_covered = CHEST|LEGS|ARMS|HANDS|FEET
	heat_protection =	 CHEST|LEGS|ARMS|HANDS|FEET
	cold_protection =	 CHEST|LEGS|ARMS|HANDS|FEET
