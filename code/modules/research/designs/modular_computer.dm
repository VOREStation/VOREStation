// Modular computer components
/datum/design/item/modularcomponent/AssembleDesignName()
	..()
	name = "Computer part design ([item_name])"

// Hard drives

/datum/design/item/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/
=======
	materials = list(MAT_STEEL = 2000, "glass" = 100)
	build_path = /obj/item/computer_hardware/hard_drive/
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VAAAA"

/datum/design/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
<<<<<<< HEAD
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced
=======
	materials = list(MAT_STEEL = 4000, "glass" = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VAAAB"

/datum/design/item/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 400)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super
=======
	materials = list(MAT_STEEL = 8000, "glass" = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VAAAC"

/datum/design/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 16000, MAT_GLASS = 800)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster
=======
	materials = list(MAT_STEEL = 16000, "glass" = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VAAAD"

/datum/design/item/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small
=======
	materials = list(MAT_STEEL = 4000, "glass" = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VAAAE"

/datum/design/item/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro
=======
	materials = list(MAT_STEEL = 2000, "glass" = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VAAAF"

// Network cards

/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 500, MAT_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/network_card
=======
	materials = list(MAT_STEEL = 500, "glass" = 100)
	build_path = /obj/item/computer_hardware/network_card
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VBAAA"

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced
=======
	materials = list(MAT_STEEL = 1000, "glass" = 200)
	build_path = /obj/item/computer_hardware/network_card/advanced
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VBAAB"

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 400)
	build_path = /obj/item/weapon/computer_hardware/network_card/wired
=======
	materials = list(MAT_STEEL = 5000, "glass" = 400)
	build_path = /obj/item/computer_hardware/network_card/wired
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VBAAC"

// Batteries

/datum/design/item/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module
	sort_string = "VCAAA"

/datum/design/item/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/advanced
	sort_string = "VCAAB"

/datum/design/item/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/battery_module/super
	sort_string = "VCAAC"

/datum/design/item/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000)
	build_path = /obj/item/computer_hardware/battery_module/ultra
	sort_string = "VCAAD"

/datum/design/item/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module/nano
	sort_string = "VCAAE"

/datum/design/item/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/micro
	sort_string = "VCAAF"

// Processor unit

/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/processor_unit
	sort_string = "VDAAA"

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/small
	sort_string = "VDAAB"

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 32000, glass = 8000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic
	sort_string = "VDAAC"

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 16000, glass = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small
	sort_string = "VDAAD"

// Other parts

/datum/design/item/modularcomponent/cardslot
	name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/card_slot
	sort_string = "VEAAA"

/datum/design/item/modularcomponent/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/nano_printer
	sort_string = "VEAAB"

/datum/design/item/modularcomponent/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/computer_hardware/tesla_link
	sort_string = "VEAAC"

// Data crystals (USB flash drives)

/datum/design/item/modularcomponent/portabledrive/AssembleDesignName()
	..()
	name = "Portable data drive design ([item_name])"

/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
<<<<<<< HEAD
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable
=======
	materials = list("glass" = 8000)
	build_path = /obj/item/computer_hardware/hard_drive/portable
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VFAAA"

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
<<<<<<< HEAD
	materials = list(MAT_GLASS = 16000)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced
=======
	materials = list("glass" = 16000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VFAAB"

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
<<<<<<< HEAD
	materials = list(MAT_GLASS = 32000)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/super
=======
	materials = list("glass" = 32000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "VFAAC"
