// Implants

/datum/design/item/implant
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/item/implant/chemical
	name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem
	sort_string = "MFAAA"

/datum/design/item/implant/freedom
	name = "freedom"
	id = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom
	sort_string = "MFAAB"

/datum/design/item/organ/internal/augment/armmounted/hand
	desc = "An augment that fits neatly into the hand, useful for determining the usefulness of an object for research."
	id = "research_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/organ/internal/augment/armmounted/hand
	sort_string = "JVACE"


/datum/design/item/organ/internal/augment/armmounted/shoulder/multiple
	desc = "A large implant that fits into a subject's arm. It deploys an array of tools by some painful means."
	id = "tool_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple
	sort_string = "JVACI"

/datum/design/item/organ/internal/augment/armmounted/shoulder/multiple/medical
	desc = "A large implant that fits into a subject's arm. It deploys an array of tools by some painful means."
	id = "surgical_implant"
	req_tech = list(TECH_BIO = 6, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple/medical
	sort_string = "JVACJ"


/datum/design/item/organ/internal/augment/armmounted/hand/blade
	desc = "A large implant that fits into a subject's hand. It deploys a bladed weapon."
	id = "blade_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/hand/blade
	sort_string = "JVACK"

/datum/design/item/organ/internal/augment/armmounted/shoulder/blade
	desc = "A large implant that fits into a subject's arm. It deploys a large, bladed weapon."
	id = "armblade_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 5, TECH_COMBAT = 6)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000, MAT_GOLD = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/blade
	sort_string = "JVACL"

/datum/design/item/organ/internal/augment/armmounted/hand/sword
	desc = "A large implant that fits into a subject's hand. It deploys a large, energetic weapon."
	id = "sword_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 5, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 1000, MAT_GOLD = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/hand/sword
	sort_string = "JVACM"

/datum/design/item/organ/internal/augment/armmounted/dartbow
	desc = "A large implant that fits into a subject's arm. It creates a dartbow when activated."
	id = "dartbow_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_PHORON = 4000, MAT_GOLD = 4000, MAT_DIAMOND = 6000)
	build_path = /obj/item/organ/internal/augment/armmounted/dartbow
	sort_string = "JVACN"

/datum/design/item/organ/internal/augment/armmounted/taser
	desc = "A large implant that fits into a subject's arm. It turns into a taser when activated."
	id = "taser_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/taser
	sort_string = "JVACO"

/datum/design/item/organ/internal/augment/armmounted/laser
	desc = "A large implant that fits into a subject's arm. It turns into a laser when activated."
	id = "laser_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_COMBAT = 6)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 6000, MAT_GOLD = 4000, MAT_DIAMOND = 4000, MAT_PHORON = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted
	sort_string = "JVACP"

/datum/design/item/organ/internal/augment/armmounted/shoulder/surge
	desc = "A large implant that fits into a subject's arm. It floods the subject with stimulants to speed them up."
	id = "surge_implant"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_PHORON = 1000, MAT_GOLD = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/surge
	sort_string = "JVACQ"

/datum/design/item/internal/augment/bioaugment/thermalshades
	desc = "A large implant that fits into a subject's eyes. It allows them to see through walls."
	id = "thermal_implant"
	req_tech = list(TECH_BIO = 7, TECH_MATERIAL = 4, TECH_POWER = 7, TECH_ENGINEERING = 7, TECH_COMBAT = 5, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_PHORON = 10000, MAT_GOLD = 2000, MAT_DIAMOND = 10000, MAT_SILVER = 4000, MAT_TITANIUM = 1000) //this is thermals. this is expensive, yo.
	build_path = /obj/item/organ/internal/augment/bioaugment/thermalshades
	sort_string = "JVACR"
