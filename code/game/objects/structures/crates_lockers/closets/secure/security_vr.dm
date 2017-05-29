/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	storage_capacity = 3 * MOB_MEDIUM

//Custom NT Security Lockers, Only found at central command

/obj/structure/closet/secure_closet/nanotrasen_security
	name = "NanoTrasen security officer's locker"
	req_access = list(access_brig)
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secC1"
	icon_closed = "secC"
	icon_locked = "secC1"
	icon_opened = "secCopen"
	icon_broken = "secCbroken"
	icon_off = "seCcoff"
	storage_capacity = 3.5 * MOB_MEDIUM

	New()
		..()
		if(prob(25))
			new /obj/item/weapon/storage/backpack/security(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/sec(src)
		if(prob(75))
			new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
		new /obj/item/clothing/suit/storage/vest/nanotrasen(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/weapon/cartridge/security(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/device/radio/headset/headset_sec/alt(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		new /obj/item/weapon/grenade/flashbang(src)
		new /obj/item/weapon/melee/baton/loaded(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/device/hailer(src)
		new /obj/item/device/flashlight/flare(src)
		new /obj/item/clothing/accessory/storage/black_vest(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/weapon/cell/device/weapon(src)
		new /obj/item/device/flashlight/maglight(src)
		new /obj/item/clothing/head/soft/nanotrasen(src)
		new /obj/item/clothing/head/beret/nanotrasen(src)
		new /obj/item/clothing/under/nanotrasen/security(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/shoes/boots/jackboots(src)
		new /obj/item/clothing/shoes/boots/jackboots/toeless(src)
		return

/obj/structure/closet/secure_closet/nanotrasen_commander
	name = "NanoTrasen commander's locker"
	req_access = list(access_brig)
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secC1"
	icon_closed = "secC"
	icon_locked = "secC1"
	icon_opened = "secCopen"
	icon_broken = "secCbroken"
	icon_off = "seCcoff"
	storage_capacity = 3.5 * MOB_MEDIUM

	New()
		..()
		if(prob(25))
			new /obj/item/weapon/storage/backpack/security(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/sec(src)
		if(prob(75))
			new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
		new /obj/item/clothing/head/helmet/HoS(src)
		new /obj/item/clothing/suit/storage/vest/hos(src)
		new /obj/item/clothing/under/rank/head_of_security/jensen(src)
		new /obj/item/clothing/suit/storage/vest/hoscoat/jensen(src)
		new /obj/item/clothing/suit/storage/vest/hoscoat(src)
		new /obj/item/clothing/head/helmet/HoS/dermal(src)
		new /obj/item/weapon/cartridge/hos(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		new /obj/item/device/radio/headset/heads/hos/alt(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/weapon/shield/riot(src)
		new /obj/item/weapon/shield/riot/tele(src)
		new /obj/item/weapon/storage/box/holobadge/hos(src)
		new /obj/item/clothing/accessory/badge/holo/hos(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		new /obj/item/weapon/crowbar/red(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/melee/baton/loaded(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/weapon/cell/device/weapon(src)
		new /obj/item/clothing/accessory/holster/waist(src)
		new /obj/item/weapon/melee/telebaton(src)
		new /obj/item/clothing/head/beret/sec/corporate/hos(src)
		new /obj/item/device/flashlight/maglight(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/shoes/boots/jackboots(src)
		new /obj/item/clothing/shoes/boots/jackboots/toeless(src)
		new /obj/item/clothing/under/nanotrasen/security/commander(src)
		return

/obj/structure/closet/secure_closet/nanotrasen_warden
	name = "NanoTrasen warden's locker"
	req_access = list(access_brig)
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secC1"
	icon_closed = "secC"
	icon_locked = "secC1"
	icon_opened = "secCopen"
	icon_broken = "secCbroken"
	icon_off = "seCcoff"
	storage_capacity = 3.5 * MOB_MEDIUM


	New()
		..()
		if(prob(25))
			new /obj/item/weapon/storage/backpack/security(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/sec(src)
		if(prob(75))
			new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
		new /obj/item/clothing/suit/storage/vest/warden(src)
		new /obj/item/clothing/under/nanotrasen/security/warden(src)
		new /obj/item/clothing/suit/storage/vest/wardencoat/alt(src)
		new /obj/item/clothing/head/helmet/warden(src)
		new /obj/item/weapon/cartridge/security(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/device/radio/headset/headset_sec/alt(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/clothing/accessory/badge/holo/warden(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		new /obj/item/weapon/melee/baton/loaded(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/weapon/cell/device/weapon(src)
		new /obj/item/weapon/storage/box/holobadge(src)
		new /obj/item/clothing/head/beret/sec/corporate/warden(src)
		new /obj/item/device/flashlight/maglight(src)
		new /obj/item/device/megaphone(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/shoes/boots/jackboots(src)
		new /obj/item/clothing/shoes/boots/jackboots/toeless(src)
		return
