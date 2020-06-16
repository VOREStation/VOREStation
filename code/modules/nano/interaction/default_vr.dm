/mob/living/simple_mob/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		. = min(., shared_living_nano_distance(src_object))

//Allows simple mobs to interact with nanoui as long as they have "has_hands = TRUE"