<<<<<<< HEAD
/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/device/pda/hostpda = null

	var/list/botlist = null		// list of bots
	var/mob/living/bot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot
	
	var/bot_type				//The type of bot it is.
	var/bot_filter				//Determines which radio filter to use.

	var/control_freq = BOT_FREQ

	var/on = 0 //Are we currently active??
	var/menu_message = ""

/obj/item/radio/integrated/New()
	..()
	if(istype(loc.loc, /obj/item/device/pda))
		hostpda = loc.loc
	if(bot_filter)
		spawn(5)
			add_to_radio(bot_filter)

/obj/item/radio/integrated/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, control_freq)
	hostpda = null
	return ..()

/obj/item/radio/integrated/proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)

	//to_world("Post: [freq]: [key]=[value], [key2]=[value2]")
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency)
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, radio_filter = s_filter)

/obj/item/radio/integrated/Topic(href, href_list)
	..()
	switch(href_list["op"])
		if("control")
			active = locate(href_list["bot"])
			spawn(0)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = bot_filter)

		if("scanbots")		// find all bots
			botlist = null
			spawn(0)
				post_signal(control_freq, "command", "bot_status", s_filter = bot_filter)

		if("botlist")
			active = null

		if("stop", "go", "home")
			spawn(0)
				post_signal(control_freq, "command", href_list["op"], "active", active, s_filter = bot_filter)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = bot_filter)

		if("summon")
			spawn(0)
				post_signal(control_freq, "command", "summon", "active", active, "target", get_turf(hostpda), "useraccess", hostpda.GetAccess(), "user", usr, s_filter = bot_filter)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = bot_filter)

/obj/item/radio/integrated/receive_signal(datum/signal/signal)
	if(bot_type && istype(signal.source, /mob/living/bot) && signal.data["type"] == bot_type)
		if(!botlist)
			botlist = new()

		botlist |= signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

/obj/item/radio/integrated/proc/add_to_radio(bot_filter) //Master filter control for bots. Must be placed in the bot's local New() to support map spawned bots.
	if(radio_controller)
		radio_controller.add_object(src, control_freq, radio_filter = bot_filter)

/*
 *	Radio Cartridge, essentially a signaler.
 */
/obj/item/radio/integrated/signal
	var/frequency = 1457
	var/code = 30.0
	var/last_transmission
	var/datum/radio_frequency/radio_connection

/obj/item/radio/integrated/signal/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	radio_connection = null
	return ..()

/obj/item/radio/integrated/signal/Initialize()
	. = ..()
	if(radio_controller)
		if(src.frequency < PUBLIC_LOW_FREQ || src.frequency > PUBLIC_HIGH_FREQ)
			src.frequency = sanitize_frequency(src.frequency)
		set_frequency(frequency)

/obj/item/radio/integrated/signal/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency)

/obj/item/radio/integrated/signal/proc/send_signal(message="ACTIVATE")
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = message

	spawn(0)
		radio_connection.post_signal(src, signal)
=======
/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/pda/hostpda = null

	var/list/botlist = null		// list of bots
	var/mob/living/bot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot
	
	var/bot_type				//The type of bot it is.
	var/bot_filter				//Determines which radio filter to use.

	var/control_freq = BOT_FREQ

	on = FALSE //Are we currently active??
	var/menu_message = ""

/obj/item/radio/integrated/Initialize()
	. = ..()
	if(istype(loc.loc, /obj/item/pda))
		hostpda = loc.loc
	if(bot_filter)
		spawn(5)
			add_to_radio(bot_filter)

/obj/item/radio/integrated/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, control_freq)
	hostpda = null
	return ..()

/obj/item/radio/integrated/proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)

	//to_world("Post: [freq]: [key]=[value], [key2]=[value2]")
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency)
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, radio_filter = s_filter)

/obj/item/radio/integrated/Topic(href, href_list)
	..()
	switch(href_list["op"])
		if("control")
			active = locate(href_list["bot"])
			spawn(0)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = bot_filter)

		if("scanbots")		// find all bots
			botlist = null
			spawn(0)
				post_signal(control_freq, "command", "bot_status", s_filter = bot_filter)

		if("botlist")
			active = null

		if("stop", "go", "home")
			spawn(0)
				post_signal(control_freq, "command", href_list["op"], "active", active, s_filter = bot_filter)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = bot_filter)

		if("summon")
			spawn(0)
				post_signal(control_freq, "command", "summon", "active", active, "target", get_turf(hostpda), "useraccess", hostpda.GetAccess(), "user", usr, s_filter = bot_filter)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = bot_filter)

/obj/item/radio/integrated/receive_signal(datum/signal/signal)
	if(bot_type && istype(signal.source, /mob/living/bot) && signal.data["type"] == bot_type)
		if(!botlist)
			botlist = new()

		botlist |= signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

/obj/item/radio/integrated/proc/add_to_radio(bot_filter) //Master filter control for bots. Must be placed in the bot's local New() to support map spawned bots.
	if(radio_controller)
		radio_controller.add_object(src, control_freq, radio_filter = bot_filter)

/*
 *	Radio Cartridge, essentially a signaler.
 */
/obj/item/radio/integrated/signal
	frequency = 1457
	var/code = 30.0

/obj/item/radio/integrated/signal/Initialize()
	. = ..()
	if(radio_controller)
		if(src.frequency < PUBLIC_LOW_FREQ || src.frequency > PUBLIC_HIGH_FREQ)
			src.frequency = sanitize_frequency(src.frequency)
		set_frequency(frequency)

/obj/item/radio/integrated/signal/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	radio_connection = null
	return ..()

/obj/item/radio/integrated/signal/proc/send_signal(message="ACTIVATE")
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = message

	spawn(0)
		radio_connection.post_signal(src, signal)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
