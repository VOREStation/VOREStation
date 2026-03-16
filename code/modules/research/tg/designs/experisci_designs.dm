/datum/design_techweb/experi_scanner
	name = "Experimental Scanner"
	desc = "Experimental scanning unit used for performing scanning experiments."
	id = "experi_scanner"
	build_type = PROTOLATHE
	materials = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/experi_scanner
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
