/mob/living/simple_mob/clowns/big/c_shift
	tt_desc = "E Homo sapiens corydon horrificus" //this is a redspace clown
	faction = "clown"

/mob/living/simple_mob/clowns/big/c_shift/New()
	..()
	verbs += /mob/living/simple_mob/clowns/big/c_shift/proc/phase_shift
