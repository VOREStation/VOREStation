//Job Outfits

/*
SOUTHERN CROSS OUTFITS
Keep outfits simple. Spawn with basic uniforms and minimal gear. Gear instead goes in lockers. Keep this in mind if editing.
*/


/decl/hierarchy/outfit/job/explorer2
	name = OUTFIT_JOB_NAME("Explorer")
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	id_slot = slot_wear_id
	pda_slot = slot_l_store
	pda_type = /obj/item/pda/explorer //VORESTation Edit - Better Brown
	id_type = /obj/item/card/id/science/explorer
	id_pda_assignment = "Explorer"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/planetside = 1)

	headset = /obj/item/radio/headset/explorer
	headset_alt = /obj/item/radio/headset/explorer
	headset_earbud = /obj/item/radio/headset/explorer

/decl/hierarchy/outfit/job/explorer2/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/planetside/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/explorer2/technician
	name = OUTFIT_JOB_NAME(JOB_ALT_EXPLORERE_TECHNICIAN)
	belt = /obj/item/storage/belt/utility/full
	pda_slot = slot_l_store
	id_pda_assignment = JOB_ALT_EXPLORERE_TECHNICIAN

/decl/hierarchy/outfit/job/explorer2/medic
	name = OUTFIT_JOB_NAME(JOB_ALT_EXPLORER_MEDIC)
	l_hand = /obj/item/storage/firstaid/regular
	pda_slot = slot_l_store
	id_pda_assignment = JOB_ALT_EXPLORER_MEDIC

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
	pda_type = /obj/item/pda //VOREStation Edit - Civilian
	id_type = /obj/item/card/id/civilian/pilot
	id_pda_assignment = JOB_PILOT
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	headset = /obj/item/radio/headset/alt/pilot
	headset_alt = /obj/item/radio/headset/alt/pilot
	headset_earbud = /obj/item/radio/headset/alt/pilot

/decl/hierarchy/outfit/job/medical/sar
	name = OUTFIT_JOB_NAME("Field Medic") //VOREStation Edit
	uniform = /obj/item/clothing/under/utility/blue
	//suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar //VOREStation Edit
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = slot_l_store
	id_type = /obj/item/card/id/medical/sar
	pda_type = /obj/item/pda/sar //VOREStation Add
	id_pda_assignment = "Field Medic" //VOREStation Edit
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

	headset = /obj/item/radio/headset/sar
	headset_alt = /obj/item/radio/headset/sar
	headset_earbud = /obj/item/radio/headset/sar
