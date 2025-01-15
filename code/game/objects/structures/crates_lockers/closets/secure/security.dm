/obj/structure/closet/secure_closet/captains
	name = "site manager's locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/command

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/captain,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/cartridge/captain,
		/obj/item/storage/lockbox/medal,
		/obj/item/radio/headset/heads/captain,
		/obj/item/radio/headset/alt/heads/captain,
		/obj/item/radio/headset/earbud/heads/captain,
		/obj/item/gun/energy/gun,
		/obj/item/melee/telebaton,
		/obj/item/flash,
		/obj/item/storage/box/ids)


/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	req_access = list(access_hop)
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop

	starts_with = list(
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/hop,
		/obj/item/radio/headset/heads/hop,
		/obj/item/radio/headset/alt/heads/hop,
		/obj/item/radio/headset/earbud/heads/hop,
		/obj/item/storage/box/ids = 2,
		/obj/item/gun/energy/gun/compact,
		/obj/item/storage/box/commandkeys,
		/obj/item/storage/box/servicekeys,
		/obj/item/flash)

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
		/obj/item/clothing/under/rank/neo_gorka/command,
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
		/obj/item/cartridge/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/alt/heads/hos,
		/obj/item/radio/headset/earbud/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/shield/riot,
		/obj/item/shield/riot/tele,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/tool/crowbar/red,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/magnetic/railgun/heater/pistol/hos,
		/obj/item/rcd_ammo/large,
		/obj/item/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security/hos,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/gas/sechailer/swat/hos)

/obj/structure/closet/secure_closet/hos/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()


/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	storage_capacity = 42
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/security/warden

	starts_with = list(
		/obj/item/clothing/under/rank/security/aces,
		/obj/item/clothing/suit/storage/vest/aces,
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
		/obj/item/clothing/under/rank/neo_gorka/sec,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/alt/headset_sec,
		/obj/item/radio/headset/earbud/headset_sec,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/clothing/accessory/badge/holo/warden,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/device/weapon,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight,
		/obj/item/megaphone,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/gas/sechailer/swat/warden)

/obj/structure/closet/secure_closet/warden/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

	starts_with = list(
		/obj/item/clothing/under/rank/security/aces,
		/obj/item/clothing/suit/storage/vest/aces,
		/obj/item/clothing/suit/storage/vest/officer,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/alt/headset_sec,
		/obj/item/radio/headset/earbud/headset_sec,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/grenade/flashbang,
		/obj/item/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/hailer,
		/obj/item/flashlight/flare,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		///obj/item/ammo_magazine/m45/rubber, //VOREStation Removal,
		/obj/item/gun/energy/taser,
		/obj/item/cell/device/weapon,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight)

/obj/structure/closet/secure_closet/security/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	if(prob(30))
		starts_with += /obj/item/poster/nanotrasen
	return ..()

/obj/structure/closet/secure_closet/security/cargo/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/cargo
	starts_with += /obj/item/encryptionkey/headset_cargo
	return ..()

/obj/structure/closet/secure_closet/security/engine/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/engine
	starts_with += /obj/item/encryptionkey/headset_eng
	return ..()

/obj/structure/closet/secure_closet/security/science/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/science
	starts_with += /obj/item/encryptionkey/headset_sci
	return ..()

/obj/structure/closet/secure_closet/security/med/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/medblue
	starts_with += /obj/item/encryptionkey/headset_med
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
		/obj/item/storage/belt/detective,
		/obj/item/storage/box/evidence,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/alt/headset_sec,
		/obj/item/radio/headset/earbud/headset_sec,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/taperoll/police,
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/flashlight/maglight,
		/obj/item/reagent_containers/food/drinks/flask/detflask,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/taperecorder,
		/obj/item/storage/bag/detective,
		/obj/item/rectape/random = 3)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/courtroom

	starts_with = list(
		/obj/item/reagent_containers/syringe/ld50_syringe/choral = 2)

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
		/obj/item/paper/Court = 3,
		/obj/item/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/storage/briefcase)


/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	closet_appearance = /decl/closet_appearance/wall
	density = TRUE

	//too small to put a man in
	large = 0
