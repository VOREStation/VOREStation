/decl/hierarchy/outfit/job/cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo

	headset = /obj/item/radio/headset/cargo
	headset_alt = /obj/item/radio/headset/alt/cargo
	headset_earbud = /obj/item/radio/headset/earbud/cargo

/decl/hierarchy/outfit/job/cargo/qm
	name = OUTFIT_JOB_NAME("Cargo")
	uniform = /obj/item/clothing/under/rank/cargo
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/pda/quartermaster

	headset = /obj/item/radio/headset/qm
	headset_alt = /obj/item/radio/headset/alt/qm
	headset_earbud = /obj/item/radio/headset/earbud/qm

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = OUTFIT_JOB_NAME("Shaft miner")
	uniform = /obj/item/clothing/under/rank/miner
	backpack = /obj/item/storage/backpack/industrial
	satchel_one  = /obj/item/storage/backpack/satchel/eng
	id_type = /obj/item/card/id/cargo/miner
	pda_type = /obj/item/pda/shaftminer
	backpack_contents = list(/obj/item/tool/crowbar = 1, /obj/item/storage/bag/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

	headset = /obj/item/radio/headset/miner
	headset_alt = /obj/item/radio/headset/miner
	headset_earbud = /obj/item/radio/headset/miner
