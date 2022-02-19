// Complete chumps but a little bit hardier than mice.

/datum/category_item/catalogue/fauna/hare
	name = "Sivian Fauna - Ice Hare"
	desc = "Classification: S Lepus petropellis\
	<br><br>\
	Hard-skinned, horned herbivores common on the glacial regions of Sif. \
	The Ice Hare lives in colonies of up to thirty individuals dug beneath thick ice sheets for protection from many burrowing predators. \
	Their diet consists of mostly moss and lichens, though this is supplemented with the consumption of hard mineral pebbles, which it swallows whole, \
	which form the small, hard, 'ice-like' scales of the animal. \
	The Ice Hare is almost completely harmless to sapients, with relatively blunt claws and a weak jaw. Its main forms of self-defense are its speed, \
	and two sharp head spikes whose 'ear-like' appearance gave the species its common name."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/hare
	name = "ice hare"
	real_name = "ice hare"
	desc = "A small horned herbivore with a tough 'ice-like' hide."
	tt_desc = "S Lepus petropellis" //Sivian hare rockskin
	catalogue_data = list(/datum/category_item/catalogue/fauna/hare)

	icon_state = "hare"
	icon_living = "hare"
	icon_dead = "hare_dead"
	icon_rest = "hare_rest"

	maxHealth = 20
	health = 20

	armor = list(
		"melee" = 30,
		"bullet" = 5,
		"laser" = 5,
		"energy" = 0,
		"bomb" = 10,
		"bio" = 0,
		"rad" = 0
		)

	armor_soak = list(
		"melee" = 5,
		"bullet" = 0,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0
		)

	movement_cooldown = 2

	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	layer = MOB_LAYER
	density = FALSE

	response_help  = "pets"
	response_disarm = "nudges"
	response_harm   = "kicks"

	organ_names = /decl/mob_organ_names/hare


	meat_amount = 1

	say_list_type = /datum/say_list/hare

/datum/say_list/hare
	speak = list("Snrf...","Crk!")
	emote_hear = list("crackles","sniffles")
	emote_see = list("stomps the ground", "sniffs the air", "chews on something")

/decl/mob_organ_names/hare
	hit_zones = list("head", "chest", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "left head spike", "right head spike")