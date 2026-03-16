/datum/design_techweb/board/rcon_console
	name = "RCON remote control console circuit"
	id = "rcon_console"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/dronecontrol
	name = "drone control console circuit"
	id = "dronecontrol"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/powermonitor
	name = "power monitoring console circuit"
	id = "powermonitor"
	build_path = /obj/item/circuitboard/powermonitor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/solarcontrol
	name = "solar control console circuit"
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/solar_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pacman
	name = "PACMAN-type generator circuit"
	id = "pacman"
	// req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/superpacman
	name = "SUPERPACMAN-type generator circuit"
	id = "superpacman"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mrspacman
	name = "MRSPACMAN-type generator circuit"
	id = "mrspacman"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/batteryrack
	name = "cell rack PSU circuit"
	id = "batteryrack"
	// req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/batteryrack
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/smes_cell
	name = "'SMES' superconductive magnetic energy storage circuit"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	// req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/smes
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/grid_checker
	name = "power grid checker circuit"
	desc = "Allows for the construction of circuit boards used to build a grid checker."
	id = "grid_checker"
	// req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/grid_checker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/breakerbox
	name = "breaker box circuit"
	desc = "Allows for the construction of circuit boards used to build a breaker box."
	id = "breakerbox"
	// req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/breakerbox
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/secure_airlock
	name = "secure airlock electronics circuit"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/shield_generator
	name = "shield generator circuit"
	id = "shield_generator"
	// req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_BLUESPACE = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shield_generator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/shield_diffuser
	name = "shield diffuser circuit"
	id = "shield_diffuser"
	// req_tech = list(TECH_MAGNET = 4, TECH_POWER = 2, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/shield_diffuser
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense
	name = "point defense battery circuit"
	id = "pointdefense"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense_control
	name = "point defense control circuit"
	id = "pointdefense_control"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recycler_crusher
	name = "recycler - crusher circuit"
	id = "recycler_crusher"
	// req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_crusher
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recycler_sorter
	name = "recycler - sorter circuit"
	id = "recycler_sorter"
	// req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_sorter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recycler_stamper
	name = "recycler - stamper circuit"
	id = "recycler_stamper"
	// req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_stamper
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/algae_farm
	name = "Algae Oxygen Generator circuit"
	id = "algae_farm"
	// req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/thermoregulator
	name = "thermal regulator circuit"
	id = "thermoregulator"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/partslathe
	name = "Parts lathe circuit"
	id = "partslathe"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/partslathe
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rtg
	name = "radioisotope TEG circuit"
	id = "rtg"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/machine/rtg
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rtg_advanced
	name = "advanced radioisotope TEG circuit"
	id = "adv_rtg"
	// req_tech = list(TECH_DATA = 5, TECH_POWER = 5, TECH_PHORON = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/machine/rtg/advanced
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense
	name = "point defense battery circuit"
	id = "pointdefense"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense_control
	name = "point defense control circuit"
	id = "pointdefense_control"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/fusion
	name = "Fusion Core Control Console"
	id = "fusion_core_control"
	build_path = /obj/item/circuitboard/fusion_core_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/fusion/fuel_compressor
	name = "Fusion Fuel Compressor"
	id = "fusion_fuel_compressor"
	build_path = /obj/item/circuitboard/fusion_fuel_compressor

/datum/design_techweb/board/fusion/fuel_control
	name = "Fusion Fuel Control Console"
	id = "fusion_fuel_control"
	build_path = /obj/item/circuitboard/fusion_fuel_control

/datum/design_techweb/board/fusion/gyrotron_control
	name = "Gyrotron Control Console"
	id = "gyrotron_control"
	build_path = /obj/item/circuitboard/gyrotron_control

/datum/design_techweb/board/fusion/core
	name = "Fusion Core"
	id = "fusion_core"
	build_path = /obj/item/circuitboard/fusion_core

/datum/design_techweb/board/fusion/injector
	name = "Fusion Fuel Injector"
	id = "fusion_injector"
	build_path = /obj/item/circuitboard/fusion_injector

/datum/design_techweb/board/airlock_cycling
	name = "Machine Design (Cycling Airlock Board)"
	desc = "The circuit board for cycling airlock parts."
	id = "airlock_cycling"
	build_path = /obj/item/circuitboard/airlock_cycling
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/tesla_coil
	name = "Machine Design (Tesla Coil Board)"
	desc = "The circuit board for a tesla coil."
	id = "tesla_coil"
	build_path = /obj/item/circuitboard/tesla_coil
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
