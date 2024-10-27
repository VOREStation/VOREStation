// Makes robots cry.  Really weak to brute damage.
/datum/blob_type/electromagnetic_web
	name = "electromagnetic web"
	desc = "A gooy mesh that generates an electromagnetic field.  Electronics will likely be ruined if nearby."
	ai_desc = "balanced"
	effect_desc = "Causes an EMP on attack, and will EMP upon death.  It is also more fragile than average, especially to brute force."
	difficulty = BLOB_DIFFICULTY_MEDIUM // Rough for robots but otherwise fragile and can be fought at range like most blobs anyways.
	color = "#83ECEC"
	complementary_color = "#EC8383"
	damage_type = BURN
	damage_lower = 10
	damage_upper = 20
	brute_multiplier = 3
	burn_multiplier = 2
	ai_aggressiveness = 60
	chunk_active_type = BLOB_CHUNK_CONSTANT
	attack_message = "The web lashes you"
	attack_message_living = ", and you hear a faint buzzing"
	attack_message_synth = ", and your electronics get badly damaged"
	attack_verb = "lashes"

/datum/blob_type/electromagnetic_web/on_death(obj/structure/blob/B)
	empulse(B.loc, 0, 1, 2)

/datum/blob_type/electromagnetic_web/on_attack(obj/structure/blob/B, mob/living/victim)
	victim.emp_act(2)

/datum/blob_type/electromagnetic_web/on_chunk_tick(obj/item/blobcore_chunk/B)
	var/turf/T = get_turf(B)
	if(!T)
		return

	for(var/mob/living/L in view(2, T))
		L.add_modifier(/datum/modifier/faraday, 30 SECONDS)