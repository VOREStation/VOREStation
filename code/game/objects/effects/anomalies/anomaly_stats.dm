/datum/anomaly_stats
	var/severity = 1.0
	var/stability = ANOMALY_STABLE
	var/max_health
	var/base_mult = 1

	var/danger_type
	var/unstable_type
	var/containment_type
	var/transformation_type

	var/datum/anomaly_modifiers/modifier

	var/obj/effect/anomaly/attached_anomaly

	var/next_activation
	// Total of points we'll get once the anomaly does a pulse
	var/points_mult
	// Should give a pulse and do things every minute or so
	var/last_pulse
	var/curr_health
	var/flags

/datum/anomaly_stats/New()
	randomize_particle_types()
	points_mult = base_mult
	severity = rand(5.0, 15.0)
	max_health = rand(50, 150)
	curr_health = max_health
	calc_points_mult()

/datum/anomaly_stats/proc/randomize_particle_types()
	var/list/particles = list(ANOMALY_PARTICLE_SIGMA, ANOMALY_PARTICLE_DELTA, ANOMALY_PARTICLE_ZETA, ANOMALY_PARTICLE_EPSILON)
	particles = shuffle(particles)
	danger_type = particles[1]
	unstable_type = particles[2]
	containment_type = particles[3]
	transformation_type = particles[4]

/datum/anomaly_stats/proc/calc_points_mult()
	var/total = 0

	if(modifier)
		total += modifier.get_value()
	total += severity/100
	total *= curr_health/max_health

	points_mult = total*10

	return

/datum/anomaly_stats/proc/get_points_multiplier()
	return "[round(points_mult * 100)]%"

/datum/anomaly_stats/proc/particle_hit(particle)
	// I don't really like this, but switch() expects a constant expression
	if(particle == danger_type)
		update_severity(0.1, 5.0)
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
	to_chat(world, "Hit by [particle]")
	return

/datum/anomaly_stats/proc/update_severity(lower, upper)
	var/sev_change = rand(lower, upper)
	severity += sev_change

	if(severity >= 100)
		kill_anomaly(TRUE)
		return

	var/scale_factor = 1.0+(severity/100)
	var/matrix/M = matrix()
	M.Scale(scale_factor, scale_factor)
	animate(attached_anomaly, transform = M, time = 1 SECOND)
	apply_wibbly_filters(attached_anomaly)

	calc_points_mult()
	return

/datum/anomaly_stats/proc/update_health(lower, upper)
	var/health_change = rand(lower, upper)
	curr_health += health_change

	if(curr_health <= 0)
		kill_anomaly(FALSE)
		return

	calc_points_mult()
	return

/datum/anomaly_stats/proc/kill_anomaly(critical)
	if(critical)
		attached_anomaly.detonate()
		qdel(attached_anomaly)
		return
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	qdel(attached_anomaly)
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
		modifier.on_remove(src)
		modifier = null

	// Small chance of not getting anything at all
	if(prob(10))
		return

	var/picked_mod = pick(subtypesof(/datum/anomaly_modifiers))

	modifier = new picked_mod
	modifier.on_add(src)
	calc_points_mult()
	return

/datum/anomaly_stats/proc/get_activation_countdown()
	return (next_activation - world.time)/10
/*
/datum/anomaly_stats/proc/show_stats(mob/user)
	var/list/message = list()
	message += "<b>Current severity:</b> [severity]"
	message += "<b>Current anomaly state:</b> [stability]"
	message += "<b>Point output:</b> [points_mult]"
	message += ""
	message += "Particle Reaction Analysis:"
	message += "- [span_red("Danger type:")] [danger_type]"
	message += "- [span_pink("Unstable type:")] [unstable_type]"
	message += "- [span_yellow("Containment type:")] [containment_type]"
	message += "- [span_blue("Transformation type:")] [transformation_type]"
	message += ""
	message += "Behavior Deviation Analysis:"
	if(modifier)
		message += "- [modifier.get_description()]"
	message += "- [span_yellow("Anomaly produces [get_points_multiplier()] of the points")]"
	message += ""
	message += "Time until next pulse: [get_activation_countdown()] seconds"

	to_chat(user, examine_block(jointext(message, "\n")), avoid_highlighting = TRUE, trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
*/
