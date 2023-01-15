// A very cool blob, literally.
/datum/blob_type/cryogenic_goo
	name = "cryogenic goo"
	desc = "A mass of goo that freezes anything it touches."
	ai_desc = "balanced"
	effect_desc = "Lowers the temperature of the room passively, and will also greatly lower the temperature of anything it attacks."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#8BA6E9"
	complementary_color = "#7D6EB4"
	damage_type = BURN
	damage_lower = 15
	damage_upper = 25
	brute_multiplier = 0.25
	burn_multiplier = 1.2
	spread_modifier = 0.5
	ai_aggressiveness = 50
	chunk_active_ability_cooldown = 4 MINUTES
	attack_message = "The goo stabs you"
	attack_message_living = ", and you feel an intense chill from within"
	attack_message_synth = ", and your system reports lower internal temperatures"
	attack_verb = "stabs"

/datum/blob_type/cryogenic_goo/on_attack(obj/structure/blob/B, mob/living/victim)
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		var/protection = H.get_cold_protection(50)
		if(protection < 1)
			var/temp_change = 80 // Each hit can reduce temperature by up to 80 kelvin.
			var/datum/species/baseline = GLOB.all_species["Human"]
			var/temp_cap = baseline.cold_level_3 - 5 // Can't go lower than this.

			var/cold_factor = abs(protection - 1)
			temp_change *= cold_factor // If protection was at 0.5, then they only lose 40 kelvin.

			H.bodytemperature = max(H.bodytemperature - temp_change, temp_cap)
	else // Just do some extra burn for mobs who don't process bodytemp
		victim.adjustFireLoss(20)
<<<<<<< HEAD

/datum/blob_type/cryogenic_goo/on_pulse(var/obj/structure/blob/B)
	var/turf/simulated/T = get_turf(B)
	if(!istype(T))
		return
	T.freeze_floor()
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(-10 * 1000)

/datum/blob_type/cryogenic_goo/on_chunk_tick(obj/item/weapon/blobcore_chunk/B)
	B.reagents.add_reagent("cryoslurry", 0.5)

	var/turf/simulated/T = get_turf(B)
	if(!istype(T))
		return
	T.freeze_floor()
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(-10 * 1000)

/datum/blob_type/cryogenic_goo/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/living/user)
	user.add_modifier(/datum/modifier/endothermic, 5 MINUTES)
	return
=======
>>>>>>> f473ed9717a... Moves blob chunk effects to artifact effects. (#8783)
