// Spores are made from blob factories.
// They are very weak and expendable, but can overwhelm when a lot of them are together.
// When attacking, spores will hit harder if near other friendly spores.
// Some blobs can infest dead non-robotic mobs, making them into Not Zombies.

/mob/living/simple_mob/blob/spore
	name = "blob spore"
	desc = "A floating, fragile spore."

	icon_state = "blobpod"
	icon_living = "blobpod"
	glow_range = 3
	glow_intensity = 5
	layer = ABOVE_MOB_LAYER // Over the blob.

	health = 30
	maxHealth = 30
	melee_damage_lower = 2
	melee_damage_upper = 4
	movement_cooldown = -2
	hovering = TRUE

	attacktext = list("slammed into")
	attack_sound = 'sound/effects/slime_squish.ogg'
	say_list_type = /datum/say_list/spore

	organ_names = /decl/mob_organ_names/spore

	var/mob/living/carbon/human/infested = null // The human this thing is totally not making into a zombie.
	var/can_infest = FALSE
	var/is_infesting = FALSE

/datum/say_list/spore
	emote_see = list("sways", "inflates briefly")

/datum/say_list/infested
	emote_see = list("shambles around", "twitches", "stares")


/mob/living/simple_mob/blob/spore/infesting
	name = "infesting blob spore"
	can_infest = TRUE

/mob/living/simple_mob/blob/spore/weak
	name = "fragile blob spore"
	health = 15
	maxHealth = 15
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_mob/blob/spore/Initialize(mapload, var/obj/structure/blob/factory/my_factory)
	if(istype(my_factory))
		factory = my_factory
		factory.spores += src
	return ..()

/mob/living/simple_mob/blob/spore/Destroy()
	if(factory)
		factory.spores -= src
	factory = null
	if(infested)
		infested.forceMove(get_turf(src))
		visible_message(span("warning", "\The [infested] falls to the ground as the blob spore bursts."))
		infested = null
	return ..()

/mob/living/simple_mob/blob/spore/death(gibbed, deathmessage = "bursts!")
	if(overmind)
		overmind.blob_type.on_spore_death(src)
	..(gibbed, deathmessage)
	qdel(src)

/mob/living/simple_mob/blob/spore/update_icons()
	..() // This will cut our overlays.

	if(overmind)
		color = overmind.blob_type.complementary_color
		glow_color = color
		glow_toggle = TRUE
	else if(blob_type)
		color = blob_type.complementary_color
		glow_color = color
		glow_toggle = TRUE
	else
		color = null
		glow_color = null
		glow_toggle = FALSE

	if(is_infesting)
		icon = infested.icon
		copy_overlays(infested)
		var/mutable_appearance/blob_head_overlay = mutable_appearance('icons/mob/blob.dmi', "blob_head")
		if(overmind)
			blob_head_overlay.color = overmind.blob_type.complementary_color
		color = initial(color)//looks better.
		add_overlay(blob_head_overlay, TRUE)

/mob/living/simple_mob/blob/spore/handle_special()
	..()
	if(can_infest && !is_infesting && isturf(loc))
		for(var/mob/living/carbon/human/H in view(src,1))
			if(H.stat != DEAD) // We want zombies.
				continue
			if(H.isSynthetic()) // Not philosophical zombies.
				continue
			infest(H)
			break

	if(overmind)
		overmind.blob_type.on_spore_lifetick(src)

	if(factory && z != factory.z) // This is to prevent spores getting lost in space and making the factory useless.
		qdel(src)

/mob/living/simple_mob/blob/spore/proc/infest(mob/living/carbon/human/H)
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
	attacktext = list("clawed")

	H.forceMove(src)
	infested = H

	say_list = new /datum/say_list/infested()

	update_icons()
	visible_message(span("warning", "The corpse of [H.name] suddenly rises!"))

/mob/living/simple_mob/blob/spore/GetIdCard()
	if(infested) // If we've infested someone, use their ID.
		return infested.GetIdCard()

/mob/living/simple_mob/blob/spore/apply_bonus_melee_damage(A, damage_to_do)
	var/helpers = 0
	for(var/mob/living/simple_mob/blob/spore/S in view(1, src))
		if(S == src) // Don't count ourselves.
			continue
		if(!IIsAlly(S)) // Only friendly spores make us stronger.
			continue
		// Friendly spores contribute 1/4th of their averaged attack power to our attack.
		damage_to_do += ((S.melee_damage_lower + S.melee_damage_upper) / 2) / 4
		helpers++

	if(helpers)
		to_chat(src, span("notice", "Your attack is assisted by [helpers] other spore\s."))
	return damage_to_do

/decl/mob_organ_names/spore
	hit_zones = list("sporangium", "stolon", "sporangiophore")
