//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "particle1"//Need a new icon for this
	anchored = TRUE
	density = TRUE
	movement_type = UNSTOPPABLE // for bumps to trigger
	var/movement_range = 10
	var/energy = 10		//energy in eV
	var/mega_energy = 0	//energy in MeV
	var/frequency = 1
	var/ionizing = 0
	var/particle_type
	var/additional_particles = 0
	var/turf/target
	var/turf/source
	var/movetotarget = 1

/obj/effect/accelerated_particle/weak
	icon_state = "particle0"
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	icon_state = "particle2"
	movement_range = 15
	energy = 15

/obj/effect/accelerated_particle/powerful
	icon_state = "particle3"
	movement_range = 25
	energy = 50

/obj/effect/accelerated_particle/Initialize(mapload, dir = 2)
	. = ..()
	set_dir(dir)
	move(0.1 SECONDS)

/obj/effect/accelerated_particle/Bump(atom/A)
	if (A)
		if(ismob(A))
			toxmob(A)
		if((istype(A,/obj/machinery/the_singularitygen))||(istype(A,/obj/singularity/))||(istype(A, /obj/machinery/particle_smasher)))
			A:energy += energy
		//R-UST port
		else if(istype(A,/obj/machinery/power/fusion_core))
			var/obj/machinery/power/fusion_core/collided_core = A
			if(particle_type && particle_type != "neutron")
				if(collided_core.AddParticles(particle_type, 1 + additional_particles))
					collided_core.owned_field.plasma_temperature += mega_energy
					collided_core.owned_field.energy += energy
					loc = null
		else if(istype(A, /obj/effect/fusion_particle_catcher))
			var/obj/effect/fusion_particle_catcher/PC = A
			if(particle_type && particle_type != "neutron")
				if(PC.parent.owned_core.AddParticles(particle_type, 1 + additional_particles))
					PC.parent.plasma_temperature += mega_energy
					PC.parent.energy += energy
					loc = null


/obj/effect/accelerated_particle/Bumped(atom/A)
	if(ismob(A))
		Bump(A)


/obj/effect/accelerated_particle/ex_act(severity)
	qdel(src)

/obj/effect/accelerated_particle/singularity_act()
	return

/obj/effect/accelerated_particle/proc/toxmob(var/mob/living/M)
	var/radiation = (energy*2)
	M.apply_effect((radiation*3),IRRADIATE,0)
	M.updatehealth()
	//to_chat(M, span_warning("You feel odd."))


/obj/effect/accelerated_particle/proc/move(var/lag)
	if(target)
		if(movetotarget)
			if(!step_towards(src,target))
				src.loc = get_step(src, get_dir(src,target))
			if(get_dist(src,target) < 1)
				movetotarget = 0
		else
			if(!step(src, get_step_away(src,source)))
				src.loc = get_step(src, get_step_away(src,source))
	else
		if(!step(src,dir))
			src.loc = get_step(src,dir)
	movement_range--
	if(movement_range <= 0)
		qdel(src)
		return

	addtimer(CALLBACK(src, PROC_REF(move), lag), lag)
