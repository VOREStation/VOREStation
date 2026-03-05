/obj/effect/anomaly/dust
	name = "dust anomaly"
	icon_state = "dust"
	density = FALSE
	anomaly_core = /obj/item/assembly/signaler/anomaly/dust
	pass_flags = PASSTABLE | PASSGRILLE
	layer = ABOVE_MOB_LAYER
	lifespan = ANOMALY_COUNTDOWN_TIMER * 1.5

	move_chance = 80

	COOLDOWN_DECLARE(pulse_cooldown)
	var/pulse_delay = 5 SECONDS

/obj/effect/anomaly/dust/Initialize(mapload, new_lifespan, drops_core)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered)
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	animate(src, transform = matrix()*0.85, time = 3, loop = -1)
	animate(transform = matrix(), time = 3, loop = -1)

/obj/effect/anomaly/dust/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(istype(AM, /turf/simulated/floor))
		var/turf/simulated/floor/floor = AM
		if(floor.can_dirty)
			floor.dirt += 50
			floor.update_dirt()

/obj/effect/anomaly/dust/anomalyEffect(seconds_per_tick)
	. = ..()

	if(!COOLDOWN_FINISHED(src, pulse_cooldown))
		return

	new /obj/effect/temp_visual/circle_wave/dirt(get_turf(src))
	playsound(src, 'sound/effects/cosmic_energy.ogg', vol = 50, vary = TRUE)
	COOLDOWN_START(src, pulse_cooldown, pulse_delay)
	for(var/mob/living/carbon/human/person in viewers(5, src))
		person.germ_level += rand(5, 10)
		if(person.isSynthetic())
			continue
		if(person.is_mouth_covered())
			continue
		if(!person.has_lungs())
			continue
		person.emote(prob(50) ? "cough" : "sneeze")
		person.Stun(2)
		person.adjustOxyLoss(5)
		if(prob(15))
			person.Stun(2)
			to_chat(person, span_danger(pick("You have a coughing fit!", "You can't stop coughing!")))
			addtimer(CALLBACK(person, TYPE_PROC_REF(/mob, emote), "cough"), 1 SECONDS)
			addtimer(CALLBACK(person, TYPE_PROC_REF(/mob, emote), "cough"), 3 SECONDS)
			addtimer(CALLBACK(person, TYPE_PROC_REF(/mob, emote), "cough"), 6 SECONDS)

	for(var/turf/simulated/floor/ground in circleviewturfs(src, 3))
		if(ground.can_dirty)
			ground.dirt += 20
			ground.update_dirt()

		if(prob(1))
			new /obj/random/mob/vermin(ground)

		if(prob(2))
			new /obj/effect/decal/cleanable/filth(ground)

/obj/effect/anomaly/dust/detonate()
	COOLDOWN_RESET(src, pulse_cooldown)
	anomalyEffect()
