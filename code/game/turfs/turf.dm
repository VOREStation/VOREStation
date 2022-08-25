/turf
	icon = 'icons/turf/floors.dmi'
	layer = TURF_LAYER
	plane = TURF_PLANE
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE// Important for interaction with and visualization of openspace.
	level = 1
	var/holy = 0

	// Initial air contents (in moles)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/phoron = 0

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	var/movement_cost = 0       // How much the turf slows down movement, if any.

	var/list/footstep_sounds = null

	var/block_tele = FALSE      // If true, most forms of teleporting to or from this turf tile will fail.
	var/can_build_into_floor = FALSE // Used for things like RCDs (and maybe lattices/floor tiles in the future), to see if a floor should replace it.
	var/list/dangerous_objects // List of 'dangerous' objs that the turf holds that can cause something bad to happen when stepped on, used for AI mobs.
	var/tmp/changing_turf

/turf/Initialize(mapload)
	. = ..()
	
	for(var/atom/movable/AM in src)
		Entered(AM)

	//Lighting related
	set_luminosity(!(dynamic_lighting))

	if(opacity)
		directional_opacity = ALL_CARDINALS

	//Pathfinding related
	if(movement_cost && pathweight == 1) // This updates pathweight automatically.
		pathweight = movement_cost

	var/turf/Ab = GetAbove(src)
	if(Ab)
		Ab.multiz_turf_new(src, DOWN)
	var/turf/Be = GetBelow(src)
	if(Be)
		Be.multiz_turf_new(src, UP)

/turf/Destroy()
	if (!changing_turf)
		stack_trace("Improper turf qdel. Do not qdel turfs directly.")
	changing_turf = FALSE
	cleanbot_reserved_turfs -= src
	if(connections)
		connections.erase_all()
	..()
	return QDEL_HINT_IWILLGC

/turf/ex_act(severity)
	return 0

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

// Used by shuttle code to check if this turf is empty enough to not crush want it lands on.
/turf/proc/is_solid_structure()
	return 1

/turf/attack_hand(mob/user)
	//QOL feature, clicking on turf can toggle doors, unless pulling something
	if(!user.pulling)
		var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
		if(AL)
			AL.attack_hand(user)
			return TRUE
		var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
		if(FD)
			FD.attack_hand(user)
			return TRUE

	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return 0
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return 0
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return 1

/turf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
	return ..()

// Hits a mob on the tile.
/turf/proc/attack_tile(obj/item/weapon/W, mob/living/user)
	if(!istype(W))
		return FALSE

	var/list/viable_targets = list()
	var/success = FALSE // Hitting something makes this true. If its still false, the miss sound is played.

	for(var/mob/living/L in contents)
		if(L == user) // Don't hit ourselves.
			continue
		viable_targets += L

	if(!viable_targets.len) // No valid targets on this tile.
		if(W.can_cleave)
			success = W.cleave(user, src)
	else
		var/mob/living/victim = pick(viable_targets)
		success = W.resolve_attackby(victim, user)

	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src, no_attack_icons = TRUE)

	if(!success) // Nothing got hit.
		user.visible_message("<span class='warning'>\The [user] swipes \the [W] over \the [src].</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return success

/turf/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if((istype(A) && !(A.has_gravity)) || (istype(T,/turf/space)))
		return
	if(istype(O, /obj/screen))
		return
	if(user.restrained() || user.stat || user.stunned || user.paralysis || (!user.lying && !istype(user, /mob/living/silicon/robot)))
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return
	if (do_after(user, 25 + (5 * user.weakened)) && !(user.stat))
		step_towards(O, src)
		if(ismob(O))
			animate(O, transform = turn(O.transform, 20), time = 2)
			sleep(2)
			animate(O, transform = turn(O.transform, -40), time = 4)
			sleep(4)
			animate(O, transform = turn(O.transform, 20), time = 2)
			sleep(2)
			O.update_transform()

/turf/CanPass(atom/movable/mover, turf/target)
	if(!target)
		return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	stack_trace("Non movable passed to turf CanPass : [mover]")
	return FALSE

//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanPass/Cross call, lemme know or go ahead and fix this mess - kevinz000
/turf/Enter(atom/movable/mover, atom/oldloc)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems
		return
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/CanPassSelf = CanPass(mover, src)
	if(CanPassSelf || CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
		for(var/i in contents)
			if(QDELETED(mover))
				return FALSE		//We were deleted, do not attempt to proceed with movement.
			if(i == mover || i == mover.loc) // Multi tile objects and moving out of other objects
				continue
			var/atom/movable/thing = i
			if(!thing.Cross(mover))
				if(QDELETED(mover))		//Mover deleted from Cross/CanPass, do not proceed.
					return FALSE
				if(CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
					mover.Bump(thing)
					continue
				else
					if(!firstbump || ((thing.layer > firstbump.layer || thing.flags & ON_BORDER) && !(firstbump.flags & ON_BORDER)))
						firstbump = thing
	if(QDELETED(mover))					//Mover deleted from Cross/CanPass/Bump, do not proceed.
		return FALSE
	if(!CanPassSelf)	//Even if mover is unstoppable they need to bump us.
		firstbump = src
	if(firstbump)
		mover.Bump(firstbump)
		return !QDELETED(mover) && CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE)
	return TRUE

/turf/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(!. || QDELETED(mover))
		return FALSE
	for(var/i in contents)
		if(i == mover)
			continue
		var/atom/movable/thing = i
		if(!thing.Uncross(mover, newloc))
			if(thing.flags & ON_BORDER)
				mover.Bump(thing)
			if(!CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
				return FALSE
		if(QDELETED(mover))
			return FALSE		//We were deleted.

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/turf/T as anything in (trange(1,src) - src))
		if(check_blockage)
			if(!T.density)
				if(!LinkBlocked(src, T) && !TurfBlockedNonWindow(T))
					. += T
		else
			. += T

/turf/proc/CardinalTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/turf/T as anything in AdjacentTurfs(check_blockage))
		if(T.x == src.x || T.y == src.y)
			. += T

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
	else
		to_chat(user, "<span class='warning'>\The [source] is too dry to wash that.</span>")
	source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/update_blood_overlays()
	return

// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM as mob|obj, var/speed)
	if(src.density)
		spawn(2)
			step(AM, turn(AM.last_move, 180))
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, speed)

/turf/AllowDrop()
	return TRUE

/turf/proc/can_engrave()
	return FALSE

/turf/proc/try_graffiti(var/mob/vandal, var/obj/item/tool)

	if(!tool || !tool.sharp || !can_engrave())
		return FALSE

	if(jobban_isbanned(vandal, "Graffiti"))
		to_chat(vandal, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
		return

	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/W in src)
		too_much_graffiti++
	if(too_much_graffiti >= 5)
		to_chat(vandal, "<span class='warning'>There's too much graffiti here to add more.</span>")
		return FALSE

	var/message = sanitize(tgui_input_text(usr, "Enter a message to engrave.", "Graffiti"), trim = TRUE)
	if(!message)
		return FALSE

	if(!vandal || vandal.incapacitated() || !Adjacent(vandal) || !tool.loc == vandal)
		return FALSE

	vandal.visible_message("<span class='warning'>\The [vandal] begins carving something into \the [src].</span>")

	if(!do_after(vandal, max(20, length(message)), src))
		return FALSE

	vandal.visible_message("<span class='danger'>\The [vandal] carves some graffiti into \the [src].</span>")
	var/obj/effect/decal/writing/graffiti = new(src)
	graffiti.message = message
	graffiti.author = vandal.ckey

	if(lowertext(message) == "elbereth")
		to_chat(vandal, "<span class='notice'>You feel much safer.</span>")

	return TRUE

// Returns false if stepping into a tile would cause harm (e.g. open space while unable to fly, water tile while a slime, lava, etc).
/turf/proc/is_safe_to_enter(mob/living/L)
	if(LAZYLEN(dangerous_objects))
		for(var/obj/O in dangerous_objects)
			if(!O.is_safe_to_step(L))
				return FALSE
	return TRUE

// Tells the turf that it currently contains something that automated movement should consider if planning to enter the tile.
// This uses lazy list macros to reduce memory footprint, since for 99% of turfs the list would've been empty anyways.
/turf/proc/register_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYADD(dangerous_objects, O)
//	color = "#FF0000"

// Similar to above, for when the dangerous object stops being dangerous/gets deleted/moved/etc.
/turf/proc/unregister_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYREMOVE(dangerous_objects, O)
	UNSETEMPTY(dangerous_objects) // This nulls the list var if it's empty.
//	color = "#00FF00"

// This is all the way up here since its the common ancestor for things that need to get replaced with a floor when an RCD is used on them.
// More specialized turfs like walls should instead override this.
// The code for applying lattices/floor tiles onto lattices could also utilize something similar in the future.
/turf/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	if(density || !can_build_into_floor)
		return FALSE
	if(passed_mode == RCD_FLOORWALL)
		var/obj/structure/lattice/L = locate() in src
		// A lattice costs one rod to make. A sheet can make two rods, meaning a lattice costs half of a sheet.
		// A sheet also makes four floor tiles, meaning it costs 1/4th of a sheet to place a floor tile on a lattice.
		// Therefore it should cost 3/4ths of a sheet if a lattice is not present, or 1/4th of a sheet if it does.
		return list(
			RCD_VALUE_MODE = RCD_FLOORWALL,
			RCD_VALUE_DELAY = 0,
			RCD_VALUE_COST = L ? RCD_SHEETS_PER_MATTER_UNIT * 0.25 : RCD_SHEETS_PER_MATTER_UNIT * 0.75
			)
	return FALSE

/turf/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_FLOORWALL)
		to_chat(user, span("notice", "You build a floor."))
		ChangeTurf(/turf/simulated/floor/airless, preserve_outdoors = TRUE)
		return TRUE
	return FALSE


// We're about to be the A-side in a turf translation
/turf/proc/pre_translate_A(var/turf/B)
	return
// We're about to be the B-side in a turf translation
/turf/proc/pre_translate_B(var/turf/A)
	return
// We were the the A-side in a turf translation
/turf/proc/post_translate_A(var/turf/B)
	return
// We were the the B-side in a turf translation
/turf/proc/post_translate_B(var/turf/A)
	return
