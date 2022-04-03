// A blob that slips and drowns you.
/datum/blob_type/pressurized_slime
	name = "pressurized slime"
	desc = "A large mass that seems to leak slippery fluid everywhere."
	ai_desc = "drowning"
	effect_desc = "Wets the floor when expanding and when hit. Tries to drown its enemies when attacking. It forces itself past internals. Resistant to burn damage."
	difficulty = BLOB_DIFFICULTY_HARD
	color = "#AAAABB"
	complementary_color = "#BBBBAA"
	damage_type = OXY
	damage_lower = 5
	damage_upper = 15
	armor_check = null
	brute_multiplier = 0.6
	burn_multiplier = 0.2
	spread_modifier = 0.4
	ai_aggressiveness = 75
	attack_message = "The slime splashes into you"
	attack_message_living = ", and you gasp for breath"
	attack_message_synth = ", and the fluid wears down on your components"
	attack_verb = "splashes"

/datum/blob_type/pressurized_slime/on_attack(obj/structure/blob/B, mob/living/victim, def_zone)
	victim.water_act(5)
	var/turf/simulated/T = get_turf(victim)
	if(T)
		T.wet_floor()

/datum/blob_type/pressurized_slime/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	wet_surroundings(B, damage)
	return ..()

/datum/blob_type/pressurized_slime/on_pulse(var/obj/structure/blob/B)
	var/turf/simulated/T = get_turf(B)
	if(!istype(T))
		return
	T.wet_floor()

/datum/blob_type/pressurized_slime/on_death(obj/structure/blob/B)
	B.visible_message("<span class='danger'>The blob ruptures, spraying the area with liquid!</span>")
	wet_surroundings(B, 50)

/datum/blob_type/pressurized_slime/proc/wet_surroundings(var/obj/structure/blob/B, var/probability = 50)
	for(var/turf/simulated/T in range(1, get_turf(B)))
		if(prob(probability))
			T.wet_floor()
		for(var/atom/movable/AM in T)
			AM.water_act(2)

/datum/blob_type/pressurized_slime/on_chunk_tick(obj/item/weapon/blobcore_chunk/B)
	wet_surroundings(B, 10)

/datum/blob_type/pressurized_slime/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/living/user)	// Drenches you in water.
	if(user)
		user.ExtinguishMob()
		user.fire_stacks = clamp(user.fire_stacks - 1, -25, 25)