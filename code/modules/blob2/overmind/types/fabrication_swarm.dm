// Slow, tanky blobtype which uses not spores, but hivebots, as its soldiers.
/datum/blob_type/fabrication_swarm
	name = "iron tide"
	desc = "A swarm of self replicating construction nanites. Incredibly illegal, but only mildly dangerous."
	effect_desc = "Slow-spreading, but incredibly resilient. It has a chance to harden itself against attacks automatically for no resource cost, and uses cheaply-constructed hivebots as soldiers."
	ai_desc = "defensive"
	difficulty = BLOB_DIFFICULTY_MEDIUM // Emitters are okay, EMP is great.
	color = "#666666"
	complementary_color = "#B7410E"
	spread_modifier = 0.2
	can_build_factories = TRUE
	can_build_resources = TRUE
	attack_message = "The tide tries to shove you away"
	attack_message_living = ", and your skin itches"
	attack_message_synth = ", and your external plating dulls"
	attack_verb = "shoves"
	armor_pen = 40
	damage_lower = 10
	damage_upper = 25
	brute_multiplier = 0.25
	burn_multiplier = 0.6
	ai_aggressiveness = 50 //Really doesn't like you near it.
	spore_type = /mob/living/simple_mob/mechanical/hivebot/swarm

/datum/blob_type/fabrication_swarm/on_received_damage(var/obj/structure/blob/B, damage, damage_type, mob/living/attacker)
	if(istype(B, /obj/structure/blob/normal))
		if(damage > 0)
			var/reinforce_probability = min(damage, 70)
			if(prob(reinforce_probability))
				B.visible_message(span_danger("The [name] quakes, before rapidly hardening!"))
				new/obj/structure/blob/shield(get_turf(B), B.overmind)
				qdel(B)
	return ..()

/datum/blob_type/fabrication_swarm/on_emp(obj/structure/blob/B, severity)
	B.adjust_integrity(-(30 / severity))

/datum/blob_type/fabrication_swarm/on_chunk_tick(obj/item/blobcore_chunk/B)
	var/turf/T = get_turf(B)
	for(var/mob/living/L in view(world.view, T))
		if(L.stat != DEAD && L.isSynthetic())
			L.adjustBruteLoss(-1)
			L.adjustFireLoss(-1)
	return
