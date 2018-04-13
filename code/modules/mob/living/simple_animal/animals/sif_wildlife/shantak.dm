/mob/living/simple_animal/hostile/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	icon = 'icons/jungle.dmi'

	faction = "shantak"

	maxHealth = 75
	health = 75
	speed = 1
	move_to_delay = 1

	melee_damage_lower = 12
	melee_damage_upper = 28
	attack_armor_pen = 5
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("gouged")
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out its mane","clinks gently as it moves")