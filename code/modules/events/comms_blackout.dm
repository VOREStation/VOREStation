
/proc/communications_blackout(var/silent = 1)

	if(!silent)
		command_announcement.Announce("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT", new_sound = 'sound/misc/interference.ogg')
	else // AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
		for(var/mob/living/silicon/ai/A in player_list)
			to_chat(A, span_boldwarning("<br>"))
			to_chat(A, span_boldwarning("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT"))
			to_chat(A, span_boldwarning("<br>"))
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
