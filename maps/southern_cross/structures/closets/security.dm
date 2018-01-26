/*
 * SC Security
 */


/obj/structure/closet/secure_closet/hos_wardrobe
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

/obj/structure/closet/secure_closet/hos_wardrobe/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/clothing/under/rank/head_of_security/jensen(src)
	new /obj/item/clothing/under/rank/head_of_security/corp(src)
	new /obj/item/clothing/suit/storage/vest/hoscoat/jensen(src)
	new /obj/item/clothing/suit/storage/vest/hoscoat(src)
	new /obj/item/weapon/cartridge/hos(src)
	new /obj/item/device/radio/headset/heads/hos(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/weapon/storage/box/holobadge/hos(src)
	new /obj/item/clothing/accessory/badge/holo/hos(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/head/beret/sec/corporate/hos(src)
	new /obj/item/clothing/mask/gas/half(src)
	return