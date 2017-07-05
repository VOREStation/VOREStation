/mob/living/simple_animal/hostile/frog
	name = "giant frog"
	desc = "You've heard of having a frog in your throat, now get ready for the reverse."
	icon = 'icons/mob/vore.dmi'
	icon_dead = "frog-dead"
	icon_living = "frog"
	icon_state = "frog"

	speed = 5

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 25

// Pepe is love, not hate.
/mob/living/simple_animal/hostile/frog/New()
	if(rand(1,1000000) == 1)
		name = "rare Pepe"
		desc = "You found a rare Pepe. Screenshot for good luck."
	..()

// Activate Noms!
/mob/living/simple_animal/hostile/frog
	vore_active = 1
	vore_pounce_chance = 50
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/frog/space
	name = "space frog"

	//Space frog can hold its breath or whatever
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0