/datum/gm_action/comms_blackout
	name = "communications blackout"
	departments = list(ROLE_ENGINEERING, ROLE_EVERYONE)
	chaotic = 35

/datum/gm_action/comms_blackout/get_weight()
	return 50 + (metric.count_people_in_department(ROLE_ENGINEERING) * 40)

/datum/gm_action/comms_blackout/announce()
	if(prob(33))
		command_announcement.Announce("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT", new_sound = 'sound/misc/interference.ogg')
	// AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
	for(var/mob/living/silicon/ai/A in player_list)
		A << "<br>"
		A << "<span class='warning'><b>Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT</b></span>"
		A << "<br>"

/datum/gm_action/comms_blackout/start()
	..()
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
