/mob/living/simple_mob/humanoid/clown
	clown
	name = "clown"
	desc = "A denizen of clown planet"
	tt_desc = "E Homo sapiens corydon" //this is an actual clown, as opposed to someone dressed up as one
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"

	faction = "clown"

	loot_list = list(/obj/item/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("attacked")
	attack_sound = 'sound/items/bikehorn.ogg'

	organ_names = /decl/mob_organ_names/clown

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks")

/decl/mob_organ_names/clown
	hit_zones = list("head", "torso", "pie-hole", "honker", "left funny bone", "right funny bone", "left foot", "right foot", "unmentionables")