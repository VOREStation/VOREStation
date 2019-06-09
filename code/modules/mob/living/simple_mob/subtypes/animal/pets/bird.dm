// Base bird type.

/mob/living/simple_mob/animal/passive/bird
	name = "bird"
	desc = "A domesticated bird. Tweet tweet!"
	player_msg = "You are able to fly."

	icon = 'icons/mob/birds.dmi'
	icon_state = "parrot"
	item_state = null
	icon_rest = "parrot-held"
	icon_dead = "parrot-dead"

	pass_flags = PASSTABLE

	health = 30
	maxHealth = 30
	melee_damage_lower = 3
	melee_damage_upper = 3

	movement_cooldown = 0
	hovering = TRUE // Birds can fly.
	softfall = TRUE
	parachuting = TRUE

	attacktext = list("claws", "pecks")
	speak_emote = list("chirps", "caws")
	has_langs = list("Bird")
	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"

	say_list_type = /datum/say_list/bird
	holder_type = /obj/item/weapon/holder/bird

/datum/say_list/bird
	speak = list("Chirp!","Caw!","Screech!","Squawk!")
	emote_hear = list("chirps","caws")
	emote_see = list("shakes their head", "ruffles their feathers")

/obj/item/weapon/holder/bird
	name = "bird"
	desc = "It's a bird!"
	icon_state = null
	item_icons = null
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/holder/bird/sync(var/mob/living/simple_mob/SM)
	..()
	icon_state = SM.icon_rest // Looks better if the bird isn't flapping constantly in the UI.

// Subtypes for birbs.

/mob/living/simple_mob/animal/passive/bird/black_bird
	name = "common blackbird"
	desc = "A species of bird, both the males and females are known to be territorial on their breeding grounds."
	icon_state = "commonblackbird"
	icon_dead = "commonblackbird-dead"
	tt_desc = "E Turdus merula"
	icon_scale_x = 0.5
	icon_scale_y = 0.5

/mob/living/simple_mob/animal/passive/bird/azure_tit
	name = "azure tit"
	desc = "A species of bird, colored blue and white."
	icon_state = "azuretit"
	icon_dead = "azuretit-dead"
	tt_desc = "E Cyanistes cyanus"
	icon_scale_x = 0.5
	icon_scale_y = 0.5

/mob/living/simple_mob/animal/passive/bird/european_robin
	name = "european robin"
	desc = "A species of bird, they have been studied for their sense of magnetoreception."
	icon_state = "europeanrobin"
	icon_dead = "europeanrobin-dead"
	tt_desc = "E Erithacus rubecula"
	icon_scale_x = 0.5
	icon_scale_y = 0.5

/mob/living/simple_mob/animal/passive/bird/goldcrest
	name = "goldcrest"
	desc = "A species of bird, they were once called 'king of the birds' in ancient human folklore, for their golden crest. \
	Today, their scientific name still elude towards this, with <i>regulus</i>, meaning petty king."
	icon_state = "goldcrest"
	icon_dead = "goldcrest-dead"
	tt_desc = "E Regulus regulus"
	icon_scale_x = 0.5
	icon_scale_y = 0.5

/mob/living/simple_mob/animal/passive/bird/ringneck_dove
	name = "ringneck dove"
	desc = "A species of bird. They are also known as the barbary dove, and have a distinct ring-like shape around the back of their neck."
	icon_state = "ringneckdove"
	icon_dead = "ringneckdove-dead"
	tt_desc = "E Streptopelia risoria" // This is actually disputed IRL but since we can't tell the future it'll stay the same for 500+ years.
	icon_scale_x = 0.5
	icon_scale_y = 0.5
