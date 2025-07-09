/datum/design_techweb/basic
	name = "Basic Cell"
	desc = "A basic tier 1 power cell."
	id = "basic_cell"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
