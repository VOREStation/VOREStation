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
