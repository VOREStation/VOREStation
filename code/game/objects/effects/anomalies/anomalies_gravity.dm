/obj/effect/anomaly/grav
	name = "gravitational anomaly"
	icon_state = "gravity"
	density = FALSE
	anomaly_core = /obj/item/assembly/signaler/anomaly/grav
	var/boing = FALSE
	var/object_launch_prob = 20

/obj/effect/anomaly/grav/Initialize(mapload, new_lifespan)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	apply_wibbly_filters(src)

/obj/effect/anomaly/grav/anomalyEffect(seconds_per_tick)
	..()
	boing = TRUE
	for(var/obj/O in orange(4, src))
		if(!O.anchored)
			step_towards(O, src)
	for(var/mob/living/M in range(0, src))
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(istype(human.shoes, /obj/item/clothing/shoes/magboots) && (human.shoes.item_flags & NOSLIP))
				continue
		gravShock(M)
	for(var/mob/living/M in range(4, src))
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(istype(human.shoes, /obj/item/clothing/shoes/magboots) && (human.shoes.item_flags & NOSLIP))
				continue
		step_towards(M, src)
	for(var/obj/O in range(0, src))
		if(O.anchored)
			continue
		var/mob/living/target = locate() in view(4, src)
		if(target && !target.stat && prob(object_launch_prob))
			O.throw_at(target, 5, 10)

/obj/effect/anomaly/grav/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	gravShock(AM)

/obj/effect/anomaly/grav/Bump(atom/A)
	gravShock(A)

/obj/effect/anomaly/grav/Bumped(atom/movable/AM)
	gravShock(AM)

/obj/effect/anomaly/grav/proc/gravShock(mob/living/living_debris)
	if(boing && isliving(living_debris) && !living_debris.stat && !living_debris.can_overcome_gravity())
		living_debris.SetStunned(2)
		var/atom/target = get_edge_target_turf(living_debris, get_dir(src, get_step_away(living_debris, src)))
		living_debris.throw_at(target, 5, 1)
		boing = FALSE

/obj/effect/anomaly/grav/detonate()
	new /obj/effect/temp_visual/circle_wave/gravity(get_turf(src))
	playsound(src, 'sound/effects/cosmic_energy.ogg', vol = 50)

/* // Unfortunately couldn't get this one working. Maybe in the future.
/obj/effect/anomaly/grav/high
	var/datum/proximity_monitor/advanced/gravity/grav_field

/obj/effect/anomaly/grav/high/Initialize(mapload, new_lifespan)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(setup_grav_field))

/obj/effect/anomaly/grav/high/proc/setup_grav_field()
	grav_field = new(src, 7, TRUE, rand(0, 3))

/obj/effect/anomaly/grav/high/detonate()
	..()
	for(var/obj/machinery/gravity_generator/main/the_generator as anything in GLOB.machines)
		if(is_on_same_plane_or_station(the_generator.z))
			the_generator.breaker = FALSE
			the_generator.set_power()
			the_generator.charge_count = 10

/obj/effect/anomaly/grav/high/Destroy()
	QDEL_NULL(grav_field)
	. = ..()

/obj/effect/anomaly/grav/high/big
	immortal = TRUE
	anomaly_core = null

/obj/effect/anomaly/grav/high/big/Initialize(mapload, new_lifespan)
	. = ..()
	transform *= 3
*/
/obj/effect/temp_visual/circle_wave/gravity
	color = COLOR_NAVY
