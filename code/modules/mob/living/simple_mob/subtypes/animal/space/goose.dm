/mob/living/simple_mob/animal/space/goose
	name = "goose"
	desc = "It looks pretty angry!"
	tt_desc = "E Branta canadensis" //that iconstate is just a regular goose
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"

	faction = FACTION_GEESE

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

	has_langs = list(LANGUAGE_ANIMAL)

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	meat_amount = 3

	can_be_drop_prey = FALSE

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
	set category = "Abilities.Goose"

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

/mob/living/simple_mob/animal/space/goose/domesticated
	name = "domesticated goose"
	desc = "It's a domesticated goose. It still looks pretty angry."
	faction = "neutral" //Mess with this and the goose will eat anyones face, will eat other factions faces, appropiate considering its a hellbird - Jack

	can_be_drop_prey = TRUE

/mob/living/simple_mob/animal/space/goose/domesticated/casino
	name = "Donella"
	desc = "It's a golden goose named Donella, she is a beloved treasure of the golden goose casino, nobody knows where she comes from."
	icon_state = "golden_goose"
	icon_living = "golden_goose"
	icon_dead = "golden_goose_dead"
	icon = 'icons/mob/animal.dmi'

	faction = "neutral" //Mess with this and the goose will eat anyones face, will eat other factions faces, appropiate considering its a hellbird - Jack

	maxHealth = 75
	health = 75

	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 10
