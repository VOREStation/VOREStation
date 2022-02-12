/obj/structure/closet/secure_closet/hos/cynosure
	name = "head of security's locker"
	req_access = list(access_hos)
	storage_capacity = 2.6 * MOB_MEDIUM
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/suit/armor/pcarrier/light/nt/cynosure,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
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
		/obj/item/weapon/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/device/flashlight/maglight,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/gas/sechailer/swat/hos)

/obj/structure/closet/secure_closet/hos/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sec
	return ..()


/obj/structure/closet/secure_closet/warden/cynosure
	name = "warden's locker"
	storage_capacity = 42
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/security/warden

	starts_with = list(
		/obj/item/clothing/suit/armor/pcarrier/light/nt/cynosure,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/suit/storage/vest/wardencoat,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/clothing/head/helmet/warden/hat,
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
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/megaphone,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/gas/sechailer/swat/warden)

/obj/structure/closet/secure_closet/warden/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/security/cynosure
	name = "security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

	starts_with = list(
		/obj/item/clothing/suit/armor/pcarrier/light/nt/cynosure,
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
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/ammo_magazine/m45/rubber,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/cell/device/weapon,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/device/flashlight/maglight)

/obj/structure/closet/secure_closet/security/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/security/cargo/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/cargo
	starts_with += /obj/item/device/encryptionkey/headset_cargo
	return ..()

/obj/structure/closet/secure_closet/security/engine/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/engine
	starts_with += /obj/item/device/encryptionkey/headset_eng
	return ..()

/obj/structure/closet/secure_closet/security/science/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/science
	starts_with += /obj/item/device/encryptionkey/headset_sci
	return ..()

/obj/structure/closet/secure_closet/security/med/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/medblue
	starts_with += /obj/item/device/encryptionkey/headset_med
	return ..()


/obj/structure/closet/secure_closet/detective/cynosure
	name = "detective's cabinet"
	req_access = list(access_forensics_lockers)
	closet_appearance = /decl/closet_appearance/cabinet/secure

	starts_with = list(
		/obj/item/clothing/accessory/badge/holo/detective,
		/obj/item/clothing/gloves/black,
		/obj/item/gunbox,
		/obj/item/weapon/storage/belt/detective,
		/obj/item/weapon/storage/box/evidence,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/taperoll/police,
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/device/flashlight/maglight,
		/obj/item/weapon/reagent_containers/food/drinks/flask/detflask,
		/obj/item/weapon/storage/briefcase/crimekit,
		/obj/item/device/taperecorder,
		/obj/item/weapon/storage/bag/detective,
		/obj/item/device/tape/random = 3)
