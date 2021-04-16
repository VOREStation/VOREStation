/decl/hierarchy/outfit/job/centcom_officer
	name = OUTFIT_JOB_NAME("CentCom Officer")
	uniform = /obj/item/clothing/under/rank/centcom
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/beret/centcom/officer
	l_ear = /obj/item/device/radio/headset/centcom
	glasses = /obj/item/clothing/glasses/omnihud/all
	id_type = /obj/item/weapon/card/id/centcom
	pda_type = /obj/item/device/pda/centcom
	flags = OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

/decl/hierarchy/outfit/job/emergency_responder
	name = OUTFIT_JOB_NAME("Emergency Responder")
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/boots/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/weapon/storage/backpack/satchel
	id_type = /obj/item/weapon/card/id/centcom/ERT
	pda_type = /obj/item/device/pda/centcom
	flags = OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

	post_equip(var/mob/living/carbon/human/H)
		..()
		ert.add_antagonist(H.mind)

/decl/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	back = /obj/item/weapon/storage/backpack/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	backpack_contents = list(/obj/item/weapon/stamp/clown = 1, /obj/item/weapon/bikehorn = 1)
	id_type = /obj/item/weapon/card/id/civilian/clown
	pda_type = /obj/item/device/pda/clown
	flags = 0

/decl/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
	shoes = /obj/item/clothing/shoes/mime
	head = /obj/item/clothing/head/soft/mime
	mask = /obj/item/clothing/mask/gas/mime
	backpack_contents = list(/obj/item/weapon/pen/crayon/mime = 1)
	id_type = /obj/item/weapon/card/id/civilian/mime
	pda_type = /obj/item/device/pda/mime

	post_equip(var/mob/living/carbon/human/H)
		..()
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/pen/crayon/mime(H), slot_l_hand)
