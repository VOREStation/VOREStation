/datum/design_techweb/advmop
	name = "advanced mop"
	desc = "An advanced mop with pressured water jets that break away the toughest stains."
	id = "advmop"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/mop/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/spraybottle
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	id = "spraybottle"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/reagent_containers/spray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/beartrap
	name = "mechanical trap"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	id = "beartrap"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 18750)
	build_path = /obj/item/beartrap
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/experimental_welder
	name = "Experimental welding tool"
	desc = "A welding tool that generate fuel for itself."
	id = "expwelder"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 70, MAT_GLASS = 120, MAT_PHORON = 100)
	build_path = /obj/item/weldingtool/experimental
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hand_drill
	name = "Hand drill"
	desc = "A simple powered hand drill."
	id = "handdrill"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 300, MAT_SILVER = 100)
	build_path = /obj/item/tool/transforming/powerdrill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/jaws_life
	name = "Jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	id = "jawslife"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 300, MAT_SILVER = 100)
	build_path = /obj/item/tool/transforming/jawsoflife
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/rpd
	name = "Rapid Pipe Dispenser"
	desc = "A counterpart to the rapid construction device that allows creating and placing atmospheric and disposal pipes."
	id = "rapidpipedispenser"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000)
	build_path = /obj/item/pipe_dispenser
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/qpad_booster
	name = "Quantum Pad Particle Booster"
	desc = "A deceptively simple interface for increasing the mass of objects a quantum pad is capable of teleporting, at the cost of increased power draw."
	id = "qpad_booster"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 7, TECH_MATERIAL = 7, TECH_BLUESPACE = 6)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/quantum_pad_booster
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/t_scanner
	name = "T-ray Scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "tscanner"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 200)
	build_path = /obj/item/t_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/t_scanner_upg
	name = "Upgraded T-ray Scanner"
	desc = "An upgraded version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "upgradedtscanner"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 500, MAT_PHORON = 150)
	build_path = /obj/item/t_scanner/upgraded
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/t_scanner_adv
	name = "Advanced T-ray Scanner"
	desc = "An advanced version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "advancedtscanner"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 1250, MAT_PHORON = 500, MAT_SILVER = 50)
	build_path = /obj/item/t_scanner/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/atmosanalyzer
	name = "Analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	id = "atmosanalyzer"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 100)
	build_path = /obj/item/analyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/communicator
	name = "Communicator"
	desc = "A personal device used to enable long range dialog between two people."
	id = "communicator"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/communicator
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/inducer_sci
	name = "Inducer (Scientific)"
	desc = "A tool for inductively charging internal power cells."
	id = "inducersci"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/inducer/sci
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/inducer_eng
	name = "Inducer (Industrial)"
	desc = "A tool for inductively charging internal power cells."
	id = "inducerind"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000, MAT_TITANIUM = 2000)
	build_path = /obj/item/inducer/unloaded
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/beaker_noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	// req_tech = list(TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/beaker_bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	// req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_PHORON = 3000, MAT_DIAMOND = 500)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/nifrepairtool
	name = "adv. NIF repair tool"
	desc = "A tool to repair NIF implants."
	id = "anrt"
	// req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 3000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/nifrepairer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL


/datum/design_techweb/mass_spectrometer
	name = "Mass Spectrometer"
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	// req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	build_path = /obj/item/mass_spectrometer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/adv_mass_spectrometer
	name = "Advanced Mass Spectrometer"
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	// req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	build_path = /obj/item/mass_spectrometer/adv
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/reagent_scanner
	name = "Reagent Scanner"
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	// req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	build_path = /obj/item/reagent_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/adv_reagent_scanner
	name = "Advanced Reagent Scanner"
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	// req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	build_path = /obj/item/reagent_scanner/adv
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	// req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 200)
	build_path = /obj/item/robotanalyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/plant_analyzer
	desc = "A device capable of quickly scanning all relevant data about a plant."
	id = "plant_analyzer"
	// req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/analyzer/plant_analyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE
