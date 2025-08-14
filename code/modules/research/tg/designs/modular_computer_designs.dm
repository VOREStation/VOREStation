// Hard drives

/datum/design_techweb/modularcomponent
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_MODULAR_COMPUTERS + RND_SUBCATEGORY_MODULAR_COMPUTERS_PARTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ASSISTANT

/datum/design_techweb/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	// req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/

/datum/design_techweb/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced

/datum/design_techweb/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super

/datum/design_techweb/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000, MAT_GLASS = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster

/datum/design_techweb/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small

/datum/design_techweb/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	// req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro

// Network cards

/datum/design_techweb/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/network_card

/datum/design_techweb/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/network_card/advanced

/datum/design_techweb/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	// req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 400)
	build_path = /obj/item/computer_hardware/network_card/wired

// Batteries

/datum/design_techweb/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	// req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module

/datum/design_techweb/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	// req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/advanced

/datum/design_techweb/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	// req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/battery_module/super

/datum/design_techweb/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	// req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000)
	build_path = /obj/item/computer_hardware/battery_module/ultra

/datum/design_techweb/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	// req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module/nano

/datum/design_techweb/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	// req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/micro

// Processor unit

/datum/design_techweb/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/processor_unit

/datum/design_techweb/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/small

/datum/design_techweb/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	// req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 32000, glass = 8000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic

/datum/design_techweb/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 16000, glass = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small

// Other parts

/datum/design_techweb/modularcomponent/cardslot
	name = "RFID card slot"
	id = "cardslot"
	// req_tech = list(TECH_DATA = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/card_slot

/datum/design_techweb/modularcomponent/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/nano_printer

/datum/design_techweb/modularcomponent/teslalink
	name = "tesla link"
	id = "teslalink"
	// req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/computer_hardware/tesla_link

// Data crystals (USB flash drives)
/datum/design_techweb/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	// req_tech = list(TECH_DATA = 1)
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/computer_hardware/hard_drive/portable

/datum/design_techweb/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	// req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 16000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced

/datum/design_techweb/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	// req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 32000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
