var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Colony Director"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	alt_titles = list("Site Manager", "Overseer")
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = 25
	ideal_character_age = 70 // Old geezer captains ftw


/datum/job/captain/equip(var/mob/living/carbon/human/H, var/alt_title)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(H), slot_l_ear)
	switch(H.backbag)
		if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/captain(H), slot_back)
		if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/cap(H), slot_back)
		if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		if(5) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/messenger/com(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
	if(H.age>49)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.w_uniform
		var/obj/item/clothing/accessory/medal/gold/captain/medal = new()

		if(uniform && uniform.can_attach_accessory(medal))
			uniform.attach_accessory(null, medal)
		else
			qdel(medal)
	H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), slot_l_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), slot_in_backpack)


	H.implant_loyalty()

	return 1

/datum/job/captain/get_access()
	return get_all_station_access()



/datum/job/hop
	title = "Head of Personnel"
	flag = HOP
	department = "Civilian"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Colony Director"
	selection_color = "#2F2F7F"
	idtype = /obj/item/weapon/card/id/silver
	alt_titles = list("Crew Resources Officer")
	req_admin_notify = 1
	minimal_player_age = 10
	economic_modifier = 10

	minimum_character_age = 25
	ideal_character_age = 50

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)


/datum/job/hop/equip(var/mob/living/carbon/human/H, var/alt_title)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hop(H), slot_l_ear)
	switch(H.backbag)
		if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/norm(H), slot_back)
		if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_personnel(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hop(H), slot_belt)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), slot_l_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), slot_in_backpack)
	H.implant_loyalty()
	return 1



/datum/job/secretary
	title = "Command Secretary"
	flag = BRIDGE
	department = "Civilian"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "command staff"
	selection_color = "#2F2F7F"
	idtype = /obj/item/weapon/card/id/silver
	alt_titles = list("Command Liaison", "Bridge Secretary")
	minimal_player_age = 5
	economic_modifier = 7

	access = list(access_heads)
	minimal_access = list(access_heads)

/datum/job/secretary/equip(var/mob/living/carbon/human/H, var/alt_title)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_com(H), slot_l_ear)
	switch(H.backbag)
		if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/norm(H), slot_back)
		if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hop(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_l_hand)
	if(H.gender == FEMALE)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/female/skirt(H), slot_w_uniform)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/charcoal(H), slot_w_uniform)
	return 1