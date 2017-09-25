/mob/living/simple_animal/hostile/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate"
	icon_state = "faithless"
	icon_living = "faithless"
	icon_dead = "faithless_dead"

	faction = "faithless"
	intelligence_level = SA_HUMANOID
	maxHealth = 50
	health = 50
	speed = 8

	turns_per_move = 5
	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 10
	melee_damage_lower = 5
	melee_damage_upper = 5

	attacktext = "gripped"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	speak_chance = 0

/mob/living/simple_animal/hostile/faithless/Process_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/faithless/set_target()
	. = ..()
	if(.)
		audible_emote("wails at [target_mob]")

/mob/living/simple_animal/hostile/faithless/PunchTarget()
	. = ..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(12))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/faithless/cult
	faction = "cult"
	supernatural = 1

/mob/living/simple_animal/hostile/faithless/cult/cultify()
	return

/mob/living/simple_animal/hostile/faithless/cult/Life()
	..()
	check_horde()

/mob/living/simple_animal/hostile/faithless/strong
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 7
	melee_damage_upper = 20


/mob/living/simple_animal/hostile/faithless/strong/cult
	faction = "cult"
	supernatural = 1

/mob/living/simple_animal/hostile/faithless/cult/cultify()
	return

/mob/living/simple_animal/hostile/faithless/cult/Life()
	..()
	check_horde()