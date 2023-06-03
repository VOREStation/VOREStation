
//Works using the event_consent_list associative list. key is ckey, value is time they pressed the button.
//List expanded by /client/verb/show_event_interest()
/client/proc/assess_player_readiness()
	set name = "Assess player Interest"
	set desc = "Obtain a list of players who are actively and eagerly OK with their rounds being disrupted by events."
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	log_and_message_admins("has checked the event consent list", usr)

	var/message = "The following players have shown interest in their rounds being shaken up: \n"
	var/alive = 0
	var/counter = 0
	var/consenters = LAZYLEN(event_consent_list) //Stopping iteration early if we found all our people

	for(var/mob/player in player_list)

		//We skip if the current player's ckey is not in the volunteer list
		if(!event_consent_list[player.key])
			continue

		if(istype(player, /mob/living)) //If it is, and it's alive - we can check where they are.
			var/mob/living/L = player
			var/area = get_area(L)
			var/elapsed_time = (world.time - event_consent_list[L.key]) / (60 SECONDS)
			var/activity = L.client.inactivity / (60 SECONDS)
			if(activity > 30)
				to_chat(L, SPAN_NOTICE("As you are inactive, you were removed from list of players \
				showing active interest in their rounds being shaken up."))
				event_consent_list -= L.key
				continue
			message += "[player] ([L.key]) opted in [elapsed_time] minutes ago. They were last active [activity] minutes ago.\n \
			Current location: [area] \n"
			alive += 1
		else  //Otherwise, they're likely dead.
			var/elapsed_time = (world.time - event_consent_list[player.key]) / (60 SECONDS)
			var/activity = player.client.inactivity / (60 SECONDS)
			if(activity > 30)
				to_chat(player, SPAN_NOTICE("As you are inactive, you were removed from list of players \
				showing active interest in their rounds being shaken up."))
				event_consent_list -= player.key
				continue
			message += "[player] ([player.key]) opted in [elapsed_time] minutes ago. They were last active [activity] minutes ago.\n \
			They're likely dead, right now.\n"

		counter += 1
		if(counter > consenters) //We found all players who are open to spice!
			break

	message += "In total, there are [alive] currently-living players available for events!"
	to_chat(usr, SPAN_NOTICE(message))








/datum/event_readiness
	var/list/names = list()
	var/list/time_consented = list()
	var/list/refs = list()
	var/list/status = list()
