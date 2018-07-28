/mob/living/simple_mob/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate"
	icon_state = "faithless"
	icon_living = "faithless"
	icon_dead = "faithless_dead"

	faction = "faithless"

	mob_class = MOB_CLASS_DEMONIC

	maxHealth = 50
	health = 50

	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 10

	melee_damage_lower = 10
	melee_damage_upper = 18
	attack_armor_pen = 5	//It's a horror from beyond, I ain't gotta explain 5 AP

	attacktext = list("gripped")
	attack_sound = 'sound/hallucinations/growl1.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/melee


	taser_kill = FALSE

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/faithless/Process_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_mob/faithless/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(12))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

// Strong Variant
/mob/living/simple_mob/faithless/strong
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 28

// Cult Variant
/mob/living/simple_mob/faithless/cult
	faction = "cult"
	supernatural = TRUE

/mob/living/simple_mob/faithless/cult/cultify()
	return

// Strong Cult Variant
/mob/living/simple_mob/faithless/cult/strong
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 28