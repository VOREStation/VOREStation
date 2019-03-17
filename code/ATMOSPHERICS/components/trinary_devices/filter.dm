/obj/machinery/atmospherics/trinary/atmos_filter
	icon = 'icons/atmos/filter.dmi'
	icon_state = "map"
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "filter"
	density = 0
	level = 1

	name = "Gas filter"

	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500	//This also doubles as a measure of how powerful the filter is, in Watts. 7500 W ~ 10 HP

	var/temp = null // -- TLE

	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	/*
	Filter types:
	-1: Nothing
	 0: Phoron: Phoron, Oxygen Agent B
	 1: Oxygen: Oxygen ONLY
	 2: Nitrogen: Nitrogen ONLY
	 3: Carbon Dioxide: Carbon Dioxide ONLY
	 4: Sleeping Agent (N2O)
	*/
	var/filter_type = -1
	var/list/filtered_out = list()


	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/atmos_filter/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/atmos_filter/New()
	..()
	switch(filter_type)
		if(0) //removing hydrocarbons
			filtered_out = list("phoron")
		if(1) //removing O2
			filtered_out = list("oxygen")
		if(2) //removing N2
			filtered_out = list("nitrogen")
		if(3) //removing CO2
			filtered_out = list("carbon_dioxide")
		if(4)//removing N2O
			filtered_out = list("sleeping_agent")

	air1.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air2.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air3.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/trinary/atmos_filter/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/trinary/atmos_filter/update_icon()
	if(mirrored)
		icon_state = "m"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 && node3 && node1)
		icon_state += use_power ? "on" : "off"
	else
		icon_state += "off"
		use_power = 0

/obj/machinery/atmospherics/trinary/atmos_filter/process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	//Figure out the amount of moles to transfer
	var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas(src, filtered_out, air1, air2, air3, transfer_moles, power_rating)

		if(network2)
			network2.update = 1

		if(network3)
			network3.update = 1

		if(network1)
			network1.update = 1

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	return 1

/obj/machinery/atmospherics/trinary/atmos_filter/initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/trinary/atmos_filter/attack_hand(user as mob) // -- TLE
	if(..())
		return

	if(!src.allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	var/dat
	var/current_filter_type
	switch(filter_type)
		if(0)
			current_filter_type = "Phoron"
		if(1)
			current_filter_type = "Oxygen"
		if(2)
			current_filter_type = "Nitrogen"
		if(3)
			current_filter_type = "Carbon Dioxide"
		if(4)
			current_filter_type = "Nitrous Oxide"
		if(-1)
			current_filter_type = "Nothing"
		else
			current_filter_type = "ERROR - Report this bug to the admin, please!"

	dat += {"
			<b>Power: </b><a href='?src=\ref[src];power=1'>[use_power?"On":"Off"]</a><br>
			<b>Filtering: </b>[current_filter_type]<br><HR>
			<h4>Set Filter Type:</h4>
			<A href='?src=\ref[src];filterset=0'>Phoron</A><BR>
			<A href='?src=\ref[src];filterset=1'>Oxygen</A><BR>
			<A href='?src=\ref[src];filterset=2'>Nitrogen</A><BR>
			<A href='?src=\ref[src];filterset=3'>Carbon Dioxide</A><BR>
			<A href='?src=\ref[src];filterset=4'>Nitrous Oxide</A><BR>
			<A href='?src=\ref[src];filterset=-1'>Nothing</A><BR>
			<HR>
			<B>Set Flow Rate Limit:</B>
			[src.set_flow_rate]L/s | <a href='?src=\ref[src];set_flow_rate=1'>Change</a><BR>
			<B>Flow rate: </B>[round(last_flow_rate, 0.1)]L/s
			"}

	user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmos_filter")
	onclose(user, "atmos_filter")
	return

/obj/machinery/atmospherics/trinary/atmos_filter/Topic(href, href_list) // -- TLE
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["filterset"])
		filter_type = text2num(href_list["filterset"])

		filtered_out.Cut()	//no need to create new lists unnecessarily
		switch(filter_type)
			if(0) //removing hydrocarbons
				filtered_out += "phoron"
				filtered_out += "oxygen_agent_b"
			if(1) //removing O2
				filtered_out += "oxygen"
			if(2) //removing N2
				filtered_out += "nitrogen"
			if(3) //removing CO2
				filtered_out += "carbon_dioxide"
			if(4)//removing N2O
				filtered_out += "sleeping_agent"

	if (href_list["temp"])
		src.temp = null
	if(href_list["set_flow_rate"])
		var/new_flow_rate = input(usr,"Enter new flow rate (0-[air1.volume]L/s)","Flow Rate Control",src.set_flow_rate) as num
		src.set_flow_rate = max(0, min(air1.volume, new_flow_rate))
	if(href_list["power"])
		use_power=!use_power
	src.update_icon()
	src.updateUsrDialog()
/*
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.attack_hand(M)
*/
	return

//
// Mirrored Orientation - Flips the output dir to opposite side from normal.
//
/obj/machinery/atmospherics/trinary/atmos_filter/m_filter
	icon_state = "mmap"
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST
	mirrored = TRUE
