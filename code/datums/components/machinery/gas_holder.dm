/* Component that allows any movable atom to hold gas inside of it.
 */
/datum/component/gas_holder
	var/datum/gas_mixture/air_contents = new
	///CONVERT THIS TO A WEAKREF
	var/obj/machinery/atmospherics/portables_connector/connected_port
	var/volume = 1000
	var/start_pressure = ONE_ATMOSPHERE
	var/maximum_pressure = 90 * ONE_ATMOSPHERE

//Yes, it's using 'gas 1 pressure gas 2 pressure etc'...I need to know a better way to do this.
/datum/component/gas_holder/Initialize(list/gasses_to_add, gas_one_pressure, gas_two_pressure, gas_three_pressure, gas_four_pressure, volume, temperature, start_pressure, maximum_pressure)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	if(volume)
		air_contents.volume = volume
	else
		air_contents.volume = src.volume

	if(temperature)
		air_contents.temperature = temperature
	else
		air_contents.temperature = T20C

	gasses_to_add = list(GAS_O2)

	if(LAZYLEN(gasses_to_add))
		///How many gasses we're added so far.
		var/total_gasses = 1
		///We default to adding the start_pressure UNLESS a specific pressure for that gas is given.
		///This is abysmal and needs to be replaced with a different way.
		var/pressure_to_use = start_pressure
		for(var/gas_type in gasses_to_add)
			//begin shitcode
			switch(total_gasses)
				if(1)
					if(gas_one_pressure)
						pressure_to_use = gas_one_pressure
						total_gasses++
				if(2)
					if(gas_two_pressure)
						pressure_to_use = gas_two_pressure
						total_gasses++
				if(3)
					if(gas_three_pressure)
						pressure_to_use = gas_three_pressure
						total_gasses++
				if(4)
					if(gas_four_pressure)
						pressure_to_use = gas_four_pressure
						total_gasses++
			//end shitcode
			air_contents.adjust_gas(gas_type, MolesForPressure(pressure_to_use))
	START_PROCESSING(SSfastprocess, src)

/datum/component/gas_holder/proc/MolesForPressure(var/target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/datum/component/gas_holder/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ANALYSER_ACT, PROC_REF(return_atmos))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(handle_attack))

/datum/component/gas_holder/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_ANALYSER_ACT, COMSIG_PARENT_ATTACKBY))

///Returns the atmosphere we are currently using. Used by analyzers.
/datum/component/gas_holder/proc/return_atmos(var/atom/target, var/datum/gas_mixture/mixture, var/mob/user)
	SIGNAL_HANDLER
	var/list/results = list()

	if(air_contents && air_contents.total_moles > 0)
		var/pressure = air_contents.return_pressure()
		var/total_moles = air_contents.total_moles
		results += span_notice("Pressure: [round(pressure,0.1)] kPa")
		for(var/mix in air_contents.gas)
			results += span_notice("[GLOB.gas_data.name[mix]]: [round((air_contents.gas[mix] / total_moles) * 100)]% ([round(air_contents.gas[mix], 0.01)] moles)")
		results += span_notice("Temperature: [round(air_contents.temperature-T0C)]&deg;C")
		results += span_notice("Heat Capacity: [round(air_contents.heat_capacity(),0.1)]")
	else
		results += span_notice("\The [parent] is empty!")

	return results

/datum/component/gas_holder/Destroy(force = FALSE)
	QDEL_NULL(air_contents)
	connected_port = null
	..()

/datum/component/gas_holder/process()
	if(!connected_port) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		air_contents.react()

/datum/component/gas_holder/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	var/atom/movable/our_parent = parent
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return FALSE

	//Make sure are close enough for a valid connection
	if(new_port.loc != our_parent.loc)
		return FALSE

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	connected_port.on = TRUE //Activate port updates

	our_parent.anchored = TRUE //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = TRUE

	return TRUE

/datum/component/gas_holder/proc/disconnect()
	var/atom/movable/our_parent = parent
	if(!connected_port)
		return FALSE

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	our_parent.anchored = FALSE

	connected_port.connected_device = null
	connected_port = null

	return TRUE

/datum/component/gas_holder/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.update = TRUE

/datum/component/gas_holder/proc/handle_attack(var/obj/item/tool as obj, var/mob/user as mob)
	var/atom/our_parent = parent
	if(tool.has_tool_quality(TOOL_WRENCH))
		if(connected_port)
			if(disconnect())
				to_chat(user, span_warning("You disconnect \the [parent] from the port."))
				our_parent.update_icon()
				playsound(parent, tool.usesound, 50, 1)
				return COMPONENT_CANCEL_ATTACK_CHAIN
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in our_parent.loc
			if(possible_port)
				if(connect(possible_port))
					to_chat(user, span_notice("You connect \the [parent] to the port."))
					our_parent.update_icon()
					playsound(parent, tool.usesound, 50, 1)
					return COMPONENT_CANCEL_ATTACK_CHAIN
				else
					to_chat(user, span_notice("\The [parent] failed to connect to the port."))
					return FALSE
	return FALSE

/* //reminder to make this a trait
/datum/trait/inflatable
	name = "Inflatable"
	desc = "You can somehow store air like a portable canister with an air port and a wrench."
	cost = 0

/datum/trait/inflatable/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	H.inflatable = 1
	..(S,H)
*/
