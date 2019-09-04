/datum/ai_holder/simple_mob/xenobio_slime/post_melee_attack(atom/A)
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	my_slime.a_intent = I_HELP		// Return back to help after attacking