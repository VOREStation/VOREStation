// Bags of holding

/datum/design/item/boh/AssembleDesignName()
	..()
	name = "Infinite capacity storage prototype ([item_name])"

/datum/design/item/boh/ore_holding
	name = "Mining Satchel of Holding"
	desc = "For the most tenacious miners, a bag with incomprehensible depth!"
	id = "ore_holding"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3)
	materials = list(MAT_GOLD = 1000, MAT_DIAMOND = 500, MAT_URANIUM = 250) // Less expensive since it can only hold ores
	build_path = /obj/item/weapon/storage/bag/ore/holding
	sort_string = "QAAAA"

/datum/design/item/boh/bag_holding
	name = "Bag of Holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "QAAAA"

/datum/design/item/boh/dufflebag_holding
	name = "DuffleBag of Holding"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dufflebag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/weapon/storage/backpack/holding/duffle
	sort_string = "QAAAB"

/datum/design/item/boh/trashbag_holding
	name = "Trashbag of Holding"
	desc = "Considerably more utilitarian than the Bag of Holding, the Trashbag of Holding is a janitor's best friend."
	id = "trashbag_holding"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	materials = list("gold" = 2000, "diamond" = 1000, "uranium" = 250)
	build_path = /obj/item/weapon/storage/bag/trash/holding
	sort_string = "QAAAC"

/datum/design/item/boh/pouch_holding
	name = "Pouch of Holding"
	desc = "Somehow compresses the storage of a backpack into a pouch-sized container!"
	id = "pouch_holding"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	materials = list("gold" = 3000, "diamond" = 2000, "uranium" = 250)
	build_path = /obj/item/weapon/storage/pouch/holding
	sort_string = "QAAAD"
	

/datum/design/item/boh/belt_holding_med
	name = "Medical Belt of Holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	id = "belt_holding_med"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 2000, "titanium" = 500)
	build_path = /obj/item/weapon/storage/belt/medical/holding
	sort_string = "QAAAE"

/datum/design/item/boh/belt_holding_utility
	name = "Tool-Belt of Holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	id = "belt_holding_utility"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 2000, "titanium" = 500)
	build_path = /obj/item/weapon/storage/belt/utility/holding
	sort_string = "QAAAF"
	