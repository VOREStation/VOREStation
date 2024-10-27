//ERT version with unlimited range (doesn't even check) and uses no power, to enable ert comms to work anywhere.
/obj/machinery/telecomms/allinone/ert
	use_power = USE_POWER_OFF
	idle_power_usage = 0

/obj/machinery/telecomms/allinone/ert/receive_signal(datum/signal/signal)
	if(!on) // has to be on to receive messages
		return

	if(is_freq_listening(signal)) // detect subspace signals

		//signal.data["done"] = 1 // mark the signal as being broadcasted since we're a broadcaster
		signal.data["compression"] = 0

		/*
		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1
		*/

		// For some reason level is both used as a list and not a list, and now it needs to be a list.
		// Because this is a 'all in one' machine, we're gonna just cheat.
		//signal.data["level"] = using_map.contact_levels.Copy()

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		/* ###### Broadcast a message using signal.data ###### */

		var/datum/radio_frequency/connection = signal.data["connection"]

		var/list/forced_radios
		for(var/datum/weakref/wr in linked_radios_weakrefs)
			var/obj/item/radio/R = wr.resolve()
			if(istype(R))
				LAZYDISTINCTADD(forced_radios, R)

		if(connection.frequency in CENT_FREQS) // if ert broadcast, just
			Broadcast_Message(signal.data["connection"], signal.data["mob"],
							  signal.data["vmask"], signal.data["vmessage"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"], signal.data["vname"], DATA_NORMAL,
							  signal.data["compression"], list(0), connection.frequency,
							  signal.data["verb"], forced_radios)
