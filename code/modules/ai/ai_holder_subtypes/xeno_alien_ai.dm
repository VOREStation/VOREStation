/*
/// For Skathari
/// In its own file to easily expand upon. Mob found in alien.dm 
*/

/datum/ai_holder/simple_mob/xeno_alien /// Basic
	hostile = TRUE
	retaliate = TRUE
	conserve_ammo = TRUE
	cooperative = TRUE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 0
	wander = TRUE
	base_wander_delay = 4

	var/can_telegrab = FALSE 

	var/grab_defense = 2 /// Similar to gygax, how many non-targets before teleporting them away. 
	var/grab_defense_radius = 4

	var/tele_range_min = 3
	var/tele_range_max = 7

/datum/ai_holder/simple_mob/xeno_alien/on_engagement(atom/A)
	if(holder.Adjacent(A)) /// Be hard to hit. 
		holder.IMove(get_step(holder, pick(alldirs)))
		holder.face_atom(A)

/datum/ai_holder/simple_mob/xeno_alien/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/target = A
		if(can_telegrab)
			// Largely copied from electrical defense for Dark Gygax
			var/tally = 0
			var/list/potential_targets = list_targets()
			for(var/atom/movable/AM in potential_targets)
				if(get_dist(holder, AM) > grab_defense_radius)
					continue
				if(!can_attack(AM))
					continue
				tally++
			// Displace them?
			if(tally >= grab_defense)
				holder.a_intent = I_GRAB
				return
			tally = 0

		var/tar_dist = get_dist(holder, target)
		if(tar_dist >= tele_range_min && tar_dist <= tele_range_max)
			holder.a_intent = I_DISARM
			return

/datum/ai_holder/simple_mob/xeno_alien/ranged /// Drones
	pointblank = TRUE
	ignore_incapacitated = TRUE /// We're squishier and our tox hits hard. Focus on who's up. 
	var/run_if_this_close = 4
	var/max_distance = 6
	tele_range_min = 1 /// Flee!

/datum/ai_holder/simple_mob/xeno_alien/ranged/post_ranged_attack(atom/A)
	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A, run_if_this_close))
		holder.face_atom(A)
	else if(get_dist(holder, A) > max_distance)
		holder.IMove(get_step_towards(holder, A))
		holder.face_atom(A)
	else if(prob(25)) /// Let's not yakkity sax too hard
		step_rand(holder)
		holder.face_atom(A)

/datum/ai_holder/simple_mob/xeno_alien/empress /// Big mama
	ignore_incapacitated = TRUE /// Focus on better threats. 
	can_telegrab = TRUE
	tele_range_min = 1
	tele_range_max = 5 /// Give a chance to run if you've just spotted her. 