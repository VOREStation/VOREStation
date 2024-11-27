/decl/hierarchy/outfit/USDF/Marine
	name = "USDF marine"
	uniform = /obj/item/clothing/under/solgov/utility/army/urban
	shoes = /obj/item/clothing/shoes/boots/jackboots
	gloves = /obj/item/clothing/gloves/combat
	r_pocket = /obj/item/ammo_magazine/m95
	l_pocket = /obj/item/ammo_magazine/m95
	l_hand = /obj/item/ammo_magazine/m95
	r_hand = /obj/item/ammo_magazine/m95
	back = /obj/item/gun/projectile/automatic/battlerifle
	backpack_contents = list(/obj/item/storage/box = 1)
	hierarchy_type = /decl/hierarchy/outfit/wizard
	head = /obj/item/clothing/head/helmet/combat/USDF
	suit = /obj/item/clothing/suit/armor/combat/USDF
	belt = /obj/item/storage/belt/security/tactical

	headset = /obj/item/radio/headset/centcom
	headset_alt = /obj/item/radio/headset/centcom
	headset_earbud = /obj/item/radio/headset/centcom

/decl/hierarchy/outfit/USDF/Marine/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
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
	uniform = /obj/item/clothing/under/solgov/mildress/army/command
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/gun/projectile/revolver/consul
	l_pocket = /obj/item/ammo_magazine/s44
	r_pocket = /obj/item/ammo_magazine/s44
	r_hand = /obj/item/clothing/accessory/holster/hip
	l_hand = /obj/item/clothing/accessory/tie/black

	headset = /obj/item/radio/headset/centcom
	headset_alt = /obj/item/radio/headset/centcom
	headset_earbud = /obj/item/radio/headset/centcom

/decl/hierarchy/outfit/USDF/Officer/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
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
	uniform = /obj/item/clothing/under/suit_jacket/navy
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/pen/blue
	r_pocket = /obj/item/pen/red
	r_hand = /obj/item/pda/centcom
	l_hand = /obj/item/clipboard

	headset = /obj/item/radio/headset/centcom
	headset_alt = /obj/item/radio/headset/centcom
	headset_earbud = /obj/item/radio/headset/centcom

/decl/hierarchy/outfit/solcom/representative/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
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
	uniform = /obj/item/clothing/under/imperial
	mask = /obj/item/clothing/mask/gas/imperial
	suit = /obj/item/clothing/suit/armor/combat/imperial
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/security/tactical/bandolier
	l_pocket = /obj/item/cell/device/weapon
	r_pocket = /obj/item/cell/device/weapon
	r_hand = /obj/item/melee/energy/sword/imperial
	l_hand = /obj/item/shield/energy/imperial
	suit_store = /obj/item/gun/energy/imperial

	headset = /obj/item/radio/headset/syndicate
	headset_alt = /obj/item/radio/headset/syndicate
	headset_earbud = /obj/item/radio/headset/syndicate

/decl/hierarchy/outfit/imperial/officer
	name = "Imperial officer"
	head = /obj/item/clothing/head/helmet/combat/imperial/centurion
	shoes = /obj/item/clothing/shoes/leg_guard/combat/imperial
	gloves = /obj/item/clothing/gloves/arm_guard/combat/imperial
	uniform = /obj/item/clothing/under/imperial
	mask = /obj/item/clothing/mask/gas/imperial
	suit = /obj/item/clothing/suit/armor/combat/imperial/centurion
	belt = /obj/item/storage/belt/security/tactical/bandolier
	l_pocket = /obj/item/cell/device/weapon
	r_pocket = /obj/item/cell/device/weapon
	r_hand = /obj/item/melee/energy/sword/imperial
	l_hand = /obj/item/shield/energy/imperial
	suit_store = /obj/item/gun/energy/imperial

	headset = /obj/item/radio/headset/syndicate
	headset_alt = /obj/item/radio/headset/syndicate
	headset_earbud = /obj/item/radio/headset/syndicate

/*
SOUTHERN CROSS OUTFITS
Keep outfits simple. Spawn with basic uniforms and minimal gear. Gear instead goes in lockers. Keep this in mind if editing.
*/


/decl/hierarchy/outfit/job/explorer2
	name = OUTFIT_JOB_NAME(JOB_EXPLORER)
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	id_slot = slot_wear_id
	pda_slot = slot_l_store
	pda_type = /obj/item/pda/explorer
	id_type = /obj/item/card/id/exploration
	id_pda_assignment = JOB_EXPLORER
	backpack = /obj/item/storage/backpack/explorer
	satchel_one = /obj/item/storage/backpack/satchel/explorer
	messenger_bag = /obj/item/storage/backpack/messenger/explorer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	headset = /obj/item/radio/headset/explorer
	headset_alt = /obj/item/radio/headset/alt/explorer
	headset_earbud = /obj/item/radio/headset/explorer

/decl/hierarchy/outfit/job/pilot
	name = OUTFIT_JOB_NAME(JOB_PILOT)
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1/no_webbing
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	uniform_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1 = 1)
	id_slot = slot_wear_id
	pda_slot = slot_belt
	pda_type = /obj/item/pda/pilot
	id_type = /obj/item/card/id/civilian/pilot
	id_pda_assignment = JOB_PILOT
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	headset = /obj/item/radio/headset/pilot
	headset_alt = /obj/item/radio/headset/alt/pilot
	headset_earbud = /obj/item/radio/headset/alt/pilot

/decl/hierarchy/outfit/job/medical/sar
	name = OUTFIT_JOB_NAME(JOB_FIELD_MEDIC)
	uniform = /obj/item/clothing/under/utility/blue
	//suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = slot_l_store
	pda_type = /obj/item/pda/sar
	id_type = /obj/item/card/id/exploration/fm
	id_pda_assignment = JOB_FIELD_MEDIC
	backpack = /obj/item/storage/backpack/explorer
	satchel_one = /obj/item/storage/backpack/satchel/explorer
	messenger_bag = /obj/item/storage/backpack/messenger/explorer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

	headset = /obj/item/radio/headset/sar
	headset_alt = /obj/item/radio/headset/alt/sar
	headset_earbud = /obj/item/radio/headset/sar

/decl/hierarchy/outfit/job/pathfinder
	name = OUTFIT_JOB_NAME(JOB_PATHFINDER)
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer //TODO: Uniforms.
	id_slot = slot_wear_id
	pda_slot = slot_l_store
	pda_type = /obj/item/pda/pathfinder
	id_type = /obj/item/card/id/exploration/head
	id_pda_assignment = JOB_PATHFINDER
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

	headset = /obj/item/radio/headset/pathfinder
	headset_alt = /obj/item/radio/headset/alt/pathfinder
	headset_earbud = /obj/item/radio/headset/pathfinder

/decl/hierarchy/outfit/job/assistant/explorer
	id_type = /obj/item/card/id/exploration
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
