// Uncomment this define to check for possible lengthy processing of emp_act()s.
// If emp_act() takes more than defined deciseconds (1/10 seconds) an admin message and log is created.
// I do not recommend having this uncommented on main server, it probably causes a bit more lag, espicially with larger EMPs.

// #define EMPDEBUG 10

/proc/empulse(turf/epicenter, first_range, second_range, third_range, fourth_range, log=0)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("EMP with size ([first_range], [second_range], [third_range], [fourth_range]) in area [epicenter.loc.name] ")
		log_game("EMP with size ([first_range], [second_range], [third_range], [fourth_range]) in area [epicenter.loc.name] ")

	if(first_range > 1)
		var/obj/effect/overlay/pulse = new /obj/effect/overlay(epicenter)
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = TRUE
		spawn(20)
			qdel(pulse)

	if(first_range > second_range)
		second_range = first_range
	if(second_range > third_range)
		third_range = second_range
	if(third_range > fourth_range)
		fourth_range = third_range

	for(var/mob/M in range(first_range, epicenter))
		M << 'sound/effects/EMPulse.ogg'

	for(var/atom/T in range(fourth_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		//Worst effects, really hurts
		if(distance < first_range)
			T.emp_act(1)
		else if(distance == first_range)
			if(prob(50))
				T.emp_act(1)
			else
				T.emp_act(2)
		//Slightly less painful
		else if(distance <= second_range)
			T.emp_act(2)
		else if(distance == second_range)
			if(prob(50))
				T.emp_act(2)
			else
				T.emp_act(3)
		//Even less slightly less painful
		else if(distance <= third_range)
			T.emp_act(3)
		else if(distance == third_range)
			if(prob(50))
				T.emp_act(2)
			else
				T.emp_act(3)
		//This should be more or less harmless
		else if(distance <= fourth_range)
			T.emp_act(4)
		#ifdef EMPDEBUG
		if((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: [T.name] - [T.type] - took [world.timeofday - time]ds to process emp_act()!")
		#endif
	return 1