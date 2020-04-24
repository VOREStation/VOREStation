/datum/ai_holder
	var/surrendered = FALSE				// If true, the AI won't attempt to resist out of things any longer (like nets)
	var/surrender_chance = 0				// Chance the AI will give up before a resist attempt and stop resisting
	var/surrender_non_hostile = FALSE		// When we give up and surrender, if we become non-hostile
	var/bound = FALSE 						// Stateful holder to store whether or not we should be busy with resisting rather than attacking

/datum/ai_holder/handle_resist(var/buckle_level)
	if(bound) //We're already resisting in another iteration of this
		return

	//Smart one netted and is outnumbered
	if(surrender_chance && intelligence_level == AI_SMART)
		var/their_numbers = 0
		var/our_numbers = 1 //Us!
		
		//Count enemies
		var/list/potentials = list_targets()
		for(var/possible_target in potentials)
			if(found(possible_target))
				their_numbers++
			else if(can_attack(possible_target))
				their_numbers++
		
		//Count friends
		if(cooperative)
			for(var/mob/living/F in faction_friends)
				if(F == holder)
					continue
				if(F.z != holder.z)
					continue
				if(get_dist(F, holder) <= (world.view+3)) //+5 just cus people barely offscreen should count too
					our_numbers++

		surrender_chance = clamp(surrender_chance + ((their_numbers-our_numbers)*10), 10, 100) //10% per person outnumbered by, or -10% chance if they outnumber

	bound = TRUE
	//Done such that we will only once surrender and become non-hostile in the general sense, but
	//  will continue resisting out of things if we get into combat via other means like retaliation
	//  as mobs only resist out of things when in combat
	if(buckle_level >= FULLY_BUCKLED && prob(surrender_chance) && !surrendered)
		surrendered = TRUE
		returns_home = FALSE //Stop pathing home
		if(surrender_non_hostile && hostile)
			hostile = FALSE //Become unhostile
			retaliate = TRUE //But don't become totally passive
			forget_everything() //Just resets them and forgets their target and stuff
			holder.visible_message("<span class='notice'>[src] slumps and gives up, surrendering.</span>")
			bound = FALSE //Their stance will be reset by forget_everything, so they should not try to resist anymore unless they get back into combat
			return //Don't resist this time
	
	. = ..() //Call up to perform resistance if we haven't returned by now
	
	//Animal/dumb netted and doesn't understand why
	if(surrender_chance && intelligence_level == AI_NORMAL)
		if(target && !can_attack(target))
			surrender_chance += 10
			lose_target()

	bound = FALSE //Done resisting, can try it again in another iteration
