////////////////
// BLOB SPORE //
////////////////

/mob/living/simple_mob/hostile/blob/spore
	name = "blob spore"
	desc = "A floating, fragile spore."
	icon_state = "blobpod"
	icon_living = "blobpod"
	health = 30
	maxHealth = 30
	melee_damage_lower = 2
	melee_damage_upper = 4
	layer = MOB_LAYER + 0.2 // Over the blob.
	attacktext = list("slams into")
	attack_sound = 'sound/effects/slime_squish.ogg'
	emote_see = list("sways", "inflates briefly")
	var/mob/living/carbon/human/infested = null // The human this thing is totally not making into a zombie.
	var/can_infest = FALSE
	var/is_infesting = FALSE

/mob/living/simple_mob/hostile/blob/spore/infesting
	name = "infesting blob spore"
	can_infest = TRUE

/mob/living/simple_mob/hostile/blob/spore/weak
	name = "fragile blob spore"
	health = 15
	maxHealth = 15
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_mob/hostile/blob/spore/New(var/newloc, var/obj/structure/blob/factory/my_factory)
	if(istype(my_factory))
		factory = my_factory
		factory.spores += src
	..(newloc)

/mob/living/simple_mob/hostile/blob/spore/Destroy()
	if(factory)
		factory.spores -= src
	factory = null
	if(infested)
		infested.forceMove(get_turf(src))
		visible_message(span_warning("\The [infested] falls to the ground as the blob spore bursts."))
		infested = null
	return ..()

/mob/living/simple_mob/hostile/blob/spore/death(gibbed, deathmessage = "bursts!")
	if(overmind)
		overmind.blob_type.on_spore_death(src)
	..(gibbed, deathmessage)
	qdel(src)

/mob/living/simple_mob/hostile/blob/spore/update_icons()
	if(overmind)
		color = overmind.blob_type.complementary_color
		set_light(3, 5, color)
	else
		color = null
		set_light(0)

	if(is_infesting)
		cut_overlays()
		icon = infested.icon
		add_overlay(infested.overlays)
		var/mutable_appearance/blob_head_overlay = mutable_appearance('icons/mob/blob.dmi', "blob_head")
		if(overmind)
			blob_head_overlay.color = overmind.blob_type.complementary_color
		color = initial(color)//looks better.
		add_overlay(blob_head_overlay)

/mob/living/simple_mob/hostile/blob/spore/Life()
	if(can_infest && !is_infesting && isturf(src.loc))
		for(var/mob/living/carbon/human/H in view(src,1))
			if(H.stat != DEAD) // We want zombies.
				continue
			if(H.isSynthetic()) // Not philosophical zombies.
				continue
			infest(H)
			break
	if(factory && z != factory.z) // This is to prevent spores getting lost in space and making the factory useless.
		qdel(src)
	..()

/mob/living/simple_mob/hostile/blob/spore/proc/infest(mob/living/carbon/human/H)
	is_infesting = TRUE
	if(H.wear_suit)
		var/obj/item/clothing/suit/A = H.wear_suit
		if(A.armor && A.armor["melee"])
			maxHealth += A.armor["melee"] //That zombie's got armor, I want armor!

	maxHealth += 40
	health = maxHealth
	name = "Infested [H.real_name]" // Not using the Z word.
	desc = "A parasitic organism attached to a deceased body, controlling it directly as if it were a puppet."
	melee_damage_lower += 8  // 10 total.
	melee_damage_upper += 11 // 15 total.
	emote_see = list("shambles around", "twitches", "stares")
	attacktext = list("claws")

	H.forceMove(src)
	infested = H

	update_icons()
	visible_message(span_warning("The corpse of [H.name] suddenly rises!"))

/mob/living/simple_mob/hostile/blob/spore/GetIdCard()
	if(infested) // If we've infested someone, use their ID.
		return infested.GetIdCard()
