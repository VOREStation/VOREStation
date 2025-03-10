/obj/item/clothing/head/helmet/space/rig/industrial
	camera_networks = list(NETWORK_MINE)

/obj/item/clothing/head/helmet/space/rig/ce
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/head/helmet/space/rig/eva
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/head/helmet/space/rig/hazmat
	light_overlay = "hardhat_light"
	camera_networks = list(NETWORK_RESEARCH)

/obj/item/clothing/head/helmet/space/rig/medical
	camera_networks = list(NETWORK_MEDICAL)

/obj/item/clothing/head/helmet/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_SECURITY)

//Internal Affairs suit
/obj/item/rig/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "The last suit you'll ever wear."
	icon_state = "internalaffairs_rig"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage,
		)

	req_access = list()
	req_one_access = list()

	glove_type = null
	helm_type = null
	boot_type = null

/obj/item/rig/internalaffairs/equipped

	req_access = list(access_lawyer)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/paperdispenser,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp
		)

	glove_type = null
	helm_type = null
	boot_type = null

//Mining suit
/obj/item/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations."
	icon_state = "engineering_rig"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 50)
	slowdown = 0.5
	offline_slowdown = 5
	offline_vision_restriction = 2
	emp_protection = -20
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 15 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed

	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage,
		/obj/item/t_scanner,
		/obj/item/pickaxe,
		/obj/item/rcd
		)

	req_access = list()
	req_one_access = list()


/obj/item/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/vision/material,
		/obj/item/rig_module/maneuvering_jets) //VOREStation Edit - Added maneuvering jets

//Engineering suit
/obj/item/rig/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(melee = 30, bullet = 10, laser = 20,energy = 25, bomb = 20, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 0.5
	offline_vision_restriction = 1
	siemens_coefficient= 0.75

	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/eva

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage,
		/obj/item/t_scanner,
		/obj/item/rcd
		)

	req_access = list()
	req_one_access = list()
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/gauntlets/rig/eva
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/rig/eva/equipped

	req_access = list(access_engine)

	initial_modules = list(
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson
		)

//Chief Engineer's rig. This is sort of a halfway point between the old hardsuits (voidsuits) and the rig class.
/obj/item/rig/ce

	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon_state = "ce_rig"
	armor = list(melee = 40, bullet = 10, laser = 30,energy = 25, bomb = 40, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 20 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/ce
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce //VOREStation Add

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage,
		/obj/item/t_scanner,
		/obj/item/rcd
		)

	req_access = list()
	req_one_access = list()
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/gauntlets/rig/ce
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/rig/ce/equipped

	req_access = list(access_ce)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson
		)

//Research Director's suit. Just add red crowbar.
/obj/item/rig/hazmat

	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon_state = "science_rig"
	armor = list(melee = 45, bullet = 5, laser = 45, energy = 80, bomb = 60, bio = 100, rad = 100)
	slowdown = 0.5
	offline_vision_restriction = 1
	siemens_coefficient= 0.75

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/storage,
		/obj/item/pickaxe,
		/obj/item/healthanalyzer,
		/obj/item/measuring_tape,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/pickaxe/hand
		)

	req_access = list()
	req_one_access = list()

/obj/item/rig/hazmat/equipped

	req_access = list(access_rd)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner
		)

//Paramedic suit
/obj/item/rig/medical

	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor = list(melee = 30, bullet = 15, laser = 20, energy = 60, bomb = 30, bio = 100, rad = 100)
	slowdown = 0.5
	offline_vision_restriction = 1
	siemens_coefficient= 0.75
	seal_delay = 5

	helm_type = /obj/item/clothing/head/helmet/space/rig/medical

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage,
		/obj/item/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/roller
		)

	req_access = list()
	req_one_access = list()

/obj/item/rig/medical/equipped

	req_access = list(access_medical)

	initial_modules = list(
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud
		)

//Security suit
/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A Security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(melee = 60, bullet = 40, laser = 30, energy = 15, bomb = 60, bio = 100, rad = 30)
	slowdown = 0.5
	offline_slowdown = 1.5
	offline_vision_restriction = 1
	siemens_coefficient= 0.7

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard

	allowed = list(
		/obj/item/gun,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/melee/baton,
		/obj/item/storage
		)

	req_access = list()
	req_one_access = list()


/obj/item/rig/hazard/equipped

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser
		)
