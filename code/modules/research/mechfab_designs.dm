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

// Exosuit Internals

/datum/design/item/mechfab/exointernal
	category = list("Exosuit Internals")
	time = 30
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/datum/design/item/mechfab/exointernal/stan_armor
	name = "Armor Plate (Standard)"
	category = list("Exosuit Internals")
	id = "exo_int_armor_standard"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/armor

/datum/design/item/mechfab/exointernal/light_armor
	name = "Armor Plate (Lightweight)"
	category = list("Exosuit Internals")
	id = "exo_int_armor_lightweight"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 3000)
	build_path = /obj/item/mecha_parts/component/armor/lightweight

/datum/design/item/mechfab/exointernal/reinf_armor
	name = "Armor Plate (Reinforced)"
	category = list("Exosuit Internals")
	id = "exo_int_armor_reinforced"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 10000)
	build_path = /obj/item/mecha_parts/component/armor/reinforced

/datum/design/item/mechfab/exointernal/mining_armor
	name = "Armor Plate (Blast)"
	category = list("Exosuit Internals")
	id = "exo_int_armor_blast"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 10000)
	build_path = /obj/item/mecha_parts/component/armor/mining

/datum/design/item/mechfab/exointernal/gygax_armor
	name = "Armor Plate (Marshal)"
	category = list("Exosuit Internals")
	id = "exo_int_armor_gygax"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 40000, MAT_DIAMOND = 8000)
	build_path = /obj/item/mecha_parts/component/armor/marshal

/datum/design/item/mechfab/exointernal/darkgygax_armor
	name = "Armor Plate (Blackops)"
	category = list("Exosuit Internals")
	id = "exo_int_armor_dgygax"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_COMBAT = 4, TECH_ILLEGAL = 2)
	materials = list(MAT_PLASTEEL = 20000, MAT_DIAMOND = 10000, MAT_GRAPHITE = 20000)
	build_path = /obj/item/mecha_parts/component/armor/marshal/reinforced

/datum/design/item/mechfab/exointernal/durand_armour
	name = "Armor Plate (Military)"
	id = "exo_int_armor_durand"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 40000, MAT_PLASTEEL = 9525, MAT_URANIUM = 8000)
	build_path = /obj/item/mecha_parts/component/armor/military

/datum/design/item/mechfab/exointernal/marauder_armour
	name = "Armor Plate (Cutting Edge)"
	id = "exo_int_armor_marauder"
	req_tech = list(TECH_MATERIAL = 8, TECH_ENGINEERING = 7, TECH_COMBAT = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_DURASTEEL = 40000, MAT_GRAPHITE = 8000, MAT_OSMIUM = 8000)
	build_path = /obj/item/mecha_parts/component/armor/military/marauder

/datum/design/item/mechfab/exointernal/phazon_armour
	name = "Armor Plate (Janus)"
	id = "exo_int_armor_phazon"
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 6, TECH_COMBAT = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_MORPHIUM = 40000, MAT_DURASTEEL = 8000, MAT_OSMIUM = 8000)
	build_path = /obj/item/mecha_parts/component/armor/alien

/datum/design/item/mechfab/exointernal/stan_hull
	name = "Hull (Standard)"
	category = list("Exosuit Internals")
	id = "exo_int_hull_standard"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/hull

/datum/design/item/mechfab/exointernal/durable_hull
	name = "Hull (Durable)"
	category = list("Exosuit Internals")
	id = "exo_int_hull_durable"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000, MAT_PLASTEEL = 5000)
	build_path = /obj/item/mecha_parts/component/hull/durable

/datum/design/item/mechfab/exointernal/light_hull
	name = "Hull (Lightweight)"
	category = list("Exosuit Internals")
	id = "exo_int_hull_light"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 3000)
	build_path = /obj/item/mecha_parts/component/hull/lightweight

/datum/design/item/mechfab/exointernal/stan_gas
	name = "Life-Support (Standard)"
	category = list("Exosuit Internals")
	id = "exo_int_lifesup_standard"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/gas

/datum/design/item/mechfab/exointernal/reinf_gas
	name = "Life-Support (Reinforced)"
	category = list("Exosuit Internals")
	id = "exo_int_lifesup_reinforced"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 8000, MAT_PLASTEEL = 8000, MAT_GRAPHITE = 1000)
	build_path = /obj/item/mecha_parts/component/gas/reinforced

/datum/design/item/mechfab/exointernal/stan_electric
	name = "Electrical Harness (Standard)"
	category = list("Exosuit Internals")
	id = "exo_int_electric_standard"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 1000)
	build_path = /obj/item/mecha_parts/component/electrical

/datum/design/item/mechfab/exointernal/efficient_electric
	name = "Electrical Harness (High)"
	category = list("Exosuit Internals")
	id = "exo_int_electric_efficient"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4, TECH_DATA = 2)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 3000, MAT_SILVER = 3000)
	build_path = /obj/item/mecha_parts/component/electrical/high_current

/datum/design/item/mechfab/exointernal/stan_actuator
	name = "Actuator Lattice (Standard)"
	category = list("Exosuit Internals")
	id = "exo_int_actuator_standard"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/actuator

/datum/design/item/mechfab/exointernal/hispeed_actuator
	name = "Actuator Lattice (Overclocked)"
	category = list("Exosuit Internals")
	id = "exo_int_actuator_overclock"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 10000, MAT_OSMIUM = 3000, MAT_GOLD = 5000)
	build_path = /obj/item/mecha_parts/component/actuator/hispeed
