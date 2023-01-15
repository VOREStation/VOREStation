// Makes spores that spread the blob and infest dead people.
/datum/blob_type/fungal_bloom
	name = "fungal bloom"
	desc = "A massive network of rapidly expanding mycelium.  Large spore-like particles can be seen spreading from it."
	ai_desc = "swarming"
	effect_desc = "Creates floating spores that attack enemies from specialized blobs, and will spread the blob if killed.  The spores can also \
	infest deceased biological humanoids.  It is vulnerable to fire."
	difficulty = BLOB_DIFFICULTY_MEDIUM // The spores are more of an annoyance but can be difficult to contain.
	color = "#AAAAAA"
	complementary_color = "#FFFFFF"
	damage_type = TOX
	damage_lower = 15
	damage_upper = 25
	spread_modifier = 0.3 // Lower, since spores will do a lot of the spreading.
	burn_multiplier = 3
	ai_aggressiveness = 40
	can_build_factories = TRUE
	spore_type = /mob/living/simple_mob/blob/spore/infesting
	chunk_active_ability_cooldown = 2 MINUTES

/datum/blob_type/fungal_bloom/on_spore_death(mob/living/simple_mob/blob/spore/S)
	if(S.is_infesting)
		return // Don't make blobs if they were on someone's head.
	var/turf/T = get_turf(S)
	var/obj/structure/blob/B = locate(/obj/structure/blob) in T
	if(B) // Is there already a blob here?  If so, just heal it.
		B.adjust_integrity(10)
	else
		B = new /obj/structure/blob/normal(T, S.overmind) // Otherwise spread it.
		B.visible_message("<span class='danger'>\A [B] forms on \the [T] as \the [S] bursts!</span>")
<<<<<<< HEAD

/datum/blob_type/fungal_bloom/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/living/user)
	var/mob/living/simple_mob/blob/spore/S = new spore_type(get_turf(B))
	S.faction = user.faction
	S.blob_type = src
	S.update_icons()
	S.ai_holder.forget_everything()
=======
>>>>>>> f473ed9717a... Moves blob chunk effects to artifact effects. (#8783)
