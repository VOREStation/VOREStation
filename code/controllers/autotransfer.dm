var/datum/controller/transfer_controller/transfer_controller

/datum/controller/transfer_controller
	var/timerbuffer = 0 //buffer for time check
	var/currenttick = 0
	var/shift_hard_end = 0 //VOREStation Edit
	var/shift_last_vote = 0 //VOREStation Edit

/datum/controller/transfer_controller/New()
	timerbuffer = CONFIG_GET(number/vote_autotransfer_initial)
	shift_hard_end = CONFIG_GET(number/vote_autotransfer_initial) + (CONFIG_GET(number/vote_autotransfer_interval) * 0) //VOREStation Edit //Change this "1" to how many extend votes you want there to be.
	shift_last_vote = shift_hard_end - CONFIG_GET(number/vote_autotransfer_interval) //VOREStation Edit
	START_PROCESSING(SSprocessing, src)

/datum/controller/transfer_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	..()

/datum/controller/transfer_controller/process()
	currenttick = currenttick + 1
	//VOREStation Edit START
	if (round_duration_in_ds >= shift_last_vote - 2 MINUTES)
		shift_last_vote = 99999999 //Setting to a stupidly high number since it'll be not used again.
		to_world(span_world(span_notice("Warning: You have one hour left in the shift. Wrap up your scenes in the next 60 minutes before the transfer is called."))) //VOREStation Edit
	if (round_duration_in_ds >= shift_hard_end - 1 MINUTE)
		init_shift_change(null, 1)
		shift_hard_end = timerbuffer + CONFIG_GET(number/vote_autotransfer_interval) //If shuttle somehow gets recalled, let's force it to call again next time a vote would occur.
		timerbuffer = timerbuffer + CONFIG_GET(number/vote_autotransfer_interval) //Just to make sure a vote doesn't occur immediately afterwords.
	else if (round_duration_in_ds >= timerbuffer - 1 MINUTE)
		SSvote.start_vote(new /datum/vote/crew_transfer)
	//VOREStation Edit END
		timerbuffer = timerbuffer + CONFIG_GET(number/vote_autotransfer_interval)

/datum/controller/transfer_controller/proc/modify_hard_end(client/user)
	var/new_shift_end = tgui_input_number(user, "Modify the shift end timer (Input in Minutes)", "Shift End", shift_hard_end / 600)

	if(!new_shift_end)
		return

	var/calculated_end = new_shift_end * 600

	shift_hard_end = calculated_end
	shift_last_vote = calculated_end
