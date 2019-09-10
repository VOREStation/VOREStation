/decl/hierarchy/outfit/USDF/Marine
	name = "USDF marine"
	uniform = /obj/item/clothing/under/solgov/utility/marine/green
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
	head = /obj/item/clothing/head/dress/marine/command/admiral
	shoes = /obj/item/clothing/shoes/boots/jackboots
	l_ear = /obj/item/device/radio/headset/centcom
	uniform = /obj/item/clothing/under/solgov/mildress/marine/command
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

/decl/hierarchy/outfit/solgov/representative
	name = "SolGov Representative"
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/centcom
	uniform = /obj/item/clothing/under/suit_jacket/navy
	back = /obj/item/weapon/storage/backpack/satchel
	l_pocket = /obj/item/weapon/pen/blue
	r_pocket = /obj/item/weapon/pen/red
	r_hand = /obj/item/device/pda/centcom
	l_hand = /obj/item/weapon/clipboard

/decl/hierarchy/outfit/solgov/representative/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.name = "[H.real_name]'s SolGov ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "SolGov Representative"
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
