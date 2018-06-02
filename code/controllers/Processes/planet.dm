var/datum/controller/process/planet/planet_controller = null

/datum/controller/process/planet
	var/list/planets = list()
	var/list/z_to_planet = list()

/datum/controller/process/planet/setup()
	name = "planet controller"
	planet_controller = src
	schedule_interval = 1 MINUTE
	start_delay = 20 SECONDS

	var/list/planet_datums = typesof(/datum/planet) - /datum/planet
	for(var/P in planet_datums)
		var/datum/planet/NP = new P()
		planets.Add(NP)

	allocateTurfs()

/datum/controller/process/planet/proc/allocateTurfs()
	for(var/turf/simulated/OT in outdoor_turfs)
		for(var/datum/planet/P in planets)
			if(OT.z in P.expected_z_levels)
				P.planet_floors |= OT
				OT.vis_contents |= P.weather_holder.visuals
				break
	outdoor_turfs.Cut() //Why were you in there INCORRECTLY?

	for(var/turf/unsimulated/wall/planetary/PW in planetary_walls)
		for(var/datum/planet/P in planets)
			if(PW.type == P.planetary_wall_type)
				P.planet_walls |= PW
				break
	planetary_walls.Cut()

/datum/controller/process/planet/proc/unallocateTurf(var/turf/T)
	for(var/planet in planets)
		var/datum/planet/P = planet
		if(T.z in P.expected_z_levels)
			P.planet_floors -= T
			T.vis_contents -= P.weather_holder.visuals

/datum/controller/process/planet/doWork()
	if(outdoor_turfs.len || planetary_walls.len)
		allocateTurfs()

	for(var/datum/planet/P in planets)
		P.process(schedule_interval / 10)
		SCHECK //Your process() really shouldn't take this long...

		//Sun light needs changing
		if(P.needs_work & PLANET_PROCESS_SUN)
			P.needs_work &= ~PLANET_PROCESS_SUN
			// Remove old value from corners
			var/list/sunlit_corners = P.sunlit_corners
			var/old_lum_r = -P.sun["lum_r"]
			var/old_lum_g = -P.sun["lum_g"]
			var/old_lum_b = -P.sun["lum_b"]
			if(old_lum_r || old_lum_g || old_lum_b)
				for(var/C in P.sunlit_corners)
					var/datum/lighting_corner/LC = C
					LC.update_lumcount(old_lum_r, old_lum_g, old_lum_b)
					SCHECK
			sunlit_corners.Cut()

			// Calculate new values to apply
			var/new_brightness = P.sun["brightness"]
			var/new_color = P.sun["color"]
			var/lum_r = new_brightness * GetRedPart  (new_color) / 255
			var/lum_g = new_brightness * GetGreenPart(new_color) / 255
			var/lum_b = new_brightness * GetBluePart (new_color) / 255
			var/static/update_gen = -1 // Used to prevent double-processing corners. Otherwise would happen when looping over adjacent turfs.
			for(var/I in P.planet_floors)
				var/turf/simulated/T = I
				if(!T.lighting_corners_initialised)
					T.generate_missing_corners()
				for(var/C in T.get_corners())
					var/datum/lighting_corner/LC = C
					if(LC.update_gen != update_gen && LC.active)
						sunlit_corners += LC
						LC.update_gen = update_gen
						LC.update_lumcount(lum_r, lum_g, lum_b)
				SCHECK
			update_gen--
			P.sun["lum_r"] = lum_r
			P.sun["lum_g"] = lum_g
			P.sun["lum_b"] = lum_b

		//Temperature needs updating
		if(P.needs_work & PLANET_PROCESS_TEMP)
			P.needs_work &= ~PLANET_PROCESS_TEMP
			//Set new temperatures
			for(var/W in P.planet_walls)
				var/turf/unsimulated/wall/planetary/wall = W
				wall.set_temperature(P.weather_holder.temperature)
				SCHECK
