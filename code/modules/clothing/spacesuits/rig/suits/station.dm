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

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, /obj/item/storage)

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

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS, POCKET_MINING, POCKET_BAYSUIT)

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
	siemens_coefficient = 0.75

	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/eva

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_CE, /obj/item/storage)

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

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS, POCKET_MINING, POCKET_ENGINEERING, POCKET_CE, POCKET_BAYSUIT)

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

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS, POCKET_MINING, POCKET_XENOARC, POCKET_BAYSUIT)

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

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS, POCKET_MEDICAL, POCKET_BAYSUIT, /obj/item/roller, /obj/item/storage/firstaid)

	req_access = list()
	req_one_access = list()

//Access restriction and seal delay, plus pat_module and rescue_pharm for medical suit
/obj/item/rig/medical/equipped
	req_access = list(access_medical)
	seal_delay = 5

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/pat_module,
		/obj/item/rig_module/rescue_pharm
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

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS, POCKET_EXPLO, POCKET_BAYSUIT)

	req_access = list()
	req_one_access = list()


/obj/item/rig/hazard/equipped

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser
		)

// 'Technomancer' hardsuit
/obj/item/rig/focalpoint
	name = "\improper F.P.E. hardsuit control module"
	desc = "A high-end hardsuit produced by Focal Point Energistics, focused around repair and construction."

	icon = 'icons/obj/rig_modules_vr.dmi' // the item
	default_mob_icon = 'icons/mob/rig_back_vr.dmi' // the onmob
	icon_state = "techno_rig"
	suit_type = "\improper F.P.E. hardsuit"
	cell_type = /obj/item/cell/hyper

	// Copied from CE rig
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0
	rigsuit_max_pressure = 20 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE // so it's like a rig firesuit
	armor = list("melee" = 40, "bullet" = 10, "laser" = 30, "energy" = 55, "bomb" = 70, "bio" = 100, "rad" = 100)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, /obj/item/storage/backpack)
	chest_type = /obj/item/clothing/suit/space/rig/focalpoint
	helm_type = /obj/item/clothing/head/helmet/space/rig/focalpoint
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce/focalpoint
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/focalpoint

/obj/item/rig/focalpoint/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/teleporter, // Try not to set yourself on fire
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/grenade_launcher/metalfoam
	)

/obj/item/clothing/head/helmet/space/rig/focalpoint
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "techno_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

/obj/item/clothing/suit/space/rig/focalpoint
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "techno_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

/obj/item/clothing/shoes/magboots/rig/ce/focalpoint
	icon = 'icons/inventory/feet/item_vr.dmi'
	default_worn_icon = 'icons/inventory/feet/mob_vr.dmi'
	icon_state = "techno_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

/obj/item/clothing/gloves/gauntlets/rig/focalpoint
	icon = 'icons/inventory/hands/item_vr.dmi'
	default_worn_icon = 'icons/inventory/hands/mob_vr.dmi'
	icon_state = "techno_rig"
	siemens_coefficient = 0
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

// 'Ironhammer' hardsuit
/obj/item/rig/hephaestus
	name = "\improper Hephaestus hardsuit control module"
	desc = "A high-end hardsuit produced by Hephaestus Industries, focused on destroying the competition. Literally."

	icon = 'icons/obj/rig_modules_vr.dmi' // the item
	default_mob_icon = 'icons/mob/rig_back_vr.dmi' // the onmob
	icon_state = "ihs_rig"
	suit_type = "\improper Hephaestus hardsuit"
	cell_type = /obj/item/cell/super
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_SECURITY, POCKET_ENGINEERING, POCKET_BAYSUIT, /obj/item/storage/firstaid, /obj/item/roller)

	armor = list("melee" = 70, "bullet" = 70, "laser" = 70, "energy" = 50, "bomb" = 60, "bio" = 100, "rad" = 20)

	chest_type = /obj/item/clothing/suit/space/rig/hephaestus
	helm_type = /obj/item/clothing/head/helmet/space/rig/hephaestus
	boot_type = /obj/item/clothing/shoes/magboots/rig/hephaestus
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/hephaestus

/obj/item/rig/hephaestus/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/mounted/energy_blade
	)

/obj/item/clothing/head/helmet/space/rig/hephaestus
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "ihs_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

/obj/item/clothing/suit/space/rig/hephaestus
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "ihs_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

/obj/item/clothing/shoes/magboots/rig/hephaestus
	icon = 'icons/inventory/feet/item_vr.dmi'
	default_worn_icon = 'icons/inventory/feet/mob_vr.dmi'
	icon_state = "ihs_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

/obj/item/clothing/gloves/gauntlets/rig/hephaestus
	icon = 'icons/inventory/hands/item_vr.dmi'
	default_worn_icon = 'icons/inventory/hands/mob_vr.dmi'
	icon_state = "ihs_rig"
	// No animal people sprites for these yet, sad times
	species_restricted = list("exclude", SPECIES_TESHARI, SPECIES_VOX, SPECIES_DIONA)
	sprite_sheets = null

// 'Zero' rig
/obj/item/rig/zero
	name = "null hardsuit control module"
	desc = "A very lightweight suit designed to allow use inside mechs and starfighters. It feels like you're wearing nothing at all."

	icon = 'icons/obj/rig_modules_vr.dmi' // the item
	default_mob_icon = 'icons/mob/rig_back_vr.dmi' // the onmob
	icon_state = "null_rig"
	suit_type = "null hardsuit"
	cell_type = /obj/item/cell/high

	chest_type = /obj/item/clothing/suit/space/rig/zero
	helm_type = /obj/item/clothing/head/helmet/space/rig/zero
	boot_type = null
	glove_type = null
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_BAYSUIT)

	slowdown = 0
	offline_slowdown = 1
	offline_vision_restriction = 2
	armor = list("melee" = 20, "bullet" = 5, "laser" = 10, "energy" = 5, "bomb" = 35, "bio" = 100, "rad" = 20)

/obj/item/rig/zero/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets
	)

/obj/item/clothing/head/helmet/space/rig/zero
	desc = "A bubble helmet that maximizes the field of view. A state of the art holographic display provides a stream of information."
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "null_rig"
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM
	slowdown = 0

/obj/item/clothing/suit/space/rig/zero
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "null_rig"
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS // like a voidsuit
	slowdown = 0

// Medical rig from bay
/obj/item/rig/baymed
	name = "\improper Commonwealth medical hardsuit control module"
	desc = "A lightweight first responder hardsuit from the Commonwealth. Not suitable for combat use, but advanced myomer fibers can push the user to incredible speeds."
	interface_intro = "Commonwealth"

	icon = 'icons/obj/rig_modules_vr.dmi' // the item
	default_mob_icon = 'icons/mob/rig_back_vr.dmi' // the onmob
	icon_state = "medical_rig_bay"
	item_state = null
	suit_type = "medical hardsuit"
	cell_type = /obj/item/cell/high

	chest_type = /obj/item/clothing/suit/space/rig/baymed
	helm_type = /obj/item/clothing/head/helmet/space/rig/baymed
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce/baymed
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/baymed

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_MEDICAL, POCKET_BAYSUIT, /obj/item/roller)

	// speedy paper
	slowdown = -0.5
	armor = list("melee" = 10, "bullet" = 5, "laser" = 10, "energy" = 5, "bomb" = 25, "bio" = 100, "rad" = 20)

/obj/item/rig/baymed/equipped

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/pat_module,
		/obj/item/rig_module/rescue_pharm
	)

/obj/item/clothing/head/helmet/space/rig/baymed
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "medical_rig_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM
	camera_networks = list(NETWORK_MEDICAL)

/obj/item/clothing/suit/space/rig/baymed
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "medical_rig_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM

/obj/item/clothing/shoes/magboots/rig/ce/baymed
	icon = 'icons/inventory/feet/item_vr.dmi'
	default_worn_icon = 'icons/inventory/feet/mob_vr.dmi'
	icon_state = "medical_rig_bay"
	item_state = null
	sprite_sheets = null
	sprite_sheets_obj = null

/obj/item/clothing/gloves/gauntlets/rig/baymed
	icon = 'icons/inventory/hands/item_vr.dmi'
	default_worn_icon = 'icons/inventory/hands/mob_vr.dmi'
	icon_state = "medical_rig_bay"
	item_state = null
	sprite_sheets = null
	sprite_sheets_obj = null

// Engineering/'Industrial' rig from bay
/obj/item/rig/bayeng
	name = "\improper Commonwealth engineering hardsuit control module"
	desc = "An advanced construction hardsuit from the Commonwealth. Built like a tank. Don't expect to be taking any tight corners while running."
	interface_intro = "Commonwealth"

	icon = 'icons/obj/rig_modules_vr.dmi' // the item
	default_mob_icon = 'icons/mob/rig_back_vr.dmi' // the onmob
	icon_state = "engineering_rig_bay"
	item_state = null
	suit_type = "engineering hardsuit"
	cell_type = /obj/item/cell/super

	chest_type = /obj/item/clothing/suit/space/rig/bayeng
	helm_type = /obj/item/clothing/head/helmet/space/rig/bayeng
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce/bayeng
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/bayeng

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_MINING, POCKET_CE, POCKET_BAYSUIT)

	slowdown = 0
	offline_slowdown = 5 // very bulky
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 50)

/obj/item/rig/bayeng/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/grenade_launcher/metalfoam,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/ai_container
	)

/obj/item/clothing/head/helmet/space/rig/bayeng
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "engineering_rig_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/suit/space/rig/bayeng
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "engineering_rig_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM

/obj/item/clothing/shoes/magboots/rig/ce/bayeng
	icon = 'icons/inventory/feet/item_vr.dmi'
	default_worn_icon = 'icons/inventory/feet/mob_vr.dmi'
	icon_state = "engineering_rig_bay"
	item_state = null
	sprite_sheets = null
	sprite_sheets_obj = null

/obj/item/clothing/gloves/gauntlets/rig/bayeng
	icon = 'icons/inventory/hands/item_vr.dmi'
	default_worn_icon = 'icons/inventory/hands/mob_vr.dmi'
	icon_state = "engineering_rig_bay"
	item_state = null
	sprite_sheets = null
	sprite_sheets_obj = null
	siemens_coefficient = 0 // insulated

// Pathfinder rig from bay - event/reward stuff here
/obj/item/rig/pathfinder
	name = "\improper Commonwealth pathfinder hardsuit control module"
	desc = "A Commonwealth pathfinder hardsuit is hard to come by... how'd this end up on the frontier?"
	interface_intro = "Commonwealth"

	icon = 'icons/obj/rig_modules_vr.dmi' // the item
	default_mob_icon = 'icons/mob/rig_back_vr.dmi' // the onmob
	icon_state = "pathfinder_rig_bay"
	item_state = null
	suit_type = "pathfinder hardsuit"
	cell_type = /obj/item/cell/super

	chest_type = /obj/item/clothing/suit/space/rig/pathfinder
	helm_type = /obj/item/clothing/head/helmet/space/rig/pathfinder
	boot_type = /obj/item/clothing/shoes/magboots/rig/pathfinder
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/pathfinder

	slowdown = 0.5
	offline_slowdown = 4 // bulky
	offline_vision_restriction = 2 // doesn't even have a way to see out without power
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 50)

/obj/item/rig/pathfinder//equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy_blade
	)

/obj/item/clothing/head/helmet/space/rig/pathfinder
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "pathfinder_rig_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

/obj/item/clothing/suit/space/rig/pathfinder
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "pathfinder_rig_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM

/obj/item/clothing/shoes/magboots/rig/pathfinder
	icon = 'icons/inventory/feet/item_vr.dmi'
	default_worn_icon = 'icons/inventory/feet/mob_vr.dmi'
	icon_state = "pathfinder_rig_bay"
	item_state = null
	sprite_sheets = null
	sprite_sheets_obj = null

/obj/item/clothing/gloves/gauntlets/rig/pathfinder
	icon = 'icons/inventory/hands/item_vr.dmi'
	default_worn_icon = 'icons/inventory/hands/mob_vr.dmi'
	icon_state = "pathfinder_rig_bay"
	item_state = null
	sprite_sheets = null
	sprite_sheets_obj = null

/obj/item/rig/industrial/vendor
	name = "discount industrial suit control module"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations. This is a mass production model with reduced armor."
	armor = list(melee = 50, bullet = 10, laser = 20, energy = 15, bomb = 30, bio = 100, rad = 50)
