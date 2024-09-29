/mob/living/simple_mob/humanoid/russian
	name = "russian"
	desc = "For the Motherland!"
	tt_desc = "E Homo sapiens"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"

	faction = FACTION_RUSSIAN

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	attack_armor_pen = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = list("punched")

	loot_list = list(/obj/item/material/knife = 100)

	corpse = /obj/effect/landmark/mobcorpse/russian

/mob/living/simple_mob/humanoid/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"

	projectiletype = /obj/item/projectile/bullet
	casingtype = /obj/item/ammo_casing/spent
	projectilesound = 'sound/weapons/Gunshot4.ogg'

	loot_list = list(/obj/item/gun/projectile/revolver/mateba = 100)

	corpse = /obj/effect/landmark/mobcorpse/russian/ranged
