/datum/design/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

/datum/design/item/synthetic_flash
	name = "Synthetic Flash"
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MAT_STEEL = 562, MAT_GLASS = 562)
	build_path = /obj/item/flash/synthetic
	category = list("Misc")

/*
 * Non-Mech Vehicles
 */

/datum/design/item/mechfab/vehicle
	build_type = MECHFAB
	category = list("Vehicle")
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6)

/datum/design/item/mechfab/vehicle/spacebike_chassis
	name = "Spacebike Chassis"
	desc = "A space-bike's un-assembled frame."
	id = "vehicle_chassis_spacebike"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials = list(MAT_STEEL = 12000, MAT_SILVER = 3000, MAT_PHORON = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/spacebike

/datum/design/item/mechfab/vehicle/quadbike_chassis
	name = "Quad bike Chassis"
	desc = "A quad bike's un-assembled frame."
	id = "vehicle_chassis_quadbike"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 15000, MAT_SILVER = 3000, MAT_PLASTIC = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/quadbike

/datum/design/item/mechfab/vehicle/snowmobile_chassis
	name = "Snowmobile Chassis"
	desc = "A snowmobile's un-assembled frame."
	id = "vehicle_chassis_snowmobile"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 12000, MAT_SILVER = 3000, MAT_PLASTIC = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/snowmobile

/datum/design/item/mechfab/uav/basic
	name = "UAV - Recon Skimmer"
	id = "recon_skimmer"
	build_path = /obj/item/uav
	time = 20
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 6)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_SILVER = 4000)
