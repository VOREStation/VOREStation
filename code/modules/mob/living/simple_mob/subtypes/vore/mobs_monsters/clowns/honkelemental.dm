/mob/living/simple_mob/mobs_monsters/clowns/big/c_shift/honkelemental
	name = "Honk Elemental"
	desc = "That thing can't be real, right?"
	tt_desc = "E Homo sapiens corydon horrificus" //this is a redspace clown
	icon = 'icons/mob/mobs_monsters/giantclowns.dmi'
	icon_state = "honk_elemental"
	icon_living = "honk_elemental"
	icon_dead = "he_dead"
	icon_gib = "generic_gib"
	vis_height = 96

	faction = "clown"

	loot_list = list(/obj/item/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Henk!")
	emote_see = list("honks")

/mob/living/simple_mob/mobs_monsters/clowns/big/c_shift/honkelemental/verb/spawn_egg()
	set category = "Abilities"
	set name = "Spawn Clown Egg"
	set desc = "Spawns an egg that a player can touch, which will call on ghosts to spawn as clowns."

	if(is_dead())
		return

	new /obj/structure/ghost_pod/manual/clegg(get_turf(src))
	flick("he_lay",src)
