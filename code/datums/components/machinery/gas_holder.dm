/* Component that allows any movable atom to hold gas inside of it.
 */
/datum/component/gas_holder
	///The gas mixture we possess.
	var/datum/gas_mixture/air_contents = new
	///CONVERT THIS TO A WEAKREF
	var/obj/machinery/atmospherics/portables_connector/connected_port
	///Starting volume of our gas_mixture.
	var/volume = 1000
	///Starting pressure of the gasses we spawn with.
	var/start_pressure = ONE_ATMOSPHERE


	//Rupture stuff!

	///Maximum pressure we can hold (before bursting)
	var/maximum_pressure = 90 * ONE_ATMOSPHERE
	///If the vessel can rupture or not
	var/can_rupture = FALSE
	///How much integrity (lowered when our pressure is too high) we have. Explodes/breaches when it reaches 0!
	var/max_integrity = 20
	///Our current integrity
	var/integrity = 20
	///How much temperature until we begin leaking
	var/failure_temp = 173 //173 C
	///If we are currently leaking (mixing with our current atmos) or not.
	var/leaking = FALSE


	var/list/gasses_to_add = list(GAS_O2)

//Yes, it's using 'gas 1 pressure gas 2 pressure etc'...I need to know a better way to do this.
/datum/component/gas_holder/Initialize(list/gasses_to_add, gas_one_pressure, gas_two_pressure, gas_three_pressure, gas_four_pressure, volume, temperature, start_pressure, maximum_pressure, can_rupture, max_integrity, integrity, leaking)
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

	if((gasses_to_add && LAZYLEN(gasses_to_add)))
		src.gasses_to_add = gasses_to_add

	if(start_pressure)
		src.start_pressure = start_pressure

	if(maximum_pressure)
		src.maximum_pressure = maximum_pressure

	if(can_rupture)
		src.can_rupture = can_rupture

	if(max_integrity)
		src.max_integrity = max_integrity
	if(integrity)
		src.integrity = integrity
	if(leaking)
		src.leaking = leaking

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
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(handle_attack))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(handle_unbuckle))

/datum/component/gas_holder/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_ATTACKBY, COMSIG_MOVABLE_UNBUCKLE))

///Returns the atmosphere we are currently using. Used by analyzers.
/datum/component/gas_holder/proc/return_atmos()
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
	disconnect()
	QDEL_NULL(air_contents)
	connected_port = null
	..()

///Handles gas reactions inside us.
/datum/component/gas_holder/process()
	var/atom/movable/our_parent = parent
	if(!connected_port) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		if(ismob(our_parent)) //If we're a mob, make our gas assume the temp of our owner. Up to a 5K difference.
			var/mob/our_mob = parent
			//Our contents is hotter than our vessel, cool it down.
			if(air_contents.temperature+5 > our_mob.bodytemperature)
				air_contents.add_thermal_energy(-our_mob.bodytemperature)
			//Our contents is colder than our vessel, heat it up.
			if(air_contents.temperature-5 < our_mob.bodytemperature)
				air_contents.add_thermal_energy(our_mob.bodytemperature)
		air_contents.react()
		check_status() //We ONLY go kaboom when we're off of a pipeline.
		return
	//Just in case we somehow moved while we were attached.
	if(connected_port.loc != our_parent.loc)
		disconnect()

/datum/component/gas_holder/proc/check_status()
	var/atom/movable/our_parent = parent
	//Handle exploding, leaking, and rupturing of the tank

	if(!air_contents || !can_rupture)
		return

	var/pressure = air_contents.return_pressure()


	if(pressure > TANK_FRAGMENT_PRESSURE)
		disconnect()
		if(integrity <= 7)
			message_admins("A gas holder has ruptured! tank rupture! last key to touch [our_parent.name] was [our_parent.forensic_data?.get_lastprint()].")
			log_game("Explosive tank rupture! last key to touch [our_parent.name] was [our_parent.forensic_data?.get_lastprint()].")

			//Give the gas a chance to build up more pressure through reacting
			air_contents.react()
			air_contents.react()
			air_contents.react()

			pressure = air_contents.return_pressure()
			var/strength = ((pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE)

			var/mult = ((src.air_contents.volume/140)**(1/2)) * (air_contents.total_moles**(2/3))/((29*0.64) **(2/3)) //tanks appear to be experiencing a reduction on scale of about 0.64 total moles
			//tanks appear to be experiencing a reduction on scale of about 0.64 total moles



			var/turf/simulated/T = get_turf(our_parent)
			T.hotspot_expose(air_contents.temperature, 70, 1)
			if(!T)
				return

			T.assume_air(air_contents)
			explosion(
				get_turf(our_parent.loc),
				round(min(BOMBCAP_DVSTN_RADIUS, ((mult)*strength)*0.15)),
				round(min(BOMBCAP_HEAVY_RADIUS, ((mult)*strength)*0.35)),
				round(min(BOMBCAP_LIGHT_RADIUS, ((mult)*strength)*0.80)),
				round(min(BOMBCAP_FLASH_RADIUS, ((mult)*strength)*1.20)),
				)

			if(isobj(our_parent))
				var/obj/our_obj = parent
				var/num_fragments = round(rand(8,10) * sqrt(strength * mult))
				our_obj.fragmentate(T, num_fragments, rand(5) + 7, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 7,/obj/item/projectile/bullet/pellet/fragment/tank = 2,/obj/item/projectile/bullet/pellet/fragment/strong = 1))

			if(our_parent && !QDELETED(our_parent))
				if(ismob(our_parent))
					var/mob/our_mob = parent
					our_mob.gib()
					return
				else
					qdel(our_parent)
					return

		else
			integrity -=7


	else if(pressure > TANK_RUPTURE_PRESSURE)
		disconnect()
		#ifdef FIREDBG
		log_world(span_warning("[our_parent.x],[our_parent.y] tank is rupturing: [pressure] kPa, integrity [integrity]"))
		#endif

		air_contents.react()

		if(integrity <= 0)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			T.assume_air(air_contents)
			playsound(src, 'sound/weapons/gunshot_shotgun.ogg', 20, 1)
			our_parent.visible_message("[icon2html(src,viewers(src))] " + span_danger("\The [parent] flies apart!"), span_warning("You hear a bang!"))
			T.hotspot_expose(air_contents.temperature, 70, 1)


			var/strength = 1+((pressure-TANK_LEAK_PRESSURE)/TANK_FRAGMENT_SCALE)

			var/mult = (air_contents.total_moles**2/3)/((29*0.64) **2/3) //tanks appear to be experiencing a reduction on scale of about 0.64 total moles

			if(isobj(our_parent))
				var/obj/our_obj = parent
				var/num_fragments = round(rand(6,8) * sqrt(strength * mult)) //Less chunks, but bigger
				our_obj.fragmentate(T, num_fragments, 7, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 1,/obj/item/projectile/bullet/pellet/fragment/tank = 5,/obj/item/projectile/bullet/pellet/fragment/strong = 4))

			if(our_parent && !QDELETED(our_parent))
				if(ismob(our_parent))
					var/mob/our_mob = parent
					our_mob.gib()
					return
				else
					qdel(our_parent)
					return

		else
			integrity-= 5


	else if(pressure > TANK_LEAK_PRESSURE || air_contents.temperature - T0C > failure_temp)

		if((integrity <= 17 || src.leaking))
			var/turf/simulated/T = get_turf(our_parent)
			if(!T)
				return
			var/datum/gas_mixture/environment = our_parent.loc.return_air()
			var/env_pressure = environment.return_pressure()
			var/tank_pressure = src.air_contents.return_pressure()

			var/release_ratio = 0.002
			if(tank_pressure)
				release_ratio = CLAMP(sqrt(max(tank_pressure-env_pressure,0)/tank_pressure), 0.002, 1)

			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(release_ratio)
			//dynamic air release based on ambient pressure

			T.assume_air(leaked_gas)
			if(!leaking)
				our_parent.visible_message("[icon2html(src,viewers(src))] " + span_warning("\The [src] relief valve flips open with a hiss!"), "You hear hissing.")
				playsound(our_parent, 'sound/effects/spray.ogg', 10, 1, -3)
				leaking = TRUE
				#ifdef FIREDBG
				log_world(span_warning("[our_parent.x],[our_parent.y] tank is leaking: [pressure] kPa, integrity [integrity]"))
				#endif

	else
		if(integrity < max_integrity)
			integrity++
			if(leaking)
				integrity++
			if(integrity == max_integrity)
				leaking = FALSE
	if(leaking)
		mingle_with_turf(get_turf(parent), volume)

///Disconnect from our connected port when we unbuckle.
/datum/component/gas_holder/proc/handle_unbuckle(atom/movable/parent, force)
	SIGNAL_HANDLER
	disconnect()
	return

/datum/component/gas_holder/proc/mingle_with_turf(turf/simulated/target, mingle_volume)
	if(!target || !mingle_volume)
		return
	var/datum/gas_mixture/air_sample = air_contents.remove_ratio(mingle_volume/air_contents.volume)
	air_sample.volume = mingle_volume

	if(istype(target) && target.zone)
		//Have to consider preservation of group statuses
		var/datum/gas_mixture/turf_copy = new
		var/datum/gas_mixture/turf_original = new

		turf_copy.copy_from(target.zone.air)
		turf_copy.volume = target.zone.air.volume //Copy a good representation of the turf from parent group
		turf_original.copy_from(turf_copy)

		equalize_gases(list(air_sample, turf_copy))
		air_contents.merge(air_sample)


		target.zone.air.remove(turf_original.total_moles)
		target.zone.air.merge(turf_copy)

	else
		var/datum/gas_mixture/turf_air = target.return_air()

		equalize_gases(list(air_sample, turf_air))
		air_contents.merge(air_sample)
		//turf_air already modified by equalize_gases()

	if(connected_port && connected_port.network)
		connected_port.network.update = 1


///When we are connected to a port.
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
	if(ismob(our_parent))
		var/mob/our_mob = our_parent
		our_mob.buckled = new_port

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = TRUE

	return TRUE

///Disconnect from our connected port if possible.
/datum/component/gas_holder/proc/disconnect()
	var/atom/movable/our_parent = parent
	if(!connected_port)
		return FALSE

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	our_parent.anchored = FALSE
	if(ismob(our_parent))
		connected_port.unbuckle_mob(our_parent, TRUE)

	connected_port.connected_device = null
	connected_port = null

	return TRUE

///What we do when hit with a wrench.
/datum/component/gas_holder/proc/handle_attack(atom/movable/our_parent, obj/item/tool as obj, mob/user as mob)
	SIGNAL_HANDLER
	if(user.a_intent != I_HELP) //We let them do their normal attack chain.
		return FALSE
	if(!istype(tool))
		return FALSE
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
