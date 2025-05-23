/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_access = list(access_tox_storage)
	closet_appearance = /decl/closet_appearance/secure_closet/science

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/radio/headset/headset_sci,
		/obj/item/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/shoes/boots/winter/science)

/obj/structure/closet/secure_closet/scientist/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/storage/backpack/toxins
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
		/obj/item/clothing/under/rank/neo_gorka/rd,
		/obj/item/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/radio/headset/heads/rd,
		/obj/item/radio/headset/alt/heads/rd,
		/obj/item/radio/headset/earbud/heads/rd,
		/obj/item/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/flash,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science/rd,
		/obj/item/clothing/shoes/boots/winter/science,
		/obj/item/clothing/head/beret/science/rd,
		/obj/item/bluespace_harpoon) //VOREStation Add

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_tox_storage)
	closet_appearance = /decl/closet_appearance/secure_closet/science/xenoarch

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/labcoat/modern,
		/obj/item/clothing/shoes/white,
		/obj/item/melee/umbrella,
		/obj/item/clothing/glasses/science,
		/obj/item/radio/headset/headset_sci,
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/pickaxe/excavationdrill)

/obj/structure/closet/excavation
	name = "Excavation tools"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools/xenoarch

	starts_with = list(
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/flashlight/lantern,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/clothing/glasses/meson,
		/obj/item/pickaxe,
		/obj/item/measuring_tape,
		/obj/item/pickaxe/hand,
		/obj/item/storage/bag/fossils,
		/obj/item/hand_labeler)
