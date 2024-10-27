/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo

/decl/hierarchy/outfit/job/cargo/qm
	name = OUTFIT_JOB_NAME("Cargo")
	uniform = /obj/item/clothing/under/rank/cargo
	l_ear = /obj/item/radio/headset/headset_qm //VOREStation Add
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/pda/quartermaster

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = OUTFIT_JOB_NAME("Shaft miner")
	uniform = /obj/item/clothing/under/rank/miner
	l_ear = /obj/item/radio/headset/headset_mine
	backpack = /obj/item/storage/backpack/industrial
	satchel_one  = /obj/item/storage/backpack/satchel/eng
	id_type = /obj/item/card/id/cargo/miner
	pda_type = /obj/item/pda/shaftminer
	backpack_contents = list(/obj/item/tool/crowbar = 1, /obj/item/storage/bag/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
