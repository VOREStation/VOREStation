/datum/modifier
	var/effect_color					// Allows for coloring of modifiers.
	var/coloration_applied = 0			// Tells the game is coloration has been applied already or not.
	var/icon_override = 0				// Tells the game if it should use modifer_effects_vr.dmi or not.
	// ENERGY CODE. Variables to allow for energy based modifiers.
	var/energy_based					// Sees if the modifier is based on something electronic based.
	var/energy_cost						// How much the modifier uses per action/special effect blocked. For base values.
	var/energy_modifier					// How much energy is used when numbers are involed. For values, such as taking damage. Ex: (Damage*energy_modifier)
	var/obj/item/weapon/cell/energy_source = null	// The source of the above.

	// RESISTANCES CODE. Variable to enable external damage resistance modifiers. This is not unlike armor.
	// 0 = immune || < 0 = heals || 1 = full damage || >1 = increased damage.
	// It should never be below zero as it is not intended to do such, but you are free to experiment!
	// Ex: Max_brute_resistance = 0. Min_brute resistance = 1. When started, provides 100% resistance to brute. When cell is dying, goes down to 0% resistance.
	// Max is the MAXIMUM % multiplier that will be taken at a MAX charge. Min is the MINIMUM % multiplier that will be taken at a MINIMUM charge.
	// Think of it like this: Minimum = what happens at minimum charge. Max = what happens at maximum charge.
	// Why do I mention this so much? Because even /I/ got confused, and I wrote this thing!
	var/min_damage_resistance
	var/max_damage_resistance
	var/effective_damage_resistance

	var/min_brute_resistance
	var/max_brute_resistance
	var/effective_brute_resistance

	var/min_fire_resistance
	var/max_fire_resistance
	var/effective_fire_resistance

	var/min_tox_resistance
	var/max_tox_resistance
	var/effective_tox_resistance

	var/min_oxy_resistance
	var/max_oxy_resistance
	var/effective_oxy_resistance

	var/min_clone_resistance
	var/max_clone_resistance
	var/effective_clone_resistance

	var/min_hal_resistance
	var/max_hal_resistance
	var/effective_hal_resistance
	// Resistances end



/datum/modifier/underwater_stealth
	name = "underwater stealth"
	desc = "You are currently underwater, rendering it more difficult to see you and enabling you to move quicker, thanks to your aquatic nature."

	on_created_text = "<span class='warning'>You sink under the water.</span>"
	on_expired_text = "<span class='notice'>You come out from the water.</span>"

	stacks = MODIFIER_STACK_FORBID

	slowdown = -1.5							//A bit faster when actually submerged fully in water, as you're not waddling through it.
	siemens_coefficient = 1.5 				//You are, however, underwater. Getting shocked will hurt.

	outgoing_melee_damage_percent = 0.75 	//You are swinging a sword under water...Good luck.
	accuracy = -50							//You're underwater. Good luck shooting a gun. (Makes shots as if you were 3.33 tiles further.)
	evasion = 30							//You're underwater and a bit harder to hit.

/datum/modifier/underwater_stealth/on_applied()
	holder.alpha = 50
	return

/datum/modifier/underwater_stealth/on_expire()
	holder.alpha = 255
	return

/datum/modifier/underwater_stealth/tick()
	if(holder.stat == DEAD)
		expire(silent = TRUE) //If you're dead you float to the top.
	if(istype(holder.loc, /turf/simulated/floor/water))
		var/turf/simulated/floor/water/water_floor = holder.loc
		if(water_floor.depth < 1) //You're not in deep enough water anymore.
			expire(silent = FALSE)
	else
		expire(silent = FALSE)









/datum/modifier/shield_projection
	name = "Shield Projection"
	desc = "You are currently protected by a shield, rendering nigh impossible to hit you through conventional means."

	on_created_text = "<span class='notice'>Your shield generator buzzes on.</span>"
	on_expired_text = "<span class='warning'>Your shield generator buzzes off.</span>"
	stacks = MODIFIER_STACK_FORBID //No stacking shields. If you put one one your belt and backpack it won't work.

	icon_override = 1
	mob_overlay_state = "deflect"
	siemens_coefficient = 2 //Stun weapons drain 100% charge per point of damage. They're good at blocking lasers and bullets but not good at blocking stun beams!
	energy_based = 1
	energy_cost = 99999 //This is changed to the shield_generator's energy_cost.
	energy_modifier = 50 //This is how much battery is used per damage unit absorbed. Higher damage means higher charge use per damage absorbed. Changed below!

	//Not actually in use until effective resistances are set. Just here so it doesn't have to be placed down for all the variants. Less lines.
	max_damage_resistance = 1
	max_brute_resistance = 1
	max_fire_resistance = 1
	max_tox_resistance = 1
	max_oxy_resistance = 1
	max_clone_resistance = 1
	max_hal_resistance = 1
	min_damage_resistance = 1
	min_brute_resistance = 1
	min_fire_resistance = 1
	min_tox_resistance = 1
	min_oxy_resistance = 1
	min_clone_resistance = 1
	min_hal_resistance = 1

/* 	// These are not set, but left here as an example. All three (min,max,effective) must be set or BAD THINGS will happen.
	min_brute_resistance = 1 // Min = WHAT HAPPENS AT MINIMUM CHARGE
	max_brute_resistance = 0 // MAX = WHAT HAPPENS AT MAXIMUM CHARGE
	effective_brute_resistance = 1 //Just tells the game that it has vars. Done to use less checks.

	min_fire_resistance = 1
	max_fire_resistance = 0
	effective_fire_resistance = 1
	disable_duration_percent = 1 //THIS CAN ALSO BE USED! Don't be too afraid to use this one, but use it sparingly!
*/
	var/obj/item/device/personal_shield_generator/shield_generator //This is the shield generator you're wearing!


/datum/modifier/shield_projection/on_applied()
	return

/datum/modifier/shield_projection/on_expire() //Don't need to modify this!
	return

/datum/modifier/shield_projection/check_if_valid() //Let's check to make sure you got the stuff and set the vars. Don't need to modify this for any subtypes!
	if(ishuman(holder)) //Only humans can use this! Other things later down the line might use the same stuff this does, but the shield generator is human only!
		var/mob/living/carbon/human/H = holder
		if(istype(H.get_equipped_item(slot_back), /obj/item/device/personal_shield_generator))
			shield_generator = H.get_equipped_item(slot_back) //Sets the var on the modifier that the shield gen is their back shield gen.
		else if(istype(H.get_equipped_item(slot_belt), /obj/item/device/personal_shield_generator))
			shield_generator = H.get_equipped_item(slot_belt) //No need for other checks. If they got hit by this, they just turned it on.
		else if(istype(H.get_equipped_item(slot_s_store), /obj/item/device/personal_shield_generator) ) //Rigsuits.
			shield_generator = H.get_equipped_item(slot_s_store)
		else
			expire(silent = TRUE)
		if(shield_generator) //Sanity.
			energy_source = shield_generator.bcell
			energy_cost = shield_generator.generator_hit_cost
			energy_modifier = shield_generator.energy_modifier
			effect_color = shield_generator.effect_color
		if(!coloration_applied) //Does a check if colors have been applied. If not, updates the color.
			H.update_modifier_visuals() //This can only happen on the next tick, unfortunately, not the same tick the modifier is applied. Thus, must be done here.
			coloration_applied = 1
	else
		expire(silent = TRUE)


/datum/modifier/shield_projection/tick() //When the shield generator runs out of charge, it'll remove this naturally.
	if(holder.stat == DEAD)
		expire(silent = TRUE) //If you're dead the generator stops protecting you but keeps running.
	if(!shield_generator || !shield_generator.slot_check()) //No shield to begin with/shield is not on them any longer.
		expire(silent = FALSE)

	var/shield_efficiency = (energy_source.charge/energy_source.maxcharge) //1 = complete resistance. 0 = no resistance. Must be adjusted for subtypes!
	if(!isnull(effective_damage_resistance))
		effective_damage_resistance = min_damage_resistance + (max_damage_resistance - min_damage_resistance) * shield_efficiency

	if(!isnull(effective_brute_resistance))
		effective_brute_resistance = min_brute_resistance + (max_brute_resistance - min_brute_resistance) * shield_efficiency

	if(!isnull(effective_fire_resistance))
		effective_fire_resistance = min_fire_resistance + (max_fire_resistance - min_fire_resistance) * shield_efficiency

	if(!isnull(effective_tox_resistance))
		effective_tox_resistance = min_tox_resistance + (max_tox_resistance - min_tox_resistance) * shield_efficiency

	if(!isnull(effective_oxy_resistance))
		effective_oxy_resistance = min_oxy_resistance + (max_oxy_resistance - min_oxy_resistance) * shield_efficiency

	if(!isnull(effective_clone_resistance))
		effective_clone_resistance = min_clone_resistance + (max_clone_resistance - min_clone_resistance) * shield_efficiency

	if(!isnull(effective_hal_resistance))
		effective_hal_resistance = min_hal_resistance + (max_hal_resistance - min_hal_resistance) * shield_efficiency

//Shield variants.

//Simple. Goes from 100% resistance to 0% resistance depending on charge. This is mostly an example of a shield variant.
/datum/modifier/shield_projection/bruteburn
	max_brute_resistance = 0
	effective_brute_resistance = 1

	max_fire_resistance = 0
	effective_fire_resistance = 1

/datum/modifier/shield_projection/bruteburn/weak
	max_brute_resistance = 0.5
	max_fire_resistance = 0.5

//SECURITY VARIANTS
/datum/modifier/shield_projection/security // Security backpack. 50% resistance at full charge. 10% resistance for the last shot taken.
	max_brute_resistance = 0.50
	min_brute_resistance = 0.9
	effective_brute_resistance = 1

	max_fire_resistance = 0.5
	min_fire_resistance = 0.9
	effective_fire_resistance = 1

	max_hal_resistance = 0.5
	min_hal_resistance = 0.9
	effective_hal_resistance = 1

	disable_duration_percent = 0.75

/datum/modifier/shield_projection/security/weak // Security belt.
	max_brute_resistance = 0.75
	min_brute_resistance = 0.95
	max_fire_resistance = 0.75
	min_fire_resistance = 0.95
	max_hal_resistance = 0.75

/datum/modifier/shield_projection/security/strong // Dunno. Upgraded variant of security backpack?
	max_brute_resistance = 0.25
	max_fire_resistance = 0.25
	max_hal_resistance = 0.25
	siemens_coefficient = 1.5 //Not as weak as normal, but still weak.
	disable_duration_percent = 0.5


//MINING VARIANTS
/datum/modifier/shield_projection/mining //Base mining belt. 30% resistance that fades to 15% resistance
	max_brute_resistance = 0.70
	min_brute_resistance = 0.85
	effective_brute_resistance = 1

	max_fire_resistance = 0.70
	min_brute_resistance = 0.85
	effective_fire_resistance = 1

	max_hal_resistance = 1.5 // No mobs should be shooting you with halloss. If this happens, it means you're using it wrong!!!
	min_hal_resistance = 1.5
	effective_hal_resistance = 1

	disable_duration_percent = 0.75 //Miners often come into contact with things that can stun them.

/datum/modifier/shield_projection/mining/strong // Mining belt, but upgraded. Even weaker to halloss!
	max_brute_resistance = 0.55
	min_brute_resistance = 0.75
	max_fire_resistance = 0.55
	min_fire_resistance = 0.75
	disable_duration_percent = 0.5

	max_hal_resistance = 2
	min_hal_resistance = 2

//MISC VARIANTS

/datum/modifier/shield_projection/biohazard //The odd-ball damage types. Provides near-complete immunity while it's up.
	min_tox_resistance = 0.25
	max_tox_resistance = 0
	effective_tox_resistance = 1

	min_oxy_resistance = 0.25
	max_oxy_resistance = 0
	effective_oxy_resistance = 1

	min_clone_resistance = 0.25
	max_clone_resistance = 0
	effective_clone_resistance = 1

/datum/modifier/shield_projection/admin // Adminbus.
	on_created_text = "<span class='notice'>Your shield generator activates and you feel the power of the tesla buzzing around you.</span>"
	on_expired_text = "<span class='warning'>Your shield generator deactivates, leaving you feeling weak and vulnerable.</span>"
	siemens_coefficient = 0
	disable_duration_percent = 0
	min_damage_resistance = 0
	max_damage_resistance = 0
	effective_damage_resistance = 0
	min_brute_resistance = 0
	max_brute_resistance = 0
	effective_brute_resistance = 0
	min_fire_resistance = 0
	max_fire_resistance = 0
	effective_fire_resistance = 0
	min_tox_resistance = 0
	max_tox_resistance = 0
	effective_tox_resistance = 0
	min_oxy_resistance = 0
	max_oxy_resistance = 0
	effective_oxy_resistance = 0
	min_clone_resistance = 0
	max_clone_resistance = 0
	effective_clone_resistance = 0
	min_hal_resistance = 0
	max_hal_resistance = 0
	effective_hal_resistance = 0

/datum/modifier/shield_projection/broken //For broken variants. Good if possible randomization is included for packs spawned on PoIs.
	max_brute_resistance = 2
	min_brute_resistance = 2
	effective_brute_resistance = 1

	max_fire_resistance = 2
	min_fire_resistance = 2
	effective_fire_resistance = 1

/datum/modifier/shield_projection/inverted //Becomes stronger the weaker the cell is. Means the last shot taken will be the weakest. Example just to show it can be done.
	max_brute_resistance = 1
	min_brute_resistance = 0
	effective_brute_resistance = 1

	max_fire_resistance = 1
	min_fire_resistance = 0
	effective_fire_resistance = 1

/datum/modifier/shield_projection/parry //Intended for 'parry' shields, which only last for a single second before running out of charge
	max_brute_resistance = 0
	min_brute_resistance = 0
	effective_brute_resistance = 1

	max_fire_resistance = 0
	min_fire_resistance = 0
	effective_fire_resistance = 1

	max_hal_resistance = 0
	min_hal_resistance = 0
	effective_hal_resistance = 1