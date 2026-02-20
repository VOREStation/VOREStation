/datum/design_techweb/prybar
	name = "prybar"
	desc = "A steel bar with a wedge, designed specifically for opening unpowered doors in an emergency."
	id = "prybar"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 40)
	build_path = /obj/item/tool/prybar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/crowbar
	name = "crowbar"
	desc = "A steel bar with a wedge, designed specifically for opening unpowered doors in an emergency."
	id = "crowbar"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 60)
	build_path = /obj/item/tool/crowbar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut."
	id = "multitool"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 60, MAT_GLASS = 25)
	build_path = /obj/item/multitool
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/mini_welding_tool
	name = "emergency welding tool"
	desc = "A miniature welder used during emergencies."
	id = "mini_welding_tool"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 30)
	build_path = /obj/item/weldingtool/mini
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/welding_tool
	name = "welding tool"
	desc = "Used to repair machinery, or cut through plating."
	id = "welding_tool"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 90, MAT_GLASS = 40)
	build_path = /obj/item/weldingtool
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/large_welding_tool
	name = "industrial welding tool"
	desc = "A slightly larger welder with a larger tank."
	id = "large_welding_tool"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 250)
	build_path = /obj/item/weldingtool/largetank
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	id = "screwdriver"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 90)
	build_path = /obj/item/tool/screwdriver
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	id = "wirecutters"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 100)
	build_path = /obj/item/tool/wirecutters
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/wrench
	name = "wrench"
	desc = "A wrench with many common uses."
	id = "wrench"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 200)
	build_path = /obj/item/tool/wrench
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/minihoe
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	id = "spade"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 625)
	build_path = /obj/item/material/minihoe
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	id = "fire_extinguisher"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 120)
	build_path = /obj/item/extinguisher
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/bounced_radio
	name = "station bounced radio"
	desc = "Used to talk to people when headsets don't function. Range is limited."
	id = "bounced_radio"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 90, MAT_GLASS = 30)
	build_path = /obj/item/radio/off
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/destination_tagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	id = "desttagger"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 250, MAT_GLASS = 125)
	build_path = /obj/item/destTagger
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	id = "flashlight"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 60, MAT_GLASS = 25)
	build_path = /obj/item/flashlight
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	id = "maglight"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 250, MAT_GLASS = 60)
	build_path = /obj/item/flashlight/maglight
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/taperecorder
	name = "tape recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	id = "taperecorder"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 75, MAT_GLASS = 40)
	build_path = /obj/item/taperecorder
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/recordingtape
	name = "recorder cassette tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	id = "recordingcassette"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 25, MAT_GLASS = 15)
	build_path = /obj/item/rectape/random
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

/datum/design_techweb/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	id = "hatchet"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500)
	build_path = /obj/item/material/knife/machete/hatchet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/bucket
	name = "bucket"
	desc = "It's a bucket."
	id = "bucket"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 250)
	build_path = /obj/item/reagent_containers/glass/bucket
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/mop
	name = "mop"
	desc = "The world of janitalia wouldn't be complete without a mop."
	id = "mop"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 250)
	build_path = /obj/item/mop
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

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
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs. Can also recycle broken bulbs, but this requires several broken bulbs to make a functioning one."
	id = "light_replacer"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/spraybottle
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	id = "spraybottle"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_PLASTIC = 2000)
	build_path = /obj/item/reagent_containers/spray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/beartrap
	name = "mechanical trap"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	id = "beartrap"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 18750)
	build_path = /obj/item/beartrap
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)

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
	build_type = AUTOLATHE | PROTOLATHE
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
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

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
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

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
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/beaker_noreact
	name = "Cryostasis Beaker"
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
	name = "Bluespace Beaker"
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
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE


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
	name = "Robot Scanner"
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
	name = "Nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/plant_analyzer
	name = "Plant Analyzer"
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

// Mining digging devices
/datum/design_techweb/drill
	name = "Drill"
	id = "drill"
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/laser_pointer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ASSISTANT | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/translator
	name = "handheld translator"
	id = "translator"
	build_type = PROTOLATHE
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
	build_type = PROTOLATHE
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/spaceflare
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/motion_tracker
	name = "Motion Tracker"
	id = "motion_tracker"
	// req_tech = list(TECH_MAGNET = 1, TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500)
	build_path = /obj/item/motiontracker
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)

/datum/design_techweb/slime_scanner
	name = "Slime Scanner"
	desc = "A hand-held body scanner able to learn information about slimes."
	id = "slime_scanner"
	// req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/slime_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/grinder
	name = "Portable Slime Processor"
	desc = "This high tech device combines the slime processor with the latest in woodcutting technology."
	id = "slime_grinder"
	// req_tech = list(TECH_MAGNET = 4, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 200, MAT_GLASS = 200, MAT_SILVER = 500, MAT_GOLD = 100)
	build_path = /obj/item/slime_grinder
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Xenoarch
/datum/design_techweb/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	// req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000,MAT_GLASS = 5000)
	build_path = /obj/item/ano_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	id = "xenoarch_multitool"
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/xenoarch_multi_tool
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PHORON = 500)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/excavationdrill
	name = "Excavation Drill"
	id = "excavationdrill"
	// req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/pickaxe/excavationdrill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/anobattery
	name = "Anomaly power battery - Basic"
	id = "anobattery-basic"
	// req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 4, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000)
	build_path = /obj/item/anobattery
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/anobattery_mid
	name = "Anomaly power battery - Moderate"
	id = "anobattery-moderate"
	// req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 2000) //Same object, different materials
	build_path = /obj/item/anobattery/moderate
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/anobattery_advanced
	name = "Anomaly power battery - Advanced"
	id = "anobattery-advanced"
	// req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_ENGINEERING = 5, TECH_BLUESPACE = 5, TECH_DATA = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2500, MAT_GLASS = 2500, MAT_SILVER = 2000, MAT_GOLD = 2500, MAT_PHORON = 2500)
	build_path = /obj/item/anobattery/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/anobattery_exotic
	name = "Anomaly power battery - Exotic"
	id = "anobattery-exotic"
	// req_tech = list(TECH_MATERIAL = 8, TECH_POWER = 7, TECH_ENGINEERING = 6, TECH_BLUESPACE = 6,  TECH_DATA = 6, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 1500, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_PHORON = 2000, MAT_DIAMOND = 2000, MAT_MORPHIUM = 2000)
	build_path = /obj/item/anobattery/exotic
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Precursor
/datum/design_techweb/precursorcrowbar
	name = "Hybrid Crowbar"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridcrowbar"
	// req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_GOLD = 250, MAT_URANIUM = 2500)
	build_path = /obj/item/tool/crowbar/hybrid
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/precursorwrench
	name = "Hybrid Wrench"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwrench"
	// req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_SILVER = 300, MAT_URANIUM = 2000)
	build_path = /obj/item/tool/wrench/hybrid
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/precursorscrewdriver
	name = "Hybrid Screwdriver"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridscrewdriver"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_DIAMOND = 2000)
	build_path = /obj/item/tool/screwdriver/hybrid
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/precursorwirecutters
	name = "Hybrid Wirecutters"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwirecutters"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_PHORON = 2, TECH_PRECURSOR = 1)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_PHORON = 2750, MAT_DIAMOND = 2000)
	build_path = /obj/item/tool/wirecutters/hybrid
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/precursorwelder
	name = "Hybrid Welding Tool"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwelder"
	// req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_MAGNET = 5, TECH_PRECURSOR = 1)
	build_type = PROTOLATHE
	materials = list(MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_METALHYDROGEN = 4750, MAT_URANIUM = 6000)
	build_path = /obj/item/weldingtool/experimental/hybrid
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/camotrap
	name = "Chameleon Trap"
	desc = "A self-miraging mechanical trap, capable of producing short bursts of electric current when triggered."
	id = "hunt_trap"
	// req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_PHORON = 2, TECH_ARCANE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_DURASTEEL = 3000, MAT_METALHYDROGEN = 1000, MAT_PHORON = 2000)
	build_path = /obj/item/beartrap/hunting
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/protean_reboot
	name = "Protean Reboot Programmer"
	id = "protean_reboot"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_PLASTEEL = 10000)
	build_path = /obj/item/protean_reboot
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/* Decided that we were not keen on this being able to be printed freely as we immediately saw undesirable behaviour
/datum/design_techweb/telekinetic_gloves
	name = "Kinesis Assistance Module"
	id = "tk_gloves"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 4)
	build_type = PROTOLATHE
	materials = list(MAT_VERDANTIUM = 1000, MAT_SILVER = 300, MAT_PLASTEEL = 1000)
	build_path = /obj/item/clothing/gloves/telekinetic
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
*/

/datum/design_techweb/mail_scanner
	name = "Mail Scanner"
	id = "mail_scanner"
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/mail_scanner
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/atmos_holosign
	name = "Atmos Holosign"
	id = "atmos_holosign"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/holosign_creator/combifan
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ATMOSPHERICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/confetti_cannon
	name = "Confetti Cannon"
	desc = "Stuff it with paper and shoot! You'll be a hit at every party."
	id = "confetti_cannon"
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/launcher/confetti_cannon
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE


/datum/design_techweb/floor_painter
	name = "Floor Painter"
	id = "floor_painter"
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 500)
	build_path = /obj/item/floor_painter
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/medical_holosign
	name = "Medical Holosign"
	id = "medical_holosign"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/holosign_creator/medical
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	id = "handcuffs"
	materials = list(MAT_STEEL = 625)
	build_path = /obj/item/handcuffs
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	id = "legcuffs"
	materials = list(MAT_STEEL = 625)
	build_path = /obj/item/handcuffs/legcuffs
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/legcuffs_fuzzy
	name = "fuzzy legcuffs"
	desc = "Use this to keep... 'prisoners' in line."
	id = "legcuffs_fuzzy"
	materials = list(MAT_STEEL = 625)
	build_path = /obj/item/handcuffs/legcuffs/fuzzy
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/kitchen_knife
	name = "kitchen knife"
	desc = "A general purpose " + JOB_CHEF + "'s knife."
	id = "kitchen_knife"
	materials = list(MAT_STEEL = 375)
	build_path = /obj/item/material/knife
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	id = "fork"
	materials = list(MAT_STEEL = 75)
	build_path = /obj/item/material/kitchen/utensil/fork
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/spoon
	name = "spoon"
	desc = "It's a spoon."
	id = "spoon"
	materials = list(MAT_STEEL = 75)
	build_path = /obj/item/material/kitchen/utensil/spoon
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/plastic_knife
	name = "plastic knife"
	desc = "A simple plastic knife."
	id = "plastic_knife"
	materials = list(MAT_PLASTIC = 375)
	build_path = /obj/item/material/knife/plastic
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/fork
	name = "plastic fork"
	desc = "It's a plastic fork. Sure is pointy."
	id = "plastic_fork"
	materials = list(MAT_PLASTIC = 75)
	build_path = /obj/item/material/kitchen/utensil/fork/plastic
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/spoon
	name = "plastic spoon"
	desc = "It's a plastic spoon."
	id = "plastic_spoon"
	materials = list(MAT_PLASTIC = 75)
	build_path = /obj/item/material/kitchen/utensil/spoon/plastic
	build_type = AUTOLATHE | PROTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE
