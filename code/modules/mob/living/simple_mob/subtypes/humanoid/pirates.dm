/mob/living/simple_mob/humanoid/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	tt_desc = "E Homo sapiens"
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"

	faction = FACTION_PIRATE

	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 30
	attack_sharp = TRUE
	attack_edge = 1

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	loot_list = list(/obj/item/melee/energy/sword/pirate = 100)

	corpse = /obj/effect/landmark/mobcorpse/pirate

/mob/living/simple_mob/humanoid/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "piratemelee_dead"

	projectiletype = /obj/item/projectile/beam
	projectilesound = 'sound/weapons/laser.ogg'

	loot_list = list(/obj/item/gun/energy/laser = 100)

	corpse = /obj/effect/landmark/mobcorpse/pirate/ranged
