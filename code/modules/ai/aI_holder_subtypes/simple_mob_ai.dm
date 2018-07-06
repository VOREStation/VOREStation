// AIs for simple mobs.

/datum/ai_holder/simple_mob
	hostile = TRUE // The majority of simplemobs are hostile.
	cooperative = TRUE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 1 // If the mob's saylist is empty, nothing will happen.
	wander = TRUE
	base_wander_delay = 4

// For animals.
/datum/ai_holder/simple_mob/passive
	hostile = FALSE
	can_flee = TRUE

// Ranged mobs.

/datum/ai_holder/simple_mob/ranged
//	ranged = TRUE

// Tries to not waste ammo.
/datum/ai_holder/simple_mob/ranged/careful
	conserve_ammo = TRUE

// Runs away from its target if within a certain distance.
/datum/ai_holder/simple_mob/ranged/kiting
	pointblank = TRUE // So we don't need to copypaste post_melee_attack().
	var/run_if_this_close = 4 // If anything gets within this range, it'll try to move away.

/datum/ai_holder/simple_mob/ranged/kiting/threatening
	threaten = TRUE
	threaten_delay = 1 SECOND // Less of a threat and more of pre-attack notice.
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_mob/ranged/kiting/post_ranged_attack(atom/A)
	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A, run_if_this_close))
		holder.face_atom(A)

// The electric spider's AI.
/datum/ai_holder/simple_mob/ranged/electric_spider

/datum/ai_holder/simple_mob/ranged/electric_spider/max_range(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.incapacitated(INCAPACITATION_DISABLED) || L.stat == UNCONSCIOUS) // If our target is stunned, go in for the kill.
			return 1
	return ..() // Do ranged if possible otherwise.






// Melee mobs.

/datum/ai_holder/simple_mob/melee

// Dances around the enemy its fighting, making it harder to fight back.
/datum/ai_holder/simple_mob/melee/evasive

/datum/ai_holder/simple_mob/melee/evasive/post_melee_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(alldirs)))
		holder.face_atom(A)

// The AI for hooligan crabs. Follows people for awhile.
/datum/ai_holder/simple_mob/melee/hooligan
	hostile = FALSE
	retaliate = TRUE
	returns_home = TRUE
	max_home_distance = 12
	var/random_follow = TRUE // Turn off if you want to bus with crabs.

/datum/ai_holder/simple_mob/melee/hooligan/handle_stance_strategical()
	..()
	if(random_follow && stance == STANCE_IDLE && !leader)
		if(prob(10))
			for(var/mob/living/L in hearers(holder))
				if(!istype(L, holder)) // Don't follow other hooligan crabs.
					holder.visible_message("<span class='notice'>\The [holder] starts to follow \the [L].</span>")
					set_follow(L, rand(20 SECONDS, 40 SECONDS))


// The AI for nurse spiders. Wraps things in webs by 'attacking' them.
/datum/ai_holder/simple_mob/melee/nurse_spider
	wander = TRUE
	base_wander_delay = 8

// Get us unachored objects as an option as well.
/datum/ai_holder/simple_mob/melee/nurse_spider/list_targets()
	. = ..()

	var/static/alternative_targets = typecacheof(list(/obj/item, /obj/structure))

	for(var/AT in typecache_filter_list(range(vision_range, holder), alternative_targets))
		var/obj/O = AT
		if(can_see(holder, O, vision_range) && !O.anchored)
			. += O

// Select an obj if no mobs are around.
/datum/ai_holder/melee/nurse_spider/pick_target(list/targets)
	var/mobs_only = locate(/mob/living) in targets // If a mob is in the list of targets, then ignore objects.
	if(mobs_only)
		for(var/A in targets)
			if(!isliving(A))
				targets -= A

	return ..(targets)

/datum/ai_holder/simple_mob/melee/nurse_spider/can_attack(atom/movable/the_target)
	. = ..()
	if(!.) // Parent returned FALSE.
		if(istype(the_target, /obj))
			var/obj/O = the_target
			if(!O.anchored)
				return TRUE

// This AI hits something, then runs away for awhile.
// It will (almost) always flee if they are uncloaked, AND their target is not stunned.
/datum/ai_holder/simple_mob/melee/hit_and_run
	can_flee = TRUE

// Used for the 'running' part of hit and run.
/datum/ai_holder/simple_mob/melee/hit_and_run/special_flee_check()
	if(!holder.is_cloaked())
		if(target && isliving(target))
			var/mob/living/L = target
			return !L.incapacitated(INCAPACITATION_DISABLED) // Don't flee if our target is stunned in some form, even if uncloaked. This is so the mob keeps attacking a stunned opponent.
		return TRUE // We're out in the open, uncloaked, and our target isn't stunned, so lets flee.
	return FALSE


// This AI isolates people it stuns with its 'leap' attack, by dragging them away.
/datum/ai_holder/simple_mob/melee/hunter_spider

/*

/datum/ai_holder/simple_mob/melee/hunter_spider/post_special_attack(mob/living/L)
	drag_away(L)

// Called after a successful leap.
/datum/ai_holder/simple_mob/melee/hunter_spider/proc/drag_away(mob/living/L)
	world << "Doing drag_away attack on [L]"
	if(!istype(L))
		world << "Invalid type."
		return FALSE

	// If they didn't get stunned, then don't bother.
	if(!L.incapacitated(INCAPACITATION_DISABLED))
		world << "Not incapcitated."
		return FALSE

	// Grab them.
	if(!holder.start_pulling(L))
		world << "Failed to pull."
		return FALSE

	holder.visible_message(span("danger","\The [holder] starts to drag \the [L] away!"))

	var/list/allies = list()
	var/list/enemies = list()
	for(var/mob/living/thing in hearers(vision_range, holder))
		if(thing == holder || thing == L) // Don't count ourselves or the thing we just started pulling.
			continue
		if(holder.IIsAlly(thing))
			allies += thing
		else
			enemies += thing

	// First priority: Move our victim to our friends.
	if(allies.len)
		world << "Going to move to ally"
		give_destination(get_turf(pick(allies)), min_distance = 2, combat = TRUE) // This will switch our stance.

	// Second priority: Move our victim away from their friends.
	// There's a chance of it derping and pulling towards enemies if there's more than two people.
	// Preventing that will likely be both a lot of effort for developers and the CPU.
	else if(enemies.len)
		world << "Going to move away from enemies"
		var/mob/living/hostile = pick(enemies)
		var/turf/move_to = get_turf(hostile)
		for(var/i = 1 to vision_range) // Move them this many steps away from their friend.
			move_to = get_step_away(move_to, L, 7)
		if(move_to)
			give_destination(move_to, min_distance = 2, combat = TRUE) // This will switch our stance.

	// Third priority: Move our victim SOMEWHERE away from where they were.
	else
		world << "Going to move away randomly"
		var/turf/move_to = get_turf(L)
		move_to = get_step(move_to, pick(cardinal))
		for(var/i = 1 to vision_range) // Move them this many steps away from where they were before.
			move_to = get_step_away(move_to, L, 7)
		if(move_to)
			give_destination(move_to, min_distance = 2, combat = TRUE) // This will switch our stance.
*/

/datum/ai_holder/simple_mob/hivebot
	conserve_ammo = TRUE
	firing_lanes = TRUE
	can_flee = FALSE // Fearless dumb machines.
