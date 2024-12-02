/decl/hierarchy/outfit/job/medical
	hierarchy_type = /decl/hierarchy/outfit/job/medical
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/pda/medical
	pda_slot = slot_l_store

	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med

	headset = /obj/item/radio/headset/headset_med
	headset_alt = /obj/item/radio/headset/alt/headset_med
	headset_earbud = /obj/item/radio/headset/earbud/headset_med

/decl/hierarchy/outfit/job/medical/cmo
	name = OUTFIT_JOB_NAME(JOB_CHIEF_MEDICAL_OFFICER)
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/storage/firstaid/adv
	r_pocket = /obj/item/healthanalyzer
	id_type = /obj/item/card/id/medical/head
	pda_type = /obj/item/pda/heads/cmo

	headset = /obj/item/radio/headset/heads/cmo
	headset_alt = /obj/item/radio/headset/alt/heads/cmo
	headset_earbud = /obj/item/radio/headset/earbud/heads/cmo

/decl/hierarchy/outfit/job/medical/doctor
	name = OUTFIT_JOB_NAME(JOB_MEDICAL_DOCTOR)
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/regular
	r_pocket = /obj/item/flashlight/pen
	id_type = /obj/item/card/id/medical

/decl/hierarchy/outfit/job/medical/doctor/emergency_physician
	name = OUTFIT_JOB_NAME(JOB_ALT_EMERGENCY_PHYSICIAN)
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket

/decl/hierarchy/outfit/job/medical/doctor/surgeon
	name = OUTFIT_JOB_NAME(JOB_ALT_SURGEON)
	uniform = /obj/item/clothing/under/rank/medical/scrubs
	head = /obj/item/clothing/head/surgery/blue

/decl/hierarchy/outfit/job/medical/doctor/virologist
	name = OUTFIT_JOB_NAME(JOB_ALT_VIROLOGIST)
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/virologist
	mask = /obj/item/clothing/mask/surgical
	backpack = /obj/item/storage/backpack/virology
	satchel_one = /obj/item/storage/backpack/satchel/vir

/decl/hierarchy/outfit/job/medical/doctor/nurse
	name = OUTFIT_JOB_NAME(JOB_ALT_NURSE)
	suit = null

/decl/hierarchy/outfit/job/medical/doctor/nurse/pre_equip(mob/living/carbon/human/H)
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/scrubs/purple
	..()

/decl/hierarchy/outfit/job/medical/chemist
	name = OUTFIT_JOB_NAME(JOB_CHEMIST)
	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	backpack = /obj/item/storage/backpack/chemistry
	satchel_one = /obj/item/storage/backpack/satchel/chem
	sports_bag = /obj/item/storage/backpack/sport/chem
	id_type = /obj/item/card/id/medical/chemist
	pda_type = /obj/item/pda/chemist

/decl/hierarchy/outfit/job/medical/geneticist
	name = OUTFIT_JOB_NAME(JOB_GENETICIST)
	uniform = /obj/item/clothing/under/rank/geneticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/genetics
	backpack = /obj/item/storage/backpack/genetics
	r_pocket = /obj/item/flashlight/pen
	satchel_one = /obj/item/storage/backpack/satchel/gen
	id_type = /obj/item/card/id/medical/geneticist
	pda_type = /obj/item/pda/geneticist

/decl/hierarchy/outfit/job/medical/psychiatrist
	name = OUTFIT_JOB_NAME(JOB_PSYCHIATRIST)
	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/card/id/medical/psych

/decl/hierarchy/outfit/job/medical/psychiatrist/psychologist
	name = OUTFIT_JOB_NAME(JOB_ALT_PSYCHOLOGIST)
	uniform = /obj/item/clothing/under/rank/psych/turtleneck

/decl/hierarchy/outfit/job/medical/paramedic
	name = OUTFIT_JOB_NAME(JOB_PARAMEDIC)
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/boots/jackboots
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = slot_l_store
	id_type = /obj/item/card/id/medical/emt
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/medical/paramedic/emt
	name = OUTFIT_JOB_NAME(JOB_ALT_EMERGENCY_MEDICAL_TECHNICIAN)
	uniform = /obj/item/clothing/under/rank/medical/paramedic_alt
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/emt
