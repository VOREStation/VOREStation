#define TESLA_DEFAULT_POWER 1738260
#define TESLA_MINI_POWER 869130

/obj/singularity/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	pixel_x = -32
	pixel_y = -32
	current_size = STAGE_TWO
	move_self = 1
	grav_pull = 0
	contained = 0
	density = TRUE
	energy = 0
	dissipate = 1
	dissipate_delay = 5
	dissipate_strength = 1
	var/list/orbiting_balls = list()
	var/miniball = FALSE
	var/produced_power
	var/energy_to_raise = 32
	var/energy_to_lower = -20

/obj/singularity/energy_ball/New(loc, starting_energy = 50, is_miniball = FALSE)
	..()
	miniball = is_miniball

/obj/singularity/energy_ball/Initialize()
	. = ..()
	if(!miniball)
		set_light(10, 7, "#EEEEFF")

/obj/singularity/energy_ball/ex_act(severity, target)
	return

/obj/singularity/energy_ball/Destroy()
	if(orbiting && istype(orbiting.orbiting, /obj/singularity/energy_ball))
		var/obj/singularity/energy_ball/EB = orbiting.orbiting
		EB.orbiting_balls -= src

	for(var/obj/singularity/energy_ball/EB as anything in orbiting_balls)
		qdel(EB)

	. = ..()

/obj/singularity/energy_ball/admin_investigate_setup()
	if(miniball)
		return //don't annnounce miniballs
	..()


/obj/singularity/energy_ball/process(var/wait = 20)
	set waitfor = FALSE
	if(!orbiting)
		if (handle_energy())
			return

		move_the_basket_ball(max(wait - 5, 4 + orbiting_balls.len * 1.5))

		playsound(src, 'sound/effects/lightningbolt.ogg', 100, 1, extrarange = 30)

		set_dir(tesla_zap(src, 7, TESLA_DEFAULT_POWER, TRUE))

		for (var/ball in orbiting_balls)
			var/range = rand(1, CLAMP(orbiting_balls.len, 3, 7))
			tesla_zap(ball, range, TESLA_MINI_POWER/7*range, TRUE)
	else
		energy = 0 // ensure we dont have miniballs of miniballs

/obj/singularity/energy_ball/examine(mob/user)
	. = ..()
	if(orbiting_balls.len)
		. += "The amount of orbiting mini-balls is [orbiting_balls.len]."

/obj/singularity/energy_ball/proc/move_the_basket_ball(var/move_amount)
	//we face the last thing we zapped, so this lets us favor that direction a bit
	var/move_bias = dir
	for(var/i in 0 to move_amount)
		var/move_dir = pick(global.alldirs + move_bias) //ensures large-ball teslas don't just sit around
		if(target && prob(10))
			move_dir = get_dir(src,target)
		var/turf/T = get_step(src, move_dir)
		if(can_move(T))
			forceMove(T)
			set_dir(move_dir)
			for(var/mob/living/carbon/C in loc)
				dust_mob(C)
			sleep(1) // So movement is smooth

/obj/singularity/energy_ball/proc/handle_energy()
	if (energy <= 0)
		log_game("TESLA([x],[y],[z]) Collapsed entirely.")
		investigate_log("collapsed.", I_SINGULO)
		qdel(src)
		return TRUE

	if(energy >= energy_to_raise)
		energy_to_lower = energy_to_raise - 20
		energy_to_raise = energy_to_raise * 1.25

		playsound(src, 'sound/effects/lightning_chargeup.ogg', 100, 1, extrarange = 30)
		//addtimer(CALLBACK(src, PROC_REF(new_mini_ball)), 100)
		spawn(100) new_mini_ball()

	else if(energy < energy_to_lower && orbiting_balls.len)
		energy_to_raise = energy_to_raise / 1.25
		energy_to_lower = (energy_to_raise / 1.25) - 20

		var/Orchiectomy_target = pick(orbiting_balls)
		qdel(Orchiectomy_target)

	else
		dissipate() //sing code has a much better system.

/obj/singularity/energy_ball/proc/new_mini_ball()
	if(!loc)
		return
	var/obj/singularity/energy_ball/EB = new(loc, 0, TRUE)
	all_singularities -= EB //why are these miniballs even singularities in the first place, they don't do anything

	EB.transform *= pick(0.3, 0.4, 0.5, 0.6, 0.7)
	var/icon/I = icon(icon,icon_state,dir)

	var/orbitsize = (I.Width() + I.Height()) * pick(0.4, 0.5, 0.6, 0.7, 0.8)
	orbitsize -= (orbitsize / world.icon_size) * (world.icon_size * 0.25)

	EB.orbit(src, orbitsize, pick(FALSE, TRUE), rand(10, 25), pick(3, 4, 5, 6, 36))

/obj/singularity/energy_ball/attack_hand(mob/user)
	dust_mob(user)
	return 1

/obj/singularity/energy_ball/Bump(atom/A)
	dust_mob(A)

/obj/singularity/energy_ball/Bumped(atom/movable/AM)
	dust_mob(AM)

/obj/singularity/energy_ball/orbit(obj/singularity/energy_ball/target)
	if (istype(target))
		target.orbiting_balls += src
		//TODO-LESH-DEL global.poi_list -= src
		target.dissipate_strength = target.orbiting_balls.len + 1

	. = ..()
/obj/singularity/energy_ball/stop_orbit()
	if (orbiting && istype(orbiting.orbiting, /obj/singularity/energy_ball))
		var/obj/singularity/energy_ball/orbitingball = orbiting.orbiting
		orbitingball.orbiting_balls -= src
		orbitingball.dissipate_strength = orbitingball.orbiting_balls.len + 1
	..()
	if (!loc && !QDELETED(src))
		qdel(src)


/obj/singularity/energy_ball/proc/dust_mob(mob/living/L)
	if(!istype(L) || L.incorporeal_move)
		return
	// L.dust() - Changing to do fatal elecrocution instead
	L.electrocute_act(500, src, def_zone = BP_TORSO)

/proc/tesla_zap(atom/source, zap_range = 3, power, explosive = FALSE, stun_mobs = TRUE)
	if(!source) // Some mobs and maybe some objects delete themselves when they die.
		return
	. = source.dir
	if(power < 1000)
		return

	var/closest_dist = 0
	var/closest_atom
	var/obj/machinery/power/tesla_coil/closest_tesla_coil
	var/obj/machinery/power/grounding_rod/closest_grounding_rod
	var/mob/living/closest_mob
	var/obj/machinery/closest_machine
	var/obj/structure/closest_structure
	var/obj/structure/blob/closest_blob
	var/static/things_to_shock = typecacheof(list(/obj/machinery, /mob/living, /obj/structure))
	var/static/blacklisted_tesla_types = typecacheof(list(
										/obj/machinery/atmospherics,
										/obj/machinery/power/emitter,
										/obj/machinery/field_generator,
										/obj/machinery/door/blast,
										/obj/machinery/particle_accelerator/control_box,
										/obj/structure/particle_accelerator/fuel_chamber,
										/obj/structure/particle_accelerator/particle_emitter/center,
										/obj/structure/particle_accelerator/particle_emitter/left,
										/obj/structure/particle_accelerator/particle_emitter/right,
										/obj/structure/particle_accelerator/power_box,
										/obj/structure/particle_accelerator/end_cap,
										/obj/machinery/containment_field,
										/obj/structure/disposalpipe,
										/obj/structure/sign,
										/obj/machinery/gateway,
										/obj/structure/lattice,
										/obj/structure/grille,
										/obj/machinery/the_singularitygen/tesla))

	for(var/A in typecache_filter_multi_list_exclusion(oview(source, zap_range+2), things_to_shock, blacklisted_tesla_types))
		if(istype(A, /obj/machinery/power/tesla_coil))
			var/dist = get_dist(source, A)
			var/obj/machinery/power/tesla_coil/C = A
			if(dist <= zap_range && (dist < closest_dist || !closest_tesla_coil) && !C.being_shocked)
				closest_dist = dist

				//we use both of these to save on istype and typecasting overhead later on
				//while still allowing common code to run before hand
				closest_tesla_coil = C
				closest_atom = C


		else if(closest_tesla_coil)
			continue //no need checking these other things

		else if(istype(A, /obj/machinery/power/grounding_rod))
			var/obj/machinery/power/grounding_rod/G = A
			var/dist = get_dist(source, A) - (G.anchored ? 2 : 0)
			if(dist <= zap_range && (dist < closest_dist || !closest_grounding_rod))
				closest_grounding_rod = A
				closest_atom = A
				closest_dist = dist

		else if(closest_grounding_rod)
			continue

		else if(isliving(A))
			var/dist = get_dist(source, A)
			var/mob/living/L = A
			if(dist <= zap_range && (dist < closest_dist || !closest_mob) && L.stat != DEAD && !(L.status_flags & GODMODE))
				closest_mob = L
				closest_atom = A
				closest_dist = dist

		else if(closest_mob)
			continue

		else if(istype(A, /obj/machinery))
			var/obj/machinery/M = A
			var/dist = get_dist(source, A)
			if(dist <= zap_range && (dist < closest_dist || !closest_machine) && !M.being_shocked)
				closest_machine = M
				closest_atom = A
				closest_dist = dist

		else if(closest_machine)
			continue

		else if(istype(A, /obj/structure/blob))
			var/obj/structure/blob/B = A
			var/dist = get_dist(source, A)
			if(dist <= zap_range && (dist < closest_dist || !closest_tesla_coil) && !B.being_shocked)
				closest_blob = B
				closest_atom = A
				closest_dist = dist

		else if(closest_blob)
			continue

		else if(istype(A, /obj/structure))
			var/obj/structure/S = A
			var/dist = get_dist(source, A)
			if(dist <= zap_range && (dist < closest_dist || !closest_tesla_coil) && !S.being_shocked)
				closest_structure = S
				closest_atom = A
				closest_dist = dist

	//Alright, we've done our loop, now lets see if was anything interesting in range
	if(closest_atom)
		//common stuff
		var/atom/srcLoc = get_turf(source) // VOREStation Edit - Makes beams look nicer
		srcLoc.Beam(closest_atom, icon_state="lightning[rand(1,12)]", time=5, maxdistance = INFINITY)  // VOREStation Edit - Makes beams look nicer
		var/zapdir = get_dir(source, closest_atom)
		if(zapdir)
			. = zapdir

	var/drain_energy = FALSE // VOREStation Edit - Safety First! Drain Tesla fast when its loose

	//per type stuff:
	if(closest_tesla_coil)
		closest_tesla_coil.tesla_act(power, explosive, stun_mobs)

	else if(closest_grounding_rod)
		closest_grounding_rod.tesla_act(power, explosive, stun_mobs)

	else if(closest_mob)
		var/shock_damage = CLAMP(round(power/400), 10, 90) + rand(-5, 5)
		closest_mob.electrocute_act(shock_damage, source, 1 - closest_mob.get_shock_protection(), ran_zone())
		log_game("TESLA([source.x],[source.y],[source.z]) Shocked [key_name(closest_mob)] for [shock_damage]dmg.")
		message_admins("Tesla zapped [key_name_admin(closest_mob)]!")
		if(issilicon(closest_mob))
			var/mob/living/silicon/S = closest_mob
			if(stun_mobs)
				S.emp_act(3 /*EMP_LIGHT*/)
			tesla_zap(closest_mob, 7, power / 1.5, explosive, stun_mobs) // metallic folks bounce it further
		else
			tesla_zap(closest_mob, 5, power / 1.5, explosive, stun_mobs)

	else if(closest_machine)
		drain_energy = TRUE // VOREStation Edit - Safety First! Drain Tesla fast when its loose
		closest_machine.tesla_act(power, explosive, stun_mobs)

	else if(closest_blob)
		drain_energy = TRUE // VOREStation Edit - Safety First! Drain Tesla fast when its loose
		closest_blob.tesla_act(power, explosive, stun_mobs)

	else if(closest_structure)
		drain_energy = TRUE // VOREStation Edit - Safety First! Drain Tesla fast when its loose
		closest_structure.tesla_act(power, explosive, stun_mobs)

	// VOREStation Edit Start - Safety First! Drain Tesla fast when its loose
	if(drain_energy && istype(source, /obj/singularity/energy_ball))
		var/obj/singularity/energy_ball/EB = source
		if (EB.energy > 0)
			EB.energy -= min(EB.energy, max(10, round(EB.energy * 0.05)))
	// VOREStation Edit End

#undef TESLA_DEFAULT_POWER
#undef TESLA_MINI_POWER
