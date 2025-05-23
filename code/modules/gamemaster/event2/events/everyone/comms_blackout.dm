/datum/event2/meta/comms_blackout
	name = "communications blackout"
	departments = list(DEPARTMENT_EVERYONE) // It's not an engineering event because engineering can't do anything to help . . . for now.
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/comms_blackout

/datum/event2/meta/comms_blackout/get_weight()
	return 50 + GLOB.metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5



/datum/event2/event/comms_blackout/announce()
	var/alert = pick("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
					"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v¬-BZZZT", \
					"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT", \
					"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT", \
					"Ionospheri:%£ MCayj^j<.3-BZZZZZZT", \
					"#4nd%;f4y6,>£%-BZZZZZZZT")
	if(prob(33))
		command_announcement.Announce(alert, new_sound = 'sound/misc/interference.ogg')
	// AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
	for(var/mob/living/silicon/ai/A in player_list)
		to_chat(A, span_boldwarning("<br>"))
		to_chat(A, span_boldwarning("[alert]"))
		to_chat(A, span_boldwarning("<br>"))

/datum/event2/event/comms_blackout/start()
	if(prob(50))
		// One in two chance for the radios to turn i%t# t&_)#%, which can be more alarming than radio silence.
		log_debug("Doing partial outage of telecomms.")
		for(var/obj/machinery/telecomms/processor/P in telecomms_list)
			P.emp_act(1)
	else
		// Otherwise just shut everything down, madagascar style.
		log_debug("Doing complete outage of telecomms.")
		for(var/obj/machinery/telecomms/T in telecomms_list)
			T.emp_act(1)

	// Communicators go down no matter what.
	for(var/obj/machinery/exonet_node/N in GLOB.machines)
		N.emp_act(1)
