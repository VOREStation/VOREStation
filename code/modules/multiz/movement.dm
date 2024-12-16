/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC.Game"

	if(zMove(UP))
		to_chat(src, span_notice("You move upwards."))

/mob/verb/down()
	set name = "Move Down"
	set category = "IC.Game"

	if(zMove(DOWN))
		to_chat(src, span_notice("You move down."))

/mob/proc/zMove(direction)
	if(eyeobj)
		return eyeobj.zMove(direction)
	if(istype(loc,/obj/mecha))
		var/obj/mecha/mech = loc
		return mech.relaymove(src,direction)

	var/swim_modifier = 1
	var/climb_modifier = 1
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/MS = src
		swim_modifier = MS.species.swim_mult
		climb_modifier = MS.species.climb_mult

	if(!can_ztravel())
		to_chat(src, span_warning("You lack means of travel in that direction."))
		return

	var/turf/start = loc
	if(!istype(start))
		to_chat(src, span_notice("You are unable to move from here."))
		return 0

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(!destination)
		to_chat(src, span_notice("There is nothing of interest in this direction."))
		return 0

	if(is_incorporeal())
		forceMove(destination)
		return 1

	var/obj/structure/ladder/ladder = locate() in start.contents
	if((direction == UP ? ladder?.target_up : ladder?.target_down) && (ladder?.allowed_directions & direction))
		if(src.may_climb_ladders(ladder))
			return ladder.climbLadder(src, (direction == UP ? ladder.target_up : ladder.target_down))

	if(!start.CanZPass(src, direction))
		to_chat(src, span_warning("\The [start] is in the way."))
		return 0

	if(direction == DOWN)
		var/turf/simulated/floor/water/deep/ocean/diving/sink = start
		if(istype(sink) && !destination.density)
			var/pull_up_time = max((3 SECONDS + (src.movement_delay() * 10) * swim_modifier), 1)
			to_chat(src, span_notice("You start diving underwater..."))
			src.audible_message(span_notice("[src] begins to dive under the water."), runemessage = "splish splosh")
			if(do_after(src, pull_up_time))
				to_chat(src, span_notice("You reach the sea floor."))
			else
				to_chat(src, span_warning("You stopped swimming downwards."))
				return 0

		else if(!destination.CanZPass(src, direction)) // one for the down and non-special case
			to_chat(src, span_warning("\The [destination] blocks your way."))
			return 0

	else if(!destination.CanZPass(src, direction)) // and one for up
		to_chat(src, span_warning("\The [destination] blocks your way."))
		return 0


	var/area/area = get_area(src)
	if(area.get_gravity() && !can_overcome_gravity())
		if(direction == UP)
			var/obj/structure/lattice/lattice = locate() in destination.contents
			var/obj/structure/catwalk/catwalk = locate() in destination.contents

			if(lattice)
				var/pull_up_time = max((5 SECONDS + (src.movement_delay() * 10) * climb_modifier), 1)
				to_chat(src, span_notice("You grab \the [lattice] and start pulling yourself upward..."))
				src.audible_message(span_notice("[src] begins climbing up \the [lattice]."), runemessage = "clank clang")
				if(do_after(src, pull_up_time))
					to_chat(src, span_notice("You pull yourself up."))
				else
					to_chat(src, span_warning("You gave up on pulling yourself up."))
					return 0

			else if(istype(destination, /turf/simulated/floor/water/deep/ocean/diving))
				var/pull_up_time = max((5 SECONDS + (src.movement_delay() * 10) * swim_modifier), 1)
				to_chat(src, span_notice("You start swimming upwards..."))
				src.audible_message(span_notice("[src] begins to swim towards the surface."), runemessage = "splish splosh")
				if(do_after(src, pull_up_time))
					to_chat(src, span_notice("You reach the surface."))
				else
					to_chat(src, span_warning("You stopped swimming upwards."))
					return 0

			else if(catwalk?.hatch_open)
				var/pull_up_time = max((5 SECONDS + (src.movement_delay() * 10) * climb_modifier), 1)
				to_chat(src, span_notice("You grab the edge of \the [catwalk] and start pulling yourself upward..."))
				var/old_dest = destination
				destination = get_step(destination, dir) // mob's dir
				if(!destination?.Enter(src, old_dest))
					to_chat(src, span_notice("There's something in the way up above in that direction, try another."))
					return 0
				src.audible_message(span_notice("[src] begins climbing up \the [lattice]."), runemessage = "clank clang")
				if(do_after(src, pull_up_time))
					to_chat(src, span_notice("You pull yourself up."))
				else
					to_chat(src, span_warning("You gave up on pulling yourself up."))
					return 0

			// Explicit check if the destination turf allows full passing
			else if(!destination.CanZPass(src, direction))
				to_chat(src, span_warning("Something solid above stops you from passing."))
				return 0

			else if(isliving(src)) //VOREStation Edit Start. Are they a mob, and are they currently flying??
				var/mob/living/H = src
				if(H.flying)
					if(H.incapacitated(INCAPACITATION_ALL))
						to_chat(src, span_notice("You can't fly in your current state."))
						H.stop_flying() //Should already be done, but just in case.
						return 0
					var/fly_time = max(7 SECONDS + (H.movement_delay() * 10), 1) //So it's not too useful for combat. Could make this variable somehow, but that's down the road.
					to_chat(src, span_notice("You begin to fly upwards..."))
					H.audible_message(span_notice("[H] begins to flap \his wings, preparing to move upwards!"), runemessage = "flap flap")
					if(do_after(H, fly_time) && H.flying)
						to_chat(src, span_notice("You fly upwards."))
					else
						to_chat(src, span_warning("You stopped flying upwards."))
						return 0
				else
					to_chat(src, span_warning("Gravity stops you from moving upward."))
					return 0 //VOREStation Edit End.

			else
				to_chat(src, span_warning("Gravity stops you from moving upward."))
				return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start, 1.5, 0))
			to_chat(src, span_warning("\The [A] blocks you."))
			return 0
	if(!Move(destination))
		return 0
	if(isliving(src))
		var/list/atom/movable/pulling = list()
		var/mob/living/L = src
		if(L.pulling && !L.pulling.anchored)
			pulling |= L.pulling
		for(var/obj/item/grab/G in list(L.l_hand, L.r_hand))
			pulling |= G.affecting
		if(direction == UP)
			src.audible_message(span_notice("[src] moves up."))
		else if(direction == DOWN)
			src.audible_message(span_notice("[src] moves down."))
		for(var/atom/movable/P in pulling)
			P.forceMove(destination)
	return 1

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/can_overcome_gravity()
	return hovering

/mob/living/carbon/human/can_overcome_gravity()
	. = ..()
	if(!.)
		return species && species.can_overcome_gravity(src)

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, span_notice("There is nothing of interest in this direction."))

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(src, span_notice("There is nothing of interest in this direction."))

/mob/proc/can_ztravel()
	return 0

/mob/living/zMove(direction)
	//Sort of a lame hack to allow ztravel through zpipes. Should be improved.
	if(is_ventcrawling && istype(loc,/obj/machinery/atmospherics/pipe/zpipe))
		var/obj/machinery/atmospherics/pipe/zpipe/currentpipe = loc
		if(istype(currentpipe.node1,/obj/machinery/atmospherics/pipe/zpipe))
			currentpipe.ventcrawl_to(src, currentpipe.node1, direction)
		else if(istype(currentpipe.node2,/obj/machinery/atmospherics/pipe/zpipe))
			currentpipe.ventcrawl_to(src, currentpipe.node2, direction)
	return ..()

/mob/observer/can_ztravel()
	return TRUE

/mob/living/can_ztravel()
	if(incapacitated())
		return FALSE
	return (hovering || is_incorporeal())

/mob/living/simple_mob/can_ztravel()
	if(incapacitated())
		return FALSE

	if(hovering || is_incorporeal())
		return TRUE

	if(Process_Spacemove())
		return TRUE

	if(has_hands)
		return TRUE

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return FALSE

	if(hovering || is_incorporeal())
		return TRUE

	if(flying) //VOREStation Edit. Allows movement up/down with wings.
		return TRUE //VOREStation Edit

	if(Process_Spacemove())
		return TRUE

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return TRUE

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return FALSE

	if(hovering)
		return TRUE

	if(Process_Spacemove()) //Checks for active jetpack
		return TRUE

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return TRUE

// TODO - Leshana Experimental

//Execution by grand piano!
/atom/movable/proc/get_fall_damage()
	return 42

//If atom stands under open space, it can prevent fall, or not
/atom/proc/can_prevent_fall(var/atom/movable/mover, var/turf/coming_from)
	return (!CanPass(mover, coming_from))

////////////////////////////



//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall()
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	if(istype(below, /turf/space))
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(!area.get_gravity())
		return

	if(throwing)
		return
	//VOREStation Edit Start. Flight on mobs.
	if(isliving(src))
		var/mob/living/L = src //VOREStation Edit Start. Flight on mobs.
		if(L.flying) //Some other checks are done in the wings_toggle proc
			if(L.nutrition > 0.5)
				L.adjust_nutrition(-0.5) //You use up -0.5 nutrition per TILE and tick of flying above open spaces. If people wanna flap their wings in the hallways, shouldn't penalize them for it.
			if(L.incapacitated(INCAPACITATION_ALL))
				L.stop_flying()
				//Just here to see if the person is KO'd, stunned, etc. If so, it'll move onto can_fall.
			else if(L.nutrition < 300 && L.nutrition > 299.4) //290 would be risky, as metabolism could mess it up. Let's do 289.
				to_chat(L, span_danger("You are starting to get fatigued... You probably have a good minute left in the air, if that. Even less if you continue to fly around! You should get to the ground soon!")) //Ticks are, on average, 3 seconds. So this would most likely be 90 seconds, but lets just say 60.
				L.adjust_nutrition(-0.5)
				return
			else if(L.nutrition < 100 && L.nutrition > 99.4)
				to_chat(L, span_danger("You're seriously fatigued! You need to get to the ground immediately and eat before you fall!"))
				return
			else if(L.nutrition < 10) //Should have listened to the warnings!
				to_chat(L, span_danger("You lack the strength to keep yourself up in the air..."))
				L.stop_flying()
			else
				return
		if(LAZYLEN(L.grabbed_by)) //If you're grabbed (presumably by someone flying) let's not have you fall. This also allows people to grab onto you while you jump over a railing to prevent you from falling!
			return
	//VOREStation Edit End

	if(can_fall() && can_fall_to(below))
		// We spawn here to let the current move operation complete before we start falling. fall() is normally called from
		// Entered() which is part of Move(), by spawn()ing we let that complete.  But we want to preserve if we were in client movement
		// or normal movement so other move behavior can continue.
		var/mob/M = src
		var/is_client_moving = (ismob(M) && M.client && M.client.moving)
		spawn(0)
			if(is_client_moving) M.client.moving = 1
			handle_fall(below)
			if(is_client_moving) M.client.moving = 0
		// TODO - handle fall on damage!

//For children to override
/atom/movable/proc/can_fall()
	if(anchored)
		return FALSE
	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

// These didn't fall anyways but better to nip this now just incase.
/atom/movable/lighting_overlay/can_fall()
	return FALSE

// Mechas are anchored, so we need to override.
/obj/mecha/can_fall()
	return TRUE

// VOREstation edit - Falling vehicles.
/obj/vehicle/can_fall()
	return TRUE
// VOREstation edit end

/obj/item/pipe/can_fall()
	. = ..()

	if(anchored)
		return FALSE

	var/turf/below = GetBelow(src)
	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up) in below)
		return FALSE

/mob/living/can_fall()
	if(is_incorporeal())
		return FALSE
	if(hovering)
		return FALSE
	return ..()

/mob/living/carbon/human/can_fall()
	if(..())
		return species.can_fall(src)

// Another check that we probably can just merge into can_fall exept for messing up overrides
/atom/movable/proc/can_fall_to(turf/landing)
	// Check if there is anything in our turf we are standing on to prevent falling.
	for(var/obj/O in loc)
		if(!O.CanFallThru(src, landing))
			return FALSE
	// See if something in turf below prevents us from falling into it.
	for(var/atom/A in landing)
		if(ismob(A))
			continue
		if(!A.CanPass(src, src.loc, 1, 0))
			return FALSE
	return TRUE

// Check if this atom prevents things standing on it from falling. Return TRUE to allow the fall.
/obj/proc/CanFallThru(atom/movable/mover as mob|obj, turf/target as turf)
	if(!isturf(mover.loc)) // VORESTATION EDIT. We clearly didn't have enough backup checks.
		return FALSE //If this ain't working Ima be pissed.
	return TRUE

// Things that prevent objects standing on them from falling into turf below
/obj/structure/catwalk/CanFallThru(atom/movable/mover as mob|obj, turf/target as turf)
	if((target.z < z) && !hatch_open)
		return FALSE // TODO - Technically should be density = TRUE and flags |= ON_BORDER
	if(!isturf(mover.loc))
		return FALSE // Only let loose floor items fall. No more snatching things off people's hands.
	else
		return TRUE

// So you'll slam when falling onto a catwalk
/obj/structure/catwalk/CheckFall(var/atom/movable/falling_atom)
	return falling_atom.fall_impact(src)

/obj/structure/lattice/CanFallThru(atom/movable/mover as mob|obj, turf/target as turf)
	if(target.z >= z)
		return TRUE // We don't block sideways or upward movement.
	else if(istype(mover) && mover.checkpass(PASSGRILLE))
		return TRUE // Anything small enough to pass a grille will pass a lattice
	if(!isturf(mover.loc))
		return FALSE // Only let loose floor items fall. No more snatching things off people's hands.
	else
		return FALSE // TODO - Technically should be density = TRUE and flags |= ON_BORDER

// So you'll slam when falling onto a grille
/obj/structure/lattice/CheckFall(var/atom/movable/falling_atom)
	if(istype(falling_atom) && falling_atom.checkpass(PASSGRILLE))
		return FALSE
	return falling_atom.fall_impact(src)

// Actually process the falling movement and impacts.
/atom/movable/proc/handle_fall(var/turf/landing)
	var/turf/oldloc = loc

	// Now lets move there!
	if(!Move(landing))
		return 1

	// Detect if we made a silent landing.
	var/atom/A = find_fall_target(oldloc, landing)
	if(special_fall_handle(A) || !A || !A.check_impact(src))
		return
	fall_impact(A)

/atom/movable/proc/special_fall_handle(var/atom/A)
	return FALSE

/mob/living/carbon/human/special_fall_handle(var/atom/A)
	if(species)
		return species.fall_impact_special(src, A)
	return FALSE

/atom/movable/proc/find_fall_target(var/turf/oldloc, var/turf/landing)
	if(isopenspace(oldloc))
		oldloc.visible_message(span_notice("\The [src] falls down through \the [oldloc]!"), span_notice("You hear something falling through the air."))

	// If the turf has density, we give it first dibs
	if (landing.density && landing.CheckFall(src))
		return landing

	// First hit objects in the turf!
	for(var/atom/movable/A in landing)
		if(A != src && A.CheckFall(src))
			return A

	// If none of them stopped us, then hit the turf itself
	if(landing.CheckFall(src))
		return landing

/mob/living/carbon/human/find_fall_target(var/turf/landing)
	if(species)
		var/atom/A = species.find_fall_target_special(src, landing)
		if(A)
			return A
	return ..()

//CheckFall landing.fall_impact(src)

// ## THE FALLING PROCS ###

// Called on everything that falling_atom might hit. Return TRUE if you're handling it so find_fall_target() will stop checking.
/atom/proc/CheckFall(var/atom/movable/falling_atom)
	if(density && !(flags & ON_BORDER))
		return TRUE

// If you are hit: how is it handled.
// Return TRUE if the generic fall_impact should be called
// Return FALSE if you handled it yourself or if there's no effect from hitting you
/atom/proc/check_impact(var/atom/movable/falling_atom)
	if(density && !(flags & ON_BORDER))
		return TRUE

// By default all turfs are gonna let you hit them regardless of density.
/turf/CheckFall(var/atom/movable/falling_atom)
	return TRUE

/turf/check_impact(var/atom/movable/falling_atom)
	return TRUE

// Obviously you can't really hit open space.
/turf/simulated/open/CheckFall(var/atom/movable/falling_atom)
	return FALSE

/turf/simulated/open/check_impact(var/atom/movable/falling_atom)
	return FALSE

// Or actual space.
/turf/space/CheckFall(var/atom/movable/falling_atom)
	return FALSE

/turf/space/check_impact(var/atom/movable/falling_atom)
	return FALSE

// Can't fall onto ghosts
/mob/observer/dead/CheckFall()
	return FALSE

/mob/observer/dead/check_impact()
	return FALSE


// Called by CheckFall when we actually hit something. Various Vars will be described below
// hit_atom is the thing we fall on
// damage_min is the smallest amount of damage a thing (currently only mobs and mechs) will take from falling
// damage_max is the largest amount of damage a thing (currently only mobs and mechs) will take from falling.
// If silent is True, the proc won't play sound or give a message.
// If planetary is True, it's harder to stop the fall damage

/atom/movable/proc/fall_impact(var/atom/hit_atom, var/damage_min = 0, var/damage_max = 10, var/silent = FALSE, var/planetary = FALSE)
	if(!silent)
		visible_message("\The [src] falls from above and slams into \the [hit_atom]!", "You hear something slam into \the [hit_atom].")
	for(var/atom/movable/A in src.contents)
		A.fall_impact(hit_atom, damage_min, damage_max, silent = TRUE)

// Take damage from falling and hitting the ground
/mob/living/fall_impact(var/atom/hit_atom, var/damage_min = 0, var/damage_max = 5, var/silent = FALSE, var/planetary = FALSE)
	var/turf/landing = get_turf(hit_atom)
	var/safe_fall = FALSE
	if(src.softfall || (istype(src, /mob/living/simple_mob) && src.mob_size <= MOB_SMALL))
		safe_fall = TRUE
	if(planetary && src.CanParachute())
		if(!silent)
			visible_message(span_warning("\The [src] glides in from above and lands on \the [landing]!"), \
				span_danger("You land on \the [landing]!"), \
				"You hear something land \the [landing].")
		return
	else if(!planetary && safe_fall) // Falling one floor and falling one atmosphere are very different things
		if(!silent)
			visible_message(span_warning("\The [src] falls from above and lands on \the [landing]!"), \
				span_danger("You land on \the [landing]!"), \
				"You hear something land \the [landing].")
		return
	else
		if(!silent)
			if(planetary)
				visible_message(span_danger(span_large("\A [src] falls out of the sky and crashes into \the [landing]!")), \
					span_danger(span_large(" You fall out of the sky and crash into \the [landing]!")), \
					"You hear something slam into \the [landing].")
				var/turf/T = get_turf(landing)
				explosion(T, 0, 1, 2)
			else
				visible_message(span_warning("\The [src] falls from above and slams into \the [landing]!"), \
					span_danger("You fall off and hit \the [landing]!"), \
					"You hear something slam into \the [landing].")
			playsound(src, "punch", 25, 1, -1)

		// Because wounds heal rather quickly, 10 (the default for this proc) should be enough to discourage jumping off but not be enough to ruin you, at least for the first time.
		// Hits 10 times, because apparently targeting individual limbs lets certain species survive the fall from atmosphere
		for(var/i = 1 to 10)
			adjustBruteLoss(rand(damage_min, damage_max))
		Weaken(4)
		updatehealth()

/mob/living/carbon/human/fall_impact(atom/hit_atom, damage_min, damage_max, silent, planetary)
	if(!species?.handle_falling(src, hit_atom, damage_min, damage_max, silent, planetary))
		..()

//Using /atom/movable instead of /obj/item because I'm not sure what all humans can pick up or wear
/atom/movable
	var/parachute = FALSE	// Is this thing a parachute itself?
	var/hovering = FALSE	// Is the thing floating or flying in some way? If so, don't fall normally.	//Not implemented yet, idea is to let mobs/mechs ignore terrain slowdown and falling down floors
	var/softfall = FALSE	// Is the thing able to lessen their impact upon falling?
	var/parachuting = FALSE	// Is the thing able to jump out of planes and survive? Don't check this directly outside of CanParachute().

/atom/movable/proc/isParachute()
	return parachute

//This is what makes the parachute items know they've been used.
//I made it /atom/movable so it can be retooled for other things (mobs, mechs, etc), though it's only currently called in human/CanParachute().
/atom/movable/proc/handleParachute()
	return

//Checks if the thing is allowed to survive a fall from space
/atom/movable/proc/CanParachute()
	return parachuting

//For humans, this needs to be a wee bit more complicated
/mob/living/carbon/human/CanParachute()
	//Certain slots don't really need to be checked for parachute ability, i.e. pockets, ears, etc. If this changes, just add them to the loop, I guess?
	//This is done in Priority Order, so items lower down the list don't call handleParachute() unless they're actually used.
	if(back && back.isParachute())
		back.handleParachute()
		return TRUE
	if(s_store && s_store.isParachute())
		back.handleParachute()
		return TRUE
	if(belt && belt.isParachute())
		back.handleParachute()
		return TRUE
	if(wear_suit && wear_suit.isParachute())
		back.handleParachute()
		return TRUE
	if(w_uniform && w_uniform.isParachute())
		back.handleParachute()
		return TRUE
	else
		return parachuting

//Mech Code
/obj/mecha/handle_fall(var/turf/landing)
	// First things first, break any lattice
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, loc)
	if(lattice)
		// Lattices seem a bit too flimsy to hold up a massive exosuit.
		lattice.visible_message(span_danger("\The [lattice] collapses under the weight of \the [src]!"))
		qdel(lattice)

	// Then call parent to have us actually fall
	return ..()

/obj/mecha/fall_impact(var/atom/hit_atom, var/damage_min = 15, var/damage_max = 30, var/silent = FALSE, var/planetary = FALSE)
	// Anything on the same tile as the landing tile is gonna have a bad day.
	for(var/mob/living/L in hit_atom.contents)
		L.visible_message(span_danger("\The [src] crushes \the [L] as it lands on them!"))
		L.adjustBruteLoss(rand(70, 100))
		L.Weaken(8)

	var/turf/landing = get_turf(hit_atom)

	if(planetary && src.CanParachute())
		if(!silent)
			visible_message(span_warning("\The [src] glides in from above and lands on \the [landing]!"), \
				span_danger("You land on \the [landing]!"), \
				"You hear something land \the [landing].")
		return
	else if(!planetary && src.softfall) // Falling one floor and falling one atmosphere are very different things
		if(!silent)
			visible_message(span_warning("\The [src] falls from above and lands on \the [landing]!"), \
				span_danger("You land on \the [landing]!"), \
				"You hear something land \the [landing].")
		return
	else
		if(!silent)
			if(planetary)
				visible_message(span_danger(span_large("\A [src] falls out of the sky and crashes into \the [landing]!")), \
					span_danger(span_large(" You fall out of the skiy and crash into \the [landing]!")), \
					"You hear something slam into \the [landing].")
				var/turf/T = get_turf(landing)
				explosion(T, 0, 1, 2)
			else
				visible_message(span_warning("\The [src] falls from above and slams into \the [landing]!"), \
					span_danger("You fall off and hit \the [landing]!"), \
					"You hear something slam into \the [landing].")
			playsound(src, "punch", 25, 1, -1)

	// And now to hurt the mech.
	if(!planetary)
		take_damage(rand(damage_min, damage_max))
	else
		for(var/atom/movable/A in src.contents)
			A.fall_impact(hit_atom, damage_min, damage_max, silent = TRUE)
		qdel(src)

	// And hurt the floor.
	if(istype(hit_atom, /turf/simulated/floor))
		var/turf/simulated/floor/ground = hit_atom
		ground.break_tile()
