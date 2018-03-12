/mob/living/simple_animal/hostile/goose
	name = "space goose"
	desc = "That's no duck. That's a space goose. You have a bad feeling about this."
	tt_desc = "Anser aetherius" //Goose space?!
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"

	faction = "geese"
	intelligence_level = SA_ANIMAL

	maxHealth = 15
	health = 15
	speed = 4

	turns_per_move = 5

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 5
	melee_damage_lower = 5 //they're meant to be annoying, not threatening.
	melee_damage_upper = 5 //unless there's like a dozen of them, then you're screwed.
	cooperative = 1 // mwahahahahahaaa // Vorestation Edit, temporary
	attacktext = list("pecked")
	attack_sound = 'sound/weapons/bite.ogg'

	//SPACE geese aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	has_langs = list("Bird")
	speak_chance = 10
	speak = list("HONK!")
	emote_hear = list("honks loudly!")
	emote_see = list()
	say_understood = list()
	say_cannot = list()
	say_maybe_target = list("Honk?")
	say_got_target = list("HONK!!!")
	reactions = list()


	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

/mob/living/simple_animal/hostile/goose/set_target()
	. = ..()
	if(.)
		custom_emote(1,"flaps and honks at [.]!")

/mob/living/simple_animal/hostile/goose/Process_Spacemove(var/check_drift = 0)
	return 1 // VOREStation Edit No drifting in space!
