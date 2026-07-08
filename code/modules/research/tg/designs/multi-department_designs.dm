/datum/design_techweb/beaker
	name = "Beaker"
	id = "beaker"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.25))
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	build_path = /obj/item/reagent_containers/glass/beaker
	departmental_flags = ALL

/datum/design_techweb/large_beaker
	name = "Large Beaker"
	id = "large_beaker"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.5))
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	build_path = /obj/item/reagent_containers/glass/beaker/large
	departmental_flags = ALL

/datum/design_techweb/vial
	name = "Vial"
	id = "vial"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.05))
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	build_path = /obj/item/reagent_containers/glass/beaker/vial
	departmental_flags = ALL
