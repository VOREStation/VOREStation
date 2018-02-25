/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

	New()
		..()
		if(prob(75))
			new /obj/item/weapon/storage/backpack(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/norm(src)
		if(prob(25))
			new /obj/item/weapon/storage/backpack/dufflebag(src)
		new /obj/item/clothing/under/rank/cargotech(src)
		new /obj/item/clothing/under/rank/cargotech/skirt(src)
		new /obj/item/clothing/under/rank/cargotech/jeans(src)
		new /obj/item/clothing/under/rank/cargotech/jeans/female(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/cargo(src)
		new /obj/item/clothing/shoes/boots/winter/supply(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/device/radio/headset/headset_cargo/alt(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/gloves/fingerless(src)
		new /obj/item/clothing/head/soft(src)
//		new /obj/item/weapon/cartridge/quartermaster(src)
		return

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	New()
		..()
		if(prob(75))
			new /obj/item/weapon/storage/backpack(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/norm(src)
		if(prob(25))
			new /obj/item/weapon/storage/backpack/dufflebag(src)
		new /obj/item/clothing/under/rank/cargo(src)
		new /obj/item/clothing/under/rank/cargo/skirt(src)
		new /obj/item/clothing/under/rank/cargo/jeans(src)
		new /obj/item/clothing/under/rank/cargo/jeans/female(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/device/radio/headset/headset_cargo/alt(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/gloves/fingerless(src)
//		new /obj/item/weapon/cartridge/quartermaster(src)
		new /obj/item/clothing/suit/fire/firefighter(src)
		new /obj/item/weapon/tank/emergency/oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/head/soft(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/cargo(src)
		new /obj/item/clothing/shoes/boots/winter/supply(src)
		return

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	sleep(2)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/eng(src)
	new /obj/item/device/radio/headset/headset_mine(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/weapon/storage/bag/ore(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe(src)
	new /obj/item/clothing/glasses/material(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/miner(src)
	new /obj/item/clothing/shoes/boots/winter/mining(src)
	new /obj/item/stack/marker_beacon/thirty(src)