// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
//VOREStation Edit Start - Updating this for Virgo
var/global/list/default_internal_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(AI_FREQ)  = list(access_synth),
	num2text(ENT_FREQ) = list(),
	num2text(ERT_FREQ) = list(access_cent_specops),
	num2text(COMM_FREQ)= list(access_heads),
	num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ)=list(access_medical_equip),
	num2text(SEC_FREQ) = list(access_security),
	num2text(SEC_I_FREQ)=list(access_security),
	num2text(SCI_FREQ) = list(access_tox, access_robotics, access_xenobiology),
	num2text(SUP_FREQ) = list(access_cargo, access_mining_station),
	num2text(SRV_FREQ) = list(access_janitor, access_library, access_hydroponics, access_bar, access_kitchen),
	num2text(EXP_FREQ) = list(access_explorer, access_pilot)
)

var/global/list/default_medbay_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(),
	num2text(MED_I_FREQ) = list()
)
//VOREStation Edit End

/obj/item/device/radio
	icon = 'icons/obj/radio_vr.dmi' //VOREStation Edit
	name = "shortwave radio" //VOREStation Edit
	desc = "Used to talk to people when headsets don't function. Range is limited."
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "radio"

	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = PUB_FREQ //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/loudspeaker = TRUE // Allows borgs to disable canhear_range.
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/subspace_transmission = 0
	var/subspace_switchable = FALSE
	var/adhoc_fallback = FALSE //Falls back to 'radio' mode if subspace not available
	var/syndie = 0//Holder to see if it's a syndicate encrypted radio
	var/centComm = 0//Holder to see if it's a CentCom encrypted radio
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	show_messages = 1

	// Bluespace radios talk directly to telecomms equipment
	var/bluespace_radio = FALSE
	var/weakref/bs_tx_weakref //Maybe misleading, this is the device to TRANSMIT TO
	// For mappers or subtypes, to start them prelinked to these devices
	var/bs_tx_preload_id
	var/bs_rx_preload_id

	matter = list(MAT_GLASS = 25,MAT_STEEL = 75)
	var/const/FREQ_LISTENING = 1
	var/list/internal_channels

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = new

/obj/item/device/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/radio/New()
	..()
	wires = new(src)
	internal_channels = default_internal_channels.Copy()
	listening_objects += src

/obj/item/device/radio/Destroy()
	qdel(wires)
	wires = null
	listening_objects -= src
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	return ..()


/obj/item/device/radio/Initialize()
	. = ..()
	if(frequency < RADIO_LOW_FREQ || frequency > RADIO_HIGH_FREQ)
		frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
	set_frequency(frequency)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	if(bluespace_radio)
		if(bs_tx_preload_id)
			//Try to find a receiver
			for(var/obj/machinery/telecomms/receiver/RX in telecomms_list)
				if(RX.id == bs_tx_preload_id) //Again, bs_tx is the thing to TRANSMIT TO, so a receiver.
					bs_tx_weakref = weakref(RX)
					RX.link_radio(src)
					break
			//Hmm, howabout an AIO machine
			if(!bs_tx_weakref)
				for(var/obj/machinery/telecomms/allinone/AIO in telecomms_list)
					if(AIO.id == bs_tx_preload_id)
						bs_tx_weakref = weakref(AIO)
						AIO.link_radio(src)
						break
			if(!bs_tx_weakref)
				testing("A radio [src] at [x],[y],[z] specified bluespace prelink IDs, but the machines with corresponding IDs ([bs_tx_preload_id], [bs_rx_preload_id]) couldn't be found.")

		if(bs_rx_preload_id)
			var/found = 0
			//Try to find a transmitter
			for(var/obj/machinery/telecomms/broadcaster/TX in telecomms_list)
				if(TX.id == bs_rx_preload_id) //Again, bs_rx is the thing to RECEIVE FROM, so a transmitter.
					TX.link_radio(src)
					found = 1
					break
			//Hmm, howabout an AIO machine
			if(!found)
				for(var/obj/machinery/telecomms/allinone/AIO in telecomms_list)
					if(AIO.id == bs_rx_preload_id)
						AIO.link_radio(src)
						found = 1
						break
			if(!found)
				testing("A radio [src] at [x],[y],[z] specified bluespace prelink IDs, but the machines with corresponding IDs ([bs_tx_preload_id], [bs_rx_preload_id]) couldn't be found.")

/obj/item/device/radio/proc/recalculateChannels()
	return

/obj/item/device/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return FALSE

	if(b_stat)
		wires.Interact(user)

	return tgui_interact(user)

/obj/item/device/radio/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Radio", name, parent_ui)
		ui.open()

/obj/item/device/radio/tgui_data(mob/user)
	var/data[0]

	data["rawfreq"] = frequency
	data["listening"] = listening
	data["broadcasting"] = broadcasting
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["loudspeaker"] = loudspeaker

	data["mic_cut"] = (wires.is_cut(WIRE_RADIO_TRANSMIT) || wires.is_cut(WIRE_RADIO_SIGNAL))
	data["spk_cut"] = (wires.is_cut(WIRE_RADIO_RECEIVER) || wires.is_cut(WIRE_RADIO_SIGNAL))

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
	else
		data["chan_list"] = null

	if(syndie)
		data["useSyndMode"] = 1

	data["minFrequency"] = PUBLIC_LOW_FREQ
	data["maxFrequency"] = PUBLIC_HIGH_FREQ

	return data

/obj/item/device/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/device/radio/proc/list_secure_channels(var/mob/user)
	var/dat[0]

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = !!(chan_stat & FREQ_LISTENING) != 0

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "freq" = radiochannels[ch_name])))

	return dat

/obj/item/device/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_frequency_name(text2num(internal_chan)), "freq" = text2num(internal_chan))))

	return dat

/obj/item/device/radio/proc/has_channel_access(var/mob/user, var/freq)
	if(!user)
		return FALSE

	if(!(freq in internal_channels))
		return FALSE

	return user.has_internal_radio_channel_access(internal_channels[freq])

/mob/proc/has_internal_radio_channel_access(var/list/req_one_accesses)
	var/obj/item/weapon/card/id/I = GetIdCard()
	return has_access(list(), req_one_accesses, I ? I.GetAccess() : list())

/mob/observer/dead/has_internal_radio_channel_access(var/list/req_one_accesses)
	return can_admin_interact()

/obj/item/device/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/device/radio/proc/ToggleBroadcast()
	broadcasting = !broadcasting && !(wires.is_cut(WIRE_RADIO_TRANSMIT) || wires.is_cut(WIRE_RADIO_SIGNAL))

/obj/item/device/radio/proc/ToggleReception()
	listening = !listening && !(wires.is_cut(WIRE_RADIO_RECEIVER) || wires.is_cut(WIRE_RADIO_SIGNAL))

/obj/item/device/radio/CanUseTopic()
	if(!on)
		return STATUS_CLOSE
	return ..()

/obj/item/device/radio/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("setFrequency")
			var/new_frequency = (text2num(params["freq"]))
			if((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
				new_frequency = sanitize_frequency(new_frequency)
			set_frequency(new_frequency)
			if(hidden_uplink)
				if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
					usr << browse(null, "window=radio")
			. = TRUE
		if("broadcast")
			ToggleBroadcast()
			. = TRUE
		if("listen")
			ToggleReception()
			. = TRUE
		if("channel")
			var/chan_name = params["channel"]
			if(channels[chan_name] & FREQ_LISTENING)
				channels[chan_name] &= ~FREQ_LISTENING
			else
				channels[chan_name] |= FREQ_LISTENING
			. = TRUE
		if("specFreq")
			var/freq = params["channel"]
			if(has_channel_access(usr, freq))
				set_frequency(text2num(freq))
			. = TRUE
		if("subspace")
			if(subspace_switchable)
				subspace_transmission = !subspace_transmission
				if(!subspace_transmission)
					channels = list()
					to_chat(usr, "<span class='notice'>Subspace Transmission is disabled</span>")
				else
					recalculateChannels()
					to_chat(usr, "<span class='notice'>Subspace Transmission is enabled</span>")
				. = TRUE
		if("toggleLoudspeaker")
			if(!subspace_switchable)
				return
			loudspeaker = !loudspeaker

			if(loudspeaker)
				to_chat(usr, "<span class='notice'>Loadspeaker enabled.</span>")
			else
				to_chat(usr, "<span class='notice'>Loadspeaker disabled.</span>")
			. = TRUE

	if(. && iscarbon(usr))
		playsound(src, "button", 10)

GLOBAL_DATUM(autospeaker, /mob/living/silicon/ai/announcer)

/obj/item/device/radio/proc/autosay(var/message, var/from, var/channel, var/list/zlevels, var/states)	//VOREStation Edit

	if(!GLOB.autospeaker)
		return
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if(channel == "department")
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if(!istype(connection))
		return

	if(!LAZYLEN(zlevels))
		zlevels = list(0)
	//VOREStation Edit Start
	if(!states)
		states = "states"
	//VOREStation Edit End
	GLOB.autospeaker.SetName(from)
	Broadcast_Message(connection, GLOB.autospeaker,
						0, "*garbled automated announcement*", src,
						message_to_multilingual(message, GLOB.all_languages[LANGUAGE_GALCOM]), from, "Automated Announcement", from, "synthesized voice",
						DATA_FAKE, 0, zlevels, connection.frequency, states)	//VOREStation Edit

// Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/device/radio/proc/handle_message_mode(mob/living/M as mob, list/message_pieces, message_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if (message_mode == "department") // Department radio shortcut
			message_mode = channels[1]

		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	// If we were to send to a channel we don't have, drop it.
	return RADIO_CONNECTION_FAIL

/obj/item/device/radio/talk_into(mob/living/M as mob, list/message_pieces, channel, var/verb = "says")
	if(!on)
		return FALSE // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message_pieces)
		return FALSE

	if(istype(M))
		M.trigger_aiming(TARGET_CAN_RADIO)

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(wires.is_cut(WIRE_RADIO_TRANSMIT)) // The device has to have all its wires and shit intact
		return FALSE

	if(!radio_connection)
		set_frequency(frequency)

	/* Quick introduction:
		This new radio system uses a very robust FTL signaling technology unoriginally
		dubbed "subspace" which is somewhat similar to 'blue-space' but can't
		actually transmit large mass. Headsets are the only radio devices capable
		of sending subspace transmissions to the Communications Satellite.

		A headset sends a signal to a subspace listener/reciever elsewhere in space,
		the signal gets processed and logged, and an audible transmission gets sent
		to each individual headset.
	*/

	//#### Grab the connection datum ####//
	var/message_mode = handle_message_mode(M, message_pieces, channel)
	switch(message_mode)
		if(RADIO_CONNECTION_FAIL)
			return FALSE
		if(RADIO_CONNECTION_NON_SUBSPACE)
			return TRUE

	if(!istype(message_mode, /datum/radio_frequency))
		return FALSE

	var/pos_z = get_z(src)
	var/datum/radio_frequency/connection = message_mode

	//#### Tagging the signal with all appropriate identity values ####//

	// ||-- The mob's name identity --||
	var/displayname = M.name	// grab the display name (name you get when you hover over someone's icon)
	var/real_name = M.real_name // mob's real name
	var/mobkey = "none" // player key associated with mob
	var/voicemask = 0 // the speaker is wearing a voice mask
	if(M.client)
		mobkey = M.key // assign the mob's key


	var/jobname // the mob's "job"

	// --- Human: use their actual job ---
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		jobname = H.get_assignment()

	// --- Carbon Nonhuman ---
	else if (iscarbon(M)) // Nonhuman carbon mob
		jobname = "No id"

	// --- AI ---
	else if (isAI(M))
		jobname = "AI"

	// --- Cyborg ---
	else if (isrobot(M))
		jobname = "Cyborg"

	// --- Personal AI (pAI) ---
	else if (istype(M, /mob/living/silicon/pai))
		jobname = "Personal AI"

	// --- Unidentifiable mob ---
	else
		jobname = "Unknown"


	// --- Modifications to the mob's identity ---

	// The mob is disguising their identity:
	if (ishuman(M) && M.GetVoice() != real_name)
		displayname = M.GetVoice()
		jobname = "Unknown"
		voicemask = 1

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
		// Identity-associated tags:
		"mob" = M, // store a reference to the mob
		"mobtype" = M.type, 	// the mob's type
		"realname" = real_name, // the mob's real name
		"name" = displayname,	// the mob's display name
		"job" = jobname,		// the mob's job
		"key" = mobkey,			// the mob's key
		"vmessage" = message_to_multilingual(pick(M.speak_emote)), // the message to display if the voice wasn't understood
		"vname" = M.voice_name, // the name to display if the voice wasn't understood
		"vmask" = voicemask,	// 1 if the mob is using a voice gas mask

		// We store things that would otherwise be kept in the actual mob
		// so that they can be logged even AFTER the mob is deleted or something

		// Other tags:
		"compression" = rand(45,50), // compressed radio signal
		"message" = message_pieces, // the actual sent message
		"connection" = connection, // the radio connection to use
		"radio" = src, // stores the radio used for transmission
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = SIGNAL_NORMAL, // determines what type of radio input it is: normal broadcast
		"server" = null, // the last server to log this signal
		"reject" = 0,	// if nonzero, the signal will not be accepted by any broadcasting machinery
		"level" = pos_z, // The source's z level
		"verb" = verb
	)
	signal.frequency = connection.frequency // Quick frequency set

	var/filter_type = DATA_LOCAL //If we end up having to send it the old fashioned way, it's with this data var.

	/* ###### Bluespace radios talk directly to receivers (and only directly to receivers) ###### */
	if(bluespace_radio)
		//Nothing to transmit to
		if(!bs_tx_weakref)
			to_chat(loc, "<span class='warning'>\The [src] buzzes to inform you of the lack of a functioning connection.</span>")
			return FALSE

		var/obj/machinery/telecomms/tx_to = bs_tx_weakref.resolve()
		//Was linked, now destroyed or something
		if(!tx_to)
			bs_tx_weakref = null
			to_chat(loc, "<span class='warning'>\The [src] buzzes to inform you of the lack of a functioning connection.</span>")
			return FALSE

		//Transmitted in the blind. If we get a message back, cool. If not, oh well.
		signal.transmission_method = TRANSMISSION_BLUESPACE
		return tx_to.receive_signal(signal)

	/* ###### Radios with subspace_transmission can only broadcast through subspace (unless they have adhoc_fallback) ###### */
	else if(subspace_transmission)
		var/list/jamming = is_jammed(src)
		if(jamming)
			var/distance = jamming["distance"]
			to_chat(M, "<span class='danger'>\icon[src][bicon(src)] You hear the [distance <= 2 ? "loud hiss" : "soft hiss"] of static.</span>")
			return FALSE

		// First, we want to generate a new radio signal
		signal.transmission_method = TRANSMISSION_SUBSPACE

		//#### Sending the signal to all subspace receivers ####//
		for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in telecomms_list)
			R.receive_signal(signal)

		// Receiving code can be located in Telecommunications.dm
		if(signal.data["done"] && (pos_z in signal.data["level"]))
			return TRUE //Huzzah, sent via subspace

		else if(adhoc_fallback) //Less huzzah, we have to fallback
			to_chat(loc, "<span class='warning'>\The [src] pings as it falls back to local radio transmission.</span>")
			subspace_transmission = FALSE

		else //Oh well
			return FALSE

	/* ###### Intercoms and station-bounced radios ###### */
	else
		/* --- Intercoms can only broadcast to other intercoms, but bounced radios can broadcast to bounced radios and intercoms --- */
		if(istype(src, /obj/item/device/radio/intercom))
			filter_type = DATA_INTERCOM

		/* --- Try to send a normal subspace broadcast first */
		signal.transmission_method = TRANSMISSION_SUBSPACE
		signal.data["compression"] = 0

		for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in telecomms_list)
			R.receive_signal(signal)

	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

		if(signal.data["done"] && (pos_z in signal.data["level"]))
			if(adhoc_fallback)
				to_chat(loc, "<span class='notice'>\The [src] pings as it reestablishes subspace communications.</span>")
				subspace_transmission = TRUE
			// we're done here.
			return TRUE

	//Nothing handled any sort of remote radio-ing and returned before now, just squawk on this zlevel.
	return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
		src, message_pieces, displayname, jobname, real_name, M.voice_name,
		filter_type, signal.data["compression"], using_map.get_map_levels(pos_z), connection.frequency, verb)


/obj/item/device/radio/hear_talk(mob/M as mob, list/message_pieces, var/verb = "says")
	if(broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, message_pieces, null, verb)

/obj/item/device/radio/proc/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise
	if(wires.is_cut(WIRE_RADIO_RECEIVER))
		return -1
	if(!listening)
		return -1
	if(is_jammed(src))
		return -1
	if(!(0 in level))
		var/pos_z = get_z(src)
		if(!(pos_z in level))
			return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if(freq in CENT_FREQS)
		if(!(src.centComm))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if (!on)
		return -1
	if (!freq) //recieved on main frequency
		if (!listening)
			return -1
	else
		var/accept = (freq==frequency && listening)
		if (!accept)
			for (var/ch_name in channels)
				var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
				if (RF && RF.frequency==freq && (channels[ch_name]&FREQ_LISTENING))
					accept = 1
					break
		if (!accept)
			return -1
	return canhear_range

/obj/item/device/radio/proc/send_hear(freq, level)
	var/range = receive_range(freq, level)
	if(range > -1 && loudspeaker)
		return get_mobs_or_objects_in_view(range, src)


/obj/item/device/radio/examine(mob/user)
	. = ..()

	if((in_range(src, user) || loc == user))
		if(b_stat)
			. += "<span class='notice'>\The [src] can be attached and modified!</span>"
		else
			. += "<span class='notice'>\The [src] can not be modified or attached!</span>"

/obj/item/device/radio/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	user.set_machine(src)
	if (!W.is_screwdriver())
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/device/radio/beacon))
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can now be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can no longer be modified or attached!</span>")
		updateDialog()
			//Foreach goto(83)
		add_fingerprint(user)
		return
	else return

/obj/item/device/radio/emp_act(severity)
	broadcasting = 0
	listening = 0
	for (var/ch_name in channels)
		channels[ch_name] = 0
	..()

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/device/radio/borg
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks
	var/obj/item/device/encryptionkey/keyslot = null//Borg radios can handle a single encryption key
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = TRUE
	subspace_switchable = TRUE

/obj/item/device/radio/borg/Destroy()
	myborg = null
	return ..()

/obj/item/device/radio/borg/list_channels(var/mob/user)
	return list_secure_channels(user)

/obj/item/device/radio/borg/talk_into()
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/device/radio/borg/attackby(obj/item/weapon/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if (!(W.is_screwdriver() || istype(W, /obj/item/device/encryptionkey)))
		return

	if(W.is_screwdriver())
		if(keyslot)


			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.loc = T
					keyslot = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")
			playsound(src, W.usesound, 50, 1)

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			user.drop_item()
			W.loc = src
			keyslot = W

		recalculateChannels()

	return

/obj/item/device/radio/borg/recalculateChannels()
	src.channels = list()
	src.syndie = 0

	var/mob/living/silicon/robot/D = src.loc
	if(D.module)
		for(var/ch_name in D.module.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += D.module.channels[ch_name]
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += keyslot.channels[ch_name]

		if(keyslot.syndie)
			src.syndie = 1

	for (var/ch_name in src.channels)
		if(!radio_controller)
			sleep(30) // Waiting for the radio_controller to be created.
		if(!radio_controller)
			src.name = "broken radio"
			return

		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	return

/obj/item/device/radio/proc/config(op)
	if(radio_controller)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	secure_radio_connections = new
	channels = op
	if(radio_controller)
		for (var/ch_name in op)
			secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
	return

/obj/item/device/radio/off
	listening = 0

/obj/item/device/radio/phone
	broadcasting = 0
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	listening = 1
	name = "phone"
	anchored = FALSE

/obj/item/device/radio/phone/medbay
	frequency = MED_I_FREQ

/obj/item/device/radio/phone/medbay/New()
	..()
	internal_channels = default_medbay_channels.Copy()
