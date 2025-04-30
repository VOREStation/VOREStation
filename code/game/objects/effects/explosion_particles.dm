/obj/effect/expl_particles
	name = "explosive particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	opacity = 1
	anchored = TRUE
	mouse_opacity = 0

/obj/effect/expl_particles/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 1.5 SECONDS)

/datum/effect/system/expl_particles
	var/number = 10
	var/turf/location
	var/total_particles = 0

/datum/effect/system/expl_particles/proc/set_up(n = 10, loca)
	number = n
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/expl_particles/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			var/obj/effect/expl_particles/expl = new /obj/effect/expl_particles(src.location)
			var/direct = pick(GLOB.alldirs)
			for(i=0, i<pick(1;25,2;50,3,4;200), i++)
				sleep(1)
				step(expl,direct)

/obj/effect/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = TRUE
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/explosion/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 1 SECOND)

/datum/effect/system/explosion
	var/turf/location

/datum/effect/system/explosion/proc/set_up(loca)
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/explosion/proc/start()
	new/obj/effect/explosion( location )
	var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
	P.set_up(10,location)
	P.start()
	addtimer(CALLBACK(src, PROC_REF(spread_smoke)), 0.5 SECONDS)

/datum/effect/system/explosion/proc/spread_smoke()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
	S.set_up(5,0,location,null)
	S.start()

/datum/effect/system/explosion/smokeless/start()
	new/obj/effect/explosion(location)
	var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
	P.set_up(10,location)
	P.start()
