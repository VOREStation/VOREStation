var/datum/antagonist/trader/traders

/datum/antagonist/trader
	id = MODE_TRADE
	role_type = BE_OPERATIVE
	role_text = "Trader"
	role_text_plural = "Traders"
	welcome_text = "As a crewmember of the Beruang, you answer to your captain and international laws of space."
	antag_sound = 'sound/effects/antag_notice/general_goodie_alert.ogg'
	antag_text = "You are an <b>non-antagonist</b> visitor! Within the rules, \
		try to provide interesting interaction for the crew. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules apply to you.</b>"
	leader_welcome_text = "As Captain of the Beruang, you have control over your crew and cargo. It may be worth briefly discussing a consistent shared backstory with your crew."
	landmark_id = "Trader"

	id_type = /obj/item/card/id/external

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7

	can_speak_aooc = FALSE // They're not real antags.

/datum/antagonist/trader/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/trader/New()
	..()
	traders = src

/datum/antagonist/trader/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "The Beruang is an independent cargo hauler, unless you decide otherwise. You're on your way to [station_name()].")
	to_chat(player.current, "You may want to discuss a collective story with the rest of your crew. More members may be joining, so don't move out straight away!")

/datum/antagonist/trader/equip(var/mob/living/carbon/human/player)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

	create_radio(PUB_FREQ, player) //Assume they tune their headsets into the station's public radio as they approach

	var/obj/item/card/id/id = create_id("Trader", player, equip = 0)
	id.name = "[player.real_name]'s Passport"
	id.assignment = "Trader"
	id.access |= access_trader
	var/obj/item/storage/wallet/W = new(player)
	W.handle_item_insertion(id)
	player.equip_to_slot_or_del(W, slot_wear_id)
	spawn_money(rand(50,150)*10,W)

	return 1

/datum/antagonist/trader/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.name = "[player.real_name]'s Passport"
			id.registered_name = player.real_name
			W.name = "[initial(W.name)] ([id.name])"