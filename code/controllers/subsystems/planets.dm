SUBSYSTEM_DEF(planets)
	name = "Planets"
	init_order = INIT_ORDER_PLANETS
	priority = FIRE_PRIORITY_PLANETS
	wait = 2 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/new_outdoor_turfs = list()
	var/list/new_outdoor_walls = list()

	var/list/planets = list()
	var/list/z_to_planet = list()

	var/list/currentrun = list()

	var/list/needs_sun_update = list()
	var/list/needs_temp_update = list()

/datum/controller/subsystem/planets/Initialize(timeofday)
	admin_notice("<span class='danger'>Initializing planetary weather.</span>", R_DEBUG)
	createPlanets()
	allocateTurfs(TRUE)
	..()

/datum/controller/subsystem/planets/proc/createPlanets()
	var/list/planet_datums = using_map.planet_datums_to_make
	for(var/P in planet_datums)
		var/datum/planet/NP = new P()
		planets.Add(NP)
		for(var/Z in NP.expected_z_levels)
			if(Z > z_to_planet.len)
				z_to_planet.len = Z
			if(z_to_planet[Z])
				admin_notice("<span class='danger'>Z[Z] is shared by more than one planet!</span>", R_DEBUG)
				continue
			z_to_planet[Z] = NP

/datum/controller/subsystem/planets/proc/addTurf(var/turf/T,var/is_edge)
	if(is_edge)
		new_outdoor_walls |= T
	else
		new_outdoor_turfs |= T

/datum/controller/subsystem/planets/proc/removeTurf(var/turf/T,var/is_edge)
	if(is_edge)
		new_outdoor_walls -= T
	else
		new_outdoor_turfs -= T

	if(z_to_planet.len >= T.z)
		var/datum/planet/P = z_to_planet[T.z]
		if(!P)
			return
		if(is_edge)
			P.planet_floors -= T
		else
			P.planet_walls -= T
		T.vis_contents -= P.weather_holder.visuals
		T.vis_contents -= P.weather_holder.special_visuals

/datum/controller/subsystem/planets/proc/allocateTurfs(var/initial = FALSE)
	var/list/currentlist = new_outdoor_turfs
	while(currentlist.len)
		var/turf/simulated/OT = currentlist[currentlist.len]
		currentlist.len--
		if(istype(OT) && OT.outdoors && z_to_planet.len >= OT.z && z_to_planet[OT.z])
			var/datum/planet/P = z_to_planet[OT.z]
			P.planet_floors |= OT
			OT.vis_contents |= P.weather_holder.visuals
			OT.vis_contents |= P.weather_holder.special_visuals
		if(!initial && MC_TICK_CHECK)
			return

	currentlist = new_outdoor_walls
	while(currentlist.len)
		var/turf/unsimulated/wall/planetary/PW = currentlist[currentlist.len]
		currentlist.len--
		if(istype(PW) && z_to_planet.len >= PW.z && z_to_planet[PW.z])
			var/datum/planet/P = z_to_planet[PW.z]
			P.planet_walls |= PW
		if(!initial && MC_TICK_CHECK)
			return

/datum/controller/subsystem/planets/proc/unallocateTurf(var/turf/simulated/T)
	if(istype(T) && z_to_planet[T.z])
		var/datum/planet/P = z_to_planet[T.z]
		P.planet_floors -= T
		T.vis_contents -= P.weather_holder.visuals
		T.vis_contents -= P.weather_holder.special_visuals


/datum/controller/subsystem/planets/fire(resumed = 0)
	if(new_outdoor_turfs.len || new_outdoor_walls.len)
		allocateTurfs()

	if(!resumed)
		src.currentrun = planets.Copy()

	var/list/needs_sun_update = src.needs_sun_update
	while(needs_sun_update.len)
		var/datum/planet/P = needs_sun_update[needs_sun_update.len]
		needs_sun_update.len--
		updateSunlight(P)
		if(MC_TICK_CHECK)
			return

	var/list/needs_temp_update = src.needs_temp_update
	while(needs_temp_update.len)
		var/datum/planet/P = needs_temp_update[needs_temp_update.len]
		needs_temp_update.len--
		updateTemp(P)
		if(MC_TICK_CHECK)
			return

	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/planet/P = currentrun[currentrun.len]
		currentrun.len--

		P.process(last_fire)

		//Sun light needs changing
		if(P.needs_work & PLANET_PROCESS_SUN)
			P.needs_work &= ~PLANET_PROCESS_SUN
			needs_sun_update |= P

		//Temperature needs updating
		if(P.needs_work & PLANET_PROCESS_TEMP)
			P.needs_work &= ~PLANET_PROCESS_TEMP
			needs_temp_update |= P

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/planets/proc/updateSunlight(var/datum/planet/P)
	// Remove old value from corners
	var/list/sunlit_corners = P.sunlit_corners
	var/old_lum_r = -P.sun["lum_r"]
	var/old_lum_g = -P.sun["lum_g"]
	var/old_lum_b = -P.sun["lum_b"]
	if(old_lum_r || old_lum_g || old_lum_b)
		for(var/C in sunlit_corners)
			var/datum/lighting_corner/LC = C
			LC.update_lumcount(old_lum_r, old_lum_g, old_lum_b)
			CHECK_TICK
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
		CHECK_TICK
	update_gen--
	P.sun["lum_r"] = lum_r
	P.sun["lum_g"] = lum_g
	P.sun["lum_b"] = lum_b

/datum/controller/subsystem/planets/proc/updateTemp(var/datum/planet/P)
	//Set new temperatures
	for(var/W in P.planet_walls)
		var/turf/unsimulated/wall/planetary/wall = W
		wall.set_temperature(P.weather_holder.temperature)
		CHECK_TICK

/datum/controller/subsystem/planets/proc/weatherDisco()
	var/count = 100000
	while(count > 0)
		count--
		for(var/planet in planets)
			var/datum/planet/P = planet
			if(P.weather_holder)
				P.weather_holder.change_weather(pick(P.weather_holder.allowed_weather_types))
		sleep(3)
