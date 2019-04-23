/mob/living/simple_mob/animal/space/jelly
	name = "jelly blob"
	desc = "Some sort of undulating blob of slime!"

	icon_dead = "jelly_dead"
	icon_living = "jelly"
	icon_state = "jelly"
	icon = 'icons/mob/vore.dmi'

	faction = "virgo2"
	maxHealth = 50
	health = 50

	melee_damage_lower = 2
	melee_damage_upper = 7

	say_list_type = /datum/say_list/jelly
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/jelly

// Activate Noms!
/mob/living/simple_mob/animal/space/jelly
	vore_active = 1
	vore_pounce_chance = 0
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.

/datum/say_list/jelly
	emote_hear = list("squishes","spluts","splorts","sqrshes","makes slime noises")
	emote_see = list("undulates quietly")

/datum/ai_holder/simple_mob/retaliate/jelly
	speak_chance = 2
