/datum/blob_type/shifting_fragments
	name = "shifting fragments"
	desc = "A collection of fragments that seem to shuffle around constantly."
	ai_desc = "evasive"
	effect_desc = "Swaps places with nearby blobs when hit or when expanding."
	difficulty = BLOB_DIFFICULTY_EASY
	color = "#C8963C"
	complementary_color = "#3C6EC8"
	damage_type = BRUTE
	damage_lower = 20
	damage_upper = 30
	brute_multiplier = 0.5
	burn_multiplier = 0.5
	spread_modifier = 0.5
	ai_aggressiveness = 30
	chunk_active_ability_cooldown = 3 MINUTES
	attack_message = "A fragment strikes you"
	attack_verb = "strikes"

/datum/blob_type/shifting_fragments/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	if(damage > 0 && prob(60))
		var/list/available_blobs = list()
		for(var/obj/structure/blob/OB in orange(1, B))
			if((istype(OB, /obj/structure/blob/normal) || (istype(OB, /obj/structure/blob/shield) && prob(25))) && OB.overmind && OB.overmind == B.overmind)
				available_blobs += OB
		if(available_blobs.len)
			var/obj/structure/blob/targeted = pick(available_blobs)
			var/turf/T = get_turf(targeted)
			targeted.forceMove(get_turf(B))
			B.forceMove(T) // Swap places.
	return ..()

/datum/blob_type/shifting_fragments/on_expand(var/obj/structure/blob/B, var/obj/structure/blob/new_B, var/turf/T, var/mob/observer/blob/O)
	if(istype(B, /obj/structure/blob/normal) || (istype(B, /obj/structure/blob/shield) && prob(25)))
		new_B.forceMove(get_turf(B))
		B.forceMove(T)

/datum/blob_type/shifting_fragments/on_chunk_use(obj/item/blobcore_chunk/B, mob/living/user)
	user.add_modifier(/datum/modifier/sprinting, 2 MINUTES)
	return
