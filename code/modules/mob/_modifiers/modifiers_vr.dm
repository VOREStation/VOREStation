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
	mob_overlay_state = "repel_missiles" 	//Looks alright, I guess. Placeholder.
	stacks = MODIFIER_STACK_FORBID //No stacking shields. If you put one one your belt and backpack it won't work.

	siemens_coefficient = 2 //Stun weapons drain 100% charge per damage. They're good at blocking lasers and bullets but not good at blocking stun beams!
	incoming_brute_damage_percent = 0
	incoming_fire_damage_percent = 0
	incoming_hal_damage_percent = 0
	energy_based = 1
	energy_cost = 99999 //This is changed to the shield_genertor's energy_cost.
	energy_modifier = 50 //This is how much battery is used per damage unit absorbed. Higher damage means higher charge use per damage absorbed. Changed below!
	var/obj/item/device/personal_shield_generator/shield_generator //This is the shield generator you're wearing!


/datum/modifier/shield_projection/on_applied()
	return

/datum/modifier/shield_projection/on_expire()
	return

/datum/modifier/shield_projection/check_if_valid() //Let's check to make sure you got the stuff and set the vars.
	if(ishuman(holder)) //Only humans can use this!
		var/mob/living/carbon/human/H = holder
		if(istype(H.get_equipped_item(slot_back), /obj/item/device/personal_shield_generator))
			shield_generator = H.get_equipped_item(slot_back) //Sets the var on the modifier that the shield gen is their back shield gen.
			energy_source = shield_generator.bcell
			energy_cost = shield_generator.generator_hit_cost
			energy_modifier = shield_generator.energy_modifier
		else if(istype(H.get_equipped_item(slot_belt), /obj/item/device/personal_shield_generator))
			shield_generator = H.get_equipped_item(slot_belt) //No need for other checks. If they got hit by this, they just turned it on.
			energy_source = shield_generator.bcell
			energy_cost = shield_generator.generator_hit_cost
			energy_modifier = shield_generator.energy_modifier
		else if(istype(H.get_equipped_item(slot_s_store), /obj/item/device/personal_shield_generator) ) //Rigsuits.
			shield_generator = H.get_equipped_item(slot_s_store)
			energy_source = shield_generator.bcell
			energy_cost = shield_generator.generator_hit_cost
			energy_modifier = shield_generator.energy_modifier
		else
			expire(silent = TRUE)
	else
		expire(silent = TRUE)

/datum/modifier/shield_projection/tick() //When the shield generator runs out of charge, it'll remove this naturally.
	if(holder.stat == DEAD)
		expire(silent = TRUE) //If you're dead the generator stops protecting you but keeps running.
	if(!shield_generator || !shield_generator.slot_check()) //No shield to begin with/shield is not on them any longer.
		expire(silent = FALSE)
	var/shield_efficiency = 1-(energy_source.charge/energy_source.maxcharge) //0 = complete resistance. 1 = no resistance.
	incoming_brute_damage_percent = shield_efficiency //Less charge means less resistance!
	incoming_fire_damage_percent = shield_efficiency
	incoming_hal_damage_percent = shield_efficiency