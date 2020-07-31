/obj/item/weapon/rig/exploration
	name = "heavy exploration HCM"
	suit_type = "heavy exploration hardsuit"
	desc = "Expeditionary Corps' Exoplanet Exploration Armored Unit, A-Unit for short. Built for more hostile (and hungry) environments, it features additional armor and powered exoskeleton."
	icon_state = "command_exp_rig"
	armor = list(
		melee = 50, 
		bullet = 25, 
		laser = 25, 
		energy = 40, 
		bomb = 10, 
		bio = 100, 
		rad = 100
		)

	helm_type = /obj/item/clothing/head/helmet/space/rig/exploration

	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit
		)

	slowdown = 0.50
	offline_slowdown = 4
	offline_vision_restriction = TINT_BLIND

/obj/item/clothing/head/helmet/space/rig/exploration
	light_overlay = "hardhat_light_dual"

/obj/item/clothing/head/helmet/space/rig/command/exploration
	camera = /obj/machinery/camera/network/exploration
	icon_state = "command_exp_rig"
	light_overlay = "yellow_double_light"
	brightness_on = 0.8

/obj/item/weapon/rig/exploration/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/grenade_launcher/light
		)
