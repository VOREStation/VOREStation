/datum/trait/hollow
	name = "Hollow Bones/Aluminum Alloy"
	desc = "Your bones and robot limbs are much easier to break."
	cost = -2 //I feel like this should be higher, but let's see where it goes
	excludes = list(/datum/trait/boneless, /datum/trait/densebones)
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/hollow/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 0.5
		O.min_bruised_damage *= 0.5


/*
 * So, I know what you're thinking.
 * "Why is this a negative trait? It sounds like a positive one!"
 * In theory, yes. Being unable to have your limbs break DOES sound like a good thing!
 * However, that is where limb code comes into play.
 * Normally, with highly damaged limbs, you have a RNG(X)% chance for it to be sliced off if it takes a lot of damage and the damage from the blow is over a certain threshold.
 * Additionally, limbs have a 'maximum damage' it can reach in which it can't reach anymore. Your arm, for example, is 80 damage maximum. Head 75.
 * Trying to hit it more won't do any more damage, just constantly roll chances (if the hitting blow is strong enough) to cut it off/gib it.
 * With this trait, however, as soon as you reach that maximum damage, your limb IMMEDIATELY gibs. No RNG chance rolls. 'attack must be X strong to hit it off'. Nothing.
 * Additionally, normal limbloss code has one-shot protection and prevents bullets from gibbing limbs. This makes you forfeit that protection.
 */
/datum/trait/boneless
	name = "Boneless"
	desc = "You have no bones! Though your limbs will gib once reaching their maximum limit in exchange."
	cost = -3
	custom_only = TRUE
	can_take = ORGANICS
	is_genetrait = FALSE //genetically removes your bones? nah.
	hidden = FALSE
	///How much our limbs max_damage is multiplied by.
	var/limb_health = 1
	excludes = list(/datum/trait/hollow)
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/boneless/major
	name = "Boneless, Major"
	desc = "You have no bones! Your limbs are also much, much easier to gib in exchange. (Seriously this can result in one shot deaths and similar)"
	cost = -6 //For reference, getting hit in the head with a welder 3 times kills you. Head has 37.5 HP. Reaching that cap = instant death
	limb_health = 0.5
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/boneless/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/ex_organ in H.organs)
		ex_organ.cannot_break = TRUE
		ex_organ.dislocated = -1
		ex_organ.nonsolid = TRUE //ESSENTIAL for boneless. Otherwise it acts like a normal limb.
		ex_organ.spread_dam = TRUE
		ex_organ.max_damage = floor(ex_organ.max_damage * limb_health)

		if(istype(ex_organ, /obj/item/organ/external/head))
			ex_organ.encased = FALSE //you can just reach in and grab it
			ex_organ.cannot_gib = FALSE

		else if(istype(ex_organ, /obj/item/organ/external/chest))
			ex_organ.encased = FALSE
