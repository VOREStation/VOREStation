// Medical Designs
/datum/design_techweb/pillbottle
	name = "Pill Bottle"
	id = "pillbottle"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_PLASTIC = 100, MAT_GLASS = 100)
	build_path = /obj/item/storage/pill_bottle
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/syringe
	name = "Syringe"
	id = "syringe"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = 190)
	build_path = /obj/item/reagent_containers/syringe
	category = list(
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
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
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 100, MAT_GLASS = 100)
	build_path = /obj/item/flashlight/pen
	category = list(
		RND_CATEGORY_INITIAL,
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
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

// Surgical devices
/datum/design_techweb/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500)
	build_path = /obj/item/surgical/scalpel/laser1
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/scalpel/laser2
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2000, MAT_GOLD = 1500)
	build_path = /obj/item/surgical/scalpel/laser3
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 750)
	build_path = /obj/item/surgical/scalpel/manager
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/saw_manager
	name = "Energetic Bone Diverter"
	desc = "A strange development following the I.M.S., this heavy tool can split and open, or close and shut, intentional holes in bones."
	id = "advanced_saw"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_DATA = 5)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 800, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_OSMIUM = 1000)
	build_path = /obj/item/surgical/circular_saw/manager
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/organ_ripper
	name = "Organ Ripper"
	desc = "A modern and horrifying take on an ancient practice, this tool is capable of rapidly removing an organ from a hopefully willing patient, without damaging it."
	id = "organ_ripper"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 8000, MAT_OSMIUM = 2500)
	build_path = /obj/item/surgical/scalpel/ripper
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/bone_clamp
	name = "Bone Clamp"
	desc = "A miracle of modern science, this tool rapidly knits together bone, without the need for bone gel."
	id = "bone_clamp"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/bone_clamp
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/medical_analyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	id = "medical_analyzer"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/healthanalyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/improved_analyzer
	name = "improved health analyzer"
	desc = "A prototype version of the regular health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels."
	id = "improved_analyzer"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 1500)
	build_path = /obj/item/healthanalyzer/improved
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/advanced_analyzer
	name = "advanced health analyzer"
	desc = "An even more advanced handheld health scanner, complete with a full biosign monitor and on-board radiation and neurological analysis suites."
	id = "advanced_analyzer"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 7, TECH_BIO = 7, TECH_DATA = 5)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 4000, MAT_SILVER = 3500, MAT_GOLD = 2500, MAT_DIAMOND = 1250)
	build_path = /obj/item/healthanalyzer/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/phasic_analyzer
	name = "phasic health analyzer"
	desc = "State of the art handheld health scanner, containing not only a full biosign monitor, on-board radiation, and neurological analysis suites, but also a chemical-analysis suite."
	id = "phasic_analyzer"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 4000, MAT_SILVER = 3500, MAT_GOLD = 2500, MAT_DIAMOND = 2500, MAT_PHORON = 1250)
	build_path = /obj/item/healthanalyzer/phasic
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/gene_scanner
	name = "Gene Scanner"
	id = "gene_scanner"
	build_type = PROTOLATHE
	// req_tech = list(TECH_DATA = 1, TECH_BIO = 2)
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)
	build_path = /obj/item/gene_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/advanced_roller
	name = "advanced roller bed"
	desc = "A more advanced version of the regular roller bed, with inbuilt surgical stabilisers and an improved folding system."
	id = "roller_bed"
	build_type = PROTOLATHE
	// req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/roller/adv
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/sleevemate
	name = "SleeveMate 3700"
	id = "sleevemate"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/sleevemate
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/protohypospray
	name = "prototype hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 1500, MAT_SILVER = 2000, MAT_GOLD = 1500, MAT_URANIUM = 1000)
	build_path = /obj/item/reagent_containers/hypospray/science
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/syringe_gun
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, designed to incapacitate unruly patients from a distance."
	id = "syringe_gun"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/gun/launcher/syringe
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/syringe_cartridge
	name = "syringe gun cartridge"
	desc = "An impact-triggered compressed gas cartridge that can be fitted to a syringe for rapid injection."
	id = "syringe_cartridge"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 150, MAT_GLASS = 500)
	build_path = /obj/item/syringe_cartridge
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
