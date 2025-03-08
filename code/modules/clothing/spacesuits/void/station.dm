// Station voidsuits
//Engineering
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has moderate radiation and pressure shielding."
	icon_state = "rig0-engineering"
	item_state_slots = list(slot_r_hand_str = "eng_helm", slot_l_hand_str = "eng_helm")
	armor = list(melee = 30, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 70)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+5000
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has moderate radiation and pressure shielding."
	icon_state = "rig-engineering"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")
	armor = list(melee = 30, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 70)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_MINING, POCKET_ENGINEERING, POCKET_CE)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+5000
	breach_threshold = 14 //These are kinda thicc
	slowdown = 1

//Engineering HAZMAT Voidsuit

/obj/item/clothing/head/helmet/space/void/engineering/hazmat
	name = "HAZMAT voidsuit helmet"
	desc = "A engineering helmet designed for work in a low-pressure environment. Extra radiation shielding appears to have been installed at the price of comfort."
	icon_state = "rig0-engineering_rad"
	item_state_slots = list(slot_r_hand_str = "eng_helm_rad", slot_l_hand_str = "eng_helm_rad")
	armor = list(melee = 25, bullet = 5, laser = 20, energy = 5, bomb = 50, bio = 100, rad = 100)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/void/engineering/hazmat
	name = "HAZMAT voidsuit"
	desc = "A engineering voidsuit that protects against hazardous, low pressure environments. Has enhanced radiation shielding compared to regular engineering voidsuits."
	icon_state = "rig-engineering_rad"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit_rad", slot_l_hand_str = "eng_voidsuit_rad")
	armor = list(melee = 25, bullet = 5, laser = 20, energy = 5, bomb = 50, bio = 100, rad = 100)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

//Engineering Construction Voidsuit

/obj/item/clothing/head/helmet/space/void/engineering/construction
	name = "construction voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Exchanges radiation shielding for extra armor and maneuverability for field projects."
	icon_state = "rig0-engineering_con"
	item_state_slots = list(slot_r_hand_str = "eng_helm_con", slot_l_hand_str = "eng_helm_con")
	armor = list(melee = 40, bullet = 15, laser = 25, energy = 15, bomb = 35, bio = 100, rad = 50)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/void/engineering/construction
	name = "construction voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Exchanges radiation shielding for extra armor and maneuverability for field projects."
	icon_state = "rig-engineering_con"
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit_con", slot_l_hand_str = "eng_voidsuit_con")
	armor = list(melee = 40, bullet = 15, laser = 25, energy = 15, bomb = 35, bio = 100, rad = 50)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	slowdown = 0.5

//Engineering Surplus Voidsuits

/obj/item/clothing/head/helmet/space/void/engineering/alt
	name = "reinforced engineering voidsuit helmet"
	desc = "A heavy, radiation-shielded voidsuit helmet with a surprisingly comfortable interior."
	icon_state = "rig0-engineeringalt"
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 5, bomb = 45, bio = 100, rad = 100)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/engineering/alt
	name = "reinforced engineering voidsuit"
	desc = "A bulky industrial voidsuit. It's a few generations old, but a reliable design and radiation shielding make up for the lack of climate control."
	icon_state = "rig-engineeringalt"
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 100)
	slowdown = 0.5

/obj/item/clothing/head/helmet/space/void/engineering/salvage
	name = "salvage voidsuit helmet"
	desc = "A heavily modified salvage voidsuit helmet. It has been fitted with radiation-resistant plating."
	icon_state = "rig0-salvage"
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 100)

/obj/item/clothing/suit/space/void/engineering/salvage
	name = "salvage voidsuit"
	desc = "A hand-me-down salvage voidsuit. It has obviously had a lot of repair work done to its radiation shielding."
	icon_state = "rig-engineeringsav"
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 100)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_ENGINEERING, POCKET_CE)
	slowdown = 0.5

//Mining
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "rig0-mining"
	item_state_slots = list(slot_r_hand_str = "mining_helm", slot_l_hand_str = "mining_helm")
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 55, bio = 100, rad = 50)
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_CARGO)

/obj/item/clothing/suit/space/void/mining
	name = "mining voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	icon_state = "rig-mining"
	item_state_slots = list(slot_r_hand_str = "mining_voidsuit", slot_l_hand_str = "mining_voidsuit")
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_MINING)
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 55, bio = 100, rad = 50)
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored
	slowdown = 1

//Mining Surplus Voidsuit

/obj/item/clothing/head/helmet/space/void/mining/alt
	name = "frontier mining voidsuit helmet"
	desc = "An armored cheap voidsuit helmet. Someone must have through they were pretty cool when they painted a mohawk on it."
	icon_state = "rig0-miningalt"

/obj/item/clothing/suit/space/void/mining/alt
	icon_state = "rig-miningalt"
	name = "frontier mining voidsuit"
	desc = "A cheap prospecting voidsuit. What it lacks in comfort it makes up for in armor plating and street cred."
	slowdown = 0.5

//Medical
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-medical"
	item_state_slots = list(slot_r_hand_str = "medical_helm", slot_l_hand_str = "medical_helm")
	armor = list(melee = 30, bullet = 5, laser = 20, energy = 5, bomb = 25, bio = 100, rad = 80)
	camera_networks = list(NETWORK_MEDICAL)

/obj/item/clothing/suit/space/void/medical
	name = "medical voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	icon_state = "rig-medical"
	item_state_slots = list(slot_r_hand_str = "medical_voidsuit", slot_l_hand_str = "medical_voidsuit")
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_MEDICAL)
	armor = list(melee = 30, bullet = 5, laser = 20, energy = 5, bomb = 25, bio = 100, rad = 80)

//Medical EMT Voidsuit

/obj/item/clothing/head/helmet/space/void/medical/emt
	name = "emergency medical response voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Exchanges radiation shielding for some additional protection."
	icon_state = "rig0-medical_emt"
	item_state_slots = list(slot_r_hand_str = "medical_helm_emt", slot_l_hand_str = "medical_helm_emt")
	armor = list(melee = 40, bullet = 15, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)

/obj/item/clothing/suit/space/void/medical/emt
	name = "emergency medical response voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Exchanges radiation shielding for some additional protection."
	icon_state = "rig-medical_emt"
	item_state_slots = list(slot_r_hand_str = "medical_voidsuit_emt", slot_l_hand_str = "medical_voidsuit_emt")
	armor = list(melee = 40, bullet = 15, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
	breach_threshold = 14 //These are kinda thicc

//Medical Biohazard Voidsuit

/obj/item/clothing/head/helmet/space/void/medical/bio
	name = "biohazard voidsuit helmet"
	desc = "A special suit designed to protect the user in hazardous environments on the field. It feels heavier than the standard suit with extra protection around the joints."
	icon_state = "rig0-medical_bio"
	item_state_slots = list(slot_r_hand_str = "medical_helm_bio", slot_l_hand_str = "medical_helm_bio")
	armor = list(melee = 55, bullet = 15, laser = 20, energy = 15, bomb = 15, bio = 100, rad = 75)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE

/obj/item/clothing/suit/space/void/medical/bio
	name = "biohazard voidsuit"
	desc = "A special suit designed to protect the user in hazardous environments on the field. It feels heavier than the standard suit with extra protection around the joints."
	icon_state = "rig-medical_bio"
	item_state_slots = list(slot_r_hand_str = "medical_voidsuit_bio", slot_l_hand_str = "medical_voidsuit_bio")
	armor = list(melee = 55, bullet = 15, laser = 20, energy = 15, bomb = 15, bio = 100, rad = 75)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	breach_threshold = 16 //Extra Thicc
	slowdown = 1.5

//Medical Streamlined Voidsuit
/obj/item/clothing/head/helmet/space/void/medical/veymed
	name = "lightweight medical voidsuit helmet"
	desc = "A trendy, lightly radiation-shielded voidsuit helmet trimmed in a sleek blue. It possesses advanced autoadaptive systems and doesn't need to be cycled to change species fit for most large humanoids."
	icon_state = "rig0-medicalalt"
	armor = list(melee = 20, bullet = 5, laser = 20,energy = 5, bomb = 15, bio = 100, rad = 30)
	light_overlay = "helmet_light_dual_blue"
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt to most species, but diona/vox are too weird
	no_cycle = TRUE

/obj/item/clothing/suit/space/void/medical/veymed
	name = "lightweight medical voidsuit"
	desc = "A more recent model of Vey-Med voidsuit, exchanging physical protection for fully unencumbered movement and a complete range of motion. It possesses advanced autoadaptive systems and doesn't need to be cycled to change species fit for most large humanoids."
	icon_state = "rig-medicalalt"
	slowdown = 0
	armor = list(melee = 20, bullet = 5, laser = 20,energy = 5, bomb = 15, bio = 100, rad = 30)
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt, but diona/vox are too weird
	no_cycle = TRUE

/obj/item/clothing/head/helmet/space/void/medical/veymed_static
	name = "nonadaptive lightweight medical voidsuit helmet"
	desc = "A trendy, lightly radiation-shielded voidsuit helmet trimmed in a sleek blue. This specific model lacks the autoadaption feature as a cost-saving measure."
	icon_state = "rig0-medicalalt"
	armor = list(melee = 20, bullet = 5, laser = 20,energy = 5, bomb = 15, bio = 100, rad = 30)
	light_overlay = "helmet_light_dual_blue"

/obj/item/clothing/suit/space/void/medical/veymed_static
	name = "nonadaptive lightweight medical voidsuit"
	desc = "A more recent model of Vey-Med voidsuit, exchanging physical protection for fully unencumbered movement and a complete range of motion. This specific model lacks the autoadaption feature as a cost-saving measure."
	icon_state = "rig-medicalalt"
	slowdown = 0
	armor = list(melee = 20, bullet = 5, laser = 20,energy = 5, bomb = 15, bio = 100, rad = 30)

//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-sec"
	item_state_slots = list(slot_r_hand_str = "sec_helm", slot_l_hand_str = "sec_helm")
	armor = list(melee = 50, bullet = 25, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_SECURITY)

/obj/item/clothing/suit/space/void/security
	name = "security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	icon_state = "rig-sec"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuit", slot_l_hand_str = "sec_voidsuit")
	armor = list(melee = 50, bullet = 25, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 10)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ALL_TANKS, POCKET_EXPLO)
	siemens_coefficient = 0.7
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored
	slowdown = 1

//Security Crowd Control Voidsuit

/obj/item/clothing/head/helmet/space/void/security/riot
	name = "crowd control voidsuit helmet"
	desc = "A heavy-set and ominous looking crowd control suit helmet. Fitted with state of the art shock absorbing materials, to disperse blunt force trauma."
	icon_state = "rig0-sec_riot"
	armor = list(melee = 70, bullet = 15, laser = 15, energy = 15, bomb = 60, bio = 100, rad = 10)
	item_state_slots = list(slot_r_hand_str = "sec_helm_riot", slot_l_hand_str = "sec_helm_riot")

/obj/item/clothing/suit/space/void/security/riot
	name = "crowd control voidsuit"
	desc = "A heavy-set and ominous looking crowd control suit. Fitted with state of the art shock absorbing materials, to disperse blunt force trauma."
	icon_state = "rig-sec_riot"
	armor = list(melee = 70, bullet = 15, laser = 15, energy = 15, bomb = 60, bio = 100, rad = 10)
	breach_threshold = 16 //Extra Thicc
	resilience = 0.1 //Heavily Armored
	item_state_slots = list(slot_r_hand_str = "sec_voidsuit_riot", slot_l_hand_str = "sec_voidsuit_riot")

//Security Surplus Voidsuit
/obj/item/clothing/head/helmet/space/void/security/alt
	name = "security EVA voidsuit helmet"
	desc = "A grey-black voidsuit helmet with red highlights. A little tacky, but it offers better protection against modern firearms and radiation than standard-issue security voidsuit helmets."
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 25, bomb = 40, bio = 100, rad = 50)
	icon_state = "rig0-secalt"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")

/obj/item/clothing/suit/space/void/security/alt
	name = "security EVA voidsuit"
	desc = "A grey-black voidsuit with red highlights. A little tacky, but it offers better protection against modern firearms and radiation than standard-issue security voidsuits."
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 25, bomb = 40, bio = 100, rad = 50)
	breach_threshold = 16 //Extra Thicc
	resilience = 0.1 //Heavily Armored
	icon_state = "rig-secalt"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon_state = "rig0-atmos"
	item_state_slots = list(slot_r_hand_str = "atmos_helm", slot_l_hand_str = "atmos_helm")
	armor = list(melee = 40, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE+15000
	light_overlay = "helmet_light_dual"
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/suit/space/void/atmos
	name = "atmos voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	icon_state = "rig-atmos"
	item_state_slots = list(slot_r_hand_str = "atmos_voidsuit", slot_l_hand_str = "atmos_voidsuit")
	armor = list(melee = 40, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE+15000
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	breach_threshold = 16 //Extra Thicc
	slowdown = 1.5

//Atmospherics Surplus Voidsuit

/obj/item/clothing/head/helmet/space/void/atmos/alt
	desc = "A special voidsuit helmet designed for work in hazardous, low pressure environments.This one has been plated with an expensive heat and radiation resistant ceramic."
	name = "heavy duty atmospherics voidsuit helmet"
	icon_state = "rig0-atmosalt"
	armor = list(melee = 40, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 70)
	light_overlay = "hardhat_light"

/obj/item/clothing/suit/space/void/atmos/alt
	desc = "A special suit that protects against hazardous, low pressure environments. Fits better than the standard atmospheric voidsuit while still rated to withstand extreme heat and even minor radiation."
	icon_state = "rig-atmosalt"
	name = "heavy duty atmos voidsuit"
	armor = list(melee = 40, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 70)
	slowdown = 1

//Exploration
/obj/item/clothing/head/helmet/space/void/exploration
	name = "exploration voidsuit helmet"
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments."
	icon_state = "helm_explorer"
	item_state = "helm_explorer"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 50, bullet = 15, laser = 35, energy = 25, bomb = 30, bio = 100, rad = 70)
	light_overlay = "helmet_light_dual" //explorer_light
	camera_networks = list(NETWORK_EXPLORATION)

/obj/item/clothing/suit/space/void/exploration
	name = "exploration voidsuit"
	desc = "A hazard and radiation resistant voidsuit, featuring the " + JOB_EXPLORER + " emblem on its chest plate. Designed for exploring unknown planetary environments."
	icon_state = "void_explorer"
	item_state_slots = list(slot_r_hand_str = "skrell_suit_black", slot_l_hand_str = "skrell_suit_black")
	armor = list(melee = 50, bullet = 15, laser = 35, energy = 25, bomb = 30, bio = 100, rad = 70)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_MINING, POCKET_MEDICAL, POCKET_EXPLO)
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored

//SAR
/obj/item/clothing/head/helmet/space/void/expedition_medical
	name = "field medic voidsuit helmet"
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments. Has a reinforced high-vis bubble style visor."
	icon_state = "helm_exp_medic"
	item_state = "helm_exp_medic"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 30, bio = 100, rad = 90)
	light_overlay = "helmet_light_dual" //explorer_light
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+5000

/obj/item/clothing/suit/space/void/expedition_medical
	name = "field medic voidsuit"
	desc = "A hazard and radiation resistant voidsuit, featuring the " + JOB_EXPLORER + " emblem and a green cross on its chest plate. Seems to be a little lighter and more flexible than the regular explorer issue."
	icon_state = "void_exp_medic"
	item_state_slots = list(slot_r_hand_str = "skrell_suit_black", slot_l_hand_str = "skrell_suit_black")
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 15, bomb = 30, bio = 100, rad = 90)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_MINING, POCKET_MEDICAL, POCKET_EXPLO)
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+5000

/obj/item/clothing/head/helmet/space/void/exploration/alt
	desc = "A radiation-resistant helmet retrofitted for exploring unknown planetary environments."
	icon_state = "helm_explorer2"
	item_state = "helm_explorer2"
	item_state_slots = list(slot_r_hand_str = "mining_helm", slot_l_hand_str = "mining_helm")

/obj/item/clothing/suit/space/void/exploration/alt
	desc = "A lightweight, radiation-resistant voidsuit. Retrofitted for exploring unknown planetary environments."
	icon_state = "void_explorer2"
	item_state_slots = list(slot_r_hand_str = "skrell_suit_white", slot_l_hand_str = "skrell_suit_white")

//Pilot
/obj/item/clothing/head/helmet/space/void/pilot
	desc = "An atmos resistant helmet for space and planet exploration."
	name = "pilot voidsuit helmet"
	icon_state = "rig0_pilot"
	item_state = "pilot_helm"
	item_state_slots = list(slot_r_hand_str = "atmos_helm", slot_l_hand_str = "atmos_helm")
	armor = list(melee = 40, bullet = 10, laser = 25, energy = 15, bomb = 25, bio = 100, rad = 60)
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_CIVILIAN)

/obj/item/clothing/suit/space/void/pilot
	desc = "An atmos resistant voidsuit for space and planet exploration."
	icon_state = "rig-pilot"
	item_state_slots = list(slot_r_hand_str = "atmos_voidsuit", slot_l_hand_str = "atmos_voidsuit")
	name = "pilot voidsuit"
	armor = list(melee = 40, bullet = 10, laser = 25, energy = 15, bomb = 25, bio = 100, rad = 60)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, /obj/item/storage/toolbox, /obj/item/storage/briefcase/inflatable)

/obj/item/clothing/head/helmet/space/void/pilot/alt
	icon_state = "rig0_pilot2"
	item_state = "pilot_helm2"

/obj/item/clothing/suit/space/void/pilot/alt
	desc = "An atmos resistant voidsuit for space."
	icon_state = "rig-pilot2"
	item_state = "rig-pilot2"
