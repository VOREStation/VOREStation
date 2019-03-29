/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	brightness_on = 4 //luminosity when on
	light_overlay = "hardhat_light"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9
	action_button_name = "Toggle Head-light"
	w_class = ITEMSIZE_NORMAL
	ear_protection = 1

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	name = "orange hard hat"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	name = "firefighter helmet"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0.2* ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE


/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	name = "sleek hard hat"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0.2* ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE

/obj/item/clothing/head/hardhat/dblue
	name = "blue hard hat"
	icon_state = "hardhat0_dblue"
