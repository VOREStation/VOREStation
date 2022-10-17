/decl/hierarchy/outfit/job/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/engineering
	belt = /obj/item/weapon/storage/belt/utility/full/multitool
	l_ear = /obj/item/device/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/device/t_scanner
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one = /obj/item/weapon/storage/backpack/satchel/eng
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/engi
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/engineering/chief_engineer
	name = OUTFIT_JOB_NAME("Chief engineer")
	head = /obj/item/clothing/head/hardhat/white
<<<<<<< HEAD
	uniform = /obj/item/clothing/under/rank/chief_engineer
	l_ear = /obj/item/device/radio/headset/heads/ce
=======
	uniform = /obj/item/clothing/under/rank/chief_engineer{ starting_accessories=list(/obj/item/clothing/accessory/storage/overalls/chief) }
	l_ear = /obj/item/radio/headset/heads/ce
>>>>>>> 3e092d401e5... Merge pull request #8743 from Cerebulon/new_basics_engineering
	gloves = /obj/item/clothing/gloves/black
	id_type = /obj/item/weapon/card/id/engineering/head
	pda_type = /obj/item/device/pda/heads/ce

/decl/hierarchy/outfit/job/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/rank/engineer
<<<<<<< HEAD
	id_type = /obj/item/weapon/card/id/engineering
	pda_type = /obj/item/device/pda/engineering
=======
	suit = /obj/item/clothing/suit/storage/hazardvest
	id_type = /obj/item/card/id/engineering
	pda_type = /obj/item/pda/engineering
>>>>>>> 3e092d401e5... Merge pull request #8743 from Cerebulon/new_basics_engineering

/decl/hierarchy/outfit/job/engineering/atmos
	name = OUTFIT_JOB_NAME("Atmospheric technician")
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
<<<<<<< HEAD
	belt = /obj/item/weapon/storage/belt/utility/atmostech
	id_type = /obj/item/weapon/card/id/engineering/atmos
	pda_type = /obj/item/device/pda/atmos
=======
	head = /obj/item/clothing/head/hardhat/dblue
	suit = /obj/item/clothing/suit/storage/hazardvest/blue
	belt = /obj/item/storage/belt/utility/atmostech
	id_type = /obj/item/card/id/engineering/atmos
	pda_type = /obj/item/pda/atmos
>>>>>>> 3e092d401e5... Merge pull request #8743 from Cerebulon/new_basics_engineering
