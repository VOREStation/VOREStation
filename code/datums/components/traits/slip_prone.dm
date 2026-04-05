/**
 * Like unlucky, but only has a chance of slipping into someone!
 */
/datum/component/slip_prone
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

/datum/component/slip_prone/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(attempt_slip))

/datum/component/slip_prone/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/slip_prone/proc/attempt_slip(atom/movable/our_guy)
	SIGNAL_HANDLER

	if(!isliving(our_guy) || isbelly(our_guy.loc))
		return

	var/mob/living/living_guy = our_guy
	if(living_guy.is_incorporeal()) //no being unlucky if you don't even exist on the same plane.
		return

	if(!prob(0.6))
		return

	var/turf/our_guy_pos = get_turf(our_guy)
	if(!our_guy_pos)
		return

	for(var/turf/the_turf as anything in our_guy_pos.AdjacentTurfs(check_blockage = FALSE)) //need false so we can check disposal units
		if(iswall(the_turf))
			continue

		for(var/mob/living/living_mob in the_turf)
			if(living_mob == our_guy || (living_mob.vore_selected == living_guy.vore_selected))
				continue //Don't do anything to ourselves.
			if(living_mob.stat)
				continue
			if(!can_stumble_vore(living_guy, living_mob) && !can_stumble_vore(living_mob, living_guy)) //Works both ways! Either way, someone's getting eaten!
				continue
			living_mob.stumble_into(living_guy) //logic reversed here because the game is DUMB. This means that living_guy is stumbling into the target!
			living_guy.visible_message(span_danger("[living_guy] loses their balance and slips into [living_mob]!"), span_boldwarning("You lose your balance, slipping into [living_mob]!"))
			return
