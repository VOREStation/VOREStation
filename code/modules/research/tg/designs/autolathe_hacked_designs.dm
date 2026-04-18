/// Special unlocks for autolathe, usually more expensive versions of other designs, but from roundstart
/datum/design_techweb/rapidpipedispenser_hacked
	name = "Rapid Pipe Dispenser"
	desc = "A counterpart to the rapid construction device that allows creating and placing atmospheric and disposal pipes."
	id = "rapidpipedispenser_hacked"
	build_type = AUTOLATHE
	materials = list(MAT_STEEL = 22000, MAT_GLASS = 18000)
	build_path = /obj/item/pipe_dispenser
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/rcd_loaded_hacked
	name = "rapid construction device"
	desc = "A device used to rapidly build and deconstruct. Reload with compressed matter cartridges."
	id = "rcd_loaded_hacked"
	materials = list(MAT_STEEL = 110000)
	build_path = /obj/item/rcd
	build_type = AUTOLATHE
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
