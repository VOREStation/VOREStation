/mob/living/simple_mob/slime/xenobio
	temperature_range = 5
	mob_bump_flag = SLIME

/mob/living/simple_mob/slime/xenobio/Initialize(mapload, var/mob/living/simple_mob/slime/xenobio/my_predecessor)
	. = ..()
	Weaken(10)