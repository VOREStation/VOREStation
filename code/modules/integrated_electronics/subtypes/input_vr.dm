/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people or for voice activated machines."
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Galactic Common."
	icon_state = "recorder"
	complexity = 8
	inputs = list()
	outputs = list(
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15

/obj/item/integrated_circuit/input/microphone/New()
	..()
	listening_objects |= src

/obj/item/integrated_circuit/input/microphone/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(mob/living/M, msg, var/verb="says", datum/language/speaking=null)
	var/translated = FALSE
	if(M && msg)
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			if(!istype(speaking, /datum/language/common))
				translated = TRUE
		set_pin_data(IC_OUTPUT, 1, M.GetVoice())
		set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)
	if(translated)
		activate_pin(2)




obj/item/device/radio/integrated/
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "signal"
	canhear_range = -1
	var/obj/item/integrated_circuit/input/integrated_radio/circuit = null


/obj/item/device/radio/integrated/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise

	if (wires.IsIndexCut(WIRE_RECEIVE))
		return -2
	if(!listening)
		return -2
	if(is_jammed(src))
		return -2
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(!position || !(position.z in level))
			return -2
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -2
	if(freq in CENT_FREQS)
		if(!(src.centComm))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -2
	if (!on)
		return -2
	if (!freq) //recieved on main frequency
		if (!listening)
			return -2/*
	else
		var/accept = (freq==frequency && listening)
		if (!accept)
			for (var/ch_name in channels)
				var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
				if (RF.frequency==freq && (channels[ch_name]&FREQ_LISTENING))
					accept = 1
					break
		if (!accept)
			return -2*/
	return canhear_range

/obj/item/device/radio/integrated/recieve_broadcast(var/mob/M, var/vmask,
						var/message, var/name, var/job, var/realname,
						var/data, var/compression, var/freq,
						var/datum/language/speaking = null)

	var/firstletter = copytext(message, 1, 2)
	var/restoftext = copytext(message, 2, 0)
	var/bigfirstletter = uppertext(firstletter)
	var/msg = addtext(bigfirstletter, restoftext)

	var/heard_name = name
	var/channel = null

	channel = get_frequency_name(freq)

	if(findtextEx(realname, "(electronic "))
		return

	if(data == 1 || data == 3)
		return

	if(compression)
		return

	if(!(!M || !ishuman(M) || vmask))
		heard_name = realname


	var/translated = FALSE
	if(heard_name && msg && channel)
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			if(!istype(speaking, /datum/language/common))
				translated = TRUE
		circuit.set_pin_data(IC_OUTPUT, 1, channel)
		circuit.set_pin_data(IC_OUTPUT, 2, heard_name)
		circuit.set_pin_data(IC_OUTPUT, 3, msg)

	circuit.push_data()
	circuit.activate_pin(2)
	if(translated)
		circuit.activate_pin(3)


/obj/item/integrated_circuit/input/integrated_radio
	name = "integrated radio"
	desc = "Useful for interacting with radio channels"
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Galactic Common."
	icon_state = "signal"
	complexity = 18
	inputs = list(
	"channel" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	outputs = list(
	"channel" = IC_PINTYPE_STRING,
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("send message" = IC_PINTYPE_PULSE_IN, "on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20


	var/allowed_channels = list(
	"Common" = 0,
	"Entertainment" = 0
	)
	var/obj/item/device/radio/integrated/radio = null

/obj/item/integrated_circuit/input/integrated_radio/New()
	..()
	listening_objects |= src
	radio = new(src)
	radio.circuit = src
	radio.config(allowed_channels)

/obj/item/integrated_circuit/input/integrated_radio/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/integrated_radio/do_work()
	var/target_channel = get_pin_data(IC_INPUT, 1)
	var/message = get_pin_data(IC_INPUT, 2)
	if(!isnull(message))
		var/obj/O = assembly ? loc : assembly
		radio.autosay(message, "[O.name] ([initial(O.name)])", target_channel)

obj/item/integrated_circuit/input/integrated_radio/attackby(obj/item/weapon/card/id/id, mob/user)
	..()
	var/access_list = id.GetAccess()
	allowed_channels = list("Common" = 0,
							"Entertainment" = 0)

	var/engiset = 0
	var/sciset = 0
	var/servset = 0
	var/channels_added = list()
	var/amount_added = 0
	for(var/req in access_list)
		switch(req)
			if(access_synth)
				allowed_channels += list("AI Private" = 0)
				channels_added += "AI Private"
				amount_added++
			if(access_cent_specops)
				allowed_channels += list("Response Team" = 0,
										 "Special Ops" = 0)
				channels_added += "Response Team"
				channels_added += "Special Ops"
				amount_added += 2
			if(access_heads)
				allowed_channels += list("Command" = 0)
				channels_added += "Command"
				amount_added++
			if(access_engine_equip || access_atmospherics)
				if(!engiset)
					allowed_channels += list("Engineering" = 0)
					engiset++
					channels_added += "Engineering"
					amount_added++
			if(access_medical_equip)
				allowed_channels += list("Medical" = 0)
				channels_added += "Medical"
				amount_added++
			if(access_security)
				allowed_channels += list("Security" = 0)
				channels_added += "Security"
				amount_added++
			if(access_tox || access_robotics || access_xenobiology)
				if(!sciset)
					allowed_channels += list("Science" = 0)
					channels_added += "Science"
					amount_added++
			if(access_cargo)
				allowed_channels += list("Supply" = 0)
				channels_added += "Supply"
				amount_added++
			if(access_janitor || access_hydroponics)
				if(!servset)
					allowed_channels += list("Service" = 0)
					channels_added += "Service"
					amount_added++
			if(access_explorer)
				allowed_channels += list("Explorer" = 0)
				channels_added += "Explorer"
				amount_added++
	radio.config(allowed_channels)
	var/usrmessage
	switch(channels_added)
		if(0)
			usrmessage = "There is no access to any special channels on that ID"
		if(1)
			usrmessage = "You set "
			usrmessage = addtext(usrmessage, channels_added[1], " channel to the list of available channels on ", src.name)
		else
			usrmessage = "You set "
			var/counterprobs = 1
			while(counterprobs < (length(channels_added) - 1))
				usrmessage = addtext(usrmessage, channels_added[counterprobs], ", ")
				counterprobs++
			usrmessage = addtext(usrmessage, channels_added[length(channels_added) - 1], " and ", channels_added[length(channels_added)], " channels to the list of available channels on ", src.name)
	user << usrmessage
