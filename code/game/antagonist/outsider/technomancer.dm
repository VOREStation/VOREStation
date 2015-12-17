var/datum/antagonist/technomancer/technomancers

/datum/antagonist/technomancer
	id = MODE_WIZARD
	role_type = BE_WIZARD
	role_text = "Technomancer"
	role_text_plural = "Technomancers"
	bantype = "wizard"
	landmark_id = "wizard"
	welcome_text = "To be written"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudwizard"

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/technomancer/New()
	..()
	technomancers = src

/datum/antagonist/technomancer/update_antag_mob(var/datum/mind/technomancer)
	..()
	technomancer.store_memory("<B>Remember:</B> do not forget to prepare your functions.")
	technomancer.current.real_name = "[pick(wizard_first)] [pick(wizard_second)]"
	technomancer.current.name = technomancer.current.real_name

/datum/antagonist/technomancer/equip(var/mob/living/carbon/human/technomancer_mob)

	if(!..())
		return 0

	technomancer_mob.equip_to_slot_or_del(new /obj/item/device/radio/headset(technomancer_mob), slot_l_ear)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/under/psysuit(technomancer_mob), slot_w_uniform)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(technomancer_mob), slot_shoes)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/psypurple(technomancer_mob), slot_wear_suit)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/amp(technomancer_mob), slot_head)
	if(technomancer_mob.backbag == 2) technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(technomancer_mob), slot_back)
	if(technomancer_mob.backbag == 3) technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(technomancer_mob), slot_back)
	if(technomancer_mob.backbag == 4) technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(technomancer_mob), slot_back)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box(technomancer_mob), slot_in_backpack)
//	technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll(technomancer_mob), slot_r_store)
//	technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/spellbook(technomancer_mob), slot_r_hand)
	technomancer_mob.update_icons()
	return 1

/datum/antagonist/technomancer/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - technomancer killed")
		world << "<span class='danger'><font size = 3>The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been \
		killed by the crew!</font></span>"
