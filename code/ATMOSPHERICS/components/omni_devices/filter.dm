//--------------------------------------------
// Gas filter - omni variant
//--------------------------------------------
/obj/machinery/atmospherics/omni/atmos_filter
	name = "omni gas filter"
	desc = "An advanced version of the gas filter, able to be configured for filtering of multiple gasses."
	icon_state = "map_filter"
	pipe_state = "omni_filter"

	var/list/atmos_filters = new()
	var/datum/omni_port/input
	var/datum/omni_port/output

	use_power = USE_POWER_IDLE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	var/max_flow_rate = 200
	var/set_flow_rate = 200

	var/list/filtering_outputs = list()	//maps gasids to gas_mixtures

/obj/machinery/atmospherics/omni/atmos_filter/New()
	..()
	rebuild_filtering_list()
	for(var/datum/omni_port/P in ports)
		P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/omni/atmos_filter/Destroy()
	input = null
	output = null
	atmos_filters.Cut()
	return ..()

/obj/machinery/atmospherics/omni/atmos_filter/sort_ports()
	var/any_updated = FALSE
	for(var/datum/omni_port/P in ports)
		if(P.update)
			any_updated = TRUE
			if(output == P)
				output = null
			if(input == P)
				input = null
			if(atmos_filters.Find(P))
				atmos_filters -= P

			P.air.volume = 200
			switch(P.mode)
				if(ATM_INPUT)
					input = P
				if(ATM_OUTPUT)
					output = P
				if(ATM_O2 to ATM_N2O)
					atmos_filters += P
	if(any_updated)
		rebuild_filtering_list()

/obj/machinery/atmospherics/omni/atmos_filter/error_check()
	if(!input || !output || !atmos_filters)
		return 1
	if(atmos_filters.len < 1) //requires at least 1 atmos_filter ~otherwise why are you using a filter?
		return 1

	return 0

/obj/machinery/atmospherics/omni/atmos_filter/process()
	if(!..())
		return 0

	var/datum/gas_mixture/output_air = output.air	//BYOND doesn't like referencing "output.air.return_pressure()" so we need to make a direct reference
	var/datum/gas_mixture/input_air = input.air		// it's completely happy with them if they're in a loop though i.e. "P.air.return_pressure()"... *shrug*

	//Figure out the amount of moles to transfer
	var/transfer_moles = (set_flow_rate/input_air.volume)*input_air.total_moles

	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas_multi(src, filtering_outputs, input_air, output_air, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(input.network)
			input.network.update = 1
		if(output.network)
			output.network.update = 1
		for(var/datum/omni_port/P in atmos_filters)
			if(P.network)
				P.network.update = 1

	return 1

/obj/machinery/atmospherics/omni/atmos_filter/tgui_interact(mob/user,datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OmniFilter", name)
		ui.open()

/obj/machinery/atmospherics/omni/atmos_filter/tgui_data(mob/user)
	var/list/data = list()

	data["power"] = use_power
	data["config"] = configuring

	var/portData[0]
	for(var/datum/omni_port/P in ports)
		if(!configuring && P.mode == 0)
			continue

		var/input = 0
		var/output = 0
		var/atmo_filter = 1
		var/f_type = null
		switch(P.mode)
			if(ATM_INPUT)
				input = 1
				atmo_filter = 0
			if(ATM_OUTPUT)
				output = 1
				atmo_filter = 0
			if(ATM_O2 to ATM_N2O)
				f_type = mode_send_switch(P.mode)

		portData[++portData.len] = list("dir" = dir_name(P.dir, capitalize = 1), \
										"input" = input, \
										"output" = output, \
										"atmo_filter" = atmo_filter, \
										"f_type" = f_type)

	if(portData.len)
		data["ports"] = portData
	if(output)
		data["set_flow_rate"] = round(set_flow_rate*10)		//because nanoui can't handle rounded decimals.
		data["last_flow_rate"] = round(last_flow_rate*10)

	return data

/obj/machinery/atmospherics/omni/atmos_filter/proc/mode_send_switch(var/mode = ATM_NONE)
	switch(mode)
		if(ATM_O2)
			return "Oxygen"
		if(ATM_N2)
			return "Nitrogen"
		if(ATM_CO2)
			return "Carbon Dioxide"
		if(ATM_P)
			return "Phoron" //*cough* Plasma *cough*
		if(ATM_N2O)
			return "Nitrous Oxide"
		else
			return null

/obj/machinery/atmospherics/omni/atmos_filter/tgui_act(action, params)
	if(..())
		return TRUE
	
	switch(action)
		if("power")
			if(!configuring)
				update_use_power(!use_power)
			else
				update_use_power(USE_POWER_OFF)
			. = TRUE
		if("configure")
			configuring = !configuring
			if(configuring)
				update_use_power(USE_POWER_OFF)
			. = TRUE
		if("set_flow_rate")
			if(!configuring || use_power)
				return
			var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[max_flow_rate]L/s)","Flow Rate Control",set_flow_rate) as num
			set_flow_rate = between(0, new_flow_rate, max_flow_rate)
			. = TRUE
		if("switch_mode")
			if(!configuring || use_power)
				return
			switch_mode(dir_flag(params["dir"]), mode_return_switch(params["mode"]))
			. = TRUE
		if("switch_filter")
			if(!configuring || use_power)
				return
			var/new_filter = tgui_input_list(usr, "Select filter mode:", "Change filter", list("None", "Oxygen", "Nitrogen", "Carbon Dioxide", "Phoron", "Nitrous Oxide"))
			if(!new_filter)
				return
			switch_filter(dir_flag(params["dir"]), mode_return_switch(new_filter))
			. = TRUE

	update_icon()

/obj/machinery/atmospherics/omni/atmos_filter/proc/mode_return_switch(var/mode)
	switch(mode)
		if("Oxygen")
			return ATM_O2
		if("Nitrogen")
			return ATM_N2
		if("Carbon Dioxide")
			return ATM_CO2
		if("Phoron")
			return ATM_P
		if("Nitrous Oxide")
			return ATM_N2O
		if("in")
			return ATM_INPUT
		if("out")
			return ATM_OUTPUT
		if("None")
			return ATM_NONE
		else
			return null

/obj/machinery/atmospherics/omni/atmos_filter/proc/switch_filter(var/dir, var/mode)
	//check they aren't trying to disable the input or output ~this can only happen if they hack the cached tmpl file
	for(var/datum/omni_port/P in ports)
		if(P.dir == dir)
			if(P.mode == ATM_INPUT || P.mode == ATM_OUTPUT)
				return

	switch_mode(dir, mode)

/obj/machinery/atmospherics/omni/atmos_filter/proc/switch_mode(var/port, var/mode)
	if(mode == null || !port)
		return
	var/datum/omni_port/target_port = null
	var/list/other_ports = new()

	for(var/datum/omni_port/P in ports)
		if(P.dir == port)
			target_port = P
		else
			other_ports += P

	var/previous_mode = null
	if(target_port)
		previous_mode = target_port.mode
		target_port.mode = mode
		if(target_port.mode != previous_mode)
			handle_port_change(target_port)
		else
			return
	else
		return

	for(var/datum/omni_port/P in other_ports)
		if(P.mode == mode)
			var/old_mode = P.mode
			P.mode = previous_mode
			if(P.mode != old_mode)
				handle_port_change(P)

	update_ports()

/obj/machinery/atmospherics/omni/atmos_filter/proc/rebuild_filtering_list()
	filtering_outputs.Cut()
	for(var/datum/omni_port/P in ports)
		var/gasid = mode_to_gasid(P.mode)
		if(gasid)
			filtering_outputs[gasid] = P.air

/obj/machinery/atmospherics/omni/atmos_filter/proc/handle_port_change(var/datum/omni_port/P)
	switch(P.mode)
		if(ATM_NONE)
			initialize_directions &= ~P.dir
			P.disconnect()
		else
			initialize_directions |= P.dir
			P.connect()
	P.update = 1