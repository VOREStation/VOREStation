/datum/job/centcom_officer //For Business
	title = "CentCom Officer"
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_modifier = 20
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/centcom_officer
	job_description = "A Central Command Officer is there on official business. Most of time. Whatever it is, they're a VIP."

	minimum_character_age = 25
	ideal_character_age = 40

	pto_type = PTO_CIVILIAN

	get_access()
		return get_all_accesses().Copy()

/*/datum/job/centcom_visitor //For Pleasure // You mean for admin abuse... -Ace
	title = "CentCom Visitor"
	department = "Civilian"
	head_position = 1
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	idtype = /obj/item/weapon/card/id/centcom
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_modifier = 20
	whitelist_only = 1
	latejoin_only = 1

	minimum_character_age = 25
	ideal_character_age = 40

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/centcom(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom, slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/centcom(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/omnihud(H), slot_l_store)

		H.implant_loyalty()

		return 1

	get_access()
		var/access = get_all_accesses()
		return access*/

/datum/job/clown
	title = "Clown"
	flag = CLOWN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the spirit of laughter"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	job_description = "A Clown is there to entertain the crew and keep high morale using various harmless pranks and ridiculous jokes!"
	alt_titles = list("Clown" = /datum/alt_title/clown, "Comedian" = /datum/alt_title/comedian, "Jester" = /datum/alt_title/jester)
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/clown
	pto_type = PTO_CIVILIAN

/datum/alt_title/clown
	title = "Clown"

/datum/alt_title/comedian
	title = "Comedian"

/datum/alt_title/jester
	title = "Jester"

/datum/job/clown/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/mime
	title = "Mime"
	flag = MIME
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the spirit of performance"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	job_description = "A Mime is there to entertain the crew and keep high morale using unbelievable performances and acting skills!"
	alt_titles = list("Mime" = /datum/alt_title/mime, "Performer" = /datum/alt_title/performer, "Interpretive Dancer" = /datum/alt_title/interpretive_dancer)
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/mime
	pto_type = PTO_CIVILIAN

/datum/alt_title/mime
	title = "Mime"

/datum/alt_title/performer
	title = "Performer"

/datum/alt_title/interpretive_dancer
	title = "Interpretive Dancer"

/datum/job/mime/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
