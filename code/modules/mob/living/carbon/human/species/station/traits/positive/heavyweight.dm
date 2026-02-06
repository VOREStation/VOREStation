/datum/trait/heavyweight
	name = "Heavyweight"
	desc = "You are more heavyweight or otherwise more sturdy than most species, and as such, more resistant to knockdown effects and stuns. Stuns are only half as effective on you, and neither players nor mobs can trade places with you or bump you out of the way."
	cost = 2
	var_changes = list("stun_mod" = 0.5, "weaken_mod" = 0.5) // Stuns are 50% as effective - a stun of 3 seconds will be 2 seconds due to rounding up. Set to 0.5 to be in-line with the trait's description. (Weaken is used alongside stun to prevent aiming.)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/heavyweight/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.mob_size = MOB_LARGE
	H.mob_bump_flag = HEAVY
