/datum/design_techweb/sizegun
	name = "Size Gun"
	id = "sizegun"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/gun/energy/sizegun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)

/datum/design_techweb/sizegun_gradual
	name = "Gradual Size Gun"
	id = "gradsizegun"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/slow_sizegun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
