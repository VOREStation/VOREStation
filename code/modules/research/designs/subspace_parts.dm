// Telecomm parts

/datum/design/item/stock_part/subspace/AssembleDesignName()
	..()
	name = "Subspace component design ([item_name])"

/datum/design/item/stock_part/subspace/subspace_ansible
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 80, "silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "RAAAA"

/datum/design/item/stock_part/subspace/hyperwave_filter
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 40, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/sub_filter
	sort_string = "RAAAB"

/datum/design/item/stock_part/subspace/subspace_amplifier
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "gold" = 30, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "RAAAC"

/datum/design/item/stock_part/subspace/subspace_treatment
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "RAAAD"

/datum/design/item/stock_part/subspace/subspace_analyzer
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "gold" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "RAAAE"

/datum/design/item/stock_part/subspace/subspace_crystal
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("glass" = 1000, "silver" = 20, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "RAAAF"

/datum/design/item/stock_part/subspace/subspace_transmitter
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list("glass" = 100, "silver" = 10, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "RAAAG"