/mob/living/simple_mob/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"

	mob_class = MOB_CLASS_ABERRATION

	faction = FACTION_CREATURE

	maxHealth = 40
	health = 40

	harm_intent_damage = 8

	melee_damage_lower = 8
	melee_damage_upper = 15
	attack_armor_pen = 5	//It's a horror from beyond, I ain't gotta explain 5 AP
	attack_sharp = TRUE
	attack_edge = 1

	attacktext = list("chomped")
	attack_sound = 'sound/weapons/bite.ogg'

	organ_names = /decl/mob_organ_names/abberation

	speak_emote = list("gibbers")

	ai_holder_type = /datum/ai_holder/simple_mob/melee

// Strong Variant
/mob/living/simple_mob/creature/strong
	maxHealth = 160
	health = 160

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 25

// Cult Variant
/mob/living/simple_mob/creature/cult
	mob_class = MOB_CLASS_DEMONIC

	faction = FACTION_CULT

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	supernatural = TRUE

/mob/living/simple_mob/creature/cult/cultify()
	return

// Strong Cult Variant
/mob/living/simple_mob/creature/cult/strong
	maxHealth = 160
	health = 160

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 25

/decl/mob_organ_names/abberation
	hit_zones = list("fleshy mass", "maw", "eye(?)", "orifice(?)")
