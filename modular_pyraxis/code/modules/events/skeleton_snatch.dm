/datum/event/skeleton_snatch
	var/mob/living/carbon/human/calcium

/datum/event/skeleton_snatch/start()
	var/list/candidates

	for(var/mob/living/carbon/human/boneless in GLOB.human_mob_list)
		if(boneless.mind && boneless.stat != DEAD && boneless.is_client_active(5) && !SSantag_job.player_is_antag(boneless.mind))
			candidates += boneless

	calcium = pick(candidates)

	if(!calcium)
		return

	calcium.steal_skeleton()
