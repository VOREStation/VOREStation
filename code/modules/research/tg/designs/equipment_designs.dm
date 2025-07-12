/datum/design_techweb/bluespace_bracelet
	name = "Size Standardization Bracelet"
	id = "bluespacebracelet"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/clothing/gloves/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/deluxe_bluespace_bracelet
	name = "Deluxe Size Standardization Bracelet"
	id = "deluxebluespacebracelet"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/clothing/gloves/bluespace/deluxe
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/bluespace_collar
	name = "Bluespace Collar"
	id = "bluespacecollar"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/clothing/accessory/collar/shock/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/hyperfiber_jumpsuit
	name = "HYPER jumpsuit"
	id = "hfjumpsuit"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/under/hyperfiber
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/bluespace_jumpsuit
	name = "Bluespace Jumpsuit"
	id = "bluespace_jumpsuit"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/clothing/under/hyperfiber/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/ore_holding
	name = "Mining Satchel of Holding"
	desc = "For the most tenacious miners, a bag with incomprehensible depth!"
	id = "ore_holding"
	// req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 1000, MAT_DIAMOND = 500, MAT_URANIUM = 250) // Less expensive since it can only hold ores
	build_path = /obj/item/storage/bag/ore/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/sheet_holding
	name = "Sheet Snatcher of Holding"
	desc = "For those who really hate walking up and down the stairs more than once!"
	id = "sheet_holding"
	// req_tech = list(TECH_BLUESPACE = 1, TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 300, MAT_DIAMOND = 200, MAT_URANIUM = 150) // Even less expensive because it has a more limited use
	build_path = /obj/item/storage/bag/sheetsnatcher/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/bag_holding
	name = "Bag of Holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/dufflebag_holding
	name = "DuffleBag of Holding"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dufflebag_holding"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding/duffle
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/trashbag_holding
	name = "Trashbag of Holding"
	desc = "Considerably more utilitarian than the Bag of Holding, the Trashbag of Holding is a janitor's best friend."
	id = "trashbag_holding"
	// req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 2000, MAT_DIAMOND = 1000, MAT_URANIUM = 250)
	build_path = /obj/item/storage/bag/trash/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/pouch_holding
	name = "Pouch of Holding"
	desc = "Somehow compresses the storage of a backpack into a pouch-sized container!"
	id = "pouch_holding"
	// req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 2000, MAT_URANIUM = 250)
	build_path = /obj/item/storage/pouch/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)


/datum/design_techweb/belt_holding_med
	name = "Medical Belt of Holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	id = "belt_holding_med"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 2000, MAT_TITANIUM = 500)
	build_path = /obj/item/storage/belt/medical/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)

/datum/design_techweb/belt_holding_utility
	name = "Tool-Belt of Holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	id = "belt_holding_utility"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 2000, MAT_TITANIUM = 500)
	build_path = /obj/item/storage/belt/utility/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
