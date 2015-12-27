var/datum/antagonist/technomancer/technomancers

/datum/antagonist/technomancer
	id = MODE_TECHNOMANCER
	role_type = BE_WIZARD
	role_text = "Technomancer"
	role_text_plural = "Technomancers"
	bantype = "wizard"
	landmark_id = "wizard"
	welcome_text = "To be written"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE | ANTAG_VOTABLE
	antaghud_indicator = "hudwizard"

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1

	id_type = /obj/item/weapon/card/id/syndicate

/datum/antagonist/technomancer/New()
	..()
	technomancers = src

/datum/antagonist/technomancer/update_antag_mob(var/datum/mind/technomancer)
	..()
	technomancer.store_memory("<B>Remember:</B> do not forget to prepare your RIG.")
	technomancer.current.real_name = "[pick(wizard_first)] [pick(wizard_second)]"
	technomancer.current.name = technomancer.current.real_name

/datum/antagonist/technomancer/equip(var/mob/living/carbon/human/technomancer_mob)

	if(!..())
		return 0

	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(technomancer_mob), slot_w_uniform)
	create_id("Technomage", technomancer_mob)
	var/obj/item/weapon/rig/light/technomancer/magesuit = new(get_turf(technomancer_mob))
	magesuit.seal_delay = 0
	technomancer_mob.put_in_hands(magesuit)
	technomancer_mob.equip_to_slot_or_del(magesuit,slot_back)
	if(magesuit)
		magesuit.toggle_seals(src,1)
		magesuit.seal_delay = initial(magesuit.seal_delay)

	technomancer_mob.equip_to_slot_or_del(new /obj/item/device/radio/headset(technomancer_mob), slot_l_ear)
	if(technomancer_mob.backbag == 2) technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(technomancer_mob), slot_back)
	if(technomancer_mob.backbag == 3) technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(technomancer_mob), slot_back)
	if(technomancer_mob.backbag == 4) technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(technomancer_mob), slot_back)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box(technomancer_mob), slot_in_backpack)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/device/flashlight(technomancer_mob), slot_belt)
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
		killed!</font></span>"
