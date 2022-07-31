/mob/living/simple_mob/animal/space/goose
	name = "goose"
	desc = "It looks pretty angry!"
	tt_desc = "E Branta canadensis" //that iconstate is just a regular goose
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"

	faction = "geese"

	maxHealth = 30
	health = 30

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 5
	melee_damage_lower = 5 //they're meant to be annoying, not threatening.
	melee_damage_upper = 5 //unless there's like a dozen of them, then you're screwed.
	attacktext = list("pecked")
	attack_sound = 'sound/weapons/bite.ogg'

	organ_names = /decl/mob_organ_names/goose

	has_langs = list("Bird")

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	meat_amount = 3

/datum/say_list/goose
	speak = list("HONK!")
	emote_hear = list("honks loudly!")
	say_maybe_target = list("Honk?")
	say_got_target = list("HONK!!!")

/mob/living/simple_mob/animal/space/goose/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

/mob/living/simple_mob/animal/space/goose/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)

/decl/mob_organ_names/goose
	hit_zones = list("head", "chest", "left leg", "right leg", "left wing", "right wing", "neck")

/mob/living/simple_mob/animal/space/goose/white
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "whitegoose"
	icon_living = "whitegoose"
	icon_dead = "whitegoose_dead"
	name = "white goose"
	desc = "And just when you thought it was a lovely day..."
