/*
 * SC Security
 */

/obj/structure/closet/secure_closet/hos/lite
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/security(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/sec(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
		new /obj/item/clothing/head/helmet/HoS(src)
		new /obj/item/clothing/suit/storage/vest/hos(src)
		new /obj/item/clothing/head/helmet/HoS/dermal(src)
		new /obj/item/device/radio/headset/heads/hos/alt(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/weapon/shield/riot(src)
		new /obj/item/weapon/shield/riot/tele(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		new /obj/item/weapon/crowbar/red(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/melee/baton/loaded(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/weapon/cell/device/weapon(src)
		new /obj/item/weapon/melee/telebaton(src)
		new /obj/item/device/flashlight/maglight(src)
		return



/obj/structure/closet/secure_closet/hos/wardrobe
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	New()
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