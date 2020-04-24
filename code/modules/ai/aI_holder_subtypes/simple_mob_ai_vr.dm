#define VIRGO_AI_NORETURN_CREATE(x)	x/returnhome/returns_home=1;x/returnhome/max_home_distance=8

VIRGO_AI_NORETURN_CREATE(/datum/ai_holder/simple_mob/melee/evasive)
VIRGO_AI_NORETURN_CREATE(/datum/ai_holder/simple_mob/ranged/kiting/threatening)


/datum/ai_holder/simple_mob/humanoid
	surrender_chance = 30 //Humans give up easier and would prefer not dying

/datum/ai_holder/simple_mob/animal
	surrender_chance = 10 //Animals do too, but aren't quite as good at knowing when to stop without repeated whaps