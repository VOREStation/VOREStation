/mob/living/simple_mob/clowns/big
	tt_desc = "E Homo sapiens corydon horrificus" //this clown is stronk
	faction = "clown"

	maxHealth = 200
	health = 200
	see_in_dark = 8

	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_armor_pen = 5
	attack_sharp = FALSE
	attack_edge = FALSE
	melee_attack_delay = 1 SECOND
	attacktext = list("clowned")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/angryclowns

	loot_list = list(/obj/item/weapon/bikehorn = 100)

	min_oxy = 0
	max_oxy = 500
	min_tox = 0
	max_tox = 500
	min_co2 = 0
	max_co2 = 500
	min_n2 = 0
	max_n2 = 500
	minbodytemp = 0
	maxbodytemp = 700

/datum/ai_holder/simple_mob/melee/angryclowns
	can_breakthrough = TRUE
	violent_breakthrough = FALSE
	hostile = TRUE // The majority of simplemobs are hostile, gaslamps are nice.
	cooperative = FALSE
	retaliate = TRUE //so the monster can attack back
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 3
	wander = TRUE
	base_wander_delay = 9
