// Super fast spreading, but weak to EMP.
/datum/blob_type/grey_goo
	name = "grey tide"
	desc = "A swarm of self replicating nanomachines.  Extremely illegal and dangerous, the EIO was meant to prevent this from showing up a second time."
	effect_desc = "Spreads much faster than average, but is harmed greatly by electromagnetic pulses."
	ai_desc = "genocidal"
	difficulty = BLOB_DIFFICULTY_SUPERHARD // Fastest spread of them all and has snowballing capabilities.
	color = "#888888"
	complementary_color = "#CCCCCC"
	spread_modifier = 1.0
	slow_spread_with_size = FALSE
	ai_aggressiveness = 80
	can_build_resources = TRUE
	attack_message = "The tide tries to swallow you"
	attack_message_living = ", and you feel your skin dissolve"
	attack_message_synth = ", and your external plating dissolves"
	faction = FACTION_NANOMACHINES

/datum/blob_type/grey_goo/on_emp(obj/structure/blob/B, severity)
	B.adjust_integrity(-(20 / severity))

/datum/blob_type/grey_goo/on_chunk_tick(obj/item/weapon/blobcore_chunk/B)
	var/turf/T = get_turf(B)
	for(var/mob/living/L in view(world.view, T))
		if(L.stat != DEAD)
			L.adjustBruteLoss(-1)
			L.adjustFireLoss(-1)
	return
