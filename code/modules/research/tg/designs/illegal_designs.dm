/datum/design_techweb/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	// req_tech = list(TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.15), MAT_GLASS = MATERIAL_COST(0.15))
	build_path = /obj/item/encryptionkey/binary
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	// req_tech = list(TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.25))
	build_path = /obj/item/storage/box/syndie_kit/chameleon
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/clerical
	name = "clerical equipment kit"
	desc = "A kit of clerical equipment with a pen and stamp that can change appearance and color."
	id = "clerical"
	// req_tech = list(TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.25))
	build_path = /obj/item/storage/box/syndie_kit/clerical
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	// req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(2), MAT_GLASS = MATERIAL_COST(2), MAT_URANIUM = MATERIAL_COST(1))
	build_path = /obj/item/bodysnatcher
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/electropack
	name = "electropack"
	desc = "Dance my monkeys! DANCE!!!"
	id = "electropack"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(6.25), MAT_GLASS = MATERIAL_COST(1.5625))
	build_path = /obj/item/radio/electropack
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
