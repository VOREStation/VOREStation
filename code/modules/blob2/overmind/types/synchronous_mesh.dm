// Spreads damage to nearby blobs, and attacks with the force of all nearby blobs.
/datum/blob_type/synchronous_mesh
	name = "synchronous mesh"
	desc = "A mesh that seems strongly interconnected to itself.  It moves slowly, but with purpose."
	ai_desc = "defensive"
	effect_desc = "When damaged, spreads the damage to nearby blobs.  When attacking, damage is increased based on how many blobs are near the target.  It is resistant to burn damage."
	difficulty = BLOB_DIFFICULTY_EASY // Mostly a tank and spank.
	color = "#65ADA2"
	complementary_color = "#AD6570"
	damage_type = BRUTE
	damage_lower = 10
	damage_upper = 15
	brute_multiplier = 0.5
	burn_multiplier = 0.2 // Emitters do so much damage that this will likely not matter too much.
	spread_modifier = 0.3 // Since the blob spreads damage, it takes awhile to actually kill, so spread is reduced.
	ai_aggressiveness = 60
	attack_message = "The mesh synchronously strikes you"
	attack_verb = "synchronously strikes"
	var/synchronously_attacking = FALSE

/datum/blob_type/synchronous_mesh/on_attack(obj/structure/blob/B, mob/living/victim)
	if(synchronously_attacking)
		return
	synchronously_attacking = TRUE // To avoid infinite loops.
	for(var/obj/structure/blob/C in orange(1, victim))
		if(victim) // Some things delete themselves when dead...
			C.blob_attack_animation(victim)
			victim.blob_act(C)
	synchronously_attacking = FALSE

/datum/blob_type/synchronous_mesh/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	var/list/blobs_to_hurt = list() // Maximum split is 9, reducing the damage each blob takes to 11.1% but doing that damage to 9 blobs.
	for(var/obj/structure/blob/C in range(1, B))
		if(!istype(C, /obj/structure/blob/core) && !istype(C, /obj/structure/blob/node) && C.overmind && (C.overmind == B.overmind) ) //if it doesn't have the same 'ownership' or is a core or node, don't split damage to it
			blobs_to_hurt += C

	for(var/obj/structure/blob/C as anything in blobs_to_hurt)
		if(C == B)
			continue // We'll damage this later.

		C.adjust_integrity(-(damage / blobs_to_hurt.len))

	return damage / max(blobs_to_hurt.len, 1) // To hurt the blob that got hit.

/datum/blob_type/synchronous_mesh/on_chunk_tick(obj/item/blobcore_chunk/B)
	var/mob/living/carrier = B.get_carrier()

	if(!carrier)
		return

	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(world.view, carrier))
		if(L.stat != DEAD)
			nearby_mobs |= L

	if(nearby_mobs.len)
		for(var/mob/living/victim in nearby_mobs)
			var/need_beam = FALSE

			if(carrier.getBruteLoss())
				need_beam = TRUE
				victim.adjustBruteLoss(3 / nearby_mobs.len)
				carrier.adjustBruteLoss(-3 / nearby_mobs.len)

			if(carrier.getFireLoss())
				need_beam = TRUE
				victim.adjustFireLoss(3 / nearby_mobs.len)
				carrier.adjustFireLoss(-3 / nearby_mobs.len)

			if(need_beam)
				carrier.visible_message("<span class='alien'>[icon2html(B,viewers(carrier))] \The [B] sends noxious spores toward \the [victim]!</span>")
				carrier.Beam(victim, icon_state = "lichbeam", time = 2 SECONDS)
