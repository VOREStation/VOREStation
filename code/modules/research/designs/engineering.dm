// Tools

/datum/design/item/tool/AssembleDesignName()
	..()
	name = "Experimental tool prototype ([item_name])"

/datum/design/item/tool/experimental_welder
	name = "Experimental welding tool"
	desc = "A welding tool that generate fuel for itself."
	id = "expwelder"
	req_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 70, MAT_GLASS = 120, MAT_PHORON = 100)
	build_path = /obj/item/weldingtool/experimental
	sort_string = "NAAAA"

/datum/design/item/tool/hand_drill
	name = "Hand drill"
	desc = "A simple powered hand drill."
	id = "handdrill"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 300, MAT_SILVER = 100)
	build_path = /obj/item/tool/screwdriver/power
	sort_string = "NAAAB"

/datum/design/item/tool/jaws_life
	name = "Jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	id = "jawslife"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 300, MAT_SILVER = 100)
	build_path = /obj/item/tool/crowbar/power
	sort_string = "NAAAC"

/datum/design/item/tool/rpd
	name = "Rapid Pipe Dispenser"
	desc = "A counterpart to the rapid construction device that allows creating and placing atmospheric and disposal pipes."
	id = "rapidpipedispenser"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000)
	build_path = /obj/item/pipe_dispenser
	sort_string = "NAAAD"

/datum/design/item/tool/qpad_booster
	name = "Quantum Pad Particle Booster"
	desc = "A deceptively simple interface for increasing the mass of objects a quantum pad is capable of teleporting, at the cost of increased power draw."
	id = "qpad_booster"
	req_tech = list(TECH_ENGINEERING = 7, TECH_MATERIAL = 7, TECH_BLUESPACE = 6)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/quantum_pad_booster
	sort_string = "NAAAF"

// Other devices

/datum/design/item/engineering/AssembleDesignName()
	..()
	name = "Engineering device prototype ([item_name])"

/datum/design/item/engineering/t_scanner
	name = "T-ray Scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "tscanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 200)
	build_path = /obj/item/t_scanner
	sort_string = "NBAAA"

/datum/design/item/engineering/t_scanner_upg
	name = "Upgraded T-ray Scanner"
	desc = "An upgraded version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "upgradedtscanner"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 500, MAT_PHORON = 150)
	build_path = /obj/item/t_scanner/upgraded
	sort_string = "NBAAB"

/datum/design/item/engineering/t_scanner_adv
	name = "Advanced T-ray Scanner"
	desc = "An advanced version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "advancedtscanner"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 1250, MAT_PHORON = 500, MAT_SILVER = 50)
	build_path = /obj/item/t_scanner/advanced
	sort_string = "NBAAC"

/datum/design/item/engineering/atmosanalyzer
	name = "Analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	id = "atmosanalyzer"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 100)
	build_path = /obj/item/analyzer
	sort_string = "NBABA"
