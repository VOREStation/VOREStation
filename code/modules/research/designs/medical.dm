/datum/design/item/medical
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Medical equipment prototype ([item_name])"

// Surgical devices

/datum/design/item/medical/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500)
	build_path = /obj/item/surgical/scalpel/laser1
	sort_string = "KAAAA"

/datum/design/item/medical/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/scalpel/laser2
	sort_string = "KAAAB"

/datum/design/item/medical/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2000, MAT_GOLD = 1500)
	build_path = /obj/item/surgical/scalpel/laser3
	sort_string = "KAAAC"

/datum/design/item/medical/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 750)
	build_path = /obj/item/surgical/scalpel/manager
	sort_string = "KAAAD"

/datum/design/item/medical/saw_manager
	name = "Energetic Bone Diverter"
	desc = "A strange development following the I.M.S., this heavy tool can split and open, or close and shut, intentional holes in bones."
	id = "advanced_saw"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_DATA = 5)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 800, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_OSMIUM = 1000)
	build_path = /obj/item/surgical/circular_saw/manager
	sort_string = "KAAAE"

/datum/design/item/medical/organ_ripper
	name = "Organ Ripper"
	desc = "A modern and horrifying take on an ancient practice, this tool is capable of rapidly removing an organ from a hopefully willing patient, without damaging it."
	id = "organ_ripper"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 8000, MAT_OSMIUM = 2500)
	build_path = /obj/item/surgical/scalpel/ripper
	sort_string = "KAAAF"

/datum/design/item/medical/bone_clamp
	name = "Bone Clamp"
	desc = "A miracle of modern science, this tool rapidly knits together bone, without the need for bone gel."
	id = "bone_clamp"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/bone_clamp
	sort_string = "KAABA"

/datum/design/item/medical/medical_analyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	id = "medical_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/healthanalyzer
	sort_string = "KBAAA"

/datum/design/item/medical/improved_analyzer
	name = "improved health analyzer"
	desc = "A prototype version of the regular health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels."
	id = "improved_analyzer"
	req_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 1500)
	build_path = /obj/item/healthanalyzer/improved
	sort_string = "KBAAB"

/datum/design/item/medical/advanced_roller
	name = "advanced roller bed"
	desc = "A more advanced version of the regular roller bed, with inbuilt surgical stabilisers and an improved folding system."
	id = "roller_bed"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/roller/adv
	sort_string = "KCAAA"
