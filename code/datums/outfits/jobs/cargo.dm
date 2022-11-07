/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo
	shoes = /obj/item/clothing/shoes/boots/workboots

/decl/hierarchy/outfit/job/cargo/qm
	name = OUTFIT_JOB_NAME("Cargo")
	uniform = /obj/item/clothing/under/rank/cargo
<<<<<<< HEAD
	l_ear = /obj/item/device/radio/headset/headset_qm //VOREStation Add
	shoes = /obj/item/clothing/shoes/brown
=======
>>>>>>> 3584065199b... Merge pull request #8818 from Cerebulon/newbasicscargo
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/cargo/head
	pda_type = /obj/item/device/pda/quartermaster

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_type = /obj/item/weapon/card/id/cargo
	pda_type = /obj/item/device/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = OUTFIT_JOB_NAME("Shaft miner")
<<<<<<< HEAD
	uniform = /obj/item/clothing/under/rank/miner
	l_ear = /obj/item/device/radio/headset/headset_mine
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one  = /obj/item/weapon/storage/backpack/satchel/eng
	id_type = /obj/item/weapon/card/id/cargo/miner
	pda_type = /obj/item/device/pda/shaftminer
	backpack_contents = list(/obj/item/weapon/tool/crowbar = 1, /obj/item/weapon/storage/bag/ore = 1)
=======
	uniform = /obj/item/clothing/under/rank/miner{ starting_accessories=list(/obj/item/clothing/accessory/storage/overalls) }
	l_ear = /obj/item/radio/headset/headset_mine
	backpack = /obj/item/storage/backpack/industrial
	satchel_one  = /obj/item/storage/backpack/satchel/eng
	id_type = /obj/item/card/id/cargo/miner
	pda_type = /obj/item/pda/shaftminer
	backpack_contents = list(/obj/item/tool/crowbar = 1, /obj/item/storage/bag/ore = 1)
>>>>>>> 3584065199b... Merge pull request #8818 from Cerebulon/newbasicscargo
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
