/*
 * SC Engineering
 */

/obj/structure/closet/secure_closet/engineering_chief/lite
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		new /obj/item/clothing/accessory/storage/brown_vest(src)
		new /obj/item/blueprints(src)
		new /obj/item/clothing/head/hardhat/white(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/device/radio/headset/heads/ce(src)
		new /obj/item/device/radio/headset/heads/ce/alt(src)
		new /obj/item/weapon/storage/toolbox/mechanical(src)
		new /obj/item/device/multitool(src)
		new /obj/item/weapon/weldingtool/experimental(src)
		new /obj/item/device/flash(src)
		new /obj/item/taperoll/engineering(src)
		return



/obj/structure/closet/secure_closet/engineering_chief/wardrobe
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		new /obj/item/clothing/under/rank/chief_engineer(src)
		new /obj/item/clothing/under/rank/chief_engineer/skirt(src)
		new /obj/item/clothing/head/hardhat/white(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/cartridge/ce(src)
		new /obj/item/device/radio/headset/heads/ce(src)
		new /obj/item/device/radio/headset/heads/ce/alt(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/weapon/tank/emergency/oxygen/engi(src)
		new /obj/item/taperoll/engineering(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering(src)
		return