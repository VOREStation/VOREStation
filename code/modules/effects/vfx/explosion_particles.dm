/obj/effect/vfx/expl_particles
	name = "explosive particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	opacity = 1
	anchored = 1
	mouse_opacity = 0

/obj/effect/vfx/expl_particles/Initialize()
	. = ..()
	QDEL_IN(src, 1.5 SECONDS)

/datum/effect_system/expl_particles
	var/total_particles = 0

/datum/effect_system/expl_particles/set_up(n = 10, c = 0, turf/loc)
	number = n
	location = get_turf(loc)
	
/datum/effect_system/expl_particles/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			var/obj/effect/vfx/expl_particles/expl = new /obj/effect/vfx/expl_particles(src.location)
			var/direct = pick(alldirs)
			for(i=0, i<pick(1;25,2;50,3,4;200), i++)
				sleep(1)
				step(expl,direct)
