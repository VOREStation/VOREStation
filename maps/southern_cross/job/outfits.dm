//Job Outfits

/*
SOUTHERN CROSS OUTFITS
Keep outfits simple. Spawn with basic uniforms and minimal gear. Gear instead goes in lockers. Keep this in mind if editing.
*/


/decl/hierarchy/outfit/job/explorer2
	name = OUTFIT_JOB_NAME("Explorer")
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	l_ear = /obj/item/device/radio/headset/explorer
	id_slot = slot_wear_id
	pda_slot = slot_l_store
	pda_type = /obj/item/device/pda/cargo // Brown looks more rugged
	id_type = /obj/item/weapon/card/id/civilian/explorer
	id_pda_assignment = "Explorer"

/decl/hierarchy/outfit/job/explorer2/technician
	name = OUTFIT_JOB_NAME("Explorer Technician")
	belt = /obj/item/weapon/storage/belt/utility/full
	pda_slot = slot_l_store
	id_pda_assignment = "Explorer Technician"

/decl/hierarchy/outfit/job/explorer2/medic
	name = OUTFIT_JOB_NAME("Explorer Medic")
	l_hand = /obj/item/weapon/storage/firstaid/regular
	pda_slot = slot_l_store
	id_pda_assignment = "Explorer Medic"

/decl/hierarchy/outfit/job/pilot
	name = OUTFIT_JOB_NAME("Pilot")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	l_ear = /obj/item/device/radio/headset/pilot
	id_slot = slot_wear_id
	pda_slot = slot_belt
	pda_type = /obj/item/device/pda/cargo // Brown looks more rugged
	id_type = /obj/item/weapon/card/id/civilian/pilot
	id_pda_assignment = "Pilot"

/decl/hierarchy/outfit/job/medical/sar
	name = OUTFIT_JOB_NAME("Search and Rescue")
	uniform = /obj/item/clothing/under/utility/blue
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_ear = /obj/item/device/radio/headset/headset_sar
	l_hand = /obj/item/weapon/storage/firstaid/adv
	belt = /obj/item/weapon/storage/belt/medical/emt
	pda_slot = slot_l_store
	id_type = /obj/item/weapon/card/id/medical/sar
	id_pda_assignment = "Search and Rescue"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
