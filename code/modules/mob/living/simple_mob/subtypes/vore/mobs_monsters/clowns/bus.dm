/mob/living/simple_mob/clowns/big/c_shift
	tt_desc = "E Homo sapiens corydon horrificus" //this is a redspace clown
	faction = FACTION_CLOWN

/mob/living/simple_mob/clowns/big/c_shift/Initialize(mapload)
	. = ..()
	comp = LoadComponent(comp)
