/*
 * SC Science
 */


/obj/structure/closet/secure_closet/RD_wardrobe
	name = "research director's locker"
	req_access = list(access_rd)
	closet_appearance = /decl/closet_appearance/secure_closet/science/rd

	starts_with = list(
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/weapon/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/device/radio/headset/heads/rd)
