/*
 * Modifiers caused by chemicals or organs specifically.
 */

/datum/modifier/cryogelled
	name = "cryogelled"
	desc = "Your body begins to freeze."
	mob_overlay_state = "chilled"

	on_created_text = "<span class='danger'>You feel like you're going to freeze! It's hard to move.</span>"
	on_expired_text = "<span class='warning'>You feel somewhat warmer and more mobile now.</span>"
	stacks = MODIFIER_STACK_ALLOWED

	slowdown = 0.1
	evasion = -5
	attack_speed_percent = 1.1
	disable_duration_percent = 1.05
