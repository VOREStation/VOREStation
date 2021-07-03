//Prosfab stuff for borgs and such

/datum/design/item/prosfab/robot_upgrade/sizeshift
	name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/sizeshift

/datum/design/item/prosfab/robot_upgrade/bellysizeupgrade
	name = "Robohound Capacity Expansion Module"
	id = "borg_hound_capacity_module"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/bellysizeupgrade