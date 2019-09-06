/*
	A corrupted maintenance drone, produced from what seems like a bad factory.
	They also tend to dodge while in melee range.
	Code "borrowed" from viscerator drones. <3
*/

/datum/category_item/catalogue/technology/drone/corrupt_maint_drone
	name = "Drone - Corrupted Maintenance Drone"
	desc = "This drone appears to be a station maintenance drone, produced by some sort of corrupt fab, \
	which has caused it to become corrupt and attack anything nearby, except spiders and such, oddy. \
	If one is found, a swarm of others are not too far away.\
	<br><br>\
	The drone struggles to harm large targets, due to it's small size, yet it possesses a welder, which allows \
	it to **ERROR** inject it's targets, in addition to the small slashes from it's skittering claws. \
	The simplistic AI inside attempts to attack and then run, as it is aware that it is fairly weak, \
	using evasive tactics to avoid harm."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/corrupt_maint_drone
	name = "Corrupt Maintenance Drone"
	desc = "A small, normal-looking drone. It looks like one you'd find on station, except... IT'S COMING AT YOU!"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_maint_drone)

	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	icon_living = "repairbot"
	hovering = FALSE // Can trigger landmines.

	faction = "underdark"
	maxHealth = 25
	health = 25
	movement_cooldown = 0
    movement_sound = 'sound/effects/servostep.ogg'

	pass_flags = PASSTABLE
	mob_swap_flags = 0
	mob_push_flags = 0

	melee_damage_lower = 6 // Approx 12 DPS.
	melee_damage_upper = 6
	base_attack_cooldown = 2.5 // Four attacks per second.
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list("cut", "sliced")

    poison_per_bite = 5
	poison_type = "welder fuel"

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/mechanical/corrupt_maint_drone/death()
	..(null,"is smashed into pieces!")
	qdel(src)