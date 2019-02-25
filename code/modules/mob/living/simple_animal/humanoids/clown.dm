/mob/living/simple_mob/hostile/clown
	name = "clown"
	desc = "A denizen of clown planet"
	tt_desc = "E Homo sapiens corydon" //this is an actual clown, as opposed to someone dressed up as one
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	intelligence_level = SA_HUMANOID

	faction = "clown"
	maxHealth = 75
	health = 75
	speed = -1
	move_to_delay = 2

	run_at_them = 0
	cooperative = 1

	turns_per_move = 5
	stop_when_pulled = 0

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("attacked")
	attack_sound = 'sound/items/bikehorn.ogg'

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 10	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	unsuitable_atoms_damage = 10

	speak_chance = 1
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks")
