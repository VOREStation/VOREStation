var/datum/antagonist/mercenary/mercs

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_type = BE_OPERATIVE
	role_text = "Mercenary"
	bantype = "operative"
	antag_indicator = "synd"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	id_type = /obj/item/card/id/syndicate
	antaghud_indicator = "hudoperative"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 3
	initial_spawn_target = 3

/datum/antagonist/mercenary/New()
	..()
	mercs = src

/datum/antagonist/mercenary/create_global_objectives()
	if(!..())
		return 0
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear
	return 1

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	if(player.backbag == 2) player.equip_to_slot_or_del(new /obj/item/storage/backpack(player), slot_back)
	if(player.backbag == 3) player.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(player), slot_back)
	if(player.backbag == 4) player.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(player), slot_back)
	if(player.backbag == 5) player.equip_to_slot_or_del(new /obj/item/storage/backpack/messenger(player), slot_back)
	if(player.backbag == 6) player.equip_to_slot_or_del(new /obj/item/storage/backpack/sport(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/reagent_containers/pill/cyanide(player), slot_in_backpack)

	player.mind.tcrystals = DEFAULT_TELECRYSTAL_AMOUNT
	player.mind.accept_tcrystals = 1

	var/obj/item/radio/uplink/U = new(player.loc, player.mind, DEFAULT_TELECRYSTAL_AMOUNT)
	player.put_in_hands(U)

	create_id("Mercenary", player)
	create_radio(SYND_FREQ, player)
	return 1
