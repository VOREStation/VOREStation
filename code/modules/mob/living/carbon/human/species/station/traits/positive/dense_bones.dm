/datum/trait/densebones
	name = "Dense Bones"
	desc = "Your bones (or robotic limbs) are more dense or stronger then what is considered normal. It is much harder to fracture your bones, yet pain from fractures is much more intense. Bones require 50% more damage to break, and deal 2x pain on break."
	cost = 3
	excludes = list(/datum/trait/negative/hollow)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/densebones/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/organ in H.organs)
		if(istype(organ))
			organ.min_broken_damage *= 1.5
