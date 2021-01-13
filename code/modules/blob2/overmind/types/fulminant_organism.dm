// Makes tons of weak spores whenever it spreads.
/datum/blob_type/fulminant_organism
	name = "fulminant organism"
	desc = "A self expanding mass of living biomaterial, that appears to produce entities to defend it, much like a living organism's immune system."
	ai_desc = "swarming"
	effect_desc = "Creates weak floating spores that attack enemies from specialized blobs, has a chance to also create a spore when \
	it spreads onto a new tile, and has a chance to create a spore when a blob tile is destroyed.  It is more fragile than average to all types of damage."
	difficulty = BLOB_DIFFICULTY_HARD // Loads of spores that can overwhelm, and spreads quickly.
	color = "#FF0000" // Red
	complementary_color = "#FFCC00" // Orange-ish
	damage_type = TOX
	damage_lower = 10
	damage_upper = 20
	spread_modifier = 0.7
	burn_multiplier = 1.5
	brute_multiplier = 1.5
	ai_aggressiveness = 30 // The spores do most of the fighting.
	can_build_factories = TRUE
	spore_type = /mob/living/simple_mob/blob/spore/weak
	chunk_active_ability_cooldown = 60 SECONDS

/datum/blob_type/fulminant_organism/on_expand(var/obj/structure/blob/B, var/obj/structure/blob/new_B, var/turf/T, var/mob/observer/blob/O)
	if(prob(10)) // 10% chance to make a weak spore when expanding.
		var/mob/living/simple_mob/blob/spore/S = new spore_type(T)
		if(istype(S))
			S.overmind = O
			S.faction = faction
			O.blob_mobs.Add(S)
		else
			S.faction = faction
		S.update_icons()

/datum/blob_type/fulminant_organism/on_death(obj/structure/blob/B)
	if(prob(33)) // 33% chance to make a spore when dying.
		var/mob/living/simple_mob/blob/spore/S = new spore_type(get_turf(B))
		B.visible_message("<span class='danger'>\The [S] floats free from the [name]!</span>")
		if(istype(S))
			S.overmind = B.overmind
			S.faction = faction
			B.overmind.blob_mobs.Add(S)
		else
			S.faction = faction
		S.update_icons()

/datum/blob_type/fulminant_organism/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/living/user)
	for(var/I = 1 to rand(3,4))
		var/mob/living/simple_mob/blob/spore/S = new spore_type(get_turf(B))
		S.faction = user.faction
		S.blob_type = src
		S.update_icons()
		S.ai_holder.forget_everything()
		S.add_modifier(/datum/modifier/doomed, 2 MINUTES)
