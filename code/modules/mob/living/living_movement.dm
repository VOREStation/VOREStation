/mob/CanPass(atom/movable/mover, turf/target)
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
		if(is_shifted && (abs(pixel_x) >= 8 || abs(pixel_y) >= 8))
			// they're wallflowering, let 'em through
			return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	return (!mover.density || !density || lying)

/mob/CanZASPass(turf/T, is_zone)
	return ATMOS_PASS_YES

/mob/living/SelfMove(turf/n, direct, movetime)
	// If on walk intent, don't willingly step into hazardous tiles.
	// Unless the walker is confused.
	if(m_intent == "walk" && confused <= 0)
		if(!n.is_safe_to_enter(src))
			to_chat(src, span("warning", "\The [n] is dangerous to move into."))
			return FALSE // In case any code wants to know if movement happened.
	return ..() // Parent call should make the mob move.

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		return 0

/mob/living/Bump(atom/movable/AM)
	if(now_pushing || !loc || buckled == AM)
		return
	now_pushing = 1
	if (istype(AM, /mob/living))
		var/mob/living/tmob = AM

		//Even if we don't push/swap places, we "touched" them, so spread fire
		spread_fire(tmob)

		for(var/mob/living/M in range(tmob, 1))
			if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, tmob.grabbed_by.len)) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
				now_pushing = 0
				return
			if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
				now_pushing = 0
				return

		//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
		var/can_swap = 1
		if(loc.density || tmob.loc.density)
			can_swap = 0
		if(can_swap)
			for(var/atom/movable/A in loc)
				if(A == src)
					continue
				if(!A.CanPass(tmob, loc))
					can_swap = 0
				if(!can_swap) break
		if(can_swap)
			for(var/atom/movable/A in tmob.loc)
				if(A == tmob)
					continue
				if(!A.CanPass(src, tmob.loc))
					can_swap = 0
				if(!can_swap) break

		//Leaping mobs just land on the tile, no pushing, no anything.
		if(status_flags & LEAPING)
			loc = tmob.loc
			status_flags &= ~LEAPING
			now_pushing = 0
			return

		if((tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())) && tmob.canmove && canmove && !tmob.buckled && !buckled && can_swap && can_move_mob(tmob, 1, 0)) // mutual brohugs all around!
			var/turf/oldloc = loc
			//VOREstation Edit - Begin

			//check bumpnom chance, if it's a simplemob that's doing the bumping
			var/mob/living/simple_mob/srcsimp = src
			if(istype(srcsimp))
				if(srcsimp.tryBumpNom(tmob))
					now_pushing = 0
					return

			//if it's a simplemob being bumped, and the above didn't make them start getting bumpnommed, they get a chance to bumpnom
			var/mob/living/simple_mob/tmobsimp = tmob
			if(istype(tmobsimp))
				if(tmobsimp.tryBumpNom(src))
					now_pushing = 0
					return

			//VOREstation Edit - End
			forceMove(tmob.loc)
			//VOREstation Edit - Begin
			// In case of micros, we don't swap positions; instead occupying the same square!
			if(step_mechanics_pref && tmob.step_mechanics_pref)
				if(handle_micro_bump_helping(tmob))
					now_pushing = 0
					return
			// TODO - Check if we need to do something about the slime.UpdateFeed() we are skipping below.
			// VOREStation Edit - End
			tmob.forceMove(oldloc)
			now_pushing = 0
			return
		//VOREStation Edit - Begin
		else if((tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())) && canmove && can_swap && handle_micro_bump_helping(tmob))
			forceMove(tmob.loc)
			now_pushing = 0
			return
		//VOREStation Edit - End

		if(!can_move_mob(tmob, 0, 0))
			now_pushing = 0
			return
		if(a_intent == I_HELP || src.restrained())
			now_pushing = 0
			return
		// VOREStation Edit - Begin
		// Plow that nerd.
		if(ishuman(tmob))
			var/mob/living/carbon/human/H = tmob
			if(H.species.lightweight == 1 && prob(50))
				H.visible_message("<span class='warning'>[src] bumps into [H], knocking them off balance!</span>")
				H.Weaken(5)
				now_pushing = 0
				return
		// Handle grabbing, stomping, and such of micros!
		if(step_mechanics_pref && tmob.step_mechanics_pref)
			if(handle_micro_bump_other(tmob)) return
		// VOREStation Edit - End
		if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
			if(prob(40) && !(FAT in src.mutations))
				to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
				now_pushing = 0
				return
		if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(!(tmob.status_flags & CANPUSH))
			now_pushing = 0
			return

		tmob.LAssailant = src

	now_pushing = 0
	. = ..()
	if (!istype(AM, /atom/movable) || AM.anchored)
		//VOREStation Edit - object-specific proc for running into things
		if(((confused || is_blind()) && stat == CONSCIOUS && prob(50) && m_intent=="run") || flying)
			AM.stumble_into(src)
		//VOREStation Edit End
		/* VOREStation Removal - See above
		if(confused && prob(50) && m_intent=="run")
			Weaken(2)
			playsound(src, "punch", 25, 1, -1)
			visible_message("<span class='warning'>[src] [pick("ran", "slammed")] into \the [AM]!</span>")
			src.apply_damage(5, BRUTE)
			to_chat(src, "<span class='warning'>You just [pick("ran", "slammed")] into \the [AM]!</span>")
			*/ // VOREStation Removal End
		return
	if (!now_pushing)
		if(isobj(AM))
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				return
		now_pushing = 1

		var/t = get_dir(src, AM)
		if (istype(AM, /obj/structure/window))
			for(var/obj/structure/window/win in get_step(AM,t))
				now_pushing = 0
				return

		var/turf/T = AM.loc
		var/turf/T2 = get_step(AM,t)
		if(!T2) // Map edge
			now_pushing = 0
			return
		var/move_time = movement_delay(loc, t)
		move_time = DS2NEARESTTICK(move_time)
		if(AM.Move(T2, t, move_time))
			Move(T, t, move_time)

		if(ishuman(AM) && AM:grabbed_by)
			for(var/obj/item/grab/G in AM:grabbed_by)
				step(G:assailant, get_dir(G:assailant, AM))
				G.adjust_position()
		now_pushing = 0

/mob/living/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/blob) && faction == "blob") //Blobs should ignore things on their faction.
		return TRUE
	return ..()

// Called when something steps onto us. This allows for mulebots and vehicles to run things over. <3
/mob/living/Crossed(var/atom/movable/AM) // Transplanting this from /mob/living/carbon/human/Crossed()
	if(AM == src || AM.is_incorporeal()) // We're not going to run over ourselves or ghosts
		return

	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Almost all of this handles pulling movables behind us
/mob/living/Move(atom/newloc, direct, movetime)
	if(buckled && buckled.loc != newloc) //not updating position
		if(!buckled.anchored && buckled.buckle_movable)
			return buckled.Move(newloc, direct)
		else
			return 0

	var/atom/movable/pullee = pulling
	// Prior to our move it's already too far away
	if(pullee && get_dist(src, pullee) > 1)
		stop_pulling()
	// Shenanigans! Pullee closed into locker for eg.
	if(pullee && !isturf(pullee.loc) && pullee.loc != loc)
		stop_pulling()
	// Can't pull with no hands
	if(restrained())
		stop_pulling()

	// Will move our mob (probably)
	. = ..() // Moved() called at this point if successful

	if(pulledby && moving_diagonally != FIRST_DIAG_STEP && get_dist(src, pulledby) > 1) //seperated from our puller and not in the middle of a diagonal move
		pulledby.stop_pulling()

	if(s_active && !(s_active in contents) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)

/mob/living/proc/dragged(var/mob/living/dragger, var/oldloc)
	var/area/A = get_area(src)
	if(lying && !buckled && pull_damage() && A.has_gravity() && (prob(getBruteLoss() * 200 / maxHealth)))
		adjustBruteLoss(2)
		visible_message("<span class='danger'>\The [src]'s [isSynthetic() ? "state" : "wounds"] worsen terribly from being dragged!</span>")

/mob/living/Moved(var/atom/oldloc, direct, forced, movetime)
	. = ..()
	handle_footstep(loc)
	// Begin VOREstation edit
	if(is_shifted)
		is_shifted = FALSE
		pixel_x = default_pixel_x
		pixel_y = default_pixel_y
		layer = initial(layer)
		plane = initial(plane)
	// End VOREstation edit

	if(pulling) // we were pulling a thing and didn't lose it during our move.
		var/pull_dir = get_dir(src, pulling)

		if(pulling.anchored || !isturf(pulling.loc))
			stop_pulling()

		else if(get_dist(src, pulling) > 1 || (moving_diagonally != SECOND_DIAG_STEP && ((pull_dir - 1) & pull_dir))) // puller and pullee more than one tile away or in diagonal position
			// If it is too far away or across z-levels from old location, stop pulling.
			if(get_dist(pulling.loc, oldloc) > 1 || pulling.loc.z != oldloc?.z)
				stop_pulling()

			// living might take damage from drags
			else if(isliving(pulling))
				var/mob/living/M = pulling
				M.dragged(src, oldloc)

			if(pulling)								// Check it AGAIN after previous steps just in case
				pulling.Move(oldloc, 0, movetime) // the pullee tries to reach our previous position
				if(get_dist(src, pulling) > 1) // the pullee couldn't keep up
					stop_pulling()

	if(!isturf(loc))
		return
	else if(lastarea?.has_gravity == 0)
		inertial_drift()
	//VOREStation Edit Start
	else if(flying)
		inertial_drift()
		make_floating(1)
	//VOREStation Edit End
	else if(!isspace(loc))
		inertia_dir = 0
		make_floating(0)

/mob/living/proc/inertial_drift()
	if(x > 1 && x < (world.maxx) && y > 1 && y < (world.maxy))
		if(Process_Spacemove(1))
			inertia_dir = 0
			return

		var/locthen = loc
		spawn(5)
			if(!anchored && !pulledby && loc == locthen)
				var/stepdir = inertia_dir ? inertia_dir : last_move
				if(!stepdir)
					return
				var/turf/T = get_step(src, stepdir)
				if(!T)
					return
				Move(T, stepdir, 5)

/mob/living/proc/handle_footstep(turf/T)
	return FALSE
