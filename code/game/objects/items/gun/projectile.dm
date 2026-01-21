#define MOVES_HITSCAN -1		//Not actually hitscan but close as we get without actual hitscan.
#define MUZZLE_EFFECT_PIXEL_INCREMENT 17	//How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.

/obj/item/projectile_new
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	pass_flags = PASSTABLE
	mouse_opacity = 0
	hitsound = 'sound/weapons/pierce.ogg'

	blocks_emissive = EMISSIVE_BLOCK_GENERIC

	var/datum/bulletdata/shot_data = null
	var/last_projectile_move = 0
	var/last_process = 0
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!
	var/ignore_source_check = FALSE

	var/speed = 0.8			//Amount of deciseconds it takes for projectile to travel
	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/ricochets = 0

	//Hitscan
	var/list/beam_segments	//assoc list of datum/point or datum/point/vector, start = end. Used for hitscan effect generation.
	var/datum/point/beam_index
	var/turf/hitscan_last	//last turf touched during hitscanning.
	var/datum/beam_components_cache/beam_components

	light_on = TRUE

	//Homing
	var/atom/homing_target
	var/homing_offset_x = 0
	var/homing_offset_y = 0

	//Targetting
	var/yo = null
	var/xo = null
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	var/def_zone = ""	 //Aiming at
	var/mob/firer = null //Who shot it
	var/shot_from = ""   // name of the object which shot us

	embed_chance = 0	//Base chance for a projectile to embed

	var/temporary_unstoppable_movement = FALSE

	var/list/impacted_mobs = list()

	var/obj/item/ammo_casing/my_case = null

/obj/item/projectile_new/Destroy()
	QDEL_NULL(shot_data)
	. = ..()

/obj/item/projectile_new/proc/Range()
	shot_data.range--
	if(shot_data.range <= 0 && loc)
		shot_data.on_range(src)
		qdel(src)

/obj/item/projectile_new/proc/return_predicted_turf_after_moves(moves, forced_angle)		//I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, SSprojectiles.global_pixel_speed)
	var/datum/point/vector/v = current.return_vector_after_increments(moves * SSprojectiles.global_iterations_per_move)
	return v.return_turf()

/obj/item/projectile_new/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return getline(current, ending)

/obj/item/projectile_new/proc/set_pixel_speed(new_speed)
	if(trajectory)
		trajectory.set_speed(new_speed)
		return TRUE
	return FALSE

/obj/item/projectile_new/proc/record_hitscan_start(datum/point/pcache)
	if(pcache)
		beam_segments = list()
		beam_index = pcache
		beam_segments[beam_index] = null	//record start.

/obj/item/projectile_new/proc/process_hitscan()
	var/safety = shot_data.range * 3
	record_hitscan_start(RETURN_POINT_VECTOR_INCREMENT(src, Angle, MUZZLE_EFFECT_PIXEL_INCREMENT, 1))
	while(loc && !QDELETED(src))
		if(safety-- <= 0)
			if(loc)
				Bump(loc)
			if(!QDELETED(src))
				qdel(src)
			return	//Kill!
		pixel_move(1, TRUE)

/obj/item/projectile_new/proc/pixel_move(trajectory_multiplier, hitscanning = FALSE)
	if(!loc || !trajectory)
		return
	last_projectile_move = world.time
	if(shot_data.homing)
		process_homing()
	var/forcemoved = FALSE
	for(var/i in 1 to SSprojectiles.global_iterations_per_move)
		if(QDELETED(src))
			return
		trajectory.increment(trajectory_multiplier)
		var/turf/T = trajectory.return_turf()
		if(!istype(T))
			qdel(src)
			return
		if(T.z != loc.z)
			var/old = loc
			before_z_change(loc, T)
			trajectory_ignore_forcemove = TRUE
			forceMove(T)
			trajectory_ignore_forcemove = FALSE
			after_z_change(old, loc)
			if(!hitscanning)
				pixel_x = trajectory.return_px()
				pixel_y = trajectory.return_py()
			forcemoved = TRUE
			hitscan_last = loc
		else if(T != loc)
			before_move()
			step_towards(src, T)
			hitscan_last = loc
			after_move()
		if(can_hit_target(original, permutated))
			Bump(original)
	if(!hitscanning && !forcemoved && trajectory)
		pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	Range()

/obj/item/projectile_new/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	if(AM.is_incorporeal() && !shot_data.hits_phased)
		return
	..()
	if(isliving(AM) && !(pass_flags & PASSMOB))
		var/mob/living/L = AM
		if(can_hit_target(L, permutated, (AM == original)))
			Bump(AM)
			if(shot_data.dephasing)
				L.phase_in() //If the mob is phased, dephase them. If they're not phased, this does nothing.

/obj/item/projectile_new/proc/process_homing()			//may need speeding up in the future performance wise.
	if(!homing_target)
		return FALSE
	var/datum/point/PT = RETURN_PRECISE_POINT(homing_target)
	PT.x += CLAMP(homing_offset_x, 1, world.maxx)
	PT.y += CLAMP(homing_offset_y, 1, world.maxy)
	var/angle = closer_angle_difference(Angle, angle_between_points(RETURN_PRECISE_POINT(src), PT))
	setAngle(Angle + CLAMP(angle, -shot_data.homing_turn_speed, shot_data.homing_turn_speed))

/obj/item/projectile_new/proc/set_homing_target(atom/A)
	if(!A || (!isturf(A) && !isturf(A.loc)))
		return FALSE
	shot_data.homing = TRUE
	homing_target = A
	homing_offset_x = rand(shot_data.homing_inaccuracy_min, shot_data.homing_inaccuracy_max)
	homing_offset_y = rand(shot_data.homing_inaccuracy_min, shot_data.homing_inaccuracy_max)
	if(prob(50))
		homing_offset_x = -homing_offset_x
	if(prob(50))
		homing_offset_y = -homing_offset_y

/obj/item/projectile_new/process()
	last_process = world.time
	if(!loc || !trajectory)
		return PROCESS_KILL
	if(!isturf(loc))
		last_projectile_move += world.time - last_process
		return
	var/elapsed_time_deciseconds = (world.time - last_projectile_move) + time_offset
	time_offset = 0
	var/required_moves = speed > 0? FLOOR(elapsed_time_deciseconds / speed, 1) : MOVES_HITSCAN			//Would be better if a 0 speed made hitscan but everyone hates those so I can't make it a universal system :<
	if(required_moves == MOVES_HITSCAN)
		required_moves = SSprojectiles.global_max_tick_moves
	else
		if(required_moves > SSprojectiles.global_max_tick_moves)
			var/overrun = required_moves - SSprojectiles.global_max_tick_moves
			required_moves = SSprojectiles.global_max_tick_moves
			time_offset += overrun * speed
		time_offset += MODULUS(elapsed_time_deciseconds, speed)

	for(var/i in 1 to required_moves)
		pixel_move(1, FALSE)

/obj/item/projectile_new/proc/setAngle(new_angle)	//wrapper for overrides.
	Angle = new_angle
	if(!shot_data.nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile_new/forceMove(atom/target)
	if(!isloc(target) || !isloc(loc) || !z)
		return ..()
	var/zc = target.z != z
	var/old = loc
	if(zc)
		before_z_change(old, target)
	. = ..()
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		if(shot_data.hitscan)
			finalize_hitscan_and_generate_tracers(FALSE)
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)
		if(shot_data.hitscan)
			record_hitscan_start(RETURN_PRECISE_POINT(src))
	if(zc)
		after_z_change(old, target)

/obj/item/projectile_new/proc/fire(angle, atom/direct_target)
	//If no angle needs to resolve it from xo/yo!
	if(direct_target)
		if(shot_data.bump_targets)
			direct_target.bullet_act(src, def_zone)
		qdel(src)
		return
	if(isnum(angle))
		setAngle(angle)
	starting = get_turf(src)
	if(!starting)
		qdel(src)
		return
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(CLAMP(starting + xo, 1, world.maxx), CLAMP(starting + yo, 1, world.maxy), starting.z)
		setAngle(Get_Angle(src, target))
	if(shot_data.dispersion)
		setAngle(Angle + rand(-shot_data.dispersion, shot_data.dispersion))
	original_angle = Angle
	trajectory_ignore_forcemove = TRUE
	forceMove(starting)
	trajectory_ignore_forcemove = FALSE
	trajectory = new(starting.x, starting.y, starting.z, pixel_x, pixel_y, Angle, SSprojectiles.global_pixel_speed)
	last_projectile_move = world.time
	permutated = list()
	if(shot_data.hitscan)
		. = process_hitscan()
	START_PROCESSING(SSprojectiles, src)
	pixel_move(1, FALSE)	//move it now!

/obj/item/projectile_new/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(temporary_unstoppable_movement)
		temporary_unstoppable_movement = FALSE
		DISABLE_BITFIELD(movement_type, UNSTOPPABLE)
	if(can_hit_target(original, permutated, TRUE))
		Bump(original)

/obj/item/projectile_new/proc/after_z_change(atom/olcloc, atom/newloc)

/obj/item/projectile_new/proc/before_z_change(atom/oldloc, atom/newloc)

/obj/item/projectile_new/proc/before_move()
	return

/obj/item/projectile_new/proc/after_move()
	return

/obj/item/projectile_new/proc/store_hitscan_collision(datum/point/pcache)
	beam_segments[beam_index] = pcache
	beam_index = pcache
	beam_segments[beam_index] = null

//Spread is FORCED!
/obj/item/projectile_new/proc/preparePixelProjectile(atom/target, atom/source, params, spread = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)

	if(istype(source, /atom/movable))
		var/atom/movable/MT = source
		if(MT.locs && MT.locs.len)	// Multi tile!
			for(var/turf/T in MT.locs)
				if(get_dist(T, target) < get_turf(curloc))
					curloc = get_turf(T)

	trajectory_ignore_forcemove = TRUE
	forceMove(get_turf(source))
	trajectory_ignore_forcemove = FALSE
	starting = curloc
	original = target
	if(targloc || !params)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(Get_Angle(src, targloc) + spread)

	if(isliving(source) && params)
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]

		setAngle(calculated[1] + spread)
	else if(targloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(Get_Angle(src, targloc) + spread)
	else
		stack_trace("WARNING: Projectile [type] fired without either mouse parameters, or a target atom to aim at!")
		qdel(src)

/proc/calculate_projectile_angle_and_pixel_offsets(mob/user, params)
	var/list/mouse_control = params2list(params)
	var/p_x = 0
	var/p_y = 0
	var/angle = 0
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])
	if(mouse_control["screen-loc"])
		//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

		//Split X+Pixel_X up into list(X, Pixel_X)
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")

		//Split Y+Pixel_Y up into list(Y, Pixel_Y)
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32
		var/y = text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32

		//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
		var/list/screenview = user.client? getviewsize(user.client.view) : world.view
		var/screenviewX = screenview[1] * world.icon_size
		var/screenviewY = screenview[2] * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = ATAN2(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/item/projectile_new/proc/redirect(x, y, starting, source)
	old_style_target(locate(x, y, z), starting? get_turf(starting) : get_turf(source))

/obj/item/projectile_new/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	starting = get_turf(source)
	original = target
	setAngle(Get_Angle(source, target))

/obj/item/projectile_new/Destroy()
	if(shot_data.hitscan)
		finalize_hitscan_and_generate_tracers()
	STOP_PROCESSING(SSprojectiles, src)

	if(impacted_mobs)
		if(LAZYLEN(impacted_mobs))
			impacted_mobs.Cut()
		impacted_mobs = null

	QDEL_NULL(trajectory)
	cleanup_beam_segments()

	if(my_case)
		if(my_case.BB == src)
			my_case.BB = null
		my_case = null

	return ..()

/obj/item/projectile_new/proc/cleanup_beam_segments()
	QDEL_LIST_ASSOC(beam_segments)
	beam_segments = list()
	qdel(beam_index)

/obj/item/projectile_new/proc/vol_by_damage()
	if(shot_data.damage || shot_data.agony)
		var/value_to_use = shot_data.damage > shot_data.agony ? shot_data.damage : shot_data.agony
		// Multiply projectile damage by 1.2, then CLAMP the value between 30 and 100.
		// This was 0.67 but in practice it made all projectiles that did 45 or less damage play at 30,
		// which is hard to hear over the gunshots, and is rather rare for a projectile to do that much.
		return CLAMP((value_to_use) * 1.2, 30, 100)
	else
		return 50 //if the projectile doesn't do damage or agony, play its hitsound at 50% volume.

/obj/item/projectile_new/proc/finalize_hitscan_and_generate_tracers(impacting = TRUE)
	if(trajectory && beam_index)
		var/datum/point/pcache = trajectory.copy_to()
		beam_segments[beam_index] = pcache
	generate_hitscan_tracers(null, null, impacting)

/obj/item/projectile_new/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 5, impacting = TRUE)
	if(!length(beam_segments))
		return
	beam_components = new
	if(shot_data.tracer_type)
		var/tempref = "\ref[src]"
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], beam_components, shot_data.tracer_type, color, duration, shot_data.hitscan_light_range, shot_data.hitscan_light_color_override, shot_data.hitscan_light_intensity, tempref)
	if(shot_data.muzzle_type && duration > 0)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		thing.color = color
		thing.set_light(shot_data.muzzle_flash_range, shot_data.muzzle_flash_intensity, shot_data.muzzle_flash_color_override? shot_data.muzzle_flash_color_override : color)
		beam_components.beam_components += thing
	if(impacting && shot_data.impact_type && duration > 0)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(Angle)
		thing.transform = M
		thing.color = color
		thing.set_light(shot_data.impact_light_range, shot_data.impact_light_intensity, shot_data.impact_light_color_override? shot_data.impact_light_color_override : color)
		beam_components.beam_components += thing
	QDEL_IN(beam_components, duration)

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/item/projectile_new/proc/can_hit_target(atom/target, list/passthrough, direct_target = FALSE, ignore_loc = FALSE)
	if(QDELETED(target))
		return FALSE
	if(!ignore_source_check && firer)
		var/mob/M = firer
		if((target == firer) || ((target == firer.loc) && istype(firer.loc, /obj/mecha)) || (target in firer.buckled_mobs) || (istype(M) && (M.buckled == target)))
			return FALSE
	if(!ignore_loc && (loc != target.loc))
		return FALSE
	if(target in passthrough)
		return FALSE
	if(target.density)		//This thing blocks projectiles, hit it regardless of layer/mob stuns/etc.
		return TRUE
	if(!isliving(target))
		if(target.layer < PROJECTILE_HIT_THRESHOLD_LAYER)
			return FALSE
	else
		var/mob/living/L = target
		if(!direct_target)
			// Swarms are special scuffed critters. They must have density FALSE to swarm, but then they don't get hit.
			// So we'll check before, just in case. Lying might gives a chance to dodge, however.
			if(L.GetComponent(/datum/component/swarming) && L.stat != DEAD && !L.lying)
				return TRUE
			if(!L.density)
				var/datum/component/shadekin/SK = L.GetComponent(/datum/component/shadekin)
				if(!SK || (SK.in_phase && !shot_data.hits_phased)) //We don't have the phasing component, or we do but we're currently phased and the bullet can't hit phased things...This is needed for simple mobs.
					return FALSE
	return TRUE

/obj/item/projectile_new/Bump(atom/A)
	if(A in permutated)
		trajectory_ignore_forcemove = TRUE
		forceMove(get_turf(A))
		trajectory_ignore_forcemove = FALSE
		return FALSE
	if(firer && !shot_data.reflected)
		if(A == firer || (A == firer.loc && istype(A, /obj/mecha))) //cannot shoot yourself or your mech
			trajectory_ignore_forcemove = TRUE
			forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			return FALSE

	var/distance = get_dist(starting, get_turf(src))
	var/turf/target_turf = get_turf(A)
	var/passthrough = FALSE

	if(ismob(A))
		var/mob/M = A
		if(isliving(A))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/grab/G = locate() in M
			if(G && G.state >= GRAB_NECK)
				if(G.affecting.stat == DEAD)
					var/shield_chance = min(80, (30 * (M.mob_size / 10)))	//Small mobs have a harder time keeping a dead body as a shield than a human-sized one. Unathi would have an easier job, if they are made to be SIZE_LARGE in the future. -Mech
					if(prob(shield_chance))
						visible_message(span_danger("\The [M] uses [G.affecting] as a shield!"))
						if(shot_data.bump_targets)
							if(Bump(G.affecting))
								return
					else
						visible_message(span_danger("\The [M] tries to use [G.affecting] as a shield, but fails!"))
				else
					visible_message(span_danger("\The [M] uses [G.affecting] as a shield!"))
					if(shot_data.bump_targets)
						if(Bump(G.affecting))
							return //If Bump() returns 0 (keep going) then we continue on to attack M.

			if(shot_data.bump_targets)
				passthrough = !attack_mob(M, distance)
			else
				passthrough = 1 //Projectiles that don't bump (raytraces) always pass through
		else
			passthrough = 1 //so ghosts don't stop bullets
	else
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(shot_data.bump_targets) // only attack/act a turf's contents if our projectile is not a raytrace
			if(isturf(A))
				for(var/obj/O in A)
					O.bullet_act(src)
				for(var/mob/living/M in A)
					attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && shot_data.penetrating > 0)
		if(check_penetrate(A))
			passthrough = TRUE
		shot_data.penetrating--

	if(passthrough)
		trajectory_ignore_forcemove = TRUE
		forceMove(target_turf)
		permutated.Add(A)
		trajectory_ignore_forcemove = FALSE
		return FALSE

	if(A && shot_data.bump_targets)
		on_impact(A)
	qdel(src)
	return TRUE

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile_new/proc/on_hit(atom/target, blocked = 0, def_zone)
	if(blocked >= 100)		return 0//Full block
	if(!isliving(target))	return 0
//	if(isanimal(target))	return 0
	var/mob/living/L = target
	L.apply_effects(shot_data.stun, shot_data.weaken, shot_data.paralyze, shot_data.irradiate, shot_data.stutter, shot_data.eyeblur, shot_data.drowsy, shot_data.agony, blocked, shot_data.incendiary, shot_data.flammability) // add in AGONY!
	if(shot_data.modifier_type_to_apply)
		L.add_modifier(shot_data.modifier_type_to_apply, shot_data.modifier_duration)
	return 1

//called when the projectile stops flying because it Bump'd with something
/obj/item/projectile_new/proc/on_impact(atom/A)
	impact_sounds(A)
	impact_visuals(A)

	if(shot_data.damage && shot_data.damage_type == BURN)
		var/turf/T = get_turf(A)
		if(T)
			T.hotspot_expose(700, 5)

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile_new/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(embed_chance == 0 || shot_data.damage_type != BRUTE)
		return 0
	return 1

/obj/item/projectile_new/proc/get_structure_damage()
	if(shot_data.damage_type == BRUTE || shot_data.damage_type == BURN)
		return shot_data.damage
	return 0

//return 1 if the projectile should be allowed to pass through after all, 0 if not.
/obj/item/projectile_new/proc/check_penetrate(atom/A)
	return 1

/obj/item/projectile_new/proc/check_fire(atom/target as mob, mob/living/user as mob)  //Checks if you can hit them or not.
	if(target in check_trajectory(target, user, pass_flags, flags))
		return TRUE
	return FALSE

/obj/item/projectile_new/CanPass()
	return TRUE

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/item/projectile_new/proc/attack_mob(mob/living/target_mob, distance, miss_modifier = 0)
	if(!istype(target_mob))
		return

	if(target_mob.is_incorporeal() && !shot_data.hits_phased)
		return

	if(target_mob in impacted_mobs)
		return

	// Accuracy here is inverted as accuracy is being applied as a negative miss_chance_mod.
	// This means that, accuracy negates evasion 1:1 when it comes to PvP combat (or for PvE combat if you give a mob natural evasion)
	// Things that affect accuracy: gun_accuracy_mod species var (Bad Shot/Eagle Eye), Fear, Gun Accuracy.
	// +accuracy = higher chance to hit through evasion. -accuracy = lower chance to hit through evasion.
	// These ONLY matter if the mob you are attacking has evasion OR if it's coming from a non-living attacker (Mines/Turrets)
	// The get_zone_with_miss_chance() proc is HIGHLY variable and can be changed server to server with multiple simple var switches built in without having to do specialty code or multiple edits.
	var/miss_chance = (-shot_data.accuracy + miss_modifier) //Chance to miss the target. Higher
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_chance, ranged_attack=(distance > 1 || original != target_mob), force_hit = !shot_data.can_miss, attacker = firer) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		result = target_mob.bullet_act(src, def_zone)

	if(!istype(target_mob))
		return FALSE // Mob deleted itself or something.

	// Safe to add the target to the list that is soon to be poofed. No double jeopardy, pixel projectiles.
	if(islist(impacted_mobs))
		impacted_mobs |= target_mob

	if(result == PROJECTILE_FORCE_MISS)
		if(!shot_data.silenced)
			target_mob.visible_message(span_infoplain(span_bold("\The [src]") + " misses \the [target_mob] narrowly!"))
			playsound(target_mob, "bullet_miss", 75, 1)
		return FALSE

	var/impacted_organ = parse_zone(def_zone)
	if(isanimal(target_mob))
		var/mob/living/simple_mob/SM = target_mob
		var/decl/mob_organ_names/organ_plan = SM.organ_names
		impacted_organ = pick(organ_plan.hit_zones)

	//hit messages
	if(shot_data.silenced)
		playsound(target_mob, hitsound, 5, 1, -1)
		to_chat(target_mob, span_critical("You've been hit in the [impacted_organ] by \the [src]!"))
	else
		var/volume = vol_by_damage()
		playsound(target_mob, hitsound, volume, 1, -1)
		// X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter
		target_mob.visible_message(
			span_danger("\The [target_mob] was hit in the [impacted_organ] by \the [src]!"),
			span_critical("You've been hit in the [impacted_organ] by \the [src]!")
		)

	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob) && istype(target_mob))
			add_attack_logs(firer,target_mob,"Shot with \a [src.type] projectile")

	if(shot_data.dephasing)
		target_mob.phase_in() //If the mob is phased, dephase them. If they're not phased, this does nothing.


	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return FALSE

	return TRUE


/obj/item/projectile_new/proc/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	original = target
	def_zone = check_zone(target_zone)
	firer = user
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	if(shot_data.use_submunitions && shot_data.submunitions.len)
		var/temp_min_spread = 0
		if(shot_data.force_max_submunition_spread)
			temp_min_spread = shot_data.submunition_spread_max
		else
			temp_min_spread = shot_data.submunition_spread_min

		var/damage_override = null

		if(shot_data.spread_submunition_damage)
			damage_override = shot_data.damage
			if(shot_data.nodamage)
				damage_override = 0

			var/projectile_count = 0

			for(var/proj in shot_data.submunitions)
				projectile_count += shot_data.submunitions[proj]

			damage_override = round(damage_override / max(1, projectile_count))

		for(var/path in shot_data.submunitions)
			for(var/count = 1 to shot_data.submunitions[path])
				var/obj/item/projectile_new/SM = new path(get_turf(loc))
				SM.shot_data = shot_data // TEMP DO NOT KEEP, MASSIVE MEMORY LEAK
				SM.shot_from = shot_from
				SM.shot_data.dispersion = rand(temp_min_spread, shot_data.submunition_spread_max) / 10
				if(!isnull(damage_override))
					SM.shot_data.damage = damage_override
				SM.launch_projectile(target, target_zone, user, params, angle_override)

	preparePixelProjectile(target, user? user : get_turf(src), params, forced_spread)
	return fire(angle_override, direct_target)

//called to launch a projectile from a gun
/obj/item/projectile_new/proc/launch_from_gun(atom/target, target_zone, mob/user, params, angle_override, forced_spread, obj/item/gun/launcher)

	shot_from = launcher.name
	shot_data.silenced |= launcher.silenced // Silent bullets (e.g., BBs) are always silent
	if(user)
		firer = user

	return launch_projectile(target, target_zone, user, params, angle_override, forced_spread)

/obj/item/projectile_new/proc/launch_projectile_from_turf(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	original = target
	def_zone = check_zone(target_zone)
	firer = user
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	if(shot_data.use_submunitions && shot_data.submunitions.len)
		var/temp_min_spread = 0
		if(shot_data.force_max_submunition_spread)
			temp_min_spread = shot_data.submunition_spread_max
		else
			temp_min_spread = shot_data.submunition_spread_min

		var/damage_override = null

		if(shot_data.spread_submunition_damage)
			damage_override = shot_data.damage
			if(shot_data.nodamage)
				damage_override = 0

			var/projectile_count = 0

			for(var/proj in shot_data.submunitions)
				projectile_count += shot_data.submunitions[proj]

			damage_override = round(damage_override / max(1, projectile_count))

		for(var/path in shot_data.submunitions)
			for(var/count = 1 to shot_data.submunitions[path])
				var/obj/item/projectile_new/SM = new path(get_turf(loc))
				SM.shot_data = shot_data // TEMP DO NOT KEEP THIS - AWFUL MEM LEAK
				SM.shot_from = shot_from
				SM.shot_data.dispersion = rand(temp_min_spread, shot_data.submunition_spread_max) / 10
				if(!isnull(damage_override))
					SM.shot_data.damage = damage_override
				SM.launch_projectile_from_turf(target, target_zone, user, params, angle_override)

	preparePixelProjectile(target, get_turf(src), params, forced_spread)
	return fire(angle_override, direct_target)

// Makes a brief effect sprite appear when the projectile hits something solid.
/obj/item/projectile_new/proc/impact_visuals(atom/A, hit_x, hit_y)
	if(shot_data.impact_effect_type && !shot_data.hitscan) // Hitscan things have their own impact sprite.
		if(isnull(hit_x) && isnull(hit_y))
			if(trajectory)
				// Effect goes where the projectile 'stopped'.
				hit_x = A.pixel_x + trajectory.return_px()
				hit_y = A.pixel_y + trajectory.return_py()
			else if(A == original)
				// Otherwise it goes where the person who fired clicked.
				hit_x = A.pixel_x + p_x - 16
				hit_y = A.pixel_y + p_y - 16
			else
				// Otherwise it'll be random.
				hit_x = A.pixel_x + rand(-8, 8)
				hit_y = A.pixel_y + rand(-8, 8)
		new impact_effect_type(get_turf(A), src, hit_x, hit_y)

/obj/item/projectile_new/proc/impact_sounds(atom/A)
	if(shot_data.hitsound_wall && !ismob(A)) // Mob sounds are handled in attack_mob().
		var/volume = CLAMP(vol_by_damage() + 20, 0, 100)
		if(shot_data.silenced)
			volume = 5
		playsound(A, shot_data.hitsound_wall, volume, 1, -1)

#undef MOVES_HITSCAN
#undef MUZZLE_EFFECT_PIXEL_INCREMENT
