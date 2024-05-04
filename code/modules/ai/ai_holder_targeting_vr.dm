/datum/ai_holder/can_see_target(atom/movable/the_target, view_range = vision_range)
	if(the_target && isbelly(the_target.loc))
		return FALSE

	return ..()

/datum/ai_holder/simple_mob/vore
	hostile = FALSE
	retaliate = TRUE
	vore_hostile = TRUE
	forgive_resting = TRUE
	cooperative = FALSE

/datum/ai_holder/simple_mob/vore/edible
	belly_attack = FALSE

/datum/ai_holder/simple_mob/vore/micro_hunter
	micro_hunt = TRUE
	micro_hunt_size = 0.8

/datum/ai_holder/simple_mob/vore/hostile
	hostile = TRUE

/datum/ai_holder/simple_mob/vore/find_target(list/possible_targets, has_targets_list)
	if(!vore_hostile)
		return ..()
	if(!isanimal(holder))	//Only simplemobs have the vars we need
		return ..()
	var/mob/living/simple_mob/H = holder
	if(H.vore_fullness >= H.vore_capacity)	//Don't beat people up if we're full
		return ..()
	ai_log("find_target() : Entered.", AI_LOG_TRACE)

	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	var/list/valid_mobs = list()
	for(var/mob/living/possible_target in possible_targets)
		if(!can_attack(possible_target))
			continue
		. |= possible_target
		if(!isliving(possible_target))
			continue
		if(vore_check(possible_target))
			valid_mobs |= possible_target

	var/new_target
	if(valid_mobs.len)
		new_target = pick(valid_mobs)
	else if(hostile)
		new_target = pick(.)
	if(!new_target)
		return null
	give_target(new_target)
	return new_target
