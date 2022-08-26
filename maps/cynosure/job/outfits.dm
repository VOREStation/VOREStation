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
	pda_type = /obj/item/pda/cargo // Brown looks more rugged
	id_type = /obj/item/card/id/civilian
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
	uniform = /obj/item/clothing/under/rank/pilot1
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	l_ear = /obj/item/radio/headset/explorer/alt
	id_slot = slot_wear_id
	pda_slot = slot_belt
	pda_type = /obj/item/pda/cargo // Brown looks more rugged
	id_type = /obj/item/card/id/civilian
	id_pda_assignment = "Pilot"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/medical/sar
	name = OUTFIT_JOB_NAME("Search and Rescue")
	uniform = /obj/item/clothing/under/utility/blue
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_ear = /obj/item/radio/headset/sar
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = slot_l_store
	id_type = /obj/item/card/id/medical
	id_pda_assignment = "Search and Rescue"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/survivalist
	name = OUTFIT_JOB_NAME("Survivalist")
	l_ear =    null
	r_ear =    null
	pda_slot = null
	pda_type = null
	id_slot =  null
	id_type =  null
	mask =     /obj/item/clothing/mask/gas
	r_pocket = /obj/item/tank/emergency/oxygen/double
	l_pocket = /obj/item/radio
	uniform =  /obj/item/clothing/under/ascetic
	shoes =    /obj/item/clothing/shoes/boots/winter
	suit =     /obj/item/clothing/suit/storage/hooded/wintercoat
	belt =     /obj/item/gun/energy/phasegun/pistol // better make that cell count

/decl/hierarchy/outfit/job/survivalist/equip(mob/living/carbon/human/H, rank, assignment)
	. = ..()
	if(H && H.shoes)
		var/obj/item/clothing/shoes/shoes = H.shoes
		if(istype(shoes) && !shoes.holding && shoes.can_hold_knife)
			shoes.holding = new /obj/item/material/knife/tacknife/survival(H)
			shoes.update_icon()

/decl/hierarchy/outfit/job/survivalist/crash_survivor
	name = OUTFIT_JOB_NAME("Crash Survivor")
	uniform = /obj/item/clothing/under/color/lightblue
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/space/emergency
	suit = /obj/item/clothing/suit/space/emergency
	suit_store = /obj/item/tank/oxygen
	mask = null

// This is basically a joke for the service drake spawn alt title.
/decl/hierarchy/outfit/siffet
	name = OUTFIT_JOB_NAME("Siffet")
	suit = /obj/item/clothing/suit/storage/hooded/costume/siffet
	head = /obj/item/clothing/head/hood/siffet_hood
