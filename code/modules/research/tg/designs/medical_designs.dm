// Medical Designs
/datum/design_techweb/pillbottle
	name = "Pill Bottle"
	id = "pillbottle"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_PLASTIC = 100, MAT_GLASS = 100)
	build_path = /obj/item/storage/pill_bottle
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/syringe
	name = "Syringe"
	id = "syringe"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 100, MAT_GLASS = 500)
	build_path = /obj/item/reagent_containers/syringe
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/dropper
	name = "Dropper"
	id = "dropper"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = 100, MAT_PLASTIC = 500)
	build_path = /obj/item/reagent_containers/dropper
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel
	name = "Scalpel"
	id = "scalpel"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/surgical/scalpel
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/circular_saw
	name = "Circular Saw"
	id = "circular_saw"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/surgical/circular_saw
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/bonesetter
	name = "Bonesetter"
	id = "bonesetter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 1000,  MAT_GLASS = 1000)
	build_path = /obj/item/surgical/bonesetter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/surgicaldrill
	name = "Surgical Drill"
	id = "surgicaldrill"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/surgical/surgicaldrill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/retractor
	name = "Retractor"
	id = "retractor"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/surgical/retractor
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/cautery
	name = "Cautery"
	id = "cautery"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/surgical/cautery
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hemostat
	name = "Hemostat"
	id = "hemostat"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/surgical/hemostat
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/defibrillator
	name = "Defibrillator"
	desc = "A portable defibrillator, used for resuscitating recently deceased crew."
	id = "defibrillator"
	build_type = PROTOLATHE
	build_path = /obj/item/defib_kit
	materials = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT * 4, MAT_GLASS = SHEET_MATERIAL_AMOUNT * 2, MAT_SILVER =SHEET_MATERIAL_AMOUNT * 1.5, MAT_GOLD = SHEET_MATERIAL_AMOUNT * 0.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/penlight
	name = "Penlight"
	id = "penlight"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 100, MAT_GLASS = 100)
	build_path = /obj/item/flashlight/pen
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/implanter
	name = "Implanter"
	id = "implanter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/implanter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
