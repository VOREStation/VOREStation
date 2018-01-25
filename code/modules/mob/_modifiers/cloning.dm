/*
 *	Modifier applied to newly cloned people.
 */

// Gives rather nasty downsides for awhile, making them less robust.
/datum/modifier/cloning_sickness
	name = "cloning sickness"
	desc = "You feel rather weak, having been cloned not so long ago."

	on_created_text = "<span class='warning'><font size='3'>You feel really weak.</font></span>"
	on_expired_text = "<span class='notice'><font size='3'>You feel your strength returning to you.</font></span>"

	max_health_percent = 0.6				// -40% max health.
	incoming_damage_percent = 1.1			// 10% more incoming damage.
	outgoing_melee_damage_percent = 0.7		// 30% less melee damage.
	disable_duration_percent = 1.25			// Stuns last 25% longer.
	slowdown = 1							// Slower.
	evasion = -1							// 15% easier to hit.

// Tracks number of deaths, one modifier added per cloning
/datum/modifier/cloned
	name = "cloned"
	desc = "You died and were cloned, and you can never forget that."

	flags = MODIFIER_GENETIC			// So it gets copied if they die and get cloned again.
	stacks = MODIFIER_STACK_ALLOWED		// Two deaths means two instances of this.

// Prevents cloning, actual effect is on the cloning machine
/datum/modifier/no_clone
	name = "Cloning Incompatability"
	desc = "For whatever reason, you cannot be cloned."

	//WIP, but these may never be seen anyway, so *shrug
	on_created_text = "<span class='warning'>Life suddenly feels more precious.</span>"
	on_expired_text = "<span class='notice'>Death is cheap again.</span>"

	flags = MODIFIER_GENETIC


// Prevents borging (specifically the MMI part), actual effect is on the MMI.
/datum/modifier/no_borg
	name = "Cybernetic Incompatability"
	desc = "For whatever reason, your brain is incompatable with direct cybernetic interfaces, such as the MMI."

	flags = MODIFIER_GENETIC

//////////////////////////////////////
//Species-Specific Cloning Modifiers//
/////////////////////////////////////

/datum/modifier/cloning_sickness/promethean
	name = "reformation sickness"
	desc = "Your core feels damaged, as you were reformed with the improper machinery."

	on_created_text = "<span class='warning'><font size='3'>Your core aches.</font></span>"
	on_expired_text = "<span class='notice'><font size='3'>You feel your core's strength returning to normal.</font></span>"

	incoming_damage_percent = 1 //Level the incoming damage from the parent modifier. They already take 200% burn.
	incoming_brute_damage_percent = 1.5 //150% incoming brute damage. Decreases the effectiveness of their 0.75 modifier.
	incoming_hal_damage_percent = 1.25 //125% incoming halloss.

	outgoing_melee_damage_percent = 0.5 //50% less outgoing melee damage.
	attack_speed_percent = 1.2 //20% slower attack speed.
