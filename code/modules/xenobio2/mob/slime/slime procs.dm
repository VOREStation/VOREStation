/*
Slime specific procs go here.
*/
#define SHINYOVERLAY 0
#define LIGHTOVERLAY 1	
#define MAXOVERLAY 2	//Should be 1 + last overlay, to give the chance for matte slimes

/mob/living/simple_animal/xeno/slime/RandomizeTraits()
	traitdat.traits[TRAIT_XENO_COLDRES] = rand(30,270)
	traitdat.traits[TRAIT_XENO_HEATRES] = rand(30,270)
	traitdat.traits[TRAIT_XENO_CHEMVOL] = round(rand(20,40))	//Wow, a slime core with the capacity to hold 2/3rd's a beaker's worth of chemicals.
	traitdat.traits[TRAIT_XENO_HEALTH] = round(rand(50, 75))
	traitdat.traits[TRAIT_XENO_HUNGER] = rand(1, 20)
	traitdat.traits[TRAIT_XENO_STARVEDAMAGE] = rand(1, 4)
	traitdat.traits[TRAIT_XENO_EATS] = prob(95)	//Odds are, that thing'll need to eat.
	traitdat.traits[TRAIT_XENO_CHROMATIC] = prob(5)	
	if(traitdat.traits[TRAIT_XENO_CHROMATIC])
		traitdat.traits[TRAIT_XENO_HOSTILE] = 0
	else
		traitdat.traits[TRAIT_XENO_HOSTILE] = prob(30)
	traitdat.traits[TRAIT_XENO_GLOW_STRENGTH] = round(rand(1,3))
	traitdat.traits[TRAIT_XENO_GLOW_RANGE] = round(rand(1,3))
	traitdat.traits[TRAIT_XENO_STRENGTH] = round(rand(4,9))
	traitdat.traits[TRAIT_XENO_STR_RANGE] =round(rand(0,2))
	traitdat.traits[TRAIT_XENO_CANLEARN] = prob(68)
	traitdat.traits[TRAIT_XENO_SPEED] = round(rand(-10,10))
	
	

/mob/living/simple_animal/xeno/slime/proc/GrowUp()
	GenerateAdult()
	
	maxHealth = traitdat.get_trait(TRAIT_XENO_HEALTH)
	health = maxHealth
	is_child = 0
		
	return 1
	
/mob/living/simple_animal/xeno/slime/Mutate()
	..()
	cores = round(rand(1,9))
	if(is_child)
		RandomizeTraits()
		GenerateChild()
	else
		GenerateAdult()
		
/mob/living/simple_animal/xeno/slime/proc/GenerateChild()
	overlays.Cut()
	name = "[nameVar] baby slime"
	real_name = "[nameVar] baby slime"
	desc = "A shifting blob of [nameVar] goo."
	icon_state = "slime baby"
	icon_living = "slime baby"
	icon_dead = "slime baby dead"
	color = traitdat.traits[TRAIT_XENO_COLOR]
	maxHealth = traitdat.traits[TRAIT_XENO_HEALTH]/2
	health = maxHealth
	
	return 1
	
/mob/living/simple_animal/xeno/slime/proc/GenerateAdult()
	overlays.Cut()
	name = "[nameVar] slime"
	real_name = "[nameVar] slime"
	desc = "A shifting mass of [nameVar] goo."
	color = ""
	icon_state = ""
	overlay = round(rand(0, MAXOVERLAY))
	GenerateAdultIcon()
	
/mob/living/simple_animal/xeno/slime/proc/GenerateAdultIcon()	//Hack and slash adventure game to make slimes have no color on light effects later
	overlays.Cut()
	var/image/Img = new(src.icon)
	Img.icon_state = "slime adult"
	Img.color = traitdat.traits[TRAIT_XENO_COLOR]
	Img.layer = src.layer
	overlays += Img
	
	switch(overlay)
		if(SHINYOVERLAY)
			var/image/I = new(src.icon)
			I.icon = src.icon
			I.icon_state = "slime shiny"
			I.layer = src.layer + 0.1
			I.color = "#FFFFFF"
			overlays += I
		if(LIGHTOVERLAY)
			var/image/I = new(src.icon)
			I.icon = src.icon
			I.icon_state = ""
			I.icon_state = "slime light"
			I.layer = src.layer + 0.1
			I.color = "#FFFFFF"
			overlays += I

/mob/living/simple_animal/xeno/slime/handle_reagents()
	if(!stasis)
		if(!reagents)
			return
		if(reagents.total_volume <= 0)
			return
		if(reagents.has_reagent("docilitytoxin"))	//Toxin that makes them docile? Good for quelling angry mobs.
			hostile = 0
			traitdat.traits[TRAIT_XENO_HOSTILE] = 0
		..()
		
/mob/living/simple_animal/xeno/slime/ProcessTraits()
	..()
	if(is_child)
		GenerateChild()
	else
		GenerateAdult()
		