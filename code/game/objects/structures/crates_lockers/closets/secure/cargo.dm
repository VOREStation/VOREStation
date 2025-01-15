/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	closet_appearance = /decl/closet_appearance/secure_closet/cargo

	starts_with = list(
		/obj/item/clothing/under/rank/cargotech,
		/obj/item/clothing/under/rank/cargotech/skirt,
		/obj/item/clothing/under/rank/cargotech/jeans,
		/obj/item/clothing/under/rank/cargotech/jeans/female,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/shoes/boots/winter/supply,
		/obj/item/clothing/shoes/black,
		/obj/item/radio/headset/cargo,
		/obj/item/radio/headset/alt/cargo,
		/obj/item/radio/headset/earbud/cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/head/soft)

/obj/structure/closet/secure_closet/cargotech/Initialize()
	if(prob(75))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	if(prob(25))
		starts_with += /obj/item/storage/backpack/dufflebag
	return ..()

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	closet_appearance = /decl/closet_appearance/secure_closet/cargo/qm

	starts_with = list(
		/obj/item/clothing/under/rank/cargo,
		/obj/item/clothing/under/rank/cargo/skirt,
		/obj/item/clothing/under/rank/cargo/jeans,
		/obj/item/clothing/under/rank/cargo/jeans/female,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/qm,
		/obj/item/radio/headset/alt/qm,
		/obj/item/radio/headset/earbud/qm,
		/obj/item/clothing/under/rank/neo_qm,
		/obj/item/clothing/under/rank/neo_qm_skirt,
		/obj/item/clothing/under/rank/neo_qm_jacket,
		/obj/item/clothing/under/rank/neo_qm_white,
		/obj/item/clothing/under/rank/neo_qm_white_skirt,
		/obj/item/clothing/under/rank/neo_qm_turtle,
		/obj/item/clothing/under/rank/neo_qm_turtle_skirt,
		/obj/item/clothing/under/rank/neo_gorka/qm,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo/qm,
		/obj/item/clothing/head/beret/qm,
		/obj/item/clothing/shoes/boots/winter/supply)

/obj/structure/closet/secure_closet/quartermaster/Initialize()
	if(prob(75))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	if(prob(25))
		starts_with += /obj/item/storage/backpack/dufflebag
	return ..()

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	req_access = list(access_mining)
	closet_appearance = /decl/closet_appearance/secure_closet/mining

	starts_with = list(
		/obj/item/radio/headset/miner,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/black,
		/obj/item/analyzer,
		/obj/item/storage/bag/ore,
		/obj/item/storage/belt/miner,
		/obj/item/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe/drill,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
		/obj/item/clothing/shoes/boots/winter/mining,
		/obj/item/emergency_beacon,
		/obj/item/stack/marker_beacon/thirty)

/obj/structure/closet/secure_closet/miner/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	return ..()
