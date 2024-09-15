// Blob simple_mobs generally get made from the blob random event.
// They're considered slimes for the purposes of attack bonuses from certain weapons.

// Do not spawn, this is a base type.
/mob/living/simple_mob/blob
	icon = 'icons/mob/blob.dmi'
	pass_flags = PASSBLOB | PASSTABLE
	faction = FACTION_BLOB

	organ_names = /decl/mob_organ_names/blob

	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	taser_kill = FALSE

	var/mob/observer/blob/overmind = null
	var/obj/structure/blob/factory/factory = null
	var/datum/blob_type/blob_type = null	// Used for the blob core items, as they have no overmind mob.

	mob_class = MOB_CLASS_SLIME
	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/blob/speech_bubble_appearance()
	return "slime"

/mob/living/simple_mob/blob/update_icons()
	if(overmind)
		color = overmind.blob_type.complementary_color
	else if(blob_type)
		color = blob_type.complementary_color
	else
		color = null
	..()

/mob/living/simple_mob/blob/Destroy()
	if(overmind)
		overmind.blob_mobs -= src
	if(blob_type)
		blob_type = null
	return ..()

/mob/living/simple_mob/blob/blob_act(obj/structure/blob/B)
	if(!overmind && B.overmind)
		overmind = B.overmind
		faction = B.overmind.blob_type.faction
		update_icon()

	if(faction != B.faction && B.overmind)
		adjustBruteLoss(rand(B.overmind.blob_type.damage_lower, B.overmind.blob_type.damage_upper))

	else if(stat != DEAD && health < maxHealth)
		adjustBruteLoss(-maxHealth*0.0125)
		adjustFireLoss(-maxHealth*0.0125)

/mob/living/simple_mob/blob/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/blob)) // Don't block blobs from expanding onto a tile occupied by a blob mob.
		return TRUE
	return ..()

/mob/living/simple_mob/blob/Process_Spacemove()
	for(var/obj/structure/blob/B in range(1, src))
		return TRUE
	return ..()

/mob/living/simple_mob/blob/IIsAlly(mob/living/L)
	var/ally = ..(L)
	if(!ally)
		var/list/items = L.get_all_held_items()
		for(var/obj/item/I in items)
			if(istype(I, /obj/item/weapon/blobcore_chunk))
				var/obj/item/weapon/blobcore_chunk/BC = I
				if(!overmind || (BC.blob_type && overmind.blob_type.type == BC.blob_type.type) || BC.blob_type.faction == faction)
					ally = TRUE
				break

	return ally

/decl/mob_organ_names/blob
	hit_zones = list("mass")
