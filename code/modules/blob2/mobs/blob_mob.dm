////////////////
// BASE TYPE //
////////////////

//Do not spawn
/mob/living/simple_mob/hostile/blob
	icon = 'icons/mob/blob.dmi'
	pass_flags = PASSBLOB | PASSTABLE
	faction = FACTION_BLOB
//	bubble_icon = "blob"
//	speak_emote = null //so we use verb_yell/verb_say/etc
//	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
//	minbodytemp = 0
//	maxbodytemp = 360
//	unique_name = 1
//	a_intent = INTENT_HARM
	cooperative = TRUE
	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	var/mob/observer/blob/overmind = null
	var/obj/structure/blob/factory/factory = null

/mob/living/simple_mob/hostile/blob/speech_bubble_appearance()
	return "slime"

/mob/living/simple_mob/hostile/blob/update_icons()
	if(overmind)
		color = overmind.blob_type.complementary_color
	else
		color = null

/mob/living/simple_mob/hostile/blob/Destroy()
	if(overmind)
		overmind.blob_mobs -= src
	return ..()

/mob/living/simple_mob/hostile/blob/blob_act(obj/structure/blob/B)
	if(!overmind && B.overmind)
		overmind = B.overmind
		update_icon()

	if(stat != DEAD && health < maxHealth)
		adjustBruteLoss(-maxHealth*0.0125)
		adjustFireLoss(-maxHealth*0.0125)

/mob/living/simple_mob/hostile/blob/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/blob)) // Don't block blobs from expanding onto a tile occupied by a blob mob.
		return TRUE
	return ..()

/mob/living/simple_mob/hostile/blob/Process_Spacemove()
	for(var/obj/structure/blob/B in range(1, src))
		return TRUE
	return ..()
