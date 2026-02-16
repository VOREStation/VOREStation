/datum/anomaly_stats
	var/severity = 1
	var/stability
	var/max_health

	var/danger_type
	var/unstable_type
	var/containment_type
	var/transformation_type

	var/datum/anomaly_modifiers/modifier

	var/datum/weakref/attached_anomaly
	var/datum/weakref/attached_harvester

	var/next_activation
	// Total of points we'll get once the anomaly does a pulse
	var/points
	var/curr_health
	var/flags

	var/min_activation = 45 SECONDS
	var/max_activation = 90 SECONDS

/datum/anomaly_stats/New()
	randomize_particle_types()
	severity = rand(5, 15)
	max_health = rand(50, 150)
	curr_health = max_health
	points = calculate_points()
	stability = ANOMALY_STABLE

/datum/anomaly_stats/Destroy(force)
	QDEL_NULL(modifier)
	return ..()

/datum/anomaly_stats/proc/randomize_particle_types()
	var/list/particles = list(ANOMALY_PARTICLE_SIGMA, ANOMALY_PARTICLE_DELTA, ANOMALY_PARTICLE_ZETA, ANOMALY_PARTICLE_EPSILON)
	particles = shuffle(particles)
	danger_type = particles[1]
	unstable_type = particles[2]
	containment_type = particles[3]
	transformation_type = particles[4]

/datum/anomaly_stats/proc/calculate_points()
	var/total = 10

	total += severity/5
	total *= curr_health/max_health

	if(modifier)
		total *= modifier.get_value()

	points = total

	return points

/datum/anomaly_stats/proc/particle_hit(particle)
	// I don't really like this, but switch() expects a constant expression
	if(particle == danger_type)
		update_severity(1, 5)
		return
	else if(particle == unstable_type)
		update_state(TRUE)
		return
	else if(particle == containment_type)
		update_state(FALSE)
		update_health(-1, -10)
		return
	else if(particle == transformation_type)
		update_modifiers()
		return
	return

/datum/anomaly_stats/proc/update_severity(lower, upper)
	var/obj/effect/anomaly/anom = attached_anomaly.resolve()
	if(!istype(anom))
		attached_anomaly = null
		return
	var/sev_change = rand(lower, upper)
	severity += sev_change

	if(severity >= 100)
		kill_anomaly(TRUE)
		return

	var/scale_factor = 1.0+(severity/100)
	var/matrix/M = matrix()
	M.Scale(scale_factor, scale_factor)
	animate(anom, transform = M, time = 1 SECOND)
	apply_wibbly_filters(anom)

	calculate_points()
	return

/datum/anomaly_stats/proc/update_health(lower, upper)
	var/health_change = rand(lower, upper)
	curr_health += health_change

	if(curr_health <= 0)
		kill_anomaly(FALSE)
		return

	calculate_points()
	return

/datum/anomaly_stats/proc/kill_anomaly(critical)
	var/obj/effect/anomaly/anom = attached_anomaly.resolve()
	if(!istype(anom))
		attached_anomaly = null
		return
	if(critical)
		anom.detonate()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	QDEL_NULL(anom)
	return

/datum/anomaly_stats/proc/update_state(unstable)
	switch(stability)
		if(ANOMALY_STABLE)
			if(unstable && prob(15))
				stability = ANOMALY_GROWING
			else if(prob(15))
				stability = ANOMALY_DECAYING
			return
		if(ANOMALY_GROWING)
			if(!unstable && prob(15))
				stability = ANOMALY_STABLE
			return
		if(ANOMALY_DECAYING)
			if(!unstable && prob(15))
				stability = ANOMALY_STABLE
		else
			return
	return

/datum/anomaly_stats/proc/update_modifiers()
	// High chance of simply swapping the modifier
	if(prob(80) && modifier)
		modifier.on_remove(attached_anomaly)
		modifier = null

	// Small chance of not getting anything at all
	if(prob(10))
		return

	var/picked_mod = pick(subtypesof(/datum/anomaly_modifiers))

	modifier = new picked_mod
	modifier.on_add(attached_anomaly)
	calculate_points()
	return

/datum/anomaly_stats/proc/get_activation_countdown()
	return (next_activation - world.time)/10

/datum/anomaly_stats/proc/pulse_effect()
	if(stability == ANOMALY_DECAYING)
		update_health(-1, -10)
	else if(stability == ANOMALY_GROWING)
		update_severity(1, 10)

	if(prob(5))
		if(stability == ANOMALY_STABLE)
			stability = pick(ANOMALY_DECAYING, ANOMALY_GROWING)
		else
			stability = ANOMALY_STABLE

	if(attached_harvester)
		var/obj/machinery/anomaly_harvester/harvester = attached_harvester.resolve()
		if(!istype(harvester))
			return

		harvester.points += points
