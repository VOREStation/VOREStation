// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/weapon/rig/light
	name = "light suit control module"
	desc = "A lighter, less armoured rig suit."
	icon_state = "ninja_rig"
	suit_type = "light suit"
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/cell,
		/obj/item/weapon/storage
		)
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	emp_protection = 10
	slowdown = 0
	item_flags = THICKMATERIAL
	offline_slowdown = 0
	offline_vision_restriction = 0

	chest_type = /obj/item/clothing/suit/space/rig/light
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light
	boot_type =  /obj/item/clothing/shoes/magboots/rig/light
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/light
	rigsuit_max_pressure = 5 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed

/obj/item/clothing/suit/space/rig/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits

/obj/item/clothing/gloves/gauntlets/rig/light
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/light
	name = "shoes"
	step_volume_mod = 0.8

/obj/item/clothing/head/helmet/space/rig/light
	name = "hood"

/obj/item/weapon/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_state = "hacker_rig"

	req_access = list(access_syndicate)

	airtight = 1
	seal_delay = 5 //Being straight out of a cyberpunk space movie has its perks.

	helm_type = /obj/item/clothing/head/helmet/space/rig/light/hacker
	chest_type = /obj/item/clothing/suit/space/rig/light/hacker
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/light/hacker
	boot_type = /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision,
		)

/obj/item/rig/light/hacker/poi/Initialize()
	. = ..()
	if(!QDELETED(src))
		emag_act()

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/helmet/space/rig/light/hacker
	name = "headgear"
	siemens_coefficient = 0.4
	flags_inv = HIDEEARS

/obj/item/clothing/suit/space/rig/light/hacker
	siemens_coefficient = 0.4

/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.4
	step_volume_mod = 0.3 //Special sneaky cyber-soles, for infiltration.
	flags = NOSLIP //They're not magboots, so they're not super good for exterior hull walking, BUT for interior infiltration they'll do swell.

/obj/item/clothing/gloves/gauntlets/rig/light/hacker
	siemens_coefficient = 0

/obj/item/weapon/rig/light/ninja
	name = "ominous suit control module"
	suit_type = "ominous"
	desc = "A unique suit of nano-enhanced armor designed for covert operations."
	icon_state = "ninja_rig"
	armor = list(melee = 50, bullet = 15, laser = 30, energy = 10, bomb = 25, bio = 100, rad = 30)
	emp_protection = 40 //change this to 30 if too high.
	slowdown = 0

	chest_type = /obj/item/clothing/suit/space/rig/light/ninja
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/light/ninja
	boot_type = /obj/item/clothing/shoes/magboots/rig/light/ninja
	cell_type =  /obj/item/weapon/cell/hyper

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct
		)

/obj/item/clothing/gloves/gauntlets/rig/light/ninja
	name = "insulated gloves"
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/light/ninja
	step_volume_mod = 0.25	//Not quite silent, but still damn quiet

/obj/item/clothing/suit/space/rig/light/ninja
	breach_threshold = 38 //comparable to regular hardsuits

/obj/item/weapon/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "stealth_rig"

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
		)

/obj/item/rig/light/stealth/poi/Initialize()
	. = ..()
	if(!QDELETED(src))
		emag_act()
