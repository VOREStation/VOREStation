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
// Surgical devices
/datum/design_techweb/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	// req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500)
	build_path = /obj/item/surgical/scalpel/laser1
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	// req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/scalpel/laser2
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2000, MAT_GOLD = 1500)
	build_path = /obj/item/surgical/scalpel/laser3
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 750)
	build_path = /obj/item/surgical/scalpel/manager
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/saw_manager
	name = "Energetic Bone Diverter"
	desc = "A strange development following the I.M.S., this heavy tool can split and open, or close and shut, intentional holes in bones."
	id = "advanced_saw"
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_DATA = 5)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 800, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_OSMIUM = 1000)
	build_path = /obj/item/surgical/circular_saw/manager
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/organ_ripper
	name = "Organ Ripper"
	desc = "A modern and horrifying take on an ancient practice, this tool is capable of rapidly removing an organ from a hopefully willing patient, without damaging it."
	id = "organ_ripper"
	// req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 8000, MAT_OSMIUM = 2500)
	build_path = /obj/item/surgical/scalpel/ripper
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/bone_clamp
	name = "Bone Clamp"
	desc = "A miracle of modern science, this tool rapidly knits together bone, without the need for bone gel."
	id = "bone_clamp"
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/bone_clamp
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/medical_analyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	id = "medical_analyzer"
	// req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/healthanalyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/improved_analyzer
	name = "improved health analyzer"
	desc = "A prototype version of the regular health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels."
	id = "improved_analyzer"
	// req_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 1500)
	build_path = /obj/item/healthanalyzer/improved
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/advanced_analyzer
	name = "advanced health analyzer"
	desc = "An even more advanced handheld health scanner, complete with a full biosign monitor and on-board radiation and neurological analysis suites."
	id = "advanced_analyzer"
	// req_tech = list(TECH_MAGNET = 7, TECH_BIO = 7, TECH_DATA = 5)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 4000, MAT_SILVER = 3500, MAT_GOLD = 2500, MAT_DIAMOND = 1250)
	build_path = /obj/item/healthanalyzer/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/gene_scanner
	name = "Gene Scanner"
	id = "gene_scanner"
	// req_tech = list(TECH_DATA = 1, TECH_BIO = 2)
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	build_path = /obj/item/gene_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/advanced_roller
	name = "advanced roller bed"
	desc = "A more advanced version of the regular roller bed, with inbuilt surgical stabilisers and an improved folding system."
	id = "roller_bed"
	// req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/roller/adv
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/sleevemate
	name = "SleeveMate 3700"
	id = "sleevemate"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/sleevemate
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/protohypospray
	name = "prototype hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 1500, MAT_SILVER = 2000, MAT_GOLD = 1500, MAT_URANIUM = 1000)
	build_path = /obj/item/reagent_containers/hypospray/science
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

// Mining digging devices
/datum/design_techweb/drill
	name = "Drill"
	id = "drill"
	// req_tech = list(TECH_MATERIAL = 1, TECH_POWER = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 500) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/advdrill
	name = "Advanced Drill"
	id = "advanced_drill"
	// req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/advdrill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/jackhammer
	name = "Jackhammer"
	id = "jackhammer"
	// req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/plasmacutter
	name = "Plasma Cutter"
	id = "plasmacutter"
	// req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_GOLD = 500, MAT_PHORON = 500)
	build_path = /obj/item/pickaxe/plasmacutter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/pick_diamond
	name = "Diamond Pickaxe"
	id = "pick_diamond"
	// req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/drill_diamond
	name = "Diamond Drill"
	id = "drill_diamond"
	// req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

// Mining other equipment

/datum/design_techweb/depth_scanner
	name = "Depth Scanner"
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 1000,MAT_GLASS = 1000)
	build_path = /obj/item/depth_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/mining_scanner
	name = "Mining Scanner"
	id = "mining_scanner"
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 1)
	materials = list(MAT_STEEL = 1000,MAT_GLASS = 500)
	build_path = /obj/item/mining_scanner/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

// Everything that didn't fit elsewhere
/datum/design_techweb/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	// req_tech = list(TECH_MAGNET = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/laser_pointer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)

/datum/design_techweb/translator
	name = "handheld translator"
	id = "translator"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/universal_translator
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)

/datum/design_techweb/bsflare
	name = "bluespace flare"
	desc = "A marker that can be detected by shuttle landing systems."
	id = "bsflare"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/spaceflare
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)

/datum/design_techweb/motion_tracker
	name = "Motion Tracker"
	// id = "motion_tracker"
	// req_tech = list(TECH_MAGNET = 1, TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500)
	build_path = /obj/item/motiontracker
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
