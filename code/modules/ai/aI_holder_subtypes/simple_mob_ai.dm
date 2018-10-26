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

// For parrots like Poly.
// They modify their say_list datum based on what their mob hears.
/datum/ai_holder/simple_mob/passive/parrot
	speak_chance = 2
	base_wander_delay = 8

/datum/ai_holder/simple_mob/passive/parrot/on_hear_say(mob/living/speaker, message)
	if(holder.stat || !holder.say_list || !message)
		return
	var/datum/say_list/S = holder.say_list
	S.speak += message

// Doesn't really act until told to by something on the outside.
/datum/ai_holder/simple_mob/inert
	hostile = FALSE
	retaliate = FALSE
	can_flee = FALSE
	wander = FALSE
	speak_chance = 0
	cooperative = FALSE

// Used for technomancer illusions, to resemble player movement better.
/datum/ai_holder/simple_mob/inert/astar
	use_astar = TRUE

// Can't attack but calls for help. Used by the monitor and spotter wards.
// Special attacks are not blocked since they might be used for things besides attacking, and can be conditional.
/datum/ai_holder/simple_mob/monitor
	hostile = TRUE // Required to call for help.
	cooperative = TRUE
	stand_ground = TRUE // So it doesn't run up to the thing it sees.
	wander = FALSE
	can_flee = FALSE

/datum/ai_holder/simple_mob/monitor/melee_attack(atom/A)
	return FALSE

/datum/ai_holder/simple_mob/monitor/ranged_attack(atom/A)
	return FALSE

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
	var/moonwalk = TRUE // If true, mob turns to face the target while kiting, otherwise they turn in the direction they moved towards.

/datum/ai_holder/simple_mob/ranged/kiting/threatening
	threaten = TRUE
	threaten_delay = 1 SECOND // Less of a threat and more of pre-attack notice.
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_mob/ranged/kiting/no_moonwalk
	moonwalk = FALSE

/datum/ai_holder/simple_mob/ranged/kiting/on_engagement(atom/A)
	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A, run_if_this_close))
		if(moonwalk)
			holder.face_atom(A)

// Closes distance from the target even while in range.
/datum/ai_holder/simple_mob/ranged/aggressive
	pointblank = TRUE
	var/closest_distance = 1 // How close to get to the target. By default they will get into melee range (and then pointblank them).

/datum/ai_holder/simple_mob/ranged/aggressive/on_engagement(atom/A)
	if(get_dist(holder, A) > closest_distance)
		holder.IMove(get_step_towards(holder, A))
		holder.face_atom(A)

// The electric spider's AI.
/datum/ai_holder/simple_mob/ranged/electric_spider

/datum/ai_holder/simple_mob/ranged/electric_spider/max_range(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.incapacitated(INCAPACITATION_DISABLED) || L.stat == UNCONSCIOUS) // If our target is stunned, go in for the kill.
			return 1
	return ..() // Do ranged if possible otherwise.

// Switches intents based on specific criteria.
// Used for special mobs who do different things based on intents (and aren't slimes).
// Intent switching is generally done in pre_[ranged/special]_attack(), so that the mob can use the right attack for the right time.
/datum/ai_holder/simple_mob/intentional


// The Advanced Dark Gygax's AI.
// The mob has three special attacks, based on the current intent.
// This AI choose the appropiate intent for the situation, and tries to ensure it doesn't kill itself by firing missiles at its feet.
/datum/ai_holder/simple_mob/intentional/adv_dark_gygax
	conserve_ammo = TRUE					// Might help avoid 'I shoot the wall forever' cheese.
	var/closest_desired_distance = 1		// Otherwise run up to them to be able to potentially shock or punch them.

	var/electric_defense_radius = 3			// How big to assume electric defense's area is.
	var/microsingulo_radius = 3				// Same but for microsingulo pull.
	var/rocket_explosive_radius = 2			// Explosion radius for the rockets.

	var/electric_defense_threshold = 2		// How many non-targeted people are needed in close proximity before electric defense is viable.
	var/microsingulo_threshold = 2			// Similar to above, but uses an area around the target.

// Used to control the mob's positioning based on which special attack it has done.
// Note that the intent will not change again until the next special attack is about to happen.
/datum/ai_holder/simple_mob/intentional/adv_dark_gygax/on_engagement(atom/A)
	// Make the AI backpeddle if using an AoE special attack.
	var/list/risky_intents = list(I_GRAB, I_HURT) // Mini-singulo and missiles.
	if(holder.a_intent in risky_intents)
		var/closest_distance = 1
		switch(holder.a_intent) // Plus one just in case.
			if(I_HURT)
				closest_distance = rocket_explosive_radius + 1
			if(I_GRAB)
				closest_distance = microsingulo_radius + 1

		if(get_dist(holder, A) <= closest_distance)
			holder.IMove(get_step_away(holder, A, closest_distance))

	// Otherwise get up close and personal.
	else if(get_dist(holder, A) > closest_desired_distance)
		holder.IMove(get_step_towards(holder, A))

// Changes the mob's intent, which controls which special attack is used.
// I_DISARM causes Electric Defense, I_GRAB causes Micro-Singularity, and I_HURT causes Missile Barrage.
/datum/ai_holder/simple_mob/intentional/adv_dark_gygax/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/target = A

		// If we're surrounded, Electric Defense will quickly fix that.
		var/tally = 0
		for(var/mob/living/L in hearers(electric_defense_radius, holder))
			if(holder == L)
				continue
			if(L.IIsAlly(holder))
				continue
			if(L.stat)
				continue
			tally++

		// Should we shock them?
		if(tally >= electric_defense_threshold || get_dist(target, holder) <= electric_defense_radius)
			holder.a_intent = I_DISARM
			return

		// Otherwise they're a fair distance away and we're not getting mobbed up close.
		// See if we should use missiles or microsingulo.
		tally = 0 // Let's recycle the var.
		for(var/mob/living/L in hearers(microsingulo_radius, target))
			if(holder == L)
				continue
			if(L.IIsAlly(holder))
				continue
			if(L.stat)
				continue
			tally++

		// Lots of people means minisingulo would be more useful.
		if(tally >= microsingulo_threshold)
			holder.a_intent = I_GRAB
		else // Otherwise use rockets.
			holder.a_intent = I_HURT

	else
		holder.a_intent = I_HURT // Fire rockets if it's an obj/turf.



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

// Simple mobs that aren't hostile, but will fight back.
/datum/ai_holder/simple_mob/retaliate
	hostile = FALSE
	retaliate = TRUE

// Simple mobs that retaliate and support others in their faction who get attacked.
/datum/ai_holder/simple_mob/retaliate/cooperative
	cooperative = TRUE