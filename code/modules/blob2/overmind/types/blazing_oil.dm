// A blob meant to be fought like a fire.
/datum/blob_type/blazing_oil
	name = "blazing oil"
	desc = "A strange, extremely vicious liquid that seems to burn endlessly."
	ai_desc = "aggressive"
	effect_desc = "Cannot be harmed by burning weapons, and ignites entities it attacks.  It will also gradually heat up the area it is in.  Water harms it greatly."
	difficulty = BLOB_DIFFICULTY_MEDIUM // Emitters don't work but extinguishers are fairly common.  Might need fire/atmos suits.
	color = "#B68D00"
	complementary_color = "#BE5532"
	spread_modifier = 0.5
	ai_aggressiveness = 50
	damage_type = BURN
	burn_multiplier = 0 // Fire immunity
	chunk_active_ability_cooldown = 4 MINUTES
	attack_message = "The blazing oil splashes you with its burning oil"
	attack_message_living = ", and you feel your skin char and melt"
	attack_message_synth = ", and your external plating melts"
	attack_verb = "splashes"

/datum/blob_type/blazing_oil/on_attack(obj/structure/blob/B, mob/living/victim)
	victim.fire_act() // Burn them.

/datum/blob_type/blazing_oil/on_water(obj/structure/blob/B, amount)
	spawn(1)
		B.adjust_integrity(-(amount * 5))
<<<<<<< HEAD

/datum/blob_type/blazing_oil/on_pulse(var/obj/structure/blob/B)
	var/turf/T = get_turf(B)
	if(!T)
		return
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(10 * 1000)

/datum/blob_type/blazing_oil/on_chunk_tick(obj/item/weapon/blobcore_chunk/B)
	B.reagents.add_reagent("thermite_v", 0.5)

	var/turf/T = get_turf(B)
	if(!T)
		return
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(10 * 1000)

/datum/blob_type/blazing_oil/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/living/user)
	user.add_modifier(/datum/modifier/exothermic, 5 MINUTES)
	return
=======
>>>>>>> f473ed9717a... Moves blob chunk effects to artifact effects. (#8783)
