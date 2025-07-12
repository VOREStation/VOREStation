/datum/design_techweb/board/aicore
	name = "AI core circuit"
	id = "aicore"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/mmi
	name = "Man-machine interface"
	id = "mmi"
	// req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | PROSFAB
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/mmi
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/posibrain
	name = "Positronic brain"
	id = "posibrain"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_PHORON = 500, MAT_DIAMOND = 100)
	build_path = /obj/item/mmi/digital/posibrain
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/dronebrain
	name = "Robotic intelligence circuit"
	id = "dronebrain"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500)
	build_path = /obj/item/mmi/digital/robot
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	build_type = PROTOLATHE
	// req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/paicard
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/intellicard
	name = "intelliCore"
	desc = "Allows for the construction of an intelliCore."
	id = "intellicore"
	build_type = PROTOLATHE
	// req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/aicard
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
