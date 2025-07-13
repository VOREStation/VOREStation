// PDA

/datum/design_techweb/general/pda
	name = "PDA"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	// req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/pda
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

// Cartridges

/datum/design_techweb/pda_cartridge
	// req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

/datum/design_techweb/pda_cartridge/New()
	. = ..()

	var/obj/object_build_item_path = build_path
	name = "PDA accessory ([initial(object_build_item_path.name)])"

/datum/design_techweb/pda_cartridge/cart_basic
	id = "cart_basic"
	build_path = /obj/item/cartridge

/datum/design_techweb/pda_cartridge/engineering
	id = "cart_engineering"
	build_path = /obj/item/cartridge/engineering

/datum/design_techweb/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/cartridge/atmos

/datum/design_techweb/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/cartridge/medical

/datum/design_techweb/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/cartridge/chemistry

/datum/design_techweb/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/cartridge/security

/datum/design_techweb/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/cartridge/janitor

/datum/design_techweb/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/cartridge/signal/science

/datum/design_techweb/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/cartridge/quartermaster

/datum/design_techweb/pda_cartridge/head
	id = "cart_head"
	build_path = /obj/item/cartridge/head

/datum/design_techweb/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/cartridge/hop

/datum/design_techweb/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/cartridge/hos

/datum/design_techweb/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/cartridge/ce

/datum/design_techweb/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/cartridge/cmo

/datum/design_techweb/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/cartridge/rd

/datum/design_techweb/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/cartridge/captain

/datum/design_techweb/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	// req_tech = list(TECH_DATA = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/disk/design_disk
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)

/datum/design_techweb/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	// req_tech = list(TECH_DATA = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/disk/tech_disk
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
