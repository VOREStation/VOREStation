/decl/hierarchy/outfit/spec_op_officer
	name = "Special ops - Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/beret	//deathsquad
	belt = /obj/item/gun/energy/pulse_rifle/compact/admin
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/boots/combat
	gloves = /obj/item/clothing/gloves/combat

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

	headset = /obj/item/radio/headset/ert
	headset_alt = /obj/item/radio/headset/ert
	headset_earbud = /obj/item/radio/headset/ert

/decl/hierarchy/outfit/spec_op_officer/space
	name = "Special ops - Officer in space"
	suit = /obj/item/clothing/suit/armor/swat	//obj/item/clothing/suit/space/void/swat
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas/swat

	flags = OUTFIT_HAS_JETPACK

/decl/hierarchy/outfit/ert
	name = "Spec ops - Emergency response team"
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/boots/swat
	gloves = /obj/item/clothing/gloves/swat
	belt = /obj/item/gun/energy/gun
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/storage/backpack/satchel

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom/ERT

	headset = /obj/item/radio/headset/ert
	headset_alt = /obj/item/radio/headset/ert
	headset_earbud = /obj/item/radio/headset/ert

/decl/hierarchy/outfit/death_command
	name = "Spec ops - Death commando"

/decl/hierarchy/outfit/death_command/equip(var/mob/living/carbon/human/H)
	GLOB.deathsquad.equip(H)
	return 1

/decl/hierarchy/outfit/syndicate_command
	name = "Spec ops - Syndicate commando"

/decl/hierarchy/outfit/syndicate_command/equip(var/mob/living/carbon/human/H)
	GLOB.commandos.equip(H)
	return 1

/decl/hierarchy/outfit/mercenary
	name = "Spec ops - Mercenary"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/boots/combat
	belt = /obj/item/storage/belt/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/swat

	l_pocket = /obj/item/reagent_containers/pill/cyanide

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/syndicate
	id_pda_assignment = "Mercenary"

	headset = /obj/item/radio/headset/syndicate
	headset_alt = /obj/item/radio/headset/alt/syndicate
	headset_earbud = /obj/item/radio/headset/earbud/syndicate

	flags = OUTFIT_HAS_BACKPACK
