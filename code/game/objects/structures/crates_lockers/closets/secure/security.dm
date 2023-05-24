/obj/structure/closet/secure_closet/captains
	name = "site manager's locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/command

	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/captain,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/weapon/cartridge/captain,
		/obj/item/weapon/storage/lockbox/medal,
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/device/radio/headset/heads/captain/alt,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/weapon/storage/box/ids)


/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	req_access = list(access_hop)
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop

	starts_with = list(
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/head/helmet,
		/obj/item/weapon/cartridge/hop,
		/obj/item/device/radio/headset/heads/hop,
		/obj/item/device/radio/headset/heads/hop/alt,
		/obj/item/weapon/storage/box/ids = 2,
		/obj/item/weapon/gun/energy/gun/compact,
		/obj/item/weapon/storage/box/commandkeys,
		/obj/item/weapon/storage/box/servicekeys,
		/obj/item/device/flash)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	req_access = list(access_hop)
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop

	starts_with = list(
		/obj/item/clothing/under/rank/head_of_personnel,
		/obj/item/clothing/under/dress/dress_hop,
		/obj/item/clothing/under/dress/dress_hr,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/black/skirt,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/red/skirt,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/under/rank/neo_hop,
		/obj/item/clothing/under/rank/neo_hop_skirt,
		/obj/item/clothing/under/rank/neo_hop_parade_masc,
		/obj/item/clothing/under/rank/neo_hop_parade_fem,
		/obj/item/clothing/under/rank/neo_hop_turtle,
		/obj/item/clothing/under/rank/neo_hop_turtle_skirt,
		/obj/item/clothing/under/rank/neo_cmd_gorka,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_hopformal,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_civ_dep,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/head_of_personnel_whimsy,
		/obj/item/clothing/head/caphat/hop,
		/obj/item/clothing/under/suit_jacket/teal,
		/obj/item/clothing/under/suit_jacket/teal/skirt,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hop,
		/obj/item/clothing/head/caphat/hop/beret,
		/obj/item/clothing/head/caphat/hop/beret/white)


/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	storage_capacity = 2.6 * MOB_MEDIUM
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/suit/storage/vest/hos,
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
		/obj/item/weapon/gun/magnetic/railgun/heater/pistol/hos,
		/obj/item/weapon/rcd_ammo/large,
		/obj/item/weapon/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security/hos,
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


/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	storage_capacity = 42
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/security/warden

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/suit/storage/vest/wardencoat,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt2, //VOREStation Add,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/clothing/head/helmet/warden/hat,
		/obj/item/clothing/under/rank/neo_warden_red,
		/obj/item/clothing/under/rank/neo_warden_red_skirt,
		/obj/item/clothing/under/rank/neo_warden_blue,
		/obj/item/clothing/suit/storage/vest/wardencoat/neo_armsco_trench,
		/obj/item/clothing/suit/storage/vest/wardencoat/neo_bluewarden,
		/obj/item/clothing/suit/storage/vest/wardencoat/neo_warden_heavy,
		/obj/item/clothing/under/rank/neo_sec_gorka,
		/obj/item/clothing/suit/neo_armsco_trench,
		/obj/item/clothing/suit/neo_warden_heavy,
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

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/officer,
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
		///obj/item/ammo_magazine/m45/rubber, //VOREStation Removal,
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
	if(prob(30))
		starts_with += /obj/item/poster/nanotrasen
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


/obj/structure/closet/secure_closet/detective
	name = "detective's cabinet"
	req_access = list(access_forensics_lockers)
	closet_appearance = /decl/closet_appearance/cabinet/secure

	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'

	starts_with = list(
		/obj/item/clothing/accessory/badge/holo/detective,
		/obj/item/clothing/gloves/black,
		///obj/item/gunbox, // VOREStation Removal
		/obj/item/gunbox/stun,
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

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/courtroom

	starts_with = list(
		/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral = 2)

GLOBAL_LIST_BOILERPLATE(all_brig_closets, /obj/structure/closet/secure_closet/brig)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/brig
	anchored = TRUE
	var/id = null

	starts_with = list(
		/obj/item/clothing/under/color/prison,
		/obj/item/clothing/shoes/orange)

/obj/structure/closet/secure_closet/posters
	name = "morale storage"
	req_access = list(access_security)
	anchored = TRUE

	starts_with = list(
		/obj/item/poster/nanotrasen,
		/obj/item/poster/nanotrasen,
		/obj/item/poster/nanotrasen,
		/obj/item/poster/nanotrasen,
		/obj/item/poster/nanotrasen)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_lawyer)
	closet_appearance = /decl/closet_appearance/secure_closet/courtroom

	starts_with = list(
		/obj/item/clothing/shoes/brown,
		/obj/item/weapon/paper/Court = 3,
		/obj/item/weapon/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/weapon/storage/briefcase)


/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	closet_appearance = /decl/closet_appearance/wall
	density = TRUE

	//too small to put a man in
	large = 0
