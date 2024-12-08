#define FUSION_ENERGY_PER_K 20
#define FUSION_MAX_ENVIRO_HEAT 5000 //raise this if you want the reactor to dump more energy into the atmosphere
#define PLASMA_TEMP_RADIATION_DIVISIOR 20 //radiation divisior. plasma temp / divisor = radiation.


/obj/effect/fusion_em_field
	name = "electromagnetic field"
	desc = "A coruscating, barely visible field of energy. It is shaped like a slightly flattened torus."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "emfield_s1"
	alpha = 50
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	light_color = "#cc7700"

	var/size = 1
	var/energy = 0
	var/plasma_temperature = 0
	var/radiation = 0
	var/field_strength = 0.01
	var/tick_instability = 0
	var/percent_unstable = 0
	var/stable = 1
	var/id_tag
	var/critical = 0

	var/obj/machinery/power/fusion_core/owned_core
	var/list/dormant_reactant_quantities = list()
	var/list/particle_catchers = list()

	var/list/ignore_types = list(
		/obj/item/projectile,
		/obj/effect,
		/obj/fire,
		/obj/structure/cable,
		/obj/machinery/atmospherics,
		/obj/machinery/air_sensor,
		/mob/observer,
		/obj/machinery/power/hydromagnetic_trap
		)

	var/light_min_range = 2
	var/light_min_power = 3
	var/light_max_range = 5
	var/light_max_power = 5

	var/last_range
	var/last_power

/obj/effect/fusion_em_field/New(loc, var/obj/machinery/power/fusion_core/new_owned_core)
	..()

	set_light(light_min_range,light_min_power)
	last_range = light_min_range
	last_power = light_min_power

	owned_core = new_owned_core
	if(!owned_core)
		qdel(src)
	id_tag = owned_core.id_tag
	//create the gimmicky things to handle field collisions
	var/obj/effect/fusion_particle_catcher/catcher

	catcher = new (locate(src.x,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(1)
	particle_catchers.Add(catcher)

	catcher = new (locate(src.x-1,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x+1,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y+1,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y-1,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)

	catcher = new (locate(src.x-2,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x+2,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y+2,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y-2,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)

	catcher = new (locate(src.x-3,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x+3,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y+3,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y-3,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)

/obj/effect/fusion_em_field/process()
	//make sure the field generator is still intact
	if(!owned_core || QDELETED(owned_core))
		qdel(src)
		return

	// Take some gas up from our environment.
	var/added_particles = FALSE
	var/datum/gas_mixture/uptake_gas = owned_core.loc.return_air()
	if(uptake_gas)
		uptake_gas = uptake_gas.remove_by_flag(XGM_GAS_FUSION_FUEL, rand(50,100))
	if(uptake_gas && uptake_gas.total_moles)
		for(var/gasname in uptake_gas.gas)
			if(uptake_gas.gas[gasname]*10 > dormant_reactant_quantities[gasname])
				AddParticles(gasname, uptake_gas.gas[gasname]*10)
				uptake_gas.adjust_gas(gasname, -(uptake_gas.gas[gasname]), update=FALSE)
				added_particles = TRUE
		if(added_particles)
			uptake_gas.update_values()

	//let the particles inside the field react
	React()

	// Dump power to our powernet.
	owned_core.add_avail(FUSION_ENERGY_PER_K * plasma_temperature)

	// Energy decay.
	if(plasma_temperature >= 1)
		var/lost = plasma_temperature*0.01
		radiation += lost
		plasma_temperature -= lost

	//handle some reactants formatting
	for(var/reactant in dormant_reactant_quantities)
		var/amount = dormant_reactant_quantities[reactant]
		if(amount < 1)
			dormant_reactant_quantities.Remove(reactant)
		else if(amount >= 1000000)
			var/radiate = rand(3 * amount / 4, amount / 4)
			dormant_reactant_quantities[reactant] -= radiate
			radiation += radiate

		if(owned_core.reactant_dump)
			var/datum/material/Mat = get_material_by_name(reactant)

			// If the reactor won't be able to produce a sheet during shutdown with the material, it can syphon it from the field into internal storage.
			if(!Mat && amount > 1000 && owned_core.reagents.add_reagent(reactant, 0.1))	// If you want to get ingots / sheets from the tokomak, you have to shut it down, hopefully safely. Reactor reactants are either gas with a corresponding reagent IE Oxygen, Phoron, a Material which condenses uniquely on its own, or just a reagent.
				dormant_reactant_quantities[reactant] -= 1000

	var/use_range
	var/use_power
	if(plasma_temperature <= 6000)
		use_range = light_min_range
		use_power = light_min_power
	else if(plasma_temperature >= 25000)
		use_range = light_max_range
		use_power = light_max_power
	else
		var/temp_mod = ((plasma_temperature-5000)/20000)
		use_range = light_min_range + CEILING((light_max_range-light_min_range)*temp_mod, 1)
		use_power = light_min_power + CEILING((light_max_power-light_min_power)*temp_mod, 1)

	if(last_range != use_range || last_power != use_power)
		set_light(use_range,use_power)
		last_range = use_range
		last_power = use_power

	check_instability()
	Radiate()
	return 1

/obj/effect/fusion_em_field/proc/check_instability()
	if(tick_instability > 0)
		percent_unstable += (tick_instability*size)/10000
		tick_instability = 0
	else
		if(percent_unstable < 0)
			percent_unstable = 0
		else
			if(percent_unstable > 1)
				percent_unstable = 1
			if(percent_unstable > 0)
				percent_unstable = max(0, percent_unstable-rand(0.01,0.03))

	if(percent_unstable >= 1)
		owned_core.Shutdown(force_rupture=1)
	else
		if(percent_unstable > 0.1 && prob(percent_unstable*100))
			if(plasma_temperature < 2000)
				visible_message(span_danger("\The [src] ripples uneasily, like a disturbed pond."))
			else
				var/flare
				var/fuel_loss
				var/rupture
				if(percent_unstable > 0.2)
					visible_message(span_danger("\The [src] ripples uneasily, like a disturbed pond."))
					flare = prob(25)
				else if(percent_unstable > 0.5)
					visible_message(span_danger("\The [src] undulates violently, shedding plumes of plasma!"))
					flare = prob(50)
					fuel_loss = prob(20)
					rupture = prob(5)
				else if(percent_unstable > 0.8)
					visible_message(span_danger("\The [src] is wracked by a series of horrendous distortions, buckling and twisting like a living thing!"))
					flare = 1
					fuel_loss = prob(50)
					rupture = prob(25)

				if(rupture)
					if(prob(80))
						MagneticQuench()
						return
					else if(prob(15))
						MRC()
						return
					else if(prob(5))
						QuantumFluxCascade()
						return
					else if(prob(5))
						BluespaceQuenchEvent()
						return
				else
					var/lost_plasma = (plasma_temperature*percent_unstable)
					radiation += lost_plasma
					if(flare)
						spawn(1)
							emflare()
					if(fuel_loss)
						for(var/particle in dormant_reactant_quantities)
							var/lost_fuel = dormant_reactant_quantities[particle]*percent_unstable
							radiation += lost_fuel
							dormant_reactant_quantities[particle] -= lost_fuel
							if(dormant_reactant_quantities[particle] <= 0)
								dormant_reactant_quantities.Remove(particle)
					Radiate()
	return
/*/obj/effect/fusion_em_field/proc/CheckCriticality()
	if (plasma_temperature > 70000)
		critical += 0.2
	else if (instability > 0.45)
		critical += 0.6
	if(critical >= 25 && prob(percent_unstable*100))
		if (critical >= 90)
			visible_message(span_danger("\The [src] rumbles and quivers violently, threatening to break free!"))
		else if(critical >= 50)
			visible_message(span_danger("\The [src] rumbles and quivers energetically, the walls distorting slightly."))
		else if(critical >= 25)
			visible_message(span_danger("\The [src] rumbles and quivers slightly, vibrating the deck."))
*/
/obj/effect/fusion_em_field/proc/ChangeFieldStrength(var/new_strength)
	var/calc_size = 1
	if(new_strength <= 50)
		calc_size = 1
	else if(new_strength <= 200)
		calc_size = 3
	else if(new_strength <= 500)
		calc_size = 5
	else
		calc_size = 7
	field_strength = new_strength
	change_size(calc_size)

/obj/effect/fusion_em_field/proc/AddEnergy(var/a_energy, var/a_plasma_temperature)
	energy += a_energy
	plasma_temperature += a_plasma_temperature
	if(a_energy && percent_unstable > 0)
		percent_unstable -= a_energy/10000
		if(percent_unstable < 0)
			percent_unstable = 0
	while(energy >= 100)
		energy -= 100
		plasma_temperature += 1

/obj/effect/fusion_em_field/proc/AddParticles(var/name, var/quantity = 1)
	if(name in dormant_reactant_quantities)
		dormant_reactant_quantities[name] += quantity
	else if(name != "proton" && name != "electron" && name != "neutron")
		dormant_reactant_quantities.Add(name)
		dormant_reactant_quantities[name] = quantity

/obj/effect/fusion_em_field/proc/RadiateAll(var/ratio_lost = 1)

	// Create our plasma field and dump it into our environment.
	var/turf/T = get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/plasma = new
		plasma.adjust_gas(GAS_O2, (size*100), 0)
		plasma.adjust_gas(GAS_PHORON, (size*100), 0)
		plasma.temperature = (plasma_temperature/2)
		plasma.update_values()
		T.assume_air(plasma)
		T.hotspot_expose(plasma_temperature)
		plasma = null

	// Radiate all our unspent fuel and energy.
	for(var/particle in dormant_reactant_quantities)
		radiation += dormant_reactant_quantities[particle]

		var/datum/material/Mat = get_material_by_name(particle)

		if(Mat)
			while(dormant_reactant_quantities[particle] > 0)
				var/present_amount = dormant_reactant_quantities[particle] / 10000	// Reset this to the amount of the reagent present.

				if(present_amount >= 20 && Mat.stack_type)
					var/obj/S = new Mat.stack_type
					dormant_reactant_quantities[particle] -= 20
					S.throw_at_random(FALSE, 7, 3)

				else
					dormant_reactant_quantities[particle] = 0

		dormant_reactant_quantities.Remove(particle)
	radiation += plasma_temperature/2
	plasma_temperature = 0

	SSradiation.radiate(src, radiation)
	Radiate()

/obj/effect/fusion_em_field/proc/Radiate()
	if(istype(loc, /turf))
		var/empsev = max(1, min(3, CEILING(size/2, 1)))
		for(var/atom/movable/AM in range(max(1,FLOOR(size/2, 1)), loc))

			if(AM == src || AM == owned_core || !AM.simulated)
				continue

			var/skip_obstacle
			for(var/ignore_path in ignore_types)
				if(istype(AM, ignore_path))
					skip_obstacle = TRUE
					break
			if(skip_obstacle)
				continue

			log_debug("R-UST DEBUG: [AM] is [AM.type]")
			AM.visible_message(span_danger("The field buckles visibly around \the [AM]!"))
			tick_instability += rand(15,30)
			AM.emp_act(empsev)

/obj/effect/fusion_em_field/proc/change_size(var/newsize = 1)
	var/changed = 0
	switch(newsize)
		if(1)
			size = 1
			icon = 'icons/obj/machines/power/fusion.dmi'
			icon_state = "emfield_s1"
			pixel_x = 0
			pixel_y = 0
			//
			changed = 1
		if(3)
			size = 3
			icon = 'icons/effects/96x96.dmi'
			icon_state = "emfield_s3"
			pixel_x = -32 * PIXEL_MULTIPLIER
			pixel_y = -32 * PIXEL_MULTIPLIER
			//
			changed = 3
		if(5)
			size = 5
			icon = 'icons/effects/160x160.dmi'
			icon_state = "emfield_s5"
			pixel_x = -64 * PIXEL_MULTIPLIER
			pixel_y = -64 * PIXEL_MULTIPLIER
			//
			changed = 5
		if(7)
			size = 7
			icon = 'icons/effects/224x224.dmi'
			icon_state = "emfield_s7"
			pixel_x = -96 * PIXEL_MULTIPLIER
			pixel_y = -96 * PIXEL_MULTIPLIER
			//
			changed = 7
	for(var/obj/effect/fusion_particle_catcher/catcher in particle_catchers)
		catcher.UpdateSize()
	return changed

//the !!fun!! part
/obj/effect/fusion_em_field/proc/React()
	//loop through the reactants in random order
	var/list/react_pool = dormant_reactant_quantities.Copy()

	//cant have any reactions if there aren't any reactants present
	if(react_pool.len)
		//determine a random amount to actually react this cycle, and remove it from the standard pool
		//this is a hack, and quite nonrealistic :(
		for(var/reactant in react_pool)
			react_pool[reactant] = rand(FLOOR(react_pool[reactant]/2, 1),react_pool[reactant])
			dormant_reactant_quantities[reactant] -= react_pool[reactant]
			if(!react_pool[reactant])
				react_pool -= reactant

		//loop through all the reacting reagents, picking out random reactions for them
		var/list/produced_reactants = new/list
		var/list/p_react_pool = react_pool.Copy()
		while(p_react_pool.len)
			//pick one of the unprocessed reacting reagents randomly
			var/cur_p_react = pick(p_react_pool)
			p_react_pool.Remove(cur_p_react)

			//grab all the possible reactants to have a reaction with
			var/list/possible_s_reacts = react_pool.Copy()
			//if there is only one of a particular reactant, then it can not react with itself so remove it
			possible_s_reacts[cur_p_react] -= 1
			if(possible_s_reacts[cur_p_react] < 1)
				possible_s_reacts.Remove(cur_p_react)

			//loop through and work out all the possible reactions
			var/list/possible_reactions = new/list
			for(var/cur_s_react in possible_s_reacts)
				if(possible_s_reacts[cur_s_react] < 1)
					continue
				var/decl/fusion_reaction/cur_reaction = get_fusion_reaction(cur_p_react, cur_s_react)
				if(cur_reaction && plasma_temperature >= cur_reaction.minimum_energy_level)
					possible_reactions.Add(cur_reaction)

			//if there are no possible reactions here, abandon this primary reactant and move on
			if(!possible_reactions.len)
				continue

			//split up the reacting atoms between the possible reactions
			while(possible_reactions.len)
				var/decl/fusion_reaction/cur_reaction = pick(possible_reactions)
				possible_reactions.Remove(cur_reaction)

				//set the randmax to be the lower of the two involved reactants
				var/max_num_reactants = react_pool[cur_reaction.p_react] > react_pool[cur_reaction.s_react] ? \
				react_pool[cur_reaction.s_react] : react_pool[cur_reaction.p_react]
				if(max_num_reactants < 1)
					continue

				//make sure we have enough energy
				if(plasma_temperature < cur_reaction.minimum_reaction_temperature)
					continue

				if(plasma_temperature < max_num_reactants * cur_reaction.energy_consumption)
					max_num_reactants = round(plasma_temperature / cur_reaction.energy_consumption)
					if(max_num_reactants < 1)
						continue

				//randomly determined amount to react
				var/amount_reacting = rand(1, max_num_reactants)

				//removing the reacting substances from the list of substances that are primed to react this cycle
				//if there aren't enough of that substance (there should be) then modify the reactant amounts accordingly
				if( react_pool[cur_reaction.p_react] - amount_reacting >= 0 )
					react_pool[cur_reaction.p_react] -= amount_reacting
				else
					amount_reacting = react_pool[cur_reaction.p_react]
					react_pool[cur_reaction.p_react] = 0
				//same again for secondary reactant
				if(react_pool[cur_reaction.s_react] - amount_reacting >= 0 )
					react_pool[cur_reaction.s_react] -= amount_reacting
				else
					react_pool[cur_reaction.p_react] += amount_reacting - react_pool[cur_reaction.p_react]
					amount_reacting = react_pool[cur_reaction.s_react]
					react_pool[cur_reaction.s_react] = 0

				plasma_temperature -= max_num_reactants * cur_reaction.energy_consumption  // Remove the consumed energy.
				plasma_temperature += max_num_reactants * cur_reaction.energy_production   // Add any produced energy.
				radiation +=   max_num_reactants * cur_reaction.radiation           // Add any produced radiation.
				tick_instability += max_num_reactants * cur_reaction.instability

				// Create the reaction products.
				for(var/reactant in cur_reaction.products)
					var/success = 0
					for(var/check_reactant in produced_reactants)
						if(check_reactant == reactant)
							produced_reactants[reactant] += cur_reaction.products[reactant] * amount_reacting
							success = 1
							break
					if(!success)
						produced_reactants[reactant] = cur_reaction.products[reactant] * amount_reacting

				// Handle anything special. If this proc returns true, abort the current reaction.
				if(cur_reaction.handle_reaction_special(src))
					return

				// This reaction is done, and can't be repeated this sub-cycle.
				possible_reactions.Remove(cur_reaction.s_react)

		// Loop through the newly produced reactants and add them to the pool.
		for(var/reactant in produced_reactants)
			AddParticles(reactant, produced_reactants[reactant])

		// Check whether there are reactants left, and add them back to the pool.
		for(var/reactant in react_pool)
			AddParticles(reactant, react_pool[reactant])

/obj/effect/fusion_em_field/Destroy()
	set_light(0)
	RadiateAll()
	for(var/obj/effect/fusion_particle_catcher/catcher in particle_catchers)
		qdel(catcher)
	if(owned_core)
		owned_core.owned_field = null
		owned_core = null
	. = ..()

/obj/effect/fusion_em_field/bullet_act(var/obj/item/projectile/Proj)
	AddEnergy(Proj.damage)
	update_icon()
	return 0
//All procs below this point are called in _core.dm, starting at line 41.
//Stability monitoring. Gives radio annoucements if field stability is below 80%
/obj/effect/fusion_em_field/proc/stability_monitor()
	var/warnpoint = 0.10 //start warning at 10% instability
	var/warnmessage = "Warning! Field unstable! Instability at [percent_unstable * 100]%, plasma temperature at [plasma_temperature + 295]k."
	var/stablemessage = "Containment field returning to stable conditions."

	if(percent_unstable >= warnpoint) //we're unstable, start warning engineering
		global_announcer.autosay(warnmessage, "Field Stability Monitor", "Engineering")
		stable = FALSE //we know we're not stable, so let's not state the safe message.
	else if(percent_unstable < warnpoint && stable == 0) //The field is stable again. Let's set our safe variable and state the safe message.
		global_announcer.autosay(stablemessage, "Field Stability Monitor", "Engineering")
		stable = TRUE
	return

//Reaction radiation is fairly buggy and there's at least three procs dealing with radiation here, this is to ensure constant radiation output.
/obj/effect/fusion_em_field/proc/radiation_scale()
	SSradiation.radiate(src, 2 + plasma_temperature / PLASMA_TEMP_RADIATION_DIVISIOR)

//Somehow fixing the radiation issue managed to break this, but moving it to it's own proc seemed to have fixed it. I don't know.
/obj/effect/fusion_em_field/proc/temp_dump()
	if(owned_core && owned_core.loc)
		var/datum/gas_mixture/environment = owned_core.loc.return_air()
		if(environment && environment.temperature < (T0C+FUSION_MAX_ENVIRO_HEAT))
			environment.add_thermal_energy(plasma_temperature*5000)
			check_instability()

//Temperature changes depending on color.
/obj/effect/fusion_em_field/proc/temp_color()
	if(plasma_temperature > 60000) //high ultraviolet - magenta
		light_color = "#cc005f"
		light_max_range = 25
		light_max_power = 10
	else if(plasma_temperature > 12000) //ultraviolet - blue
		light_color = "#1b00cc"
		light_max_range = 20
		light_max_power = 10
	else if(plasma_temperature > 8000) //nearing ultraviolet - cyan
		light_color = "#00cccc"
		light_max_range = 15
		light_max_power = 10
	else if(plasma_temperature > 4000) // green
		light_color = "#1ab705"
		light_max_range = 10
		light_max_power = 10
	else if(plasma_temperature <= 4000) //orange
		light_color = "#cc7700"
		light_max_range = 5
		light_max_power = 5
	return
//moved the flare to a proc for various reasons. Called on line 225.
/obj/effect/fusion_em_field/proc/emflare()
		radiation += plasma_temperature/2
		light_color = "#ff0000"
		light_max_power = 30
		light_min_power = 30
		light_min_range = 30
		light_max_range = 30
		visible_message(span_danger("\The [src] flares to eye-searing brightness!"))
		sleep(60)
		temp_color()
		//plasma_temperature -= lost_plasma
		return
//Rupture() is no longer the end all be all. Fear the magnetic resonance cascade and quantum flux cascade


/obj/effect/fusion_em_field/proc/Rupture()
	visible_message(span_danger("\The [src] shudders like a dying animal before flaring to eye-searing brightness and rupturing!"))
	set_light(15, 15, "#CCCCFF")
	empulse(get_turf(src), CEILING(plasma_temperature/1000, 1), CEILING(plasma_temperature/300, 1))
	global_announcer.autosay("WARNING: FIELD RUPTURE IMMINENT!", "Containment Monitor")
	RadiateAll()
	var/list/things_in_range = range(10, owned_core)
	var/list/turfs_in_range = list()
	for (var/turf/T in things_in_range)
		turfs_in_range.Add(T)

	explosion(pick(things_in_range), -1, 5, 5, 5)
	empulse(pick(things_in_range), CEILING(plasma_temperature/1000, 1), CEILING(plasma_temperature/300, 1))
	spawn(25)
		explosion(pick(things_in_range), -1, 5, 5, 5)
		spawn(25)
			explosion(pick(things_in_range), -1, 5, 5, 5)
			spawn(25)
				explosion(pick(things_in_range), -1, 5, 5, 5)
				spawn(10)
					explosion(pick(things_in_range), -1, 5, 5, 5)
					spawn(10)
						explosion(pick(things_in_range), -1, 5, 5, 5)
						spawn(10)
							explosion(pick(things_in_range), -1, 5, 5, 5)
	return

/obj/effect/fusion_em_field/proc/MRC() //spews electromagnetic pulses in an area around the core.
	visible_message(span_danger("\The [src] glows an extremely bright pink and flares out of existance!"))
	global_announcer.autosay("Warning! Magnetic Resonance Cascade detected! Brace for electronic system distruption.", "Field Stability Monitor")
	set_light(15, 15, "#ff00d8")
	var/list/things_in_range = range(15, owned_core)
	var/list/turfs_in_range = list()
	for (var/turf/T in things_in_range)
		turfs_in_range.Add(T)
	for(var/loopcount = 1 to 10)
		spawn(200)
			empulse(pick(things_in_range), 10, 15)
	Destroy()
	return

/obj/effect/fusion_em_field/proc/QuantumFluxCascade() //spews hot phoron and oxygen in a radius around the RUST. Will probably set fire to things
	global_announcer.autosay("Warning! Quantum fluxuation detected! Flammable gas release expected.", "Field Stability Monitor")
	var/list/things_in_range = range(15, owned_core)
	var/list/turfs_in_range = list()
	for (var/turf/T in things_in_range)
		turfs_in_range.Add(T)
	for(var/loopcount = 1 to 10)
		var/turf/TT = get_turf(pick(turfs_in_range))
		if(istype(TT))
			var/datum/gas_mixture/plasma = new
			plasma.adjust_gas(GAS_O2, (size*100), 0)
			plasma.adjust_gas(GAS_PHORON, (size*100), 0)
			plasma.temperature = (plasma_temperature/2)
			plasma.update_values()
			TT.assume_air(plasma)
			TT.hotspot_expose(plasma_temperature)
			plasma = null
	Destroy()
	return

/obj/effect/fusion_em_field/proc/MagneticQuench() //standard hard shutdown. dumps hot oxygen/phoron into the core's area and releases an EMP in the area around the core.
	global_announcer.autosay("Warning! Magnetic Quench event detected, engaging hard shutdown.", "Field Stability Monitor")
	empulse(owned_core, 10, 15)
	var/turf/TT = get_turf(owned_core)
	if(istype(TT))
		var/datum/gas_mixture/plasma = new
		plasma.adjust_gas(GAS_O2, (size*100), 0)
		plasma.adjust_gas(GAS_PHORON, (size*100), 0)
		plasma.temperature = (plasma_temperature/2)
		plasma.update_values()
		TT.assume_air(plasma)
		TT.hotspot_expose(plasma_temperature)
		plasma = null
	Destroy()
	owned_core.Shutdown()
	return

/obj/effect/fusion_em_field/proc/BluespaceQuenchEvent() //!!FUN!! causes a number of explosions in an area around the core. Will likely destory or heavily damage the reactor.
	visible_message(span_danger("\The [src] shudders like a dying animal before flaring to eye-searing brightness and rupturing!"))
	set_light(15, 15, "#CCCCFF")
	empulse(get_turf(src), CEILING(plasma_temperature/1000, 1), CEILING(plasma_temperature/300, 1))
	global_announcer.autosay("WARNING: FIELD RUPTURE IMMINENT!", "Containment Monitor")
	RadiateAll()
	var/list/things_in_range = range(10, owned_core)
	var/list/turfs_in_range = list()
	for (var/turf/T in things_in_range)
		turfs_in_range.Add(T)
	for(var/loopcount = 1 to 10)
		explosion(pick(things_in_range), -1, 5, 5, 5)
		empulse(pick(things_in_range), CEILING(plasma_temperature/1000, 1), CEILING(plasma_temperature/300, 1))
	Destroy()
	owned_core.Shutdown()
	return

#undef FUSION_HEAT_CAP
#undef FUSION_ENERGY_PER_K
#undef FUSION_MAX_ENVIRO_HEAT
#undef PLASMA_TEMP_RADIATION_DIVISIOR
