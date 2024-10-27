var/datum/antagonist/highlander/highlanders

/datum/antagonist/highlander
	role_text = "Highlander"
	role_text_plural = "Highlanders"
	welcome_text = "There can be only one."
	id = MODE_HIGHLANDER
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE //| ANTAG_RANDSPAWN | ANTAG_VOTABLE // Someday...

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 3
	initial_spawn_target = 5

	id_type = /obj/item/card/id/centcom/ERT

/datum/antagonist/highlander/New()
	..()
	highlanders = src

/datum/antagonist/highlander/create_objectives(var/datum/mind/player)

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = player
	steal_objective.set_target("nuclear authentication disk")
	player.objectives |= steal_objective

	var/datum/objective/hijack/hijack_objective = new
	hijack_objective.owner = player
	player.objectives |= hijack_objective

/datum/antagonist/highlander/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	// drop original items! It used to be a loop that just Qdeled everything including your organs!
	// Dropping because of non-oxy breathers... That would suck wouldn't it?
	player.drop_from_inventory(player.get_equipped_item(slot_wear_id))
	player.drop_from_inventory(player.get_equipped_item(slot_wear_suit))
	player.drop_from_inventory(player.get_equipped_item(slot_w_uniform))
	player.drop_from_inventory(player.get_equipped_item(slot_l_ear))
	player.drop_from_inventory(player.get_equipped_item(slot_head))
	player.drop_from_inventory(player.get_equipped_item(slot_l_hand))
	player.drop_from_inventory(player.get_equipped_item(slot_shoes))
	player.drop_from_inventory(player.get_equipped_item(slot_l_store))
	// highlanders!
	player.equip_to_slot_or_del(new /obj/item/clothing/under/kilt(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/head/beret(player), slot_head)
	player.equip_to_slot_or_del(new /obj/item/material/sword(player), slot_l_hand)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/combat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/pinpointer(get_turf(player)), slot_l_store)

	var/obj/item/card/id/id = create_id("Highlander", player)
	if(id)
		id.access |= get_all_station_access()
		id.icon_state = "centcom"
	create_radio(DTH_FREQ, player)

/proc/only_one()

	if(!ticker)
		tgui_alert_async(usr,"The game hasn't started yet!")
		return

	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		highlanders.add_antagonist(H.mind)

	message_admins(span_notice("[key_name_admin(usr)] used THERE CAN BE ONLY ONE!"), 1)
	log_admin("[key_name(usr)] used there can be only one.")
