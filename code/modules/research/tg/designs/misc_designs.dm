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
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/cartridge/atmos
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/cartridge/medical
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/cartridge/chemistry
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/cartridge/security
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/cartridge/janitor
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/cartridge/signal/science
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/cartridge/quartermaster
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/head
	id = "cart_head"
	build_path = /obj/item/cartridge/head
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/cartridge/hop
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/cartridge/hos
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/cartridge/ce
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/cartridge/cmo
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/cartridge/rd
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/cartridge/captain
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

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
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/disk/botany
	name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	id = "disk_botany"
	// req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10, MAT_URANIUM = 5)
	build_path = /obj/item/disk/botany
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/borgos
	name = "Borg-O's Recipe"
	desc = "A recipe for the cult classic Borg-O's meal. Warning: Not suitable for organic consumption."
	id = "borgos1"
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/trash/rkibble
	build_type = PROTOLATHE //I...I guess???
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/shelter_capsule
	name = "Bluespace Shelter Capsule (5x5)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 25000, MAT_TITANIUM = 2500, MAT_DURASTEEL = 1000, MAT_DIAMOND = 200, MAT_URANIUM = 500)
	build_path = /obj/item/survivalcapsule
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_luxury
	name = "Bluespace Shelter Capsule - Luxury (7x7)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_luxury"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 35000, MAT_GLASS = 35000, MAT_TITANIUM = 5000, MAT_DURASTEEL = 2500, MAT_DIAMOND = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/survivalcapsule/luxury
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_sauna
	name = "Bluespace Shelter Capsule - Sauna (7x7)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_sauna"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 35000, MAT_GLASS = 35000, MAT_TITANIUM = 5000, MAT_DURASTEEL = 5000, MAT_DIAMOND = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/survivalcapsule/sauna
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_luxuryalt
	name = "Bluespace Shelter Capsule - Alt. Luxury (7x7)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_luxuryalt"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 35000, MAT_GLASS = 35000, MAT_TITANIUM = 5000, MAT_DURASTEEL = 5000, MAT_DIAMOND = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/survivalcapsule/luxuryalt
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_kitchen
	name = "Bluespace Shelter Capsule - Kitchen (7x7)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_kitchen"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 35000, MAT_GLASS = 35000, MAT_TITANIUM = 5000, MAT_DURASTEEL = 5000, MAT_DIAMOND = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/survivalcapsule/kitchen
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_pocketdorm
	name = "Bluespace Shelter Capsule - Pocket Dorm (5x5)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_pocketdorm"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 25000, MAT_TITANIUM = 2500, MAT_DURASTEEL = 1000, MAT_DIAMOND = 200, MAT_URANIUM = 500)
	build_path = /obj/item/survivalcapsule/pocketdorm
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_recroom
	name = "Bluespace Shelter Capsule - Rec Room + Cards Table (9x9)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_recroom"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 40000, MAT_GLASS = 40000, MAT_TITANIUM = 5000, MAT_DURASTEEL = 2500, MAT_DIAMOND = 500, MAT_URANIUM = 1000)
	build_path = /obj/item/survivalcapsule/recroom
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_luxurybar
	name = "Bluespace Shelter Capsule - Luxury Bar (11x11)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_luxurybar"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50000, MAT_GLASS = 50000, MAT_TITANIUM = 6000, MAT_DURASTEEL = 3000, MAT_DIAMOND = 750, MAT_URANIUM = 1500) // These are 11x11 rooms in a pocket. They NEED to be expensive!
	build_path = /obj/item/survivalcapsule/luxurybar
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_luxurycabin
	name = "Bluespace Shelter Capsule - Luxury Cabin (11x11)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_luxurycabin"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50000, MAT_GLASS = 50000, MAT_TITANIUM = 6000, MAT_DURASTEEL = 3000, MAT_DIAMOND = 750, MAT_URANIUM = 1500) // These are 11x11 rooms in a pocket. They NEED to be expensive!
	build_path = /obj/item/survivalcapsule/luxurycabin
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_cafe
	name = "Bluespace Shelter Capsule - Cafe (11x11)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_cafe"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50000, MAT_GLASS = 50000, MAT_TITANIUM = 6000, MAT_DURASTEEL = 3000, MAT_DIAMOND = 750, MAT_URANIUM = 1500) // These are 11x11 rooms in a pocket. They NEED to be expensive!
	build_path = /obj/item/survivalcapsule/cafe
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/shelter_capsule_luxuryrecroom
	name = "Bluespace Shelter Capsule - Luxury Rec Room (11x11)"
	desc = "A capsule filled with pre-programmed nanites that can generate a small, fully atmosphere-protected shelter in seconds. Do not put in mouth."
	id = "shelter_capsule_luxuryrecroom"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50000, MAT_GLASS = 50000, MAT_TITANIUM = 6000, MAT_DURASTEEL = 3000, MAT_DIAMOND = 750, MAT_URANIUM = 1500) // These are 11x11 rooms in a pocket. They NEED to be expensive!
	build_path = /obj/item/survivalcapsule/luxuryrecroom
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/anomaly_neutralizer
	name = "Anomaly Neutralizer"
	desc = "An advanced tool capable of instantly neutralizing anomalies, designed to capture the fleeting aberrations created by the engine."
	id = "anomaly_neutralizer"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_GOLD = SHEET_MATERIAL_AMOUNT, MAT_PHORON = SHEET_MATERIAL_AMOUNT * 2.5, MAT_URANIUM = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/anomaly_neutralizer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/anomaly_releaser
	name = "Anomaly Releaser"
	desc = "A one-time use device, reactivates anomalies and stabilizes them."
	id = "anomaly_releaser"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_GOLD = SHEET_MATERIAL_AMOUNT, MAT_PHORON = SHEET_MATERIAL_AMOUNT * 2.5, MAT_URANIUM = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/anomaly_releaser
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/reactive_armour
	name = "Reactive Armor Shell"
	desc = "An experimental suit of armour capable of utilizing an implanted anomaly core to protect the user."
	id = "reactive_armour"
	build_type = PROTOLATHE
	materials = list(
		MAT_STEEL = SHEET_MATERIAL_AMOUNT*5,
		MAT_URANIUM = SHEET_MATERIAL_AMOUNT*4,
		MAT_DIAMOND = SHEET_MATERIAL_AMOUNT*2.5,
		MAT_SILVER = SHEET_MATERIAL_AMOUNT*2.5,
		MAT_GOLD = SHEET_MATERIAL_AMOUNT*2.5
	)
	build_path = /obj/item/clothing/suit/armor/reactive_armor_shell
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ashtray
	name = "ashtray"
	desc = "An ashtray."
	id = "ashtray"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 250)
	build_path = /obj/item/material/ashtray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/glasstray
	name = "glass ashtray"
	desc = "An shinier ashtray."
	id = "glasstray"
	build_type = PROTOLATHE
	materials = list(MAT_GLASS = 250)
	build_path = /obj/item/material/ashtray/glass
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/sticky_tape
	name = "tape role"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	id = "sticky_tape"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_PLASTIC = 500)
	build_path = /obj/item/tape_roll
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = ALL

// Assemblies
/datum/design_techweb/assembly_igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	build_type = AUTOLATHE | PROTOLATHE
	id = "igniter"
	materials = list(MAT_STEEL = 625, MAT_GLASS = 60)
	build_path = /obj/item/assembly/igniter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ASSEMBLIES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/assembly_infrared_emitter
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	build_type = AUTOLATHE | PROTOLATHE
	id = "infrared_emitter"
	materials = list(MAT_STEEL = 1250, MAT_GLASS = 625)
	build_path = /obj/item/assembly/infra
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ASSEMBLIES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/assembly_prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	build_type = AUTOLATHE | PROTOLATHE
	id = "prox_sensor"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/assembly/prox_sensor
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ASSEMBLIES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/assembly_signaler
	name = "remote signaling device"
	desc = "Used to remotely activate devices.  Tap against another secured signaler to transfer configuration."
	build_type = AUTOLATHE | PROTOLATHE
	id = "signaler"
	materials = list(MAT_STEEL = 1250, MAT_GLASS = 250)
	build_path = /obj/item/assembly/signaler
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ASSEMBLIES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/assembly_timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	build_type = AUTOLATHE | PROTOLATHE
	id = "timer"
	materials = list(MAT_STEEL = 625, MAT_GLASS = 60)
	build_path = /obj/item/assembly/timer
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ASSEMBLIES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

// Pai card
/datum/design_techweb/sleevecard
	name = "sleevecard"
	desc = "This upgraded pAI module has enough capacity to run a whole mind of human-level intelligence."
	build_type = AUTOLATHE | PROTOLATHE
	id = "sleevecard"
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/paicard/sleevecard
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL
