/datum/design_techweb/implant
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design_techweb/implant/backup
	name = "Backup implant"
	id = "implant_backup"
	// req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/implantcase/backup
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/implant/sizecontrol
	name = "Size control implant"
	id = "implant_size"
	// req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/implanter/sizecontrol
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/implant/chemical
	name = "Chemical Implant"
	id = "implant_chem"
	// req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/implantcase/chem
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/implant/freedom
	name = "Freedom Implant"
	id = "implant_free"
	// req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/implantcase/freedom
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/hand
	name = "Resonant Analyzer Implant"
	desc = "An augment that fits neatly into the hand, useful for determining the usefulness of an object for research."
	id = "research_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/organ/internal/augment/armmounted/hand
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/shoulder/multiple
	name = "Rotary Toolkit Implant"
	desc = "A large implant that fits into a subject's arm. It deploys an array of tools by some painful means."
	id = "tool_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/shoulder/multiple/medical
	name = "Rotary Medical Kit Implant"
	desc = "A large implant that fits into a subject's arm. It deploys an array of tools by some painful means."
	id = "surgical_implant"
	// req_tech = list(TECH_BIO = 6, TECH_MATERIAL = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple/medical
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/hand/blade
	name = "Handblade Implant"
	desc = "A large implant that fits into a subject's hand. It deploys a bladed weapon."
	id = "blade_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/hand/blade
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/shoulder/blade
	name = "Armblade Implant"
	desc = "A large implant that fits into a subject's arm. It deploys a large, bladed weapon."
	id = "armblade_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 5, TECH_COMBAT = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000, MAT_GOLD = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/blade
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/hand/sword
	name = "Energy Blade Implant"
	desc = "A large implant that fits into a subject's hand. It deploys a large, energetic weapon."
	id = "sword_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 5, TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000, MAT_GOLD = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/hand/sword
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/dartbow
	name = "Crossbow Implant"
	desc = "A large implant that fits into a subject's arm. It creates a dartbow when activated."
	id = "dartbow_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_ILLEGAL = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_PHORON = 4000, MAT_GOLD = 4000, MAT_DIAMOND = 6000)
	build_path = /obj/item/organ/internal/augment/armmounted/dartbow
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/taser
	name = "Taser Implant"
	desc = "A large implant that fits into a subject's arm. It turns into a taser when activated."
	id = "taser_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/taser
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/laser
	name = "Laser Implant"
	desc = "A large implant that fits into a subject's arm. It turns into a laser when activated."
	id = "laser_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_GOLD = 4000, MAT_DIAMOND = 4000, MAT_PHORON = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/organ/internal/augment/armmounted/shoulder/surge
	name = "Surge Implant"
	desc = "A large implant that fits into a subject's arm. It floods the subject with stimulants to speed them up."
	id = "surge_implant"
	// req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_POWER = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_PHORON = 1000, MAT_GOLD = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/surge
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/internal/augment/bioaugment/thermalshades
	name = "Thermal Shadess Implant"
	desc = "A large implant that fits into a subject's eyes. It allows them to see through walls."
	id = "thermal_implant"
	// req_tech = list(TECH_BIO = 7, TECH_MATERIAL = 4, TECH_POWER = 7, TECH_ENGINEERING = 7, TECH_COMBAT = 5, TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_PHORON = 10000, MAT_GOLD = 2000, MAT_DIAMOND = 10000, MAT_SILVER = 4000, MAT_TITANIUM = 1000) //this is thermals. this is expensive, yo.
	build_path = /obj/item/organ/internal/augment/bioaugment/thermalshades
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
