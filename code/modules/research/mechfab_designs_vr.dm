/datum/design/item/mechfab/rigsuit/rescuepharm
	name = "hardsuit mounted rescue pharmacy"
	desc = "A suit mounted rescue drug dispenser."
	id = "rig_component_rescuepharm"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_MAGNET = 5, TECH_BIO = 4)
	materials = list(MAT_PLASTEEL = 3000, MAT_GRAPHITE = 2000, MAT_PLASTIC = 3500, MAT_SILVER = 1750, MAT_GOLD = 1250)
	build_path = /obj/item/rig_module/rescue_pharm

/datum/design/item/mechfab/rigsuit/mounted_sizegun
	name = "hardsuit mounted size gun"
	desc = "A suit mounted size gun. Features interface-based target size adjustment for hands-free size-altering shenanigans."
	id = "rig_gun_sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/rig_module/mounted/sizegun

/datum/design/item/mecha/weapon/laser_gamma
	name = "GA-X \"Render\" Experimental Gamma Laser"
	id = "mech_laser_gamma"
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 4, TECH_PHORON = 4, TECH_POWER = 4, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000, MAT_PHORON = 2500, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_URANIUM = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gamma

/datum/design/item/mecha/medigun
	name = "BL-3/P directed restoration system"
	desc = "A portable medical system used to treat external injuries from afar."
	id = "mech_medigun"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 1750, MAT_DIAMOND = 1500, MAT_PHORON = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/medigun
