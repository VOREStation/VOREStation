/obj/structure/closet/secure_closet/hos
	name = "head of security's attire"
	req_access = list(access_hos)
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen/alt,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/device/radio/headset/heads/hos,
		/obj/item/device/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/weapon/storage/belt/security,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security/hos,
		/obj/item/clothing/mask/gas/half)

/obj/structure/closet/secure_closet/hos2
	name = "head of security's gear"
	req_access = list(access_hos)
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/weapon/cartridge/hos,
		/obj/item/taperoll/police,
		/obj/item/weapon/shield/riot/tele,
		/obj/item/weapon/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/tool/crowbar/red,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/device/flash,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/device/flashlight/maglight)

//Custom NT Security Lockers, Only found at central command
/obj/structure/closet/secure_closet/nanotrasen_security
	name = "NanoTrasen security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/nanotrasen/security
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/nanotrasen,
		/obj/item/clothing/head/helmet,
		/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/device/flashlight/flare,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/cell/device/weapon,
		/obj/item/device/flashlight/maglight,
		/obj/item/clothing/head/soft/nanotrasen,
		/obj/item/clothing/head/beret/nanotrasen,
		/obj/item/clothing/under/nanotrasen/security,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless)

/obj/structure/closet/secure_closet/nanotrasen_security/Initialize()
	if(prob(25))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(75))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/nanotrasen_commander
	name = "NanoTrasen commander's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/nanotrasen/commander
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen/alt,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/weapon/cartridge/hos,
		/obj/item/device/radio/headset/heads/hos,
		/obj/item/device/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/weapon/shield/riot,
		/obj/item/weapon/shield/riot/tele,
		/obj/item/weapon/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/tool/crowbar/red,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/device/flashlight/maglight,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless,
		/obj/item/clothing/under/nanotrasen/security/commander)

/obj/structure/closet/secure_closet/nanotrasen_commander/Initialize()
	if(prob(25))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(75))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/nanotrasen_warden
	name = "NanoTrasen warden's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/nanotrasen/warden
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/nanotrasen/security/warden,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt2,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/clothing/accessory/badge/holo/warden,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/belt/security,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/cell/device/weapon,
		/obj/item/weapon/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/megaphone,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless)

/obj/structure/closet/secure_closet/nanotrasen_warden/Initialize()
	if(prob(25))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/sec(src)
	if(prob(75))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	return ..()

/obj/structure/closet/secure_closet/captains
	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/captain,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/weapon/cartridge/captain,
		/obj/item/weapon/storage/lockbox/medal,
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/device/radio/headset/heads/captain/alt,
		/obj/item/gunbox/captain,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/weapon/storage/box/ids,
		/obj/item/weapon/melee/rapier,
		/obj/item/clothing/accessory/holster/machete/rapier)
