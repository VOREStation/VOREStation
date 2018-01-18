//These are a copy of Polaris' Southern Cross jobs

var/const/access_pilot = 67
var/const/access_explorer = 43

////////////////////////////////////////////////////////////

/datum/access/pilot
	id = access_pilot
	desc = "Pilot"
	region = ACCESS_REGION_SUPPLY

/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

////////////////////////////////////////////////////////////

/obj/item/weapon/card/id/medical/sar
	assignment = "Search and Rescue"
	rank = "Search and Rescue"
	job_access_type = /datum/job/sar

/obj/item/weapon/card/id/civilian/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/job/pilot

/obj/item/weapon/card/id/civilian/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/job/explorer

////////////////////////////////////////////////////////////

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	department = "Civilian"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/pilot
	economic_modifier = 4
	whitelist_only = 1
	latejoin_only = 1
	access = list(access_pilot, access_cargo, access_mining, access_mining_station)
	minimal_access = list(access_pilot, access_cargo, access_mining, access_mining_station)
	outfit_type = /decl/hierarchy/outfit/job/pilot

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the explorer leader and the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/explorer
	economic_modifier = 4
	whitelist_only = 1
	latejoin_only = 1
	access = list(access_pilot, access_explorer)
	minimal_access = list(access_pilot, access_explorer)
	outfit_type = /decl/hierarchy/outfit/job/explorer2
/* I split this into multiple jobs because it's set to latejoin_only, which means you can't see it to select alt titles.
	alt_titles = list(
		"Explorer Technician" = /decl/hierarchy/outfit/job/explorer2/technician,
		"Explorer Medic" = /decl/hierarchy/outfit/job/explorer2/medic)
*/

/datum/job/explorer/technician
	title = "Explorer Technician"
	flag = EXPLORER_T
	outfit_type = /decl/hierarchy/outfit/job/explorer2/technician

/datum/job/explorer/medic
	title = "Explorer Medic"
	flag = EXPLORER_M
	outfit_type = /decl/hierarchy/outfit/job/explorer2/medic

/datum/job/sar
	title = "Search and Rescue"
	flag = SAR
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/medical
	economic_modifier = 4
	whitelist_only = 1
	latejoin_only = 1
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist, access_explorer)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_explorer)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar

////////////////////////////////////////////////////////////

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
	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/storage/toggle/bomber
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
	l_hand = /obj/item/weapon/storage/firstaid/adv
	belt = /obj/item/weapon/storage/belt/medical/emt
	pda_slot = slot_l_store
	id_type = /obj/item/weapon/card/id/medical/sar
	id_pda_assignment = "Search and Rescue"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

////////////////////////////////////////////////////////////

/obj/item/device/encryptionkey/pilot
	name = "pilot's encryption key"
	icon_state = "com_cypherkey"
	channels = list("Supply" = 1, "Explorer" = 1)

/obj/item/device/encryptionkey/explorer
	name = "explorer radio encryption key"
	icon_state = "com_cypherkey"
	channels = list("Explorer" = 1)

////////////////////////////////////////////////////////////

/obj/item/device/radio/headset/pilot
	name = "pilot's headset"
	desc = "A bowman headset used by pilots, has access to supply and explorer channels."
	icon_state = "cargo_headset_alt"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/pilot

/obj/item/device/radio/headset/explorer
	name = "explorer's headset"
	desc = "Headset used by explorers for exploring. Access to the explorer channel."
	icon_state = "mine_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/explorer

////////////////////////////////////////////////////////////

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	name = "search and rescue winter coat"
	desc = "A heavy winter jacket. A white star of life is emblazoned on the back, with the words search and rescue written underneath."
	icon_state = "coatsar"
	item_icons = list(slot_wear_suit_str = 'maps/southern_cross/icons/mob/sc_suit.dmi')
	icon = 'maps/southern_cross/icons/obj/sc_suit.dmi'
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 5)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
