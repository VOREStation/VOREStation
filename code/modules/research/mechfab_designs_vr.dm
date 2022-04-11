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