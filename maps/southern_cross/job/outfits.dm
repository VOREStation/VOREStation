//Job Outfits

/*
SOUTHERN CROSS OUTFITS
Keep outfits simple. Spawn with basic uniforms and minimal gear. Gear instead goes in lockers. Keep this in mind if editing.
*/


/decl/hierarchy/outfit/job/explorer2
	name = OUTFIT_JOB_NAME("Explorer")
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	l_ear = /obj/item/radio/headset/explorer
	id_slot = slot_wear_id
	pda_slot = slot_l_store
<<<<<<< HEAD
	pda_type = /obj/item/device/pda/explorer //VORESTation Edit - Better Brown
	id_type = /obj/item/weapon/card/id/science/explorer
=======
	pda_type = /obj/item/pda/cargo // Brown looks more rugged
	id_type = /obj/item/card/id/science/explorer
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	id_pda_assignment = "Explorer"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/planetside = 1)

/decl/hierarchy/outfit/job/explorer2/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/planetside/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/explorer2/technician
	name = OUTFIT_JOB_NAME("Explorer Technician")
	belt = /obj/item/storage/belt/utility/full
	pda_slot = slot_l_store
	id_pda_assignment = "Explorer Technician"

/decl/hierarchy/outfit/job/explorer2/medic
	name = OUTFIT_JOB_NAME("Explorer Medic")
	l_hand = /obj/item/storage/firstaid/regular
	pda_slot = slot_l_store
	id_pda_assignment = "Explorer Medic"

/decl/hierarchy/outfit/job/pilot
	name = OUTFIT_JOB_NAME("Pilot")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1/no_webbing
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	l_ear = /obj/item/radio/headset/pilot/alt
	uniform_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1 = 1)
	id_slot = slot_wear_id
	pda_slot = slot_belt
<<<<<<< HEAD
	pda_type = /obj/item/device/pda //VOREStation Edit - Civilian
	id_type = /obj/item/weapon/card/id/civilian/pilot
=======
	pda_type = /obj/item/pda/cargo // Brown looks more rugged
	id_type = /obj/item/card/id/civilian/pilot
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	id_pda_assignment = "Pilot"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/medical/sar
	name = OUTFIT_JOB_NAME("Field Medic") //VOREStation Edit
	uniform = /obj/item/clothing/under/utility/blue
	//suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar //VOREStation Edit
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_ear = /obj/item/radio/headset/sar
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = slot_l_store
<<<<<<< HEAD
	id_type = /obj/item/weapon/card/id/medical/sar
	pda_type = /obj/item/device/pda/sar //VOREStation Add
	id_pda_assignment = "Field Medic" //VOREStation Edit
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL
=======
	id_type = /obj/item/card/id/medical/sar
	id_pda_assignment = "Search and Rescue"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
