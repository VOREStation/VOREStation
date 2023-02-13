/*Main file that controls frequency of OOC player tips
Whether player tips start firing at all is determined by a global preference
Weighted list of player tips held in a separate file.
Controlled by the player_tips subsystem under code/controllers/subsystems/player_tips

*/

/datum/player_tips
	var/min_tip_delay = 45 MINUTES
	var/max_tip_delay = 75 MINUTES
	var/tip_delay = 5 MINUTES //10 minute initial delay for first tip of the day. Timer starts 5 minutes after game starts, plus 5 minutes here. Gets overwritten afterwards
	var/last_tip_time = 0
	var/last_tip = null

//Called every 5 minutes as defined in the subsystem.
/datum/player_tips/proc/send_tips()
	if(world.time > last_tip_time + tip_delay)
		var/tip = pick_tip("none") //"none" picks a random topic of advice.
		var/stopWhile = 0
		while(tip == last_tip) //Prevent posting the same tip twice in a row if possible, but don't force it.
			tip = pick_tip("none")
			stopWhile = stopWhile + 1
			if(stopWhile >= 10)
				break

		for(var/mob/M in player_list)
			if(M.is_preference_enabled(/datum/client_preference/player_tips))
				if(!last_tip) //Notifying players how to turn tips off, or call them on-demand in a personalized manner.
					to_chat(M, SPAN_WARNING("You have periodic player tips enabled. You may turn them off at any time with the Toggle Receiving Player Tips verb in Preferences, or in character set up under the OOC tab!\n Player tips appear every 45-75 minutes."))
				to_chat(M, SPAN_NOTICE("[tip]"))

		last_tip = tip
		last_tip_time = world.time
		tip_delay = rand(min_tip_delay, max_tip_delay)





/mob/living/verb/request_automated_advice()
	set name = "Request Automated Advice"
	set desc = "Sends you advice from a list of possibilities. You can choose to request a specific topic."
	set category = "OOC"

	var/choice = tgui_input_list(src, "What topic would you like to receive advice on?", "Select Topic", list("none","general","gameplay","roleplay","lore","cancel"))
	if(choice == "cancel")
		return
	var/static/datum/player_tips/player_tips = new
	to_chat(src, SPAN_NOTICE("[player_tips.pick_tip(choice)]"))
