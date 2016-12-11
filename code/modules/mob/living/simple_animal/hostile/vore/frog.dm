/mob/living/simple_animal/hostile/vore/frog
	name = "giant frog"
	desc = "You've heard of having a frog in your throat, now get ready for the reverse."
	icon_dead = "frog-dead"
	icon_living = "frog"
	icon_state = "frog"
	speed = 5
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 25
	pounce_chance = 90

// Pepe is love, not hate.
/mob/living/simple_animal/hostile/vore/frog/New()
	if(rand(1,1000000) == 1)
		name = "rare Pepe"
		desc = "You found a rare Pepe. Screenshot for good luck."
	..()