//Mining suit
/obj/item/weapon/rig/robotics
	name = "advanced suit control belt"
	suit_type = "advanced suit"
	desc = "A lightweight suit combining the utility of a RIG with the wearability of a voidsuit."
	icon_state = "void_explorer2"
	slot_flags = SLOT_BELT
	armor = list(melee = 40, bullet = 30, laser = 20, energy = 15, bomb = 30, bio = 100, rad = 50)
	slowdown = 1
	offline_slowdown = 2
	offline_vision_restriction = 0
	emp_protection = -20
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 8 * ONE_ATMOSPHERE
	rigsuit_min_pressure = 0

	chest_type = /obj/item/clothing/suit/space/rig
	helm_type =  /obj/item/clothing/head/helmet/space/rig
	boot_type =  null
	glove_type = null
	cell_type =  null

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/storage/box
		)

	req_access = list()
	req_one_access = list()
