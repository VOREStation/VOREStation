/obj/effect/anomaly/flux
	name = "flux wave anomaly"
	icon_state = "flux"
	density = TRUE
	anomaly_core = /obj/item/assembly/signaler/anomaly/flux
	var/canshock = FALSE
	var/shockdamage = 20
	var/emp_zap = FLUX_EMP

/obj/effect/anomaly/flux/Initialize(mapload, new_lifespan, drops_core, emp_zap = FLUX_EMP)
	. = ..()
	src.emp_zap = emp_zap
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered)
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	apply_wibbly_filters(src)

/obj/effect/anomaly/flux/anomalyEffect()
	..()
	canshock = TRUE
	for(var/mob/living/M in range(0, src))
		mobShock(M)

/obj/effect/anomaly/flux/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	mobShock(AM)

/obj/effect/anomaly/flux/Bump(atom/A)
	mobShock(A)

/obj/effect/anomaly/flux/Bumped(atom/movable/AM)
	mobShock(AM)

/obj/effect/anomaly/flux/attack_hand(mob/living/user)
	mobShock(user)
	. = ..()

/obj/effect/anomaly/flux/attackby(obj/item/I, mob/user)
	mobShock(user)
	. = ..()

/obj/effect/anomaly/flux/proc/mobShock(mob/living/M)
	if(canshock && istype(M) && !M.is_incorporeal())
		canshock = FALSE
		M.electrocute_act(shockdamage, name)

/obj/effect/anomaly/flux/detonate()
	switch(emp_zap)
		if(FLUX_EMP)
			empulse(src, 4, 16)
			explosion(src, heavy_impact_range = 1, light_impact_range = 4, flash_range = 6)
		if(FLUX_LIGHT_EMP)
			empulse(src, 4, 6)
			explosion(src, light_impact_range = 3, flash_range = 6)
		if(FLUX_NO_EMP)
			new /obj/effect/effect/sparks(loc)

/obj/effect/anomaly/flux/minor
	anomaly_core = null

/obj/effect/anomaly/flux/minor/Initialize(mapload, new_lifespan, emp_zap = FLUX_NO_EMP)
	return ..()
