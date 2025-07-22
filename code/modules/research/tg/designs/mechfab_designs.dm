/datum/design_techweb/mechfab
	build_type = MECHFAB
	//req_tech = list(TECH_MATERIAL = 1)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

///RIPLEY
/datum/design_techweb/mechfab/ripley
	desc = "A part used in the construction of the Ripley mecha series"
	build_type = MECHFAB
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/ripley/circuit_main
	name = "APLU 'Ripley' central control circuit"
	id = "ripley_main"
	build_path = /obj/item/circuitboard/mecha/ripley/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/ripley/circuit_peri
	name = "APLU 'Ripley' peripherals control circuit"
	id = "ripley_peri"
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/ripley/chassis
	name = "Ripley Chassis"
	id = "ripley_chassis"
	build_path = /obj/item/mecha_parts/chassis/ripley
	materials = list(MAT_STEEL = 15000)

/datum/design_techweb/mechfab/ripley/torso
	name = "Ripley Torso"
	id = "ripley_torso"
	build_path = /obj/item/mecha_parts/part/ripley_torso
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 11250)

/datum/design_techweb/mechfab/ripley/left_arm
	name = "Ripley Left Arm"
	id = "ripley_left_arm"
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	materials = list(MAT_STEEL = 18750)

/datum/design_techweb/mechfab/ripley/right_arm
	name = "Ripley Right Arm"
	id = "ripley_right_arm"
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	materials = list(MAT_STEEL = 18750)

/datum/design_techweb/mechfab/ripley/left_leg
	name = "Ripley Left Leg"
	id = "ripley_left_leg"
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	materials = list(MAT_STEEL = 22500)

/datum/design_techweb/mechfab/ripley/right_leg
	name = "Ripley Right Leg"
	id = "ripley_right_leg"
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	materials = list(MAT_STEEL = 22500)

///FIREFIGHTER
/datum/design_techweb/mechfab/ripley/chassis/firefighter
	desc = "A part used in the construction of the Firefighter mecha series"
	name = "Firefigher Chassis"
	id = "firefighter_chassis"
	build_path = /obj/item/mecha_parts/chassis/firefighter

///ODYSSEUS
/datum/design_techweb/mechfab/odysseus
	desc = "A part used in the construction of the Odysseus mecha series"
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/odysseus/odysseus_main
	name = "'Odysseus' central control circuit"
	id = "odysseus_main"
	// req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/odysseus/odysseus_peri
	name = "'Odysseus' peripherals control circuit"
	id = "odysseus_peri"
	// req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/odysseus/chassis
	name = "Odysseus Chassis"
	id = "odysseus_chassis"
	build_path = /obj/item/mecha_parts/chassis/odysseus
	materials = list(MAT_STEEL = 15000)

/datum/design_techweb/mechfab/odysseus/torso
	name = "Odysseus Torso"
	id = "odysseus_torso"
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	materials = list(MAT_STEEL = 18750)

/datum/design_techweb/mechfab/odysseus/head
	name = "Odysseus Head"
	id = "odysseus_head"
	build_path = /obj/item/mecha_parts/part/odysseus_head
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 7500)

/datum/design_techweb/mechfab/odysseus/left_arm
	name = "Odysseus Left Arm"
	id = "odysseus_left_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	materials = list(MAT_STEEL = 7500)

/datum/design_techweb/mechfab/odysseus/right_arm
	name = "Odysseus Right Arm"
	id = "odysseus_right_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	materials = list(MAT_STEEL = 7500)

/datum/design_techweb/mechfab/odysseus/left_leg
	name = "Odysseus Left Leg"
	id = "odysseus_left_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	materials = list(MAT_STEEL = 11250)

/datum/design_techweb/mechfab/odysseus/right_leg
	name = "Odysseus Right Leg"
	id = "odysseus_right_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	materials = list(MAT_STEEL = 11250)

///GYGAX
/datum/design_techweb/mechfab/gygax
	desc = "A part used in the construction of the Gygax mecha series"
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/gygax/gygax_main
	name = "'Gygax' central control circuit"
	id = "gygax_main"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/gygax/gygax_peri
	name = "'Gygax' peripherals control circuit"
	id = "gygax_peri"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/gygax/gygax_targ
	name = "'Gygax' weapon control and targeting circuit"
	id = "gygax_targ"
	// req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/gygax/gygax_medical
	name = "'Serenity' medical control circuit"
	id = "gygax_medical"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/medical
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/gygax/chassis/serenity
	name = "Serenity Chassis"
	id = "serenity_chassis"
	build_path = /obj/item/mecha_parts/chassis/serenity
	materials = list(MAT_STEEL = 18750, MAT_PHORON = 4000)

/datum/design_techweb/mechfab/gygax/chassis
	name = "Gygax Chassis"
	id = "gygax_chassis"
	build_path = /obj/item/mecha_parts/chassis/gygax
	materials = list(MAT_STEEL = 18750)

/datum/design_techweb/mechfab/gygax/torso
	name = "Gygax Torso"
	id = "gygax_torso"
	build_path = /obj/item/mecha_parts/part/gygax_torso
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000)

/datum/design_techweb/mechfab/gygax/head
	name = "Gygax Head"
	id = "gygax_head"
	build_path = /obj/item/mecha_parts/part/gygax_head
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 7500)

/datum/design_techweb/mechfab/gygax/left_arm
	name = "Gygax Left Arm"
	id = "gygax_left_arm"
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	materials = list(MAT_STEEL = 22500)

/datum/design_techweb/mechfab/gygax/right_arm
	name = "Gygax Right Arm"
	id = "gygax_right_arm"
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	materials = list(MAT_STEEL = 22500)

/datum/design_techweb/mechfab/gygax/left_leg
	name = "Gygax Left Leg"
	id = "gygax_left_leg"
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	materials = list(MAT_STEEL = 26250)

/datum/design_techweb/mechfab/gygax/right_leg
	name = "Gygax Right Leg"
	id = "gygax_right_leg"
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	materials = list(MAT_STEEL = 26250)

/datum/design_techweb/mechfab/gygax/armour
	name = "Gygax Armour Plates"
	id = "gygax_armour"
	build_path = /obj/item/mecha_parts/part/gygax_armour
	materials = list(MAT_STEEL = 37500, MAT_DIAMOND = 7500)

///DURAND
/datum/design_techweb/mechfab/durand
	desc = "A part used in the construction of the Durand mecha series"
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/durand/durand_main
	name = "'Durand' central control circuit"
	id = "durand_main"
	// req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 2000, MAT_GRAPHITE = 1250)
	build_path = /obj/item/circuitboard/mecha/durand/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/durand/durand_peri
	name = "'Durand' peripherals control circuit"
	id = "durand_peri"
	// req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 2000, MAT_GRAPHITE = 1250)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/durand/durand_targ
	name = "'Durand' weapon control and targeting circuit"
	id = "durand_targ"
	// req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	materials = list(MAT_GLASS = 2000, MAT_GRAPHITE = 1250)
	build_path = /obj/item/circuitboard/mecha/durand/targeting
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/durand/chassis
	name = "Durand Chassis"
	id = "durand_chassis"
	build_path = /obj/item/mecha_parts/chassis/durand
	materials = list(MAT_STEEL = 18750, MAT_PLASTEEL = 20000)

/datum/design_techweb/mechfab/durand/torso
	name = "Durand Torso"
	id = "durand_torso"
	build_path = /obj/item/mecha_parts/part/durand_torso
	materials = list(MAT_STEEL = 41250, MAT_PLASTEEL = 15000, MAT_SILVER = 7500)

/datum/design_techweb/mechfab/durand/head
	name = "Durand Head"
	id = "durand_head"
	build_path = /obj/item/mecha_parts/part/durand_head
	materials = list(MAT_STEEL = 18750, MAT_GLASS = 7500, MAT_SILVER = 2250)

/datum/design_techweb/mechfab/durand/left_arm
	name = "Durand Left Arm"
	id = "durand_left_arm"
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	materials = list(MAT_STEEL = 26250, MAT_SILVER = 2250)

/datum/design_techweb/mechfab/durand/right_arm
	name = "Durand Right Arm"
	id = "durand_right_arm"
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	materials = list(MAT_STEEL = 26250, MAT_SILVER = 2250)

/datum/design_techweb/mechfab/durand/left_leg
	name = "Durand Left Leg"
	id = "durand_left_leg"
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	materials = list(MAT_STEEL = 30000, MAT_SILVER = 2250)

/datum/design_techweb/mechfab/durand/right_leg
	name = "Durand Right Leg"
	id = "durand_right_leg"
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	materials = list(MAT_STEEL = 30000, MAT_SILVER = 2250)

/datum/design_techweb/mechfab/durand/armour
	name = "Durand Armour Plates"
	id = "durand_armour"
	build_path = /obj/item/mecha_parts/part/durand_armour
	materials = list(MAT_STEEL = 27500, MAT_PLASTEEL = 10000, MAT_URANIUM = 7500)

///JANUS
/datum/design_techweb/mechfab/janus
	desc = "A part used in the construction of the Janus mecha series"
	category = list(
		RND_CATEGORY_MECHFAB_JANUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)
	//req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)

/datum/design_techweb/mechfab/janusmodule
	name = "Blackbox Circuit Datamass"
	desc = "A design that seems to be in a constantly shifting superposition."
	category = list(
		RND_CATEGORY_MECHFAB_JANUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)
	id = "janus_module"
	// req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)
	materials = list(MAT_DURASTEEL = 3000, MAT_MORPHIUM = 2000, MAT_METALHYDROGEN = 6000, MAT_URANIUM = 6000, MAT_VERDANTIUM = 1500)
	build_path = /obj/random/janusmodule

/datum/design_techweb/mechfab/janusmodule/create_item(target)
	var/path = pick(subtypesof(/obj/item/circuitboard/mecha/imperion))
	return new path(target)

/datum/design_techweb/mechfab/janus/chassis
	name = "Janus Chassis"
	id = "janus_chassis"
	build_path = /obj/item/mecha_parts/chassis/janus
	materials = list(MAT_DURASTEEL = 19000, MAT_MORPHIUM = 10500, MAT_PLASTEEL = 5500, MAT_LEAD = 2500)
	//req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 3)

/datum/design_techweb/mechfab/janus/torso
	name = "Imperion Torso"
	id = "janus_torso"
	build_path = /obj/item/mecha_parts/part/janus_torso
	materials = list(MAT_STEEL = 30000, MAT_DURASTEEL = 8000, MAT_MORPHIUM = 10000, MAT_GOLD = 5000, MAT_VERDANTIUM = 5000)

/datum/design_techweb/mechfab/janus/head
	name = "Imperion Head"
	id = "janus_head"
	build_path = /obj/item/mecha_parts/part/janus_head
	materials = list(MAT_STEEL = 30000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 6000, MAT_GOLD = 5000)

/datum/design_techweb/mechfab/janus/left_arm
	name = "Prototype Gygax Left Arm"
	id = "janus_left_arm"
	build_path = /obj/item/mecha_parts/part/janus_left_arm
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_DIAMOND = 7000)

/datum/design_techweb/mechfab/janus/right_arm
	name = "Prototype Gygax Right Arm"
	id = "janus_right_arm"
	build_path = /obj/item/mecha_parts/part/janus_right_arm
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_DIAMOND = 7000)

/datum/design_techweb/mechfab/janus/left_leg
	name = "Prototype Durand Left Leg"
	id = "janus_left_leg"
	build_path = /obj/item/mecha_parts/part/janus_left_leg
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_URANIUM = 7000)

/datum/design_techweb/mechfab/janus/right_leg
	name = "Prototype Durand Right Leg"
	id = "janus_right_leg"
	build_path = /obj/item/mecha_parts/part/janus_right_leg
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_URANIUM = 7000)

/datum/design_techweb/mechfab/janus/phase_coil
	name = "Janus Phase Coil"
	id = "janus_coil"
	build_path = /obj/item/prop/alien/phasecoil
	materials = list(MAT_SUPERMATTER = 2000, MAT_PLASTEEL = 60000, MAT_URANIUM = 3250, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_VERDANTIUM = 5000, MAT_DIAMOND = 10000, MAT_LEAD = 15000)

///--------///
///Fighters///
///--------///

///Pinnace///

/datum/design_techweb/mechfab/pinnace
	desc = "A part used in the construction of the Pinnace fighter series"
	category = list(
		RND_CATEGORY_MECHFAB_PINNACE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/pinnace/pinnace_main
	name = "Pinnace central control board circuit"
	id = "pinnace_main"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/pinnace/pinnace_flight
	name = "Pinnace flight control board circuit"
	id = "pinnace_flight"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/flight
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/pinnace/pinnace_targeting
	name = "Pinnace weapon control and targeting board circuit"
	id = "pinnace_targeting"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/targeting
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/pinnace/pinnace_cockpit_control
	name = "Pinnace manual flight control instruments circuit"
	id = "pinnace_cockpit_control"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/cockpitboard
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/pinnace/chassis
	name = "Pinnace Chassis"
	id = "pinnace_chassis"
	build_path = /obj/item/mecha_parts/fighter/chassis/pinnace
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 10000, MAT_PLASTEEL = 10000)

/datum/design_techweb/mechfab/pinnace/core
	name = "Pinnace Core"
	id = "pinnace_core"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_core
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 7000, MAT_PLASTEEL = 7000)

/datum/design_techweb/mechfab/pinnace/cockpit
	name = "Pinnace Cockpit"
	id = "pinnace_cockpit"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_cockpit
	materials = list(MAT_STEEL = 2500, MAT_PLASTEEL = 2500, MAT_GLASS = 7500, MAT_PLASTIC = 2500)

/datum/design_techweb/mechfab/pinnace/main_engine
	name = "Pinnace Main Engine"
	id = "pinnace_main_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_main_engine
	materials = list(MAT_STEEL = 15000, MAT_PLASTEEL = 5000)

/datum/design_techweb/mechfab/pinnace/left_engine
	name = "Pinnace Left Engine"
	id = "pinnace_left_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_left_engine
	materials = list(MAT_STEEL = 10000, MAT_PLASTEEL = 2500)

/datum/design_techweb/mechfab/pinnace/right_engine
	name = "Pinnace Right Engine"
	id = "pinnace_right_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_right_engine
	materials = list(MAT_STEEL = 10000, MAT_PLASTEEL = 2500)

/datum/design_techweb/mechfab/pinnace/left_wing
	name = "Pinnace Left Wing"
	id = "pinnace_left_wing"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_left_wing
	materials = list(MAT_STEEL = 7000, MAT_PLASTIC = 3000, MAT_PLASTEEL = 5000)

/datum/design_techweb/mechfab/pinnace/right_wing
	name = "Pinnace Right Wing"
	id = "pinnace_right_wing"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_right_wing
	materials = list(MAT_STEEL = 7000, MAT_PLASTIC = 3000, MAT_PLASTEEL = 5000)

///Baron///

/datum/design_techweb/mechfab/baron
	desc = "A part used in the construction of the Baron fighter series"
	category = list(
		RND_CATEGORY_MECHFAB_BARON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/baron/baron_main
	name = "Baron central control board circuit"
	id = "baron_main"
	// req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/baron/baron_flight
	name = "Baron flight control board circuit"
	id = "baron_flight"
	// req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/flight
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/baron/baron_targeting
	name = "Baron weapon control and targeting board circuit"
	id = "baron_targeting"
	// req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/targeting
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/baron/baron_cockpit_control
	name = "Baron manual flight control instruments circuit"
	id = "baron_cockpit_control"
	// req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/cockpitboard
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/baron/chassis
	name = "Baron Chassis"
	id = "baron_chassis"
	build_path = /obj/item/mecha_parts/fighter/chassis/baron
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 15000)

/datum/design_techweb/mechfab/baron/core
	name = "Baron Core"
	id = "baron_core"
	build_path = /obj/item/mecha_parts/fighter/part/baron_core
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 15000)

/datum/design_techweb/mechfab/baron/cockpit
	name = "Baron Cockpit"
	id = "baron_cockpit"
	build_path = /obj/item/mecha_parts/fighter/part/baron_cockpit
	materials = list(MAT_STEEL = 5000, MAT_PLASTEEL = 5000, MAT_GLASS = 10000, MAT_PLASTIC = 5000)

/datum/design_techweb/mechfab/baron/main_engine
	name = "Baron Main Engine"
	id = "baron_main_engine"
	build_path = /obj/item/mecha_parts/fighter/part/baron_main_engine
	materials = list(MAT_STEEL = 25000, MAT_PLASTEEL = 10000)

/datum/design_techweb/mechfab/baron/left_engine
	name = "Baron Left Engine"
	id = "baron_left_engine"
	build_path = /obj/item/mecha_parts/fighter/part/baron_left_engine
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 5000)

/datum/design_techweb/mechfab/baron/right_engine
	name = "Baron Right Engine"
	id = "baron_right_engine"
	build_path = /obj/item/mecha_parts/fighter/part/baron_right_engine
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 5000)

/datum/design_techweb/mechfab/baron/left_wing
	name = "Baron Left Wing"
	id = "baron_left_wing"
	build_path = /obj/item/mecha_parts/fighter/part/baron_left_wing
	materials = list(MAT_STEEL = 15000, MAT_PLASTIC = 6000, MAT_PLASTEEL = 10000)

/datum/design_techweb/mechfab/baron/right_wing
	name = "Baron Right Wing"
	id = "baron_right_wing"
	build_path = /obj/item/mecha_parts/fighter/part/baron_right_wing
	materials = list(MAT_STEEL = 15000, MAT_PLASTIC = 6000, MAT_PLASTEEL = 10000)


///EXOSUIT INTERNALS
//TODO: Expand these descriptions to say what they do in length.

/datum/design_techweb/mechfab/exointernal
	desc = "Internal component for a mecha."
	category = list(
		RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	//req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/datum/design_techweb/mechfab/exointernal/stan_armor
	name = "Armor Plate (Standard)"
	desc = "Armor plating that fits all mecha."
	id = "exo_int_armor_standard"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/armor

/datum/design_techweb/mechfab/exointernal/light_armor
	name = "Armor Plate (Lightweight)"
	desc = "Armor plating that fits all mecha."
	id = "exo_int_armor_lightweight"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 3000)
	build_path = /obj/item/mecha_parts/component/armor/lightweight

/datum/design_techweb/mechfab/exointernal/reinf_armor
	name = "Armor Plate (Reinforced)"
	desc = "Armor plating that fits all mecha."
	id = "exo_int_armor_reinforced"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 10000)
	build_path = /obj/item/mecha_parts/component/armor/reinforced

/datum/design_techweb/mechfab/exointernal/mining_armor
	name = "Armor Plate (Blast)"
	id = "exo_int_armor_blast"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 10000)
	build_path = /obj/item/mecha_parts/component/armor/mining

/datum/design_techweb/mechfab/exointernal/gygax_armor
	name = "Armor Plate (Marshal)"
	desc = "Armor plating that fits combat mecha."
	id = "exo_int_armor_gygax"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 40000, MAT_DIAMOND = 8000)
	build_path = /obj/item/mecha_parts/component/armor/marshal

/datum/design_techweb/mechfab/exointernal/darkgygax_armor
	name = "Armor Plate (Blackops)"
	desc = "Armor plating that fits combat mecha."
	id = "exo_int_armor_dgygax"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_COMBAT = 4, TECH_ILLEGAL = 2)
	materials = list(MAT_PLASTEEL = 20000, MAT_DIAMOND = 10000, MAT_GRAPHITE = 20000)
	build_path = /obj/item/mecha_parts/component/armor/marshal/reinforced

/datum/design_techweb/mechfab/exointernal/durand_armour
	name = "Armor Plate (Military)"
	desc = "Armor plating that fits combat mecha."
	id = "exo_int_armor_durand"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 40000, MAT_PLASTEEL = 9525, MAT_URANIUM = 8000)
	build_path = /obj/item/mecha_parts/component/armor/military

/datum/design_techweb/mechfab/exointernal/marauder_armour
	name = "Armor Plate (Cutting Edge)"
	desc = "Armor plating that fits marauder mecha."
	id = "exo_int_armor_marauder"
	//req_tech = list(TECH_MATERIAL = 8, TECH_ENGINEERING = 7, TECH_COMBAT = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_DURASTEEL = 40000, MAT_GRAPHITE = 8000, MAT_OSMIUM = 8000)
	build_path = /obj/item/mecha_parts/component/armor/military/marauder

/datum/design_techweb/mechfab/exointernal/phazon_armour
	name = "Armor Plate (Janus)"
	desc = "Armor plating that fits all mecha."
	id = "exo_int_armor_phazon"
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 6, TECH_COMBAT = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_MORPHIUM = 40000, MAT_DURASTEEL = 8000, MAT_OSMIUM = 8000)
	build_path = /obj/item/mecha_parts/component/armor/alien

/datum/design_techweb/mechfab/exointernal/stan_hull
	name = "Hull (Standard)"
	desc = "Hull that fits all mecha."
	id = "exo_int_hull_standard"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/hull

/datum/design_techweb/mechfab/exointernal/durable_hull
	name = "Hull (Durable)"
	id = "exo_int_hull_durable"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000, MAT_PLASTEEL = 5000)
	build_path = /obj/item/mecha_parts/component/hull/durable

/datum/design_techweb/mechfab/exointernal/light_hull
	name = "Hull (Lightweight)"
	desc = "Hull that fits all mecha."
	id = "exo_int_hull_light"
	//req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 3000)
	build_path = /obj/item/mecha_parts/component/hull/lightweight

/datum/design_techweb/mechfab/exointernal/stan_gas
	name = "Life-Support (Standard)"
	desc = "Life support module for mecha."
	id = "exo_int_lifesup_standard"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/gas

/datum/design_techweb/mechfab/exointernal/reinf_gas
	name = "Life-Support (Reinforced)"
	desc = "Upgraded life support module for mecha."
	id = "exo_int_lifesup_reinforced"
	//req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 8000, MAT_PLASTEEL = 8000, MAT_GRAPHITE = 1000)
	build_path = /obj/item/mecha_parts/component/gas/reinforced

/datum/design_techweb/mechfab/exointernal/stan_electric
	name = "Electrical Harness (Standard)"
	desc = "Electrical harness for a mecha."
	id = "exo_int_electric_standard"
	//req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 1000)
	build_path = /obj/item/mecha_parts/component/electrical

/datum/design_techweb/mechfab/exointernal/efficient_electric
	name = "Electrical Harness (High)"
	desc = "Electrical harness for a mecha."
	id = "exo_int_electric_efficient"
	//req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4, TECH_DATA = 2)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 3000, MAT_SILVER = 3000)
	build_path = /obj/item/mecha_parts/component/electrical/high_current

/datum/design_techweb/mechfab/exointernal/stan_actuator
	name = "Actuator Lattice (Standard)"
	desc = "Actuator Lattice for a mecha."
	id = "exo_int_actuator_standard"
	//req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mecha_parts/component/actuator

/datum/design_techweb/mechfab/exointernal/hispeed_actuator
	name = "Actuator Lattice (Overclocked)"
	desc = "Actuator Lattice for a mecha."
	id = "exo_int_actuator_overclock"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 10000, MAT_OSMIUM = 3000, MAT_GOLD = 5000)
	build_path = /obj/item/mecha_parts/component/actuator/hispeed

/datum/design_techweb/mechfab/vehicle
	build_type = MECHFAB
	category = list(
		RND_SUBCATEGORY_MECHFAB_VEHICLE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6)

/datum/design_techweb/mechfab/vehicle/spacebike_chassis
	name = "Spacebike Chassis"
	desc = "A space-bike's un-assembled frame."
	id = "vehicle_chassis_spacebike"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials = list(MAT_STEEL = 12000, MAT_SILVER = 3000, MAT_PHORON = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/spacebike

/datum/design_techweb/mechfab/vehicle/quadbike_chassis
	name = "Quad bike Chassis"
	desc = "A quad bike's un-assembled frame."
	id = "vehicle_chassis_quadbike"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 15000, MAT_SILVER = 3000, MAT_PLASTIC = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/quadbike

/datum/design_techweb/mechfab/vehicle/snowmobile_chassis
	name = "Snowmobile Chassis"
	desc = "A snowmobile's un-assembled frame."
	id = "vehicle_chassis_snowmobile"
	//req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 12000, MAT_SILVER = 3000, MAT_PLASTIC = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/snowmobile

/datum/design_techweb/mechfab/vehicle/basic //I'm going to just count this as a vehicle...
	name = "UAV - Recon Skimmer"
	desc = "A UAV designed for reconnaissance and light scouting. It is equipped with a camera and can be controlled remotely."
	id = "recon_skimmer"
	category = list(
		RND_SUBCATEGORY_MECHFAB_VEHICLE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)
	build_path = /obj/item/uav
	//req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 6)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_SILVER = 4000)


///Micromechs...I know downstream is going to disable these from orbit, so feel free to take the line below to add your disable start:

/datum/design_techweb/mechfab/gopher
	desc = "A part used in the construction of the Gopher micro mech series"
	category = list(
		RND_CATEGORY_MECHFAB_GOPHER + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/gopher/gopher_main
	name = "'Gopher' central control circuit"
	id = "gopher_main"
	build_path = /obj/item/circuitboard/mecha/gopher/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/gopher/gopher_peri
	name = "'Gopher' peripherals control circuit"
	id = "gopher_peri"
	build_path = /obj/item/circuitboard/mecha/gopher/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/gopher/chassis
	name = "Gopher Chassis"
	id = "gopher_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/gopher
	materials = list(MAT_STEEL = 7000)

/datum/design_techweb/mechfab/gopher/torso
	name = "Gopher Torso"
	id = "gopher_torso"
	build_path = /obj/item/mecha_parts/micro/part/gopher_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design_techweb/mechfab/gopher/left_arm
	name = "Gopher Left Arm"
	id = "gopher_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design_techweb/mechfab/gopher/right_arm
	name = "Gopher Right Arm"
	id = "gopher_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_arm

	materials = list(MAT_STEEL = 8750)

/datum/design_techweb/mechfab/gopher/left_leg
	name = "Gopher Left Leg"
	id = "gopher_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design_techweb/mechfab/gopher/right_leg
	name = "Gopher Right Leg"
	id = "gopher_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design_techweb/micro
	name = "Miniature Drill"
	id = "micro_drill"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/micro
	materials = list(MAT_STEEL = 2500)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hydraulic_clampmicro
	name = "Mounted ore box"
	id = "ore_scoop"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/micro/orescoop
	materials = list(MAT_STEEL = 2500)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/mechfab/polecat
	desc = "A part used in the construction of the Gopher micro mech series"
	category = list(
		RND_CATEGORY_MECHFAB_POLECAT + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/polecat/polecat_main
	name = "'Polecat' central control circuit"
	id = "polecat_main"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/polecat/polecat_peri
	name = "'Polecat' peripherals control circuit"
	id = "polecat_peri"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/polecat/polecat_targ
	name = "'Polecat' weapon control and targeting circuit"
	id = "polecat_targ"
	// req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/polecat/targeting
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/polecat/chassis
	name = "Polecat Chassis"
	id = "polecat_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/polecat
	materials = list(MAT_STEEL = 7000)

/datum/design_techweb/mechfab/polecat/torso
	name = "Polecat Torso"
	id = "polecat_torso"
	build_path = /obj/item/mecha_parts/micro/part/polecat_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design_techweb/mechfab/polecat/left_arm
	name = "Polecat Left Arm"
	id = "polecat_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design_techweb/mechfab/polecat/right_arm
	name = "Polecat Right Arm"
	id = "polecat_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_arm
	materials = list(MAT_STEEL = 8750)

/datum/design_techweb/mechfab/polecat/left_leg
	name = "Polecat Left Leg"
	id = "polecat_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design_techweb/mechfab/polecat/right_leg
	name = "Polecat Right Leg"
	id = "polecat_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design_techweb/mechfab/polecat/armour
	name = "Polecat Armour Plates"
	id = "polecat_armour"
	build_path = /obj/item/mecha_parts/micro/part/polecat_armour
	materials = list(MAT_STEEL = 12500, MAT_PLASTIC = 7500)

/datum/design_techweb/mechfab/weasel
	desc = "A part used in the construction of the Weasel micro mech series"
	category = list(
		RND_CATEGORY_MECHFAB_WEASEL + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design_techweb/mechfab/weasel/weasel_main
	name = "'Weasel' central control circuit"
	id = "weasel_main"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/main
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/weasel/weasel_peri
	name = "'Weasel' peripherals control circuit"
	id = "weasel_peri"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/peripherals
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/weasel/weasel_targ
	name = "'Weasel' weapon control and targeting circuit"
	id = "weasel_targ"
	// req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/weasel/targeting
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/mechfab/weasel/chassis
	name = "Weasel Chassis"
	id = "weasel_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/weasel
	materials = list(MAT_STEEL = 7000)

/datum/design_techweb/mechfab/weasel/torso
	name = "Weasel Torso"
	id = "weasel_torso"
	build_path = /obj/item/mecha_parts/micro/part/weasel_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design_techweb/mechfab/weasel/left_arm
	name = "Weasel Left Arm"
	id = "weasel_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design_techweb/mechfab/weasel/right_arm
	name = "Weasel Right Arm"
	id = "weasel_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_arm
	materials = list(MAT_STEEL = 8750)

/*/datum/design_techweb/mechfab/weasel/left_leg
	name = "Weasel Left Leg"
	id = "weasel_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design_techweb/mechfab/weasel/right_leg
	name = "Weasel Right Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_leg
	materials = list(MAT_STEEL = 12500)*/

/datum/design_techweb/mechfab/weasel/tri_leg
	name = "Weasel Tri Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_tri_leg
	materials = list(MAT_STEEL = 27500)

/datum/design_techweb/mechfab/weasel/head
	name = "Weasel Head"
	id = "weasel_head"
	build_path = /obj/item/mecha_parts/micro/part/weasel_head
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2500)

//End of micromechs.
