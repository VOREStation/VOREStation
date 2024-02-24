/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_access = list(access_tox_storage)
	closet_appearance = /decl/closet_appearance/secure_closet/science

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/weapon/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/shoes/boots/winter/science)

/obj/structure/closet/secure_closet/scientist/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/weapon/storage/backpack/toxins
	return ..()


/obj/structure/closet/secure_closet/RD
	name = "research director's locker"
	req_access = list(access_rd)
	closet_appearance = /decl/closet_appearance/secure_closet/science/rd

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/labcoat/modern,
		/obj/item/clothing/suit/storage/toggle/labcoat/rd,
		/obj/item/clothing/under/rank/neo_rd_turtle,
		/obj/item/clothing/under/rank/neo_rd_turtle_skirt,
		/obj/item/clothing/under/rank/neo_rd_suit,
		/obj/item/clothing/under/rank/neo_rd_suit_skirt,
		/obj/item/clothing/under/rank/neo_rd_gorka,
		/obj/item/weapon/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/device/radio/headset/heads/rd,
		/obj/item/device/radio/headset/heads/rd/alt,
		/obj/item/weapon/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science/rd,
		/obj/item/clothing/shoes/boots/winter/science,
		/obj/item/clothing/head/beret/science/rd,
		/obj/item/weapon/bluespace_harpoon) //VOREStation Add

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_tox_storage)
	closet_appearance = /decl/closet_appearance/secure_closet/science/xenoarch

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/labcoat/modern,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/melee/umbrella,
		/obj/item/clothing/glasses/science,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/weapon/storage/belt/archaeology,
		/obj/item/weapon/storage/excavation)

/obj/structure/closet/excavation
	name = "Excavation tools"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools/xenoarch

	starts_with = list(
		/obj/item/weapon/storage/belt/archaeology,
		/obj/item/weapon/storage/excavation,
		/obj/item/device/flashlight/lantern,
		/obj/item/device/ano_scanner,
		/obj/item/device/depth_scanner,
		/obj/item/device/core_sampler,
		/obj/item/device/gps,
		/obj/item/device/beacon_locator,
		/obj/item/device/radio/beacon,
		/obj/item/clothing/glasses/meson,
		/obj/item/weapon/pickaxe,
		/obj/item/device/measuring_tape,
		/obj/item/weapon/pickaxe/hand,
		/obj/item/weapon/storage/bag/fossils,
		/obj/item/weapon/hand_labeler)
