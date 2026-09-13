/*
 * Makes it so certain types of mutations can not occur when a slime splits.
*/
/mob/living/simple_mob/slime/xenobio/proc/remove_slime_types(types_to_exclude)
	switch(types_to_exclude)
		if("colorless")
			exclusion_types |= list(
			/mob/living/simple_mob/slime/xenobio,
			/mob/living/simple_mob/slime/xenobio/metal,
			/mob/living/simple_mob/slime/xenobio/silver,
			/mob/living/simple_mob/slime/xenobio/oil,
			/mob/living/simple_mob/slime/xenobio/light_pink,
			/mob/living/simple_mob/slime/xenobio/bluespace)
		if("hot")
			exclusion_types |= list(
			/mob/living/simple_mob/slime/xenobio/amber,
			/mob/living/simple_mob/slime/xenobio/gold,
			/mob/living/simple_mob/slime/xenobio/yellow,
			/mob/living/simple_mob/slime/xenobio/orange,
			/mob/living/simple_mob/slime/xenobio/red,
			/mob/living/simple_mob/slime/xenobio/pink,
			/mob/living/simple_mob/slime/xenobio/ruby)
		if("cold")
			exclusion_types |= list(
			/mob/living/simple_mob/slime/xenobio/emerald,
			/mob/living/simple_mob/slime/xenobio/green,
			/mob/living/simple_mob/slime/xenobio/blue,
			/mob/living/simple_mob/slime/xenobio/cerulean,
			/mob/living/simple_mob/slime/xenobio/dark_blue,
			/mob/living/simple_mob/slime/xenobio/purple,
			/mob/living/simple_mob/slime/xenobio/dark_purple)
