// Bags of holding

/datum/design/item/boh/AssembleDesignName()
	..()
	name = "Infinite capacity storage prototype ([item_name])"

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

/datum/design/item/boh/bag_holding
	name = "Trashbag of Holding"
	desc = "Considerably more utilitarian than the Bag of Holding, the Trashbag of Holding is a janitor's best friend."
	id = "trashbag_holding"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	materials = list("gold" = 2000, "diamond" = 1000, "uranium" = 250)
	build_path = /obj/item/weapon/storage/bag/trash/holding
	sort_string = "QAAAC"