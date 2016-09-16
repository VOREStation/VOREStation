

/mob/living/simple_animal/hostile/goose
	name = "space goose"
	desc = "That's no duck. That's a space goose. You have a bad feeling about this."
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	icon_gib = "generic_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 15 //nothing an unarmed crewmember shouldn't be able to stomp into the dirt, if they're alone.
	health = 15

	harm_intent_damage = 5
	melee_damage_lower = 5 //they're meant to be annoying, not threatening.
	melee_damage_upper = 5 //unless there's like a dozen of them, then you're screwed.
	attacktext = "pecked"
	attack_sound = 'sound/weapons/bite.ogg'

	break_stuff_probability = 5

	faction = "geese"


/mob/living/simple_animal/hostile/goose/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"flaps and honks at [.]!")