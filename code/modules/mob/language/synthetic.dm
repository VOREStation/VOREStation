/datum/language/binary
	name = "Robot Talk"
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote_italics"
	speech_verb = "states"
	ask_verb = "queries"
	exclaim_verb = "declares"
	key = "b"
	machine_understands = 0
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	message = encode_html_emphasis(message)

	var/message_start = "[name], <span class='name'>[speaker.name]</span>"
	var/message_body = "<span class='message'>[speaker.say_quote(message)], \"[message]\"</span>"

	for (var/mob/M in dead_mob_list)
		if(!istype(M,/mob/new_player) && !istype(M,/mob/living/carbon/brain)) //No meta-evesdropping
			var/message_to_send = span_binary("[message_start] ([ghost_follow_link(speaker, M)]) [message_body]")
			if(M.check_mentioned(message) && M.client?.prefs?.read_preference(/datum/preference/toggle/check_mention))
				message_to_send = "<font size='3'><b>[message_to_send]</b></font>"
			M.show_message(message_to_send, 2)

	for (var/mob/living/S in living_mob_list)
		if(drone_only && !istype(S,/mob/living/silicon/robot/drone))
			continue
		else if(istype(S , /mob/living/silicon/ai))
			message_start = span_binary("[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'><span class='name'>[speaker.name]</span></a>")
		else if (!S.binarycheck())
			continue

		var/message_to_send = span_binary("[message_start] [message_body]")
		if(S.check_mentioned(message) && S.client?.prefs?.read_preference(/datum/preference/toggle/check_mention))
			message_to_send = "<font size='3'><b>[message_to_send]</b></font>"
		S.show_message(message_to_send, 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(istype(M, /mob/living/silicon) || M.binarycheck())
			continue
		M.show_message("<span class='binarysay'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span>",2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = "Drone Talk"
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote_italics"
	key = "d"
	machine_understands = 0
	flags = RESTRICTED | HIVEMIND
	drone_only = 1
