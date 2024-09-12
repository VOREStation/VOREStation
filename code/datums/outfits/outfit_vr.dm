/decl/hierarchy/outfit/USDF/Marine
	name = "USDF marine"
	uniform = /obj/item/clothing/under/solgov/utility/army/urban
	shoes = /obj/item/clothing/shoes/boots/jackboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/centcom
	r_pocket = /obj/item/ammo_magazine/m95
	l_pocket = /obj/item/ammo_magazine/m95
	l_hand = /obj/item/ammo_magazine/m95
	r_hand = /obj/item/ammo_magazine/m95
	back = /obj/item/weapon/gun/projectile/automatic/battlerifle
	backpack_contents = list(/obj/item/weapon/storage/box = 1)
	hierarchy_type = /decl/hierarchy/outfit/wizard
	head = /obj/item/clothing/head/helmet/combat/USDF
	suit = /obj/item/clothing/suit/armor/combat/USDF
	belt = /obj/item/weapon/storage/belt/security/tactical

/decl/hierarchy/outfit/USDF/Marine/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.name = "[H.real_name]'s military ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "USDF"
	C.registered_name = H.real_name
	return C

/decl/hierarchy/outfit/USDF/Officer
	name = "USDF officer"
	head = /obj/item/clothing/head/dress/army/command
	shoes = /obj/item/clothing/shoes/boots/jackboots
	l_ear = /obj/item/device/radio/headset/centcom
	uniform = /obj/item/clothing/under/solgov/mildress/army/command
	back = /obj/item/weapon/storage/backpack/satchel
	belt = /obj/item/weapon/gun/projectile/revolver/consul
	l_pocket = /obj/item/ammo_magazine/s44
	r_pocket = /obj/item/ammo_magazine/s44
	r_hand = /obj/item/clothing/accessory/holster/hip
	l_hand = /obj/item/clothing/accessory/tie/black

/decl/hierarchy/outfit/USDF/Officer/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.name = "[H.real_name]'s military ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "USDF"
	C.registered_name = H.real_name
	return C

/decl/hierarchy/outfit/solcom/representative
	name = "SolCom Representative"
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/centcom
	uniform = /obj/item/clothing/under/suit_jacket/navy
	back = /obj/item/weapon/storage/backpack/satchel
	l_pocket = /obj/item/weapon/pen/blue
	r_pocket = /obj/item/weapon/pen/red
	r_hand = /obj/item/device/pda/centcom
	l_hand = /obj/item/weapon/clipboard

/decl/hierarchy/outfit/solcom/representative/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.name = "[H.real_name]'s SolCom ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "SolCom Representative"
	C.registered_name = H.real_name
	return C

/decl/hierarchy/outfit/imperial/soldier
	name = "Imperial soldier"
	head = /obj/item/clothing/head/helmet/combat/imperial
	shoes =/obj/item/clothing/shoes/leg_guard/combat/imperial
	gloves = /obj/item/clothing/gloves/arm_guard/combat/imperial
	l_ear = /obj/item/device/radio/headset/syndicate
	uniform = /obj/item/clothing/under/imperial
	mask = /obj/item/clothing/mask/gas/imperial
	suit = /obj/item/clothing/suit/armor/combat/imperial
	back = /obj/item/weapon/storage/backpack/satchel
	belt = /obj/item/weapon/storage/belt/security/tactical/bandolier
	l_pocket = /obj/item/weapon/cell/device/weapon
	r_pocket = /obj/item/weapon/cell/device/weapon
	r_hand = /obj/item/weapon/melee/energy/sword/imperial
	l_hand = /obj/item/weapon/shield/energy/imperial
	suit_store = /obj/item/weapon/gun/energy/imperial

/decl/hierarchy/outfit/imperial/officer
	name = "Imperial officer"
	head = /obj/item/clothing/head/helmet/combat/imperial/centurion
	shoes = /obj/item/clothing/shoes/leg_guard/combat/imperial
	gloves = /obj/item/clothing/gloves/arm_guard/combat/imperial
	l_ear = /obj/item/device/radio/headset/syndicate
	uniform = /obj/item/clothing/under/imperial
	mask = /obj/item/clothing/mask/gas/imperial
	suit = /obj/item/clothing/suit/armor/combat/imperial/centurion
	belt = /obj/item/weapon/storage/belt/security/tactical/bandolier
	l_pocket = /obj/item/weapon/cell/device/weapon
	r_pocket = /obj/item/weapon/cell/device/weapon
	r_hand = /obj/item/weapon/melee/energy/sword/imperial
	l_hand = /obj/item/weapon/shield/energy/imperial
	suit_store = /obj/item/weapon/gun/energy/imperial

/*
SOUTHERN CROSS OUTFITS
Keep outfits simple. Spawn with basic uniforms and minimal gear. Gear instead goes in lockers. Keep this in mind if editing.
*/


/decl/hierarchy/outfit/job/explorer2
	name = OUTFIT_JOB_NAME(JOB_EXPLORER)
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	l_ear = /obj/item/device/radio/headset/explorer
	id_slot = slot_wear_id
	pda_slot = slot_l_store
	pda_type = /obj/item/device/pda/explorer
	id_type = /obj/item/weapon/card/id/exploration
	id_pda_assignment = JOB_EXPLORER
	backpack = /obj/item/weapon/storage/backpack/explorer
	satchel_one = /obj/item/weapon/storage/backpack/satchel/explorer
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/explorer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/pilot
	name = OUTFIT_JOB_NAME("Pilot")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1/no_webbing
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	l_ear = /obj/item/device/radio/headset/pilot/alt
	uniform_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1 = 1)
	id_slot = slot_wear_id
	pda_slot = slot_belt
	pda_type = /obj/item/device/pda/pilot
	id_type = /obj/item/weapon/card/id/civilian/pilot
	id_pda_assignment = "Pilot"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/medical/sar
	name = OUTFIT_JOB_NAME(JOB_FIELD_MEDIC)
	uniform = /obj/item/clothing/under/utility/blue
	//suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_ear = /obj/item/device/radio/headset/sar
	l_hand = /obj/item/weapon/storage/firstaid/regular
	belt = /obj/item/weapon/storage/belt/medical/emt
	pda_slot = slot_l_store
	pda_type = /obj/item/device/pda/sar
	id_type = /obj/item/weapon/card/id/exploration/fm
	id_pda_assignment = JOB_FIELD_MEDIC
	backpack = /obj/item/weapon/storage/backpack/explorer
	satchel_one = /obj/item/weapon/storage/backpack/satchel/explorer
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/explorer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/pathfinder
	name = OUTFIT_JOB_NAME(JOB_PATHFINDER)
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer //TODO: Uniforms.
	l_ear = /obj/item/device/radio/headset/pathfinder
	id_slot = slot_wear_id
	pda_slot = slot_l_store
	pda_type = /obj/item/device/pda/pathfinder
	id_type = /obj/item/weapon/card/id/exploration/head
	id_pda_assignment = JOB_PATHFINDER
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/assistant/explorer
	id_type = /obj/item/weapon/card/id/exploration
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
