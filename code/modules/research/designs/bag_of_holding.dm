// Bags of holding

/datum/design/item/boh/AssembleDesignName()
	..()
	name = "Infinite capacity storage prototype ([item_name])"

/datum/design/item/boh/ore_holding
	name = "Mining Satchel of Holding"
	desc = "For the most tenacious miners, a bag with incomprehensible depth!"
	id = "ore_holding"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3)
	materials = list("gold" = 1000, "diamond" = 500, "uranium" = 250) // Less expensive since it can only hold ores
	build_path = /obj/item/weapon/storage/bag/ore/holding
	sort_string = "QAAAA"

/datum/design/item/boh/bag_holding
	name = "Bag of Holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "QAAAA"

/datum/design/item/boh/dufflebag_holding
	name = "DuffleBag of Holding"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dufflebag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/weapon/storage/backpack/holding/duffle
	sort_string = "QAAAB"