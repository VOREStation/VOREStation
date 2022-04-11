// Telecomm parts

/datum/design/item/stock_part/subspace/AssembleDesignName()
	..()
	name = "Subspace component design ([item_name])"

/datum/design/item/stock_part/subspace/subspace_ansible
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 80, MAT_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "RAAAA"

/datum/design/item/stock_part/subspace/hyperwave_filter
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 40, MAT_SILVER = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/sub_filter
	sort_string = "RAAAB"

/datum/design/item/stock_part/subspace/subspace_amplifier
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_GOLD = 30, MAT_URANIUM = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "RAAAC"

/datum/design/item/stock_part/subspace/subspace_treatment
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "RAAAD"

/datum/design/item/stock_part/subspace/subspace_analyzer
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_GOLD = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "RAAAE"

/datum/design/item/stock_part/subspace/subspace_crystal
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_GLASS = 1000, MAT_SILVER = 20, MAT_GOLD = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "RAAAF"

/datum/design/item/stock_part/subspace/subspace_transmitter
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list(MAT_GLASS = 100, MAT_SILVER = 10, MAT_URANIUM = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "RAAAG"