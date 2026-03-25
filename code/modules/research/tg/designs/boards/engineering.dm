/datum/design_techweb/board/rcon_console
	SET_CIRCUIT_DESIGN_NAMEDESC("RCON remote control console")
	id = "rcon_console"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/dronecontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("drone control console")
	id = "dronecontrol"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/powermonitor
	SET_CIRCUIT_DESIGN_NAMEDESC("power monitoring console")
	id = "powermonitor"
	build_path = /obj/item/circuitboard/powermonitor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/solarcontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("solar control console")
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/solar_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/solar_tracker
	SET_CIRCUIT_DESIGN_NAMEDESC("solar tracker")
	id = "solar_tracker"
	build_path = /obj/item/tracker_electronics
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pacman
	SET_CIRCUIT_DESIGN_NAMEDESC("PACMAN-type generator")
	id = "pacman"
	// req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/superpacman
	SET_CIRCUIT_DESIGN_NAMEDESC("SUPERPACMAN-type generator")
	id = "superpacman"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mrspacman
	SET_CIRCUIT_DESIGN_NAMEDESC("MRSPACMAN-type generator")
	id = "mrspacman"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/batteryrack
	SET_CIRCUIT_DESIGN_NAMEDESC("cell rack PSU")
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
	SET_CIRCUIT_DESIGN_NAMEDESC("power grid checker")
	id = "grid_checker"
	// req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/grid_checker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/breakerbox
	SET_CIRCUIT_DESIGN_NAMEDESC("breaker box")
	id = "breakerbox"
	// req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/breakerbox
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/hydromagnetic_trap
	SET_CIRCUIT_DESIGN_NAMEDESC("hydromagnetic trap")
	id = "hydromagnetic_trap"
	// req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/hydromagnetic_trap
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
	SET_CIRCUIT_DESIGN_NAMEDESC("shield generator")
	id = "shield_generator"
	// req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_BLUESPACE = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shield_generator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/shield_diffuser
	SET_CIRCUIT_DESIGN_NAMEDESC("shield diffuser")
	id = "shield_diffuser"
	// req_tech = list(TECH_MAGNET = 4, TECH_POWER = 2, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/shield_diffuser
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense
	SET_CIRCUIT_DESIGN_NAMEDESC("point defense battery")
	id = "pointdefense"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense_control
	SET_CIRCUIT_DESIGN_NAMEDESC("point defense control")
	id = "pointdefense_control"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recycler_crusher
	SET_CIRCUIT_DESIGN_NAMEDESC("recycling crusher")
	id = "recycler_crusher"
	// req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_crusher
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recycler_sorter
	SET_CIRCUIT_DESIGN_NAMEDESC("recycling sorter")
	id = "recycler_sorter"
	// req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_sorter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recycler_stamper
	SET_CIRCUIT_DESIGN_NAMEDESC("recycling stamper")
	id = "recycler_stamper"
	// req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_stamper
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/algae_farm
	SET_CIRCUIT_DESIGN_NAMEDESC("Algae Oxygen Generator")
	id = "algae_farm"
	// req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/thermoregulator
	SET_CIRCUIT_DESIGN_NAMEDESC("thermal regulator")
	id = "thermoregulator"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/partslathe
	SET_CIRCUIT_DESIGN_NAMEDESC("Parts lathe")
	id = "partslathe"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/partslathe
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rtg
	SET_CIRCUIT_DESIGN_NAMEDESC("radioisotope TEG")
	id = "rtg"
	// req_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/machine/rtg
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rtg_advanced
	SET_CIRCUIT_DESIGN_NAMEDESC("advanced radioisotope TEG")
	id = "adv_rtg"
	// req_tech = list(TECH_DATA = 5, TECH_POWER = 5, TECH_PHORON = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/machine/rtg/advanced
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/dtype_rtg
	SET_CIRCUIT_DESIGN_NAMEDESC("d-type rotary electric generator")
	id = "dtype_rtg"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/machine/reg_d
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/ctype_rtg
	SET_CIRCUIT_DESIGN_NAMEDESC("c-type rotary electric generator")
	id = "ctype_rtg"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/machine/reg_c
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense
	SET_CIRCUIT_DESIGN_NAMEDESC("point defense battery")
	id = "pointdefense"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pointdefense_control
	SET_CIRCUIT_DESIGN_NAMEDESC("point defense control")
	id = "pointdefense_control"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/fusion
	SET_CIRCUIT_DESIGN_NAMEDESC("Fusion Core Control Console")
	id = "fusion_core_control"
	build_path = /obj/item/circuitboard/fusion_core_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/fusion/fuel_compressor
	SET_CIRCUIT_DESIGN_NAMEDESC("Fusion Fuel Compressor")
	id = "fusion_fuel_compressor"
	build_path = /obj/item/circuitboard/fusion_fuel_compressor

/datum/design_techweb/board/fusion/fuel_control
	SET_CIRCUIT_DESIGN_NAMEDESC("Fusion Fuel Control Console")
	id = "fusion_fuel_control"
	build_path = /obj/item/circuitboard/fusion_fuel_control

/datum/design_techweb/board/fusion/gyrotron_control
	SET_CIRCUIT_DESIGN_NAMEDESC("Gyrotron Control Console")
	id = "gyrotron_control"
	build_path = /obj/item/circuitboard/gyrotron_control

/datum/design_techweb/board/fusion/core
	SET_CIRCUIT_DESIGN_NAMEDESC("Fusion Core")
	id = "fusion_core"
	build_path = /obj/item/circuitboard/fusion_core

/datum/design_techweb/board/fusion/injector
	SET_CIRCUIT_DESIGN_NAMEDESC("Fusion Fuel Injector")
	id = "fusion_injector"
	build_path = /obj/item/circuitboard/fusion_injector

/datum/design_techweb/board/airlock_cycling
	name = "airlock cycling control circuit"
	desc = "The circuit board for cycling airlock parts."
	id = "airlock_cycling"
	build_path = /obj/item/circuitboard/airlock_cycling
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/tesla_coil
	SET_CIRCUIT_DESIGN_NAMEDESC("tesla coil")
	id = "tesla_coil"
	build_path = /obj/item/circuitboard/tesla_coil
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/grounding_rod
	SET_CIRCUIT_DESIGN_NAMEDESC("grounding rod")
	id = "grounding_rod"
	build_path = /obj/item/circuitboard/grounding_rod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/electrochromic
	SET_CIRCUIT_DESIGN_NAMEDESC("electrochromic button")
	id = "electrochromic"
	build_path = /obj/item/circuitboard/electrochromic
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mass_driver_button
	SET_CIRCUIT_DESIGN_NAMEDESC("mass driver button")
	id = "mass_driver_button"
	build_path = /obj/item/circuitboard/mass_driver_button
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/automatic_pipe_layer
	SET_CIRCUIT_DESIGN_NAMEDESC("automatic pipe layer")
	id = "automatic_pipe_layer"
	build_path = /obj/item/circuitboard/pipelayer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/geiger
	SET_CIRCUIT_DESIGN_NAMEDESC("wall-mounted geiger counter")
	id = "geiger"
	build_path = /obj/item/circuitboard/geiger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/gyrotron
	SET_CIRCUIT_DESIGN_NAMEDESC("gyrotron")
	id = "gyrotron"
	build_path = /obj/item/circuitboard/gyrotron
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/supermatter_core_manager
	SET_CIRCUIT_DESIGN_NAMEDESC("supermatter core control")
	id = "supermatter_core_manager"
	build_path = /obj/item/circuitboard/air_management/supermatter_core
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/supermatter_injector_control
	SET_CIRCUIT_DESIGN_NAMEDESC("supermatter injector control")
	id = "supermatter_injector_control"
	build_path = /obj/item/circuitboard/air_management/injector_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
