/mob/living/simple_animal/retaliate/bee
	name = "space bumble bee"
	desc = "Buzz buzz."
	icon = 'icons/mob/vore.dmi'
	icon_state = "bee"
	icon_living = "bee"
	icon_dead = "bee-dead"

	speak = list("Buzzzz")
	speak_chance = 1

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	turns_per_move = 5
	speed = 5
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15 // To do: Make it toxin damage.
	melee_damage_upper = 15
	attacktext = "stung"

	//Space bees aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "bee"

/mob/living/simple_animal/retaliate/bee/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space bee!

// Activate Noms!
/mob/living/simple_animal/retaliate/bee
	vore_active = 1
	vore_icons = SA_ICON_LIVING
