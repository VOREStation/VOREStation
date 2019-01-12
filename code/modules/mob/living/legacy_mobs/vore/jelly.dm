/mob/living/simple_animal/hostile/jelly
	name = "jelly blob"
	desc = "Some sort of undulating blob of slime!"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "jelly_dead"
	icon_living = "jelly"
	icon_state = "jelly"

	faction = "virgo2"
	maxHealth = 50
	health = 50

	melee_damage_lower = 5
	melee_damage_upper = 15

	speak_chance = 2
	emote_hear = list("squishes","spluts","splorts","sqrshes","makes slime noises")
	emote_see = list("undulates quietly")

// Activate Noms!
/mob/living/simple_animal/hostile/jelly
	vore_active = 1
	vore_pounce_chance = 0
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.
