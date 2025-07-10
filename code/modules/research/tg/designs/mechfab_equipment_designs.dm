/datum/design_techweb/mechfab/equipment
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)
	time = 10
	materials = list(MAT_STEEL = 7500)

/datum/design_techweb/mechfab/equipment/tracking
	name = "Exosuit Tracking Beacon"
	id = "mech_tracker"
	time = 5
	materials = list(MAT_STEEL = 375)
	build_path = /obj/item/mecha_parts/mecha_tracking
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/hydraulic_clamp
	name = "Hydraulic Clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/equipment/drill
	name = "Drill"
	id = "mech_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/equipment/extinguisher
	name = "Extinguisher"
	id = "extinguisher"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/extinguisher
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/cable_layer
	name = "Cable Layer"
	id = "mech_cable_layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 1000)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/sleeper
	name = "Sleeper"
	id = "mech_sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	materials = list(MAT_STEEL = 3750, MAT_GLASS = 7500)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/equipment/passenger
	name = "Passenger Compartment"
	id = "mech_passenger"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger
	materials = list(MAT_STEEL = 3750, MAT_GLASS = 3750)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/shocker
	name = "Exosuit Electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	id = "mech_shocker"
	//req_tech = list(TECH_COMBAT = 3, TECH_POWER = 6, TECH_MAGNET = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/shocker
	materials = list(MAT_STEEL = 3500, MAT_GOLD = 750, MAT_GLASS = 1000)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/// I guess this isn't STRICTLY a weapon...
/datum/design_techweb/mechfab/equipment/syringe_gun
	name = "Syringe Gun"
	id = "mech_syringe_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	time = 20
	materials = list(MAT_STEEL = 2250, MAT_GLASS = 1500)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

//You escape the weapon designation as well.
/datum/design_techweb/mechfab/equipment/medigun
	name = "BL-3/P directed restoration system"
	desc = "A portable medical system used to treat external injuries from afar."
	id = "mech_medigun"
	//req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 1750, MAT_DIAMOND = 1500, MAT_PHORON = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/medigun
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

// *** Weapon modules
/datum/design_techweb/mechfab/equipment/weapon
	//req_tech = list(TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_WEAPONS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY


/datum/design_techweb/mechfab/equipment/weapon/taser
	name = "PBT \"Pacifier\" Mounted Taser"
	id = "mech_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser

/datum/design_techweb/mechfab/equipment/weapon/rigged_taser
	name = "Jury-Rigged Taser"
	id = "mech_taser-r"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser/rigged

/datum/design_techweb/mechfab/equipment/weapon/lmg
	name = "Ultra AC 2"
	id = "mech_lmg"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg

/datum/design_techweb/mechfab/equipment/weapon/rigged_lmg
	name = "Jury-Rigged Machinegun"
	id = "mech_lmg-r"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/rigged

/datum/design_techweb/mechfab/equipment/weapon/flaregun
	name = "Flare Launcher"
	id = "mecha_flare_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	materials = list(MAT_STEEL = 9375)

/datum/design_techweb/mechfab/equipment/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	id = "mech_scattershot"
	//req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 3000, MAT_PLASTIC = 2000, MAT_SILVER = 2500)

/datum/design_techweb/mechfab/equipment/weapon/rigged_scattershot
	name = "Jury-Rigged Shrapnel Cannon"
	id = "mech_scattershot-r"
	//req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot/rigged
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2000, MAT_PLASTIC = 2000, MAT_SILVER = 2000)

/datum/design_techweb/mechfab/equipment/weapon/laser
	name = "CH-PS \"Immolator\" Laser"
	id = "mech_laser"
	//req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 3000, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/laser_rigged
	name = "Jury-Rigged Welder-Laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	//req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design_techweb/mechfab/equipment/weapon/laser_heavy
	name = "CH-LC \"Solaris\" Laser Cannon"
	id = "mech_laser_heavy"
	//req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 3000, MAT_DIAMOND = 2000, MAT_OSMIUM = 5000, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/rigged_laser_heavy
	name = "Jury-Rigged Emitter Cannon"
	id = "mech_laser_heavy-r"
	//req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_ILLEGAL = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/rigged
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 4000, MAT_DIAMOND = 1500, MAT_OSMIUM = 4000, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/laser_xray
	name = "CH-XS \"Penetrator\" Laser"
	id = "mech_laser_xray"
	//req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray
	materials = list(MAT_STEEL = 9000, MAT_GLASS = 3000, MAT_PHORON = 1000, MAT_SILVER = 1500, MAT_GOLD = 2500, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/rigged_laser_xray
	name = "Jury-Rigged Xray Rifle"
	id = "mech_laser_xray-r"
	//req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray/rigged
	materials = list(MAT_STEEL = 8500, MAT_GLASS = 2500, MAT_PHORON = 1000, MAT_SILVER = 1250, MAT_GOLD = 2000, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/phase
	name = "NT-PE \"Scorpio\" Phase-Emitter"
	id = "mech_phase"
	//req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/phase
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000, MAT_PLASTIC = 3000)

/datum/design_techweb/mechfab/equipment/weapon/ion
	name = "MK-IV Ion Heavy Cannon"
	id = "mech_ion"
	//req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	materials = list(MAT_STEEL = 15000, MAT_URANIUM = 2000, MAT_SILVER = 2000, MAT_OSMIUM = 4500, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/rigged_ion
	name = "Jury-Rigged Ion Cannon"
	id = "mech_ion-r"
	//req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion/rigged
	materials = list(MAT_STEEL = 13000, MAT_URANIUM = 1000, MAT_SILVER = 1000, MAT_OSMIUM = 3000, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/grenade_launcher
	name = "SGL-6 Grenade Launcher"
	id = "mech_grenade_launcher"
	//req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade
	materials = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_PLASTIC = 3000)

/datum/design_techweb/mechfab/equipment/weapon/rigged_grenade_launcher
	name = "Jury-Rigged Pneumatic Flashlauncher"
	id = "mech_grenade_launcher-rig"
	//req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/rigged
	materials = list(MAT_STEEL = 5000, MAT_GOLD = 2000, MAT_PLASTIC = 2000)

/datum/design_techweb/mechfab/equipment/weapon/clusterbang_launcher
	name = "SOP-6 Grenade Launcher"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	//req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 15000, MAT_GOLD = 4500, MAT_URANIUM = 4500)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited

/datum/design_techweb/mechfab/equipment/weapon/conc_grenade_launcher
	name = "SGL-9 Grenade Launcher"
	id = "mech_grenade_launcher_conc"
	//req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/concussion
	materials = list(MAT_STEEL = 9000, MAT_GOLD = 1000, MAT_OSMIUM = 1000, MAT_PLASTIC = 3000)

/datum/design_techweb/mechfab/equipment/weapon/frag_grenade_launcher
	name = "HEP-MI 6 Grenade Launcher"
	id = "mech_grenade_launcher_frag"
	//req_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag/mini
	materials = list(MAT_STEEL = 10000, MAT_GOLD = 2500, MAT_URANIUM = 3000, MAT_OSMIUM = 3000, MAT_PLASTIC = 3000)

/datum/design_techweb/mechfab/equipment/weapon/flamer
	name = "CR-3 Mark 8 Flamethrower"
	desc = "A weapon that violates the CCWC at two hundred gallons per minute."
	id = "mech_flamer_full"
	//req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_PHORON = 4, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 10000, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_PHORON = 8000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer

/datum/design_techweb/mechfab/equipment/weapon/flamer_rigged
	name = "AA-CR-1 Mark 4 Flamethrower"
	desc = "A weapon that accidentally violates the CCWC at one hundred gallons per minute."
	id = "mech_flamer_rigged"
	//req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 1500, MAT_SILVER = 1500, MAT_URANIUM = 2000, MAT_PHORON = 6000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged

/datum/design_techweb/mechfab/equipment/weapon/flame_mg
	name = "DR-AC 3 Incendiary Rotary MG"
	desc = "A weapon that violates the CCWC at sixty rounds a minute."
	id = "mech_lmg_flamer"
	//req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_PHORON = 2, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 1750, MAT_URANIUM = 1500, MAT_PHORON = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary

/datum/design_techweb/mechfab/equipment/weapon/laser_gamma
	name = "GA-X \"Render\" Experimental Gamma Laser"
	id = "mech_laser_gamma"
	//req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 4, TECH_PHORON = 4, TECH_POWER = 4, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000, MAT_PHORON = 2500, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_URANIUM = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gamma

// *** Nonweapon modules
/datum/design_techweb/mechfab/equipment/wormhole_gen
	name = "Wormhole Generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	//req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	//req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/cloak
	name = "Cloaking Device"
	desc = "A device that renders the exosuit invisible to the naked eye, though not to thermal detection. Uses large amounts of energy."
	id = "mech_cloaking"
	//req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/cloak
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/rcd
	name = "RCD"
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	time = 120
	materials = list(MAT_STEEL = 20000, MAT_PLASTIC = 10000, MAT_PHORON = 18750, MAT_SILVER = 15000, MAT_GOLD = 15000)
	//req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/gravcatapult
	name = "Gravitational Catapult"
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	//req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/repair_droid
	name = "Repair Droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	//req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 7500, MAT_GOLD = 750, MAT_SILVER = 1500, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES
	)

/* These are way too OP to be buildable
/datum/design_techweb/mechfab/equipment/combat_shield
	name = "linear combat shield"
	desc = "Linear shield projector. Deploys a large, familiar, and rectangular shield in one direction at a time."
	id = "mech_shield_droid"
	//req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_PHORON = 5000, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/combat_shield
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES
	)

/datum/design_techweb/mechfab/equipment/omni_shield
	name = "Omni Shield"
	desc = "Integral shield projector. Can only protect the exosuit, but has no weak angles."
	id = "mech_shield_omni"
	//req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_PHORON = 5000, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/omni_shield
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES
	)
*/

/datum/design_techweb/mechfab/equipment/crisis_drone
	name = "Crisis Drone"
	desc = "Deploys a small medical drone capable of patching small wounds in order to stabilize nearby patients."
	id = "mech_med_droid"
	//req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_BIO = 5, TECH_DATA = 4, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_VERDANTIUM = 2500, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/crisis_drone
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/equipment/rad_drone
	name = "Hazmat Drone"
	desc = "Deploys a small hazmat drone capable of purging minor radiation damage in order to stabilize nearby patients."
	id = "mech_rad_droid"
	//req_tech = list(TECH_PHORON = 4, TECH_MAGNET = 5, TECH_BIO = 6, TECH_DATA = 4, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_VERDANTIUM = 2500, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/crisis_drone/rad
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/equipment/medanalyzer
	name = "Mounted Body Scanner"
	desc = "An advanced mech-mounted device that is not quite as powerful as a stationary body scanner, though still suitably powerful."
	id = "mech_med_analyzer"
	//req_tech = list(TECH_PHORON = 4, TECH_MAGNET = 5, TECH_BIO = 5, TECH_DATA = 4)
	materials = list(MAT_PLASTEEL = 4500, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/medanalyzer
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/mechfab/equipment/jetpack
	name = "Ion Jetpack"
	desc = "Using directed ion bursts and cunning solar wind reflection technique, this device enables controlled space flight."
	id = "mech_jetpack"
	//req_tech = list(TECH_ENGINEERING = 3, TECH_MAGNET = 4) //One less magnet than the actual got-damn teleporter.
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/jetpack
	materials = list(MAT_STEEL = 7500, MAT_SILVER = 300, MAT_GLASS = 600)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/phoron_generator
	desc = "Phoron Reactor"
	id = "mech_phoron_generator"
	//req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials = list(MAT_STEEL = 7500, MAT_SILVER = 375, MAT_GLASS = 750)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/energy_relay
	name = "Energy Relay"
	id = "mech_energy_relay"
	//req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	materials = list(MAT_STEEL = 7500, MAT_GOLD = 1500, MAT_SILVER = 2250, MAT_GLASS = 1500)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/ccw_armor
	name = "CCW Armor Booster"
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	//req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 11250, MAT_SILVER = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/equipment/proj_armor
	name = "Ranged Armor Booster"
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	//req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 15000, MAT_GOLD = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/mechfab/equipment/diamond_drill
	name = "Diamond Drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 7500, MAT_DIAMOND = 4875)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/equipment/ground_drill
	name = "Surface Bore"
	desc = "A heavy duty bore. Bigger, better, stronger than the core sampler, but not quite as good as a large drill."
	id = "mech_ground_drill"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 2, TECH_PHORON = 1)
	materials = list(MAT_STEEL = 7000, MAT_SILVER = 3000, MAT_PHORON = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/bore
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/equipment/orescanner
	name = "Ore Scanner"
	desc = "A hefty device used to scan for subterranean veins of ore."
	id = "mech_ore_scanner"
	//req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/orescanner
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/equipment/advorescanner
	name = "Advanced Ore Scanner"
	desc = "A hefty device used to scan for the exact volumes of subterranean veins of ore."
	id = "mech_ore_scanner_adv"
	//req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_POWER = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 5000, MAT_OSMIUM = 3000, MAT_SILVER = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/orescanner/advanced
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mechfab/equipment/runningboard
	name = "Powered Exosuit Running Board"
	desc = "A running board with a power-lifter attachment, to quickly catapult exosuit pilots into the cockpit. Only fits to working exosuits."
	id = "mech_runningboard"
	//req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/mecha_equipment/runningboard/limited
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/powerwrench
	name = "hydraulic wrench"
	desc = "A large, hydraulic wrench."
	id = "mech_wrench"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 2000, MAT_GLASS = 1250)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/powercrowbar
	name = "hydraulic prybar"
	desc = "A large, hydraulic prybar."
	id = "mech_crowbar"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_OSMIUM = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/prybar
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/powercutters
	name = "hydraulic cable cutter"
	desc = "A large, hydraulic cablecutter."
	id = "mech_wirecutter"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_OSMIUM = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/cutter
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/powerscrewdriver
	name = "hydraulic screwdriver"
	desc = "A large, hydraulic screwdriver."
	id = "mech_screwdriver"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_OSMIUM = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/screwdriver
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/powerwelder
	name = "welding laser"
	desc = "A large welding laser."
	id = "mech_welder"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_PHORON = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/welding
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/inflatables
	name = "inflatables deployer"
	desc = "A large pneumatic inflatable deployer."
	id = "mech_inflatables"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 2000, MAT_PLASTIC = 4000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/inflatables
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mechfab/equipment/hardpoint_clamp
	name = "hardpoint actuator"
	desc = "A complex device used to commandeer equipment from the ground."
	id = "mech_hardpoint_clamp"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_POWER = 5, TECH_COMBAT = 2, TECH_MAGNET = 4)
	materials = list(MAT_PLASTEEL = 2500, MAT_PLASTIC = 3000, MAT_OSMIUM = 1500, MAT_SILVER = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/hardpoint_actuator
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/generator_nuclear
	name = "Nuclear Reactor"
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	//req_tech = list(TECH_POWER= 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 7500, MAT_SILVER = 375, MAT_GLASS = 750)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/speedboost_ripley
	name = "Ripley Leg Actuator Overdrive"
	desc = "System enhancements and overdrives to make a mech's legs move faster."
	id = "mech_speedboost_ripley"
	//req_tech = list( TECH_POWER = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 10000, MAT_SILVER = 1000, MAT_GOLD = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/speedboost
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/auxstorage
	name = "Auxillary Exosuit Storage Bay"
	desc = "An auxillary storage compartment, for attaching to exosuits."
	id = "mech_storage"
	//req_tech = list(TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/mecha_equipment/storage
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)

/datum/design_techweb/mechfab/equipment/bsauxstorage
	name = "Auxillary Exosuit Storage Wormhole"
	desc = "An auxillary storage wormhole, for attaching to exosuits."
	id = "mech_storage_bs"
	//req_tech = list(TECH_MATERIAL = 4)
	materials = list(MAT_PLASTEEL = 10000, MAT_GRAPHITE = 8000, MAT_OSMIUM = 6000, MAT_PHORON = 6000, MAT_SILVER = 4000, MAT_GOLD = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/storage/bluespace
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	)
