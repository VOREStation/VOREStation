/datum/ai_holder
	var/surrendered = FALSE				// If true, the AI won't attempt to resist out of things any longer (like nets)
	var/surrender_chance = 0				// Chance the AI will give up before a resist attempt and stop resisting
	var/surrender_non_hostile = FALSE		// When we give up and surrender, if we become non-hostile
	var/bound = FALSE 						// Stateful holder to store whether or not we should be busy with resisting rather than attacking

/datum/ai_holder/handle_resist(var/buckle_level)
	if(bound) //We're already resisting in another iteration of this
		return

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
	
	bound = FALSE //Done resisting, can try it again in another iteration
