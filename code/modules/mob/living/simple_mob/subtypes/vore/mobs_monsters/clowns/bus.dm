/mob/living/simple_mob/mobs_monsters/clowns/big/c_shift
	tt_desc = "E Homo sapiens corydon horrificus" //this is a redspace clown
	faction = "clown"

/mob/living/simple_mob/mobs_monsters/clowns/big/c_shift/Initialize()
	. = ..()
	verbs += /mob/living/simple_mob/mobs_monsters/clowns/big/c_shift/proc/phase_shift
