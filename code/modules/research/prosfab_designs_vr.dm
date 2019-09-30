//Prosfab stuff for borgs and such

/datum/design/item/prosfab/robot_upgrade/sizeshift
	name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/borg/upgrade/sizeshift