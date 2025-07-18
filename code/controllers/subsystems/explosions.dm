SUBSYSTEM_DEF(explosions)
	name = "Explosions"
	priority = FIRE_PRIORITY_EXPLOSIONS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 0.5 SECONDS

	VAR_PRIVATE/resolve_explosions = FALSE
	VAR_PRIVATE/list/currentrun = null
	VAR_PRIVATE/list/currentsignals = null
	VAR_PRIVATE/list/pending_explosions = list()
	VAR_PRIVATE/list/resolving_explosions = list()
	VAR_PRIVATE/list/explosion_signals = list()

/datum/controller/subsystem/explosions/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/explosions/stat_entry(msg)
	var/meme = ""
	switch(resolving_explosions.len)
		if(0 to 10000) meme = ""
		if(10000 to 15000) meme = "- HEAVY LOAD"
		if(15000 to 20000) meme = "- EXTREME LOAD"
		if(20000 to 25000) meme = "- I STILL FUNCTION"
		if(25000 to 30000) meme = "- WANNA BET?"
		if(30000 to INFINITY) meme = "- CALL /abort() TO FORCE END"
	msg = "E: [explosion_signals.len] | P: [pending_explosions.len] | R: [resolving_explosions.len] | CR : [currentrun.len] | CS : [currentsignals.len] - [resolve_explosions ? "RESOLVING" : currentrun.len ? "PREPARING" : "IDLING"] [meme]"
	return ..()

/datum/controller/subsystem/explosions/fire(resumed)
	// Build both queues. The first one gets the explosion power in each turf
	// The second queue applies that explosion power to all turfs and objects in them
	if(!resumed)
		if(resolve_explosions && !currentrun.len)
			end_resolve()
		if(!resolve_explosions)
			// Setup the explosion buffer!
			currentrun = pending_explosions.Copy()
			currentsignals = explosion_signals.Copy()
			pending_explosions.Cut()
			explosion_signals.Cut()
	if(currentrun.len == 0 && !resolve_explosions) // Wait till we're useful if we have nothing to do!
		suspend()
		return

	// The heavy lifting part...
	while(currentrun.len)
		// Lets handle list management here instead of in each proc
		// get the first key of the current run, use the key to get the
		// data, use the data, than discard it from the list using the key!
		var/key = currentrun[1] // Yes this is how you get the first KEY... byond why...
		if(resolve_explosions)
			fire_resolve_explosions(currentrun[key])
		else
			fire_prepare_explosions(currentrun[key])
		currentrun.Remove(key)

		// Check if we move on to final resolution
		if(currentrun.len == 0)
			if(!resolve_explosions)
				start_resolve()
				currentrun = resolving_explosions.Copy()
				resolving_explosions.Cut()
				return
			break // In resolution mode, break into final res ahead

		if(MC_TICK_CHECK)
			return

	// !!!Final resolution!!!
	// Toggles between setup, and explosion modes. Sends signals to dopplers. Rebuilds powernets
	// We've handled the actual explosions, it's time to wrap up everything else.
	// send signals to all machines scanning for them
	for(var/list/time_dat in currentsignals)
		var/x0 	= time_dat[1]
		var/y0 	= time_dat[2]
		var/z0 	= time_dat[3]
		var/devastation_range 	= time_dat[4]
		var/heavy_impact_range 	= time_dat[5]
		var/light_impact_range 	= time_dat[6]
		var/tim 				= time_dat[7]
		for(var/i,i<=GLOB.doppler_arrays.len,i++)
			var/obj/machinery/doppler_array/Array = GLOB.doppler_arrays[i]
			if(Array)
				Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range, tim - world.time)
	currentsignals.Cut()

	// return to setup mode... Unless...
	end_resolve()
	if(!pending_explosions.len)
		suspend_and_invoke_deferred_subsystems()

/datum/controller/subsystem/explosions/proc/fire_prepare_explosions(var/list/data)
	var/pwr = data[4]
	var/direction = data[5]
	var/starting_power = data[6]
	if(pwr <= 0)
		return
	//This step handles the gathering of turfs which will be ex_act() -ed in the next step. It also ensures each turf gets the maximum possible amount of power dealt to it.
	var/turf/epicenter = locate(data[1],data[2],data[3])
	if(!epicenter)
		return
	var/list/res_explo = resolving_explosions["[epicenter.x].[epicenter.y].[epicenter.z]"] // check if this has already resolved
	if(res_explo && res_explo[4] >= pwr)
		return
	if(direction)
		//This is the amount of power that will be spread to the tile in the direction of the blast, subtracted from everything blocking it in the turf!
		var/spread_power = pwr - epicenter.explosion_resistance
		for(var/obj/O in epicenter)
			if(O.explosion_resistance)
				spread_power -= O.explosion_resistance
		if(spread_power > 0)
			// Fan outward from the original explosion
			var/turf/T = get_step(epicenter, direction)
			if(T)
				append_currentrun(T.x,T.y,T.z,spread_power,direction,starting_power)
				T = get_step(epicenter, turn(direction,90))
				if(T)
					append_currentrun(T.x,T.y,T.z,spread_power,direction,starting_power)
				T = get_step(src, turn(direction,-90))
				if(T)
					append_currentrun(T.x,T.y,T.z,spread_power,direction,starting_power)
			// Make these feel a little more flashy
			if(spread_power > 3 && spread_power < GLOB.max_explosion_range && prob(6)) // bombs above maxcap are probably badmins, lets not make 10000 effects
				if(prob(30))
					var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
					S.set_up(2,0,epicenter,direction)
					S.start()
				else
					var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
					P.set_up(2,epicenter,direction)
					P.start()
	// Build the final explosion list, will be processed when we get to final resolution
	finalize_explosion(data[1],data[2],data[3],pwr,starting_power)

/datum/controller/subsystem/explosions/proc/fire_resolve_explosions(var/list/data)
	var/pwr = data[4]
	var/starting_power = data[5]
	if(pwr <= 0)
		return
	var/turf/T = locate(data[1],data[2],data[3])
	if(!T)
		return
	//Wow severity looks confusing to calculate... Fret not, I didn't leave you with any additional instructions or help. (just kidding, see the line under the calculation)
	var/severity = 4 - round(max(min( 3, ((pwr - T.explosion_resistance) / (max(3,(starting_power/3)))) ) ,1), 1)								//sanity			effective power on tile				divided by either 3 or one third the total explosion power
							//															One third because there are three power levels and I
							//															want each one to take up a third of the crater
	T.ex_act(severity)
	for(var/atom_movable in T.contents)
		var/atom/movable/AM = atom_movable
		if(AM && AM.simulated)
			AM.ex_act(severity)

/datum/controller/subsystem/explosions/proc/start_resolve()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	resolve_explosions = TRUE

/datum/controller/subsystem/explosions/proc/end_resolve()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	resolve_explosions = FALSE

/datum/controller/subsystem/explosions/proc/wake_and_defer_subsystem_updates(var/defer = FALSE)
	// waking from sleep, we are absolutely not resuming, and INSTANT feedback to players is required here.
	if(can_fire) // already awake
		return
	wake()
	next_fire = 0
	// Save these for AFTER the explosion has resolved
	if(defer)
		SSmachines.defer_powernet_rebuild();

/datum/controller/subsystem/explosions/proc/suspend_and_invoke_deferred_subsystems()
	// Resolve all the stuff we put off for after the explosion resolved
	// Awaiting the rust powernet rebuild so this can be called normally...
	INVOKE_ASYNC(SSmachines, TYPE_PROC_REF(/datum/controller/subsystem/machines,release_powernet_defer))
	// we've finished. Pause because was have no more work to do.
	if(!can_fire) // already asleep
		return
	suspend()

/datum/controller/subsystem/explosions/proc/abort()
	if(!currentrun.len)
		return
	// Removes all entries except the top most, so we enter resolution phase properly, need at least one entry to do so...
	var/key = currentrun[1]
	var/data = currentrun[key]
	currentrun.Cut()
	currentrun[key] = data

// INTERNAL explosion proc, meant for GROWING a currently processing blast.
/datum/controller/subsystem/explosions/proc/append_currentrun(var/x0,var/y0,var/z0,var/pwr,var/direction,var/starting_power)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(pwr <= 0)
		return
	// check if there is already an explosion calculated by our current run...
	var/final_data = resolving_explosions["[x0].[y0].[z0]"]
	var/final_power = 0
	if(final_data)
		final_power = final_data[4]
	// If there is already a stronger explosion calculated there, then we don't need to bother
	if(pwr <= final_power)
		return
	// Update data at position for next run. Floodfill until the current_run is empty of new explosions!
	var/max_starting = starting_power
	var/list/dat = currentrun["[x0].[y0].[z0]"]
	if(!isnull(dat) && dat[6] > max_starting)
		max_starting = dat[6]
	if(isnull(dat) || pwr >= dat[4])
		currentrun["[x0].[y0].[z0]"] = list(x0,y0,z0,pwr,direction,max_starting)

// Queue explosion event, call this from explosion() ONLY
/datum/controller/subsystem/explosions/proc/append_explosion(var/turf/epicenter,var/pwr,var/devastation_range,var/heavy_impact_range,var/light_impact_range,var/flash_range)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(pwr <= 0)
		return
	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/z0 = epicenter.z
	// actual explosion. Do not allow multiple, just take the highest power explosion hitting that turf
	var/max_starting = pwr
	var/list/dat = pending_explosions["[x0].[y0].[z0]"]
	if(!isnull(dat) && dat[6] > max_starting)
		max_starting = dat[6]
	if(isnull(dat) || pwr >= dat[4])
		// primary explosion
		pending_explosions["[x0].[y0].[z0]"] = list(x0,y0,z0,pwr,0,max_starting)
		// outward radiating explosions
		var/rad_power = pwr - epicenter.explosion_resistance
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(epicenter, direction)
			if(T)
				dat = pending_explosions["[T.x].[T.y].[T.z]"]
				max_starting = pwr
				if(!isnull(dat) && dat[6] > max_starting)
					max_starting = dat[6]
				if(isnull(dat) || rad_power >= dat[4])
					pending_explosions["[T.x].[T.y].[T.z]"] = list(T.x,T.y,T.z,rad_power,direction,max_starting)

	// send signals to dopplers
	explosion_signals.Add(list( list(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,world.time) )) // append a list in a list. Needed so that the data list doesn't get merged into the list of datalists

	// BOINK! Time to wake up sleeping beauty!
	wake_and_defer_subsystem_updates(devastation_range > 1 || heavy_impact_range > 2) // If significant enough devistation then rebuild!

// Collect prepared explosions for BLAST PROCESSING
/datum/controller/subsystem/explosions/proc/finalize_explosion(var/x0,var/y0,var/z0,var/pwr,var/max_starting)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(pwr <= 0)
		return
	var/list/dat = pending_explosions["[x0].[y0].[z0]"]
	if(isnull(dat) || pwr >= dat[4])
		resolving_explosions["[x0].[y0].[z0]"] = list(x0,y0,z0,pwr,max_starting)

/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, shaped)
	// Lets assume recursive prey has happened...
	var/limit_escape = 10
	while(isbelly(epicenter))
		if(limit_escape-- <= 0)
			break
		var/obj/belly/B = epicenter
		epicenter = B.owner.loc
	epicenter = get_turf(epicenter)
	if(!epicenter)
		return

	// Handles recursive propagation of explosions.
	var/multi_z_scalar = CONFIG_GET(number/multi_z_explosion_scalar)
	if(z_transfer && multi_z_scalar)
		var/adj_dev   = max(0, (multi_z_scalar * devastation_range) - (shaped ? 2 : 0) )
		var/adj_heavy = max(0, (multi_z_scalar * heavy_impact_range) - (shaped ? 2 : 0) )
		var/adj_light = max(0, (multi_z_scalar * light_impact_range) - (shaped ? 2 : 0) )
		var/adj_flash = max(0, (multi_z_scalar * flash_range) - (shaped ? 2 : 0) )
		if(adj_dev > 0 || adj_heavy > 0)
			if(HasAbove(epicenter.z) && z_transfer & UP)
				explosion(GetAbove(epicenter), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, UP, shaped)
			if(HasBelow(epicenter.z) && z_transfer & DOWN)
				explosion(GetBelow(epicenter), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, DOWN, shaped)
	var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)

	// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
	// Stereo users will also hear the direction of the explosion!
	// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
	// 3/7/14 will calculate to 80 + 35
	var/far_dist = 0
	far_dist += heavy_impact_range * 5
	far_dist += devastation_range * 20
	var/frequency = get_rand_frequency()
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(max_range + world.view - 2, 1))
				M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
				/* Downstream - Ear Ringing/Deafness
				//var/mob/living/mL = M
				//if(isliving(mL))
				//	mL.deaf_loop.start()
				*/
			else if(dist <= far_dist)
				var/far_volume = CLAMP(far_dist, 30, 50) // Volume is based on explosion size and dist
				far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
				M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

	var/close = range(world.view+round(devastation_range,1), epicenter)
	// to all distanced mobs play a different sound
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			if(!(M in close))
				// check if the mob can hear
				if(M.ear_deaf <= 0 || !M.ear_deaf)
					if(!istype(M.loc,/turf/space))
						M << 'sound/effects/explosionfar.ogg'

	if(adminlog)
		message_admins("Explosion with [shaped ? "shaped" : "non-shaped"] size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
		log_game("Explosion with [shaped ? "shaped" : "non-shaped"] size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

	if(heavy_impact_range > 1)
		var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
		E.set_up(epicenter)
		E.start()

	// Queue explosion event
	var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
	SSexplosions.append_explosion(epicenter,power,devastation_range,heavy_impact_range,light_impact_range,flash_range)
