/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_tox_storage)

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
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"
	req_access = list(access_rd)

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/weapon/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/device/radio/headset/heads/rd,
		/obj/item/device/radio/headset/heads/rd/alt,
		/obj/item/weapon/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/shoes/boots/winter/science,
		/obj/item/weapon/bluespace_harpoon) //VOREStation Add
