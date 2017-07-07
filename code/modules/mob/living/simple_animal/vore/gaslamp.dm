/mob/living/simple_animal/gaslamp
	name = "gaslamp"
	desc = "Some sort of floaty alien with a warm glow."
	icon = 'icons/mob/vore32x64.dmi'
	icon_state = "gaslamp"
	icon_living = "gaslamp"
	icon_dead = "gaslamp-dead"

	faction = "gaslamp"
	maxHealth = 100
	health = 100
	move_to_delay = 4

	speak_chance = 1
	emote_see = list("looms", "sways gently")

	speed = 2

	retaliate = 1

	melee_damage_lower = 10
	melee_damage_upper = 30
	attacktext = "whips"
	friendly = "caresses"

	old_x = 0
	old_y = 0
	pixel_x = 0
	pixel_y = 0
	layer = 9

	response_help   = "tries to help"	// If clicked on help intent
	response_disarm = "pushes" // If clicked on disarm intent
	response_harm   = "swats"	// If clicked on harm intent

	//Mob environment settings
	minbodytemp = 0			// Minimum "okay" temperature in kelvin
	maxbodytemp = 350			// Maximum of above
	heat_damage_per_tick = 3	// Amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 2	// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	fire_alert = 0				// 0 = fine, 1 = hot, 2 = cold

	min_oxy = 0					// Oxygen in moles, minimum, 0 is 'no minimum
	max_oxy = 1					// Oxygen in moles, maximum, 0 is 'no maximum'
	min_tox = 0					// Phoron min
	max_tox = 0					// Phoron max
	min_co2 = 0					// CO2 min
	max_co2 = 0					// CO2 max
	min_n2 = 0					// N2 min
	max_n2 = 0					// N2 max
	unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

// Activate Noms!
/mob/living/simple_animal/gaslamp
	vore_active = 1
	vore_capacity = 2
	vore_default_mode = DM_ABSORB
	vore_escape_chance = 10
	vore_pounce_chance = 50
	vore_icons = SA_ICON_LIVING
