/decl/hierarchy/outfit/standard_space_gear
	name = "Standard space gear"
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/space
	uniform = /obj/item/clothing/under/color/grey
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/breath
	flags = OUTFIT_HAS_JETPACK

/decl/hierarchy/outfit/emergency_space_gear
	name = "Emergency space gear"
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/space/emergency
	suit = /obj/item/clothing/suit/space/emergency
	uniform = /obj/item/clothing/under/color/grey
	back = /obj/item/tank/oxygen
	mask = /obj/item/clothing/mask/breath

/decl/hierarchy/outfit/soviet_soldier
	name = "Soviet soldier"
	uniform = /obj/item/clothing/under/soviet
	shoes = /obj/item/clothing/shoes/boots/combat
	head = /obj/item/clothing/head/ushanka/soviet
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/gun/projectile/revolver/mateba

/decl/hierarchy/outfit/soviet_soldier/admiral
	name = "Soviet admiral"
	head = /obj/item/clothing/head/hgpiratecap
	l_ear = /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	suit = /obj/item/clothing/suit/hgpirate

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom	//station
	id_pda_assignment = "Admiral"

/decl/hierarchy/outfit/merchant
	name = "Merchant"
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/color/grey
	id_slot = slot_wear_id
	id_type = /obj/item/card/id/civilian	//merchant
	pda_slot = slot_r_store
	pda_type = /obj/item/pda/chef //cause I like the look
	id_pda_assignment = "Merchant"

/decl/hierarchy/outfit/merchant/vox
	name = "Merchant - Vox"
	shoes = /obj/item/clothing/shoes/boots/jackboots/toeless
	uniform = /obj/item/clothing/under/vox/vox_robes
	suit = /obj/item/clothing/suit/armor/vox_scrap

/decl/hierarchy/outfit/zaddat
	name = "Zaddat Suit"
	suit = /obj/item/clothing/suit/space/void/zaddat/
	mask = /obj/item/clothing/mask/gas/zaddat

/decl/hierarchy/outfit/maint_straggler
	name = "Maintenance Straggler Outfit"
	id_slot = slot_wear_id
	id_type = /obj/item/card/id/civilian/straggler
	pda_slot = slot_r_store
	id_pda_assignment = "NO DATA"
