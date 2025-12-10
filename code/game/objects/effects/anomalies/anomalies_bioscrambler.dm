/obj/effect/anomaly/bioscrambler
	name = "bioscrambler anomaly"
	icon_state = "bioscrambler"
	anomaly_core = /obj/item/assembly/signaler/anomaly/bioscrambler
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	layer = ABOVE_MOB_LAYER
	lifespan = ANOMALY_COUNTDOWN_TIMER * 2

	/// Who are we moving towards?
	var/datum/weakref/pursuit_target
	/// Cooldown for every anomaly pulse
	COOLDOWN_DECLARE(pulse_cooldown)
	/// How many seconds between each anomaly pulse
	var/pulse_delay = 10 SECONDS
	/// Range of anomaly pulse
	var/range = 2

/obj/effect/anomaly/bioscrambler/Initialize(mapload, new_lifespan, drops_core)
	. = ..()
	pursuit_target = WEAKREF(find_nearest_target())

/obj/effect/anomaly/bioscrambler/anomalyEffect(seconds_per_tick)
	. = ..()
	if(!COOLDOWN_FINISHED(src, pulse_cooldown))
		return

	new /obj/effect/temp_visual/circle_wave/bioscrambler(get_turf(src))
	playsound(src, 'sound/effects/cosmic_energy.ogg', vol = 50, vary = TRUE)
	COOLDOWN_START(src, pulse_cooldown, pulse_delay)
	for(var/mob/living/carbon/human/nearby in viewers(range, src))
		var/susceptibility = GetAnomalySusceptibility(nearby)
		if(prob(susceptibility * 100))
			randmutb(nearby)
			domutcheck(nearby, null)
			nearby.balloon_alert(nearby, "something has changed about you")

/obj/effect/anomaly/bioscrambler/move_anomaly()
	update_target()
	if(isnull(pursuit_target))
		return ..()
	var/turf/step_turf = get_step(src, get_dir(src, pursuit_target.resolve()))
	step_to(src, step_turf)

/obj/effect/anomaly/bioscrambler/proc/update_target()
	var/mob/living/current_target = pursuit_target?.resolve()
	if(QDELETED(current_target))
		pursuit_target = null
	if(!isnull(pursuit_target) && prob(80))
		return
	var/mob/living/new_target = find_nearest_target()
	if(isnull(new_target))
		pursuit_target = null
		return
	if(new_target == current_target)
		return
	if(isbelly(new_target.loc) || istype(new_target.loc, /area/crew_quarters))
		return
	current_target = new_target
	pursuit_target = WEAKREF(new_target)

/obj/effect/anomaly/bioscrambler/proc/find_nearest_target()
	var/closest_distance = INFINITY
	var/mob/living/carbon/closest_target = null
	for(var/mob/living/carbon/target in GLOB.player_list)
		if(target.z != z)
			continue
		if(SEND_SIGNAL(target, COMSIG_CHECK_FOR_GODMODE) & COMSIG_GODMODE_CANCEL)
			continue
		if(target.stat >= UNCONSCIOUS)
			continue
		if(istype(get_area(target), /area/crew_quarters))
			continue
		var/distance_from_target = get_dist(src, target)
		if(distance_from_target >= closest_distance)
			continue
		closest_distance = distance_from_target
		closest_target = target

	return closest_target

/// A bioscrambler anomaly subtype which does not pursue people, for purposes of a space ruin
/obj/effect/anomaly/bioscrambler/docile

/obj/effect/anomaly/bioscrambler/docile/update_target()
	return

/obj/effect/anomaly/bioscrambler/detonate()
	COOLDOWN_RESET(src, pulse_cooldown)
	anomalyEffect()
