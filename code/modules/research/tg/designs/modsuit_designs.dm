/*
 * Modsuits
 */

//Modsuit chassis
/datum/design_techweb/mechfab/modsuit
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 6)
	category = list(
		RND_CATEGORY_MODSUITS
	)

//General robotics modsuit
/datum/design_techweb/mechfab/modsuit/basic_belt
	name = "Advanced Suit Control Belt"
	desc = "A belt holding a compressed space-suit."
	id = "rigmodule_belt_basic"
	materials = list(MAT_PLASTEEL = 12000, MAT_GOLD = 3000, MAT_GRAPHITE = 3000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000)
	build_path = /obj/item/rig/robotics

// Station Suits
/datum/design_techweb/mechfab/modsuit/eva_controller
	name = "EVA Suit Control Module"
	desc = "An engineering Hardsuit featuring a visor with welding protection, iommunity to radiation, and insulated gauntlets. It is well insulated against the heat."
	id = "eva_rig_module"
	materials = list(MAT_PLASTEEL = 16000, MAT_GOLD = 3000, MAT_GRAPHITE = 4500, MAT_OSMIUM = 1000, MAT_PLASTIC = 4500, MAT_LEAD = 2000, MAT_STEEL = 2000)
	build_path = /obj/item/rig/eva

/datum/design_techweb/mechfab/modsuit/eva_ce_controller
	name = "Advanced EVA Suit Control Module"
	desc = "A more advanced EVA hardsuit with the same features, plus additional atmospheric protection and advanced magboots. Finely polished for engineering clout."
	id = "advanced_eva_rig_module"
	materials = list(MAT_PLASTEEL = 16000, MAT_GOLD = 6000, MAT_GRAPHITE = 4500, MAT_OSMIUM = 4000, MAT_PLASTIC = 8000, MAT_LEAD = 2000, MAT_PHORON = 6000, MAT_STEEL = 3000, MAT_TITANIUM = 2000)
	build_path = /obj/item/rig/ce

/datum/design_techweb/mechfab/modsuit/ami_controller
	name = "AMI Suit Control Module"
	desc = "A hardsuit for the rigors of science. In theory it should protect the wearer from the stranger things that the universe can offer. In 'theory.'"
	id = "ami_rig_module"
	materials = list(MAT_PLASTEEL = 12000, MAT_GOLD = 3000, MAT_GRAPHITE = 3000, MAT_OSMIUM = 2000, MAT_PLASTIC = 6000, MAT_LEAD = 2000, MAT_PHORON = 12000)
	build_path = /obj/item/rig/hazmat

/datum/design_techweb/mechfab/modsuit/industrial_controller
	name = "Industrial Suit Control Module"
	desc = "Ugly as hell, and heavier than I-Beam. Designed to protect thickly beardered miners in the depths."
	id = "industrial_rig_module"
	materials = list(MAT_PLASTEEL = 14000, MAT_GOLD = 4000, MAT_GRAPHITE = 5000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000, MAT_STEEL = 10000, MAT_TITANIUM = 2000)
	build_path = /obj/item/rig/industrial

/datum/design_techweb/mechfab/modsuit/hazard_controller
	name = "Hazard Suit Control Module"
	desc = "A security hardsuit with protection for bringing justice into the blackness of the void."
	id = "hazard_rig_module"
	materials = list(MAT_PLASTEEL = 14000, MAT_GOLD = 4000, MAT_GRAPHITE = 5000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000, MAT_STEEL = 10000, MAT_TITANIUM = 2000)
	build_path = /obj/item/rig/hazard

/datum/design_techweb/mechfab/modsuit/rescue_controller
	name = "Rescue Suit Control Module"
	desc = "A hardsuit designed for medical rescue in hazardous environments. Just don't expect it to stop a bullet."
	id = "medical_rig_module"
	materials = list(MAT_PLASTEEL = 12000, MAT_GOLD = 6000, MAT_GRAPHITE = 3000, MAT_OSMIUM = 4000, MAT_PLASTIC = 10000, MAT_LEAD = 2000)
	build_path = /obj/item/rig/medical

/datum/design_techweb/mechfab/modsuit/zero_controller
	name = "Zero Suit Control Module"
	desc = "A very bare bones and stylish suit designed for pilots with advanced holographic interfaces for the task."
	id = "zero_rig_module"
	materials = list(MAT_PLASTEEL = 12000, MAT_GOLD = 3000, MAT_GRAPHITE = 3000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000)
	build_path =/obj/item/rig/zero

///Modsuit Modules
/datum/design_techweb/mechfab/modsuit/modules
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 6)
	category = list(
		RND_CATEGORY_MODSUIT_MODULES
	)

/datum/design_techweb/mechfab/modsuit/rescuepharm
	name = "hardsuit mounted rescue pharmacy"
	desc = "A suit mounted rescue drug dispenser."
	id = "rig_component_rescuepharm"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_BIO = 4)
	materials = list(MAT_PLASTEEL = 3000, MAT_GRAPHITE = 2000, MAT_PLASTIC = 3500, MAT_SILVER = 1750, MAT_GOLD = 1250)
	build_path = /obj/item/rig_module/rescue_pharm
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/modsuit/pat
	name = "hardsuit mounted P.A.T."
	desc = "Pre-emptive Access Tunneling for first responders to access areas they normally cannot. Use responsibly."
	id = "rig_component_pat"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_BIO = 4)
	materials = list(MAT_PLASTEEL = 3000, MAT_GRAPHITE = 2000, MAT_SILVER = 1750, MAT_GOLD = 1250, MAT_OSMIUM = 2000)
	build_path = /obj/item/rig_module/rescue_pharm
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/modsuit/mounted_sizegun
	name = "hardsuit mounted size gun"
	desc = "A suit mounted size gun. Features interface-based target size adjustment for hands-free size-altering shenanigans."
	id = "rig_gun_sizegun"
	//req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/rig_module/mounted/sizegun
	//Not giving this a department flag intentionally.tIT

/datum/design_techweb/mechfab/modsuit/modules/jetpack
	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	id = "rig_thrusters"
	materials = list(MAT_PLASTEEL = 1000, MAT_GOLD = 1000, MAT_GRAPHITE = 1000, MAT_PLASTIC = 500)
	build_path = /obj/item/rig_module/maneuvering_jets
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_GENERAL
	)

/datum/design_techweb/mechfab/modsuit/modules/powersink
	name = "hardsuit power siphon"
	desc = "A complex device used to pull power from machines."
	id = "rig_siphon"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_PHORON = 4, TECH_MAGNET = 5, TECH_POWER = 6, TECH_ILLEGAL = 3)
	materials = list(MAT_PLASTEEL = 3000, MAT_METALHYDROGEN = 1000, MAT_GRAPHITE = 1000, MAT_PLASTIC = 5000, MAT_PHORON = 2000, MAT_VERDANTIUM = 1500)
	build_path = /obj/item/rig_module/power_sink
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_GENERAL
	)

/datum/design_techweb/mechfab/modsuit/modules/flash
	name = "hardsuit mounted flash"
	desc = "A suit-mounted flash."
	id = "rig_device_flash"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_PLASTIC = 3000, MAT_METALHYDROGEN = 200, MAT_GRAPHITE = 500)
	build_path = /obj/item/rig_module/device/flash
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design_techweb/mechfab/modsuit/modules/plasmacutter
	name = "hardsuit mounted plasmacutter"
	desc = "A suit-mounted plasmacutter."
	id = "rig_device_plasmacutter"
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 3000, MAT_PLASTIC = 3000, MAT_PHORON = 2500, MAT_GRAPHITE = 500)
	build_path = /obj/item/rig_module/device/plasmacutter
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/healthanalyzer
	name = "hardsuit health analyzer"
	desc = "A hardsuit mounted health analyzer."
	id = "rig_device_healthanalyzer"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_BIO = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 1000, MAT_SILVER = 1000, MAT_GRAPHITE = 1000, MAT_PLASTIC = 500)
	build_path = /obj/item/rig_module/device/healthscanner
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/modsuit/modules/drill
	name = "hardsuit mounted drill"
	desc = "A hardsuit mounted drill."
	id = "rig_device_drill"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 1500, MAT_DIAMOND = 2500, MAT_GRAPHITE = 1000, MAT_PLASTIC = 500)
	build_path = /obj/item/rig_module/device/drill
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/modsuit/modules/excdrill
	name = "hardsuit mounted excavation drill"
	desc = "A hardsuit mounted excavation drill."
	id = "rig_device_excdrill"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_ARCANE = 1)
	materials = list(MAT_PLASTEEL = 1500, MAT_DIAMOND = 2000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 1000)
	build_path = /obj/item/rig_module/device/arch_drill
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/modsuit/modules/anomscanner
	name = "hardsuit mounted anomaly scanner"
	desc = "A suit-mounted anomaly scanner."
	id = "rig_device_anomscanner"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_PLASTIC = 3000, MAT_METALHYDROGEN = 200, MAT_GRAPHITE = 500)
	build_path = /obj/item/rig_module/device/anomaly_scanner
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/modsuit/modules/orescanner
	name = "hardsuit mounted ore scanner"
	desc = "A suit-mounted ore scanner."
	id = "rig_device_orescanner"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 3)
	materials = list(MAT_PLASTEEL = 2000, MAT_PLASTIC = 2000, MAT_GRAPHITE = 500)
	build_path = /obj/item/rig_module/device/orescanner
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/modsuit/modules/rcd
	name = "hardsuit mounted rcd"
	desc = "A suit-mounted rcd."
	id = "rig_device_rcd"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 5000, MAT_URANIUM = 3000, MAT_PHORON = 2000, MAT_GRAPHITE = 1500)
	build_path = /obj/item/rig_module/device/rcd
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/paperdispenser
	name = "hardsuit mounted paper dispenser"
	desc = "A suit-mounted paper dispenser."
	id = "rig_device_paperdispenser"
	//req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BIO = 2, TECH_POWER = 2)
	materials = list(MAT_PLASTEEL = 1000, MAT_PLASTIC = 500, MAT_PHORON = 500, MAT_GRAPHITE = 100)
	build_path = /obj/item/rig_module/device/paperdispenser
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/mechfab/modsuit/modules/pen
	name = "hardsuit mounted pen"
	desc = "A suit-mounted pen."
	id = "rig_device_pen"
	//req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BIO = 2, TECH_POWER = 2)
	materials = list(MAT_PLASTEEL = 1000, MAT_PLASTIC = 500, MAT_PHORON = 500, MAT_GRAPHITE = 100)
	build_path = /obj/item/rig_module/device/pen
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/mechfab/modsuit/modules/grenade_metalfoam
	name = "hardsuit metalfoam-bomb launcher"
	desc = "A compact metalfoam grenade system for a hardsuit."
	id = "rig_grenade_metalfoam"
	//req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 2, TECH_POWER = 3)
	materials = list(MAT_PLASTEEL = 2000, MAT_OSMIUM = 1000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 500)
	build_path = /obj/item/rig_module/grenade_launcher/metalfoam
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/grenade_flash
	name = "hardsuit flashbang launcher"
	desc = "A compact flashbang grenade system for a hardsuit."
	id = "rig_grenade_flashbang"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_OSMIUM = 1500, MAT_GRAPHITE = 1000, MAT_PLASTIC = 1000)
	build_path = /obj/item/rig_module/grenade_launcher/flash
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/grenade_cleanfoam
	name = "hardsuit cleaning-foam-bomb launcher"
	desc = "A compact cleaning-foam grenade system for a hardsuit."
	id = "rig_grenade_cleanfoam"
	//req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2, TECH_POWER = 2)
	materials = list(MAT_PLASTEEL = 2000, MAT_GLASS = 1000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 750)
	build_path = /obj/item/rig_module/cleaner_launcher
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/taser
	name = "hardsuit taser"
	desc = "A compact taser system for a hardsuit."
	id = "rig_gun_taser"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 500)
	build_path = /obj/item/rig_module/mounted/taser
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/egun
	name = "hardsuit egun"
	desc = "A compact egun system for a hardsuit."
	id = "rig_gun_egun"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 4, TECH_COMBAT = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_GOLD = 1250, MAT_GRAPHITE = 1500, MAT_PLASTIC = 500)
	build_path = /obj/item/rig_module/mounted/egun
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/mop
	name = "hardsuit intense cleaning device"
	desc = "An advanced cleaning device."
	id = "rig_gun_tempgun"
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4, TECH_MAGNET = 5, TECH_POWER = 4, TECH_COMBAT = 6)
	materials = list(MAT_PLASTEEL = 2000, MAT_GOLD = 1750, MAT_URANIUM = 1500, MAT_GRAPHITE = 1500, MAT_PLASTIC = 1000)
	build_path = /obj/item/rig_module/mounted/mop
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/mechfab/modsuit/modules/sprinter
	name = "hardsuit overclocker"
	desc = "A compact overclocking system for a hardsuit."
	id = "rig_component_sprinter"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_BIO = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/rig_module/sprinter

/datum/design_techweb/mechfab/modsuit/modules/meson
	name = "hardsuit meson visor"
	desc = "A compact meson visor for a hardsuit."
	id = "rig_component_meson"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 5, TECH_MAGNET = 3, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_OSMIUM = 500)
	build_path = /obj/item/rig_module/vision/meson
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/material
	name = "hardsuit material visor"
	desc = "A compact material visor for a hardsuit."
	id = "rig_component_material"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 5, TECH_MAGNET = 3, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_OSMIUM = 500)
	build_path = /obj/item/rig_module/vision/material
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/modsuit/modules/nvg
	name = "hardsuit night-vision visor"
	desc = "A compact night-vision visor for a hardsuit."
	id = "rig_component_nvg"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 4, TECH_POWER = 5)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_OSMIUM = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/rig_module/vision/nvg
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/thermal
	name = "hardsuit thermal scanning visor"
	desc = "A compact thermal visor for a hardsuit."
	id = "rig_component_thermal"
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_OSMIUM = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/rig_module/vision/thermal
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/multi
	name = "hardsuit complete visor suite"
	desc = "An optical package for the bounty-hunter in you. Contains all available visors in a tight package."
	id = "rig_component_multi_visor"
	materials = list(MAT_PLASTEEL = 8000, MAT_GRAPHITE = 5500, MAT_OSMIUM = 4500, MAT_URANIUM = 6000, MAT_MORPHIUM = 2000)
	build_path = /obj/item/rig_module/vision/multi
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design_techweb/mechfab/modsuit/modules/mining
	name = "hardsuit mining scanners"
	desc = "A visor suite for miners featuring Material and Mesons."
	id = "rig_component_mining"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 4, TECH_POWER = 5)
	materials = list(MAT_PLASTEEL = 3500, MAT_GRAPHITE = 2000, MAT_OSMIUM = 1000)
	build_path = /obj/item/rig_module/vision/mining
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/modsuit/modules/graviton
	name = "hardsuit graviton scanners"
	desc = "Advanced Visor suite that combines the features of mesons and material into a single package."
	id = "rig_component_graviton"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 4, TECH_POWER = 5)
	materials = list(MAT_PLASTEEL = 3500, MAT_GRAPHITE = 2000, MAT_OSMIUM = 1000)
	build_path = /obj/item/rig_module/vision/mining
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)

/datum/design_techweb/mechfab/modsuit/modules/sechud
	name = "hardsuit security visor"
	desc = "A compact security visor for a hardsuit."
	id = "rig_component_sechud"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 500, MAT_SILVER = 500)
	build_path = /obj/item/rig_module/vision/sechud
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/modsuit/modules/medhud
	name = "hardsuit medical visor"
	desc = "A compact medical visor for a hardsuit."
	id = "rig_component_medhud"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_BIO = 2)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 500, MAT_SILVER = 500)
	build_path = /obj/item/rig_module/vision/medhud
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/modsuit/modules/voice
	name = "hardsuit voice-changer"
	desc = "A compact voice-changer for a hardsuit."
	id = "rig_component_voice"
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4, TECH_MAGNET = 4, TECH_BIO = 4, TECH_ILLEGAL = 3)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_PLASTIC = 1000, MAT_SILVER = 500, MAT_PHORON = 1000)
	build_path = /obj/item/rig_module/voice
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_GENERAL
	)

/datum/design_techweb/mechfab/modsuit/modules/aicontainer
	name = "hardsuit intelligence storage system"
	desc = "A compact AI network system for a hardsuit."
	id = "rig_component_aicontainer"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_BIO = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_DIAMOND = 1000, MAT_GOLD = 500, MAT_SILVER = 750, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/rig_module/ai_container
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)

/datum/design_techweb/mechfab/modsuit/modules/datajack
	name = "hardsuit datajack"
	desc = "A compact datajack for a hardsuit."
	id = "rig_component_datajack"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_POWER = 5)
	materials = list(MAT_PLASTEEL = 2000, MAT_GRAPHITE = 1500, MAT_METALHYDROGEN = 1000, MAT_GOLD = 500, MAT_SILVER = 750, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/rig_module/datajack
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_GENERAL
	)

/datum/design_techweb/mechfab/modsuit/modules/cheminjector
	name = "hardsuit chemical injector"
	desc = "A compact chemical injector network for a hardsuit."
	id = "rig_component_chemicals"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_BIO = 4)
	materials = list(MAT_PLASTEEL = 3000, MAT_GRAPHITE = 2000, MAT_PLASTIC = 3500, MAT_SILVER = 1750, MAT_GOLD = 1250)
	build_path = /obj/item/rig_module/chem_dispenser/injector/advanced/empty
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/modsuit/modules/teleporter
	name = "hardsuit teleporter system"
	desc = "An enigmatic teleporter system for a hardsuit."
	id = "rig_component_teleport"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_POWER = 6, TECH_ILLEGAL = 3, TECH_BLUESPACE = 4, TECH_ARCANE = 2, TECH_PRECURSOR = 3)
	materials = list(MAT_DURASTEEL = 5000, MAT_GRAPHITE = 3000, MAT_MORPHIUM = 1500, MAT_OSMIUM = 1500, MAT_PHORON = 1750, MAT_VERDANTIUM = 3000, MAT_SUPERMATTER = 2000)
	build_path = /obj/item/rig_module/teleporter
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/radshield
	name = "hardsuit radiation absorption device"
	desc = "A miniaturized radiation absorption array, for use in hardsuits and providing full radiation protection."
	id = "rig_component_radshield"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BLUESPACE = 4)
	materials = list(MAT_STEEL = 8000, MAT_GRAPHITE = 3000, MAT_OSMIUM = 1500, MAT_PHORON = 2250, MAT_SILVER = 1500, MAT_GOLD = 1500)
	build_path = /obj/item/rig_module/rad_shield
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/radshield_adv
	name = "hardsuit advanced radiation absorption device"
	desc = "An optimized, miniaturized radiation absorption array, for use in hardsuits and providing full radiation protection. Reduced power draw."
	id = "rig_component_radshield_adv"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_POWER = 6, TECH_BLUESPACE = 4)
	materials = list(MAT_PLASTEEL = 8000, MAT_GRAPHITE = 4000, MAT_OSMIUM = 2000, MAT_PHORON = 3250, MAT_SILVER = 2250, MAT_GOLD = 2250)
	build_path = /obj/item/rig_module/rad_shield/advanced
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/atmosshield
	name = "hardsuit atmospheric protection enhancement suite"
	desc = "An advanced atmospheric protection suite, providing protection against both pressure and heat. At the cost of concerningly high power draw."
	id = "rig_component_atmosshield"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_POWER = 6, TECH_BLUESPACE = 4)
	materials = list(MAT_PLASTEEL = 8000, MAT_DURASTEEL = 4000, MAT_GRAPHITE = 8000, MAT_OSMIUM = 6000, MAT_PHORON = 6000, MAT_SILVER = 4000, MAT_GOLD = 4000)
	build_path = /obj/item/rig_module/atmos_shield
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/atmosshield_adv
	name = "hardsuit advanced atmospheric protection enhancement suite"
	desc = "An advanced atmospheric protection suite, providing protection against both pressure and heat. At the cost of concerningly high power draw."
	id = "rig_component_atmosshield_adv"
	//req_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_POWER = 6, TECH_BLUESPACE = 4)
	materials = list(MAT_PLASTEEL = 8000, MAT_DURASTEEL = 4000, MAT_GRAPHITE = 9000, MAT_OSMIUM = 7500, MAT_PHORON = 6000, MAT_SILVER = 8000, MAT_GOLD = 6000)
	build_path = /obj/item/rig_module/atmos_shield
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/faradayshield
	name = "hardsuit electrical protection enhancement suite"
	desc = "An advanced faraday shielding suite, providing protection against electrical discharges. At the cost of concerningly high power draw."
	id = "rig_component_faradayshield"
	materials = list(MAT_PLASTEEL = 8000, MAT_GRAPHITE = 8000, MAT_OSMIUM = 6000, MAT_PHORON = 6000, MAT_SILVER = 4000, MAT_GOLD = 4000, MAT_PLASTIC = 6000)
	build_path = /obj/item/rig_module/faraday_shield
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/modsuit/modules/faradayshield/advanced
	name = "hardsuit advanced electrical protection enhancement suite"
	desc = "An optimized faraday shielding suite, providing protection against electrical discharges. At the cost of concerningly high power draw."
	id = "rig_component_faradayshield_adv"
	materials = list(MAT_PLASTEEL = 8000, MAT_GRAPHITE = 8000, MAT_OSMIUM = 8000, MAT_PHORON = 7000, MAT_SILVER = 5500, MAT_GOLD = 5500, MAT_PLASTIC = 6000)
	build_path = /obj/item/rig_module/faraday_shield/advanced
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
