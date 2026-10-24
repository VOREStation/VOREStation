//Fire aberration
/obj/effect/abstract/aberration/spawner/emp
	name = "EMP aberration"
	effect_to_spawn = /obj/effect/abstract/aberration/emp

/obj/effect/abstract/aberration/spawner/emp/small
	range = 2
	percent_drop = 30

/obj/effect/abstract/aberration/emp
	icon = 'icons/obj/traps/aberrations.dmi'
	icon_state = "aberr_emp_static"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/abstract/aberration/emp/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(emp_turf)), rand(3 SECONDS, 7 SECONDS), TIMER_DELETE_ME|TIMER_UNIQUE)


/obj/effect/abstract/aberration/emp/proc/emp_turf(atom/movable/target)
	for(var/atom/movable/AM in get_turf(src))
		if(AM == src)
			continue
		if(AM.is_incorporeal())
			continue
		AM.emp_act(EMP_HEAVY)
	flick("aberr_emp_pulse", src)
	alpha = 125
	animate(src, alpha = 255, time = 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(emp_turf)), 3 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE)
