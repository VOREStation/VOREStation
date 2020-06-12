/mob/living/simple_mob/mobs_monsters/clowns/normal
	name = "Clown"
	desc = "A regular, every tuesday Clown."
	tt_desc = "E Homo sapiens corydon" //this is a clown
	icon = 'icons/mob/mobs_monsters/newclowns.dmi'
	icon_state = "c_normal"
	icon_living = "c_normal"
	icon_dead = "clown_dead"
	icon_gib = "generic_gib"

	faction = "clown"

	loot_list = list(/obj/item/weapon/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Henk!")
	emote_see = list("honks")




/mob/living/simple_mob/mobs_monsters/clowns/big/honkmunculus
	name = "A Clown?"
	desc = "That clown has some interesting proportions."
	tt_desc = "E Homo sapiens corydon horrificus" //this is a redspace clown
	icon = 'icons/mob/mobs_monsters/TGClowns.dmi'
	icon_state = "honkmunculus"
	icon_living = "honkmunculus"
	icon_dead = "honkmunculus_dead"
	icon_gib = "generic_gib"

	faction = "clown"

	loot_list = list(/obj/item/weapon/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Henk!")
	emote_see = list("honks")



/mob/living/simple_mob/mobs_monsters/clowns/big/cluwne
	name = "A Clown?"
	desc = "Oh no not that thing."
	tt_desc = "E Homo sapiens corydon horrificus" //this is a redspace clown
	icon = 'icons/mob/mobs_monsters/newclowns.dmi'
	icon_state = "cluwne"
	icon_living = "cluwne"
	icon_dead = "cluwne_dead"
	icon_gib = "generic_gib"

	faction = "clown"

	loot_list = list(/obj/item/weapon/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Henk!")
	emote_see = list("honks")

