//Why are these a subclass of cat?
/mob/living/simple_animal/bird
	name = "parrot"
	desc = "A domesticated bird. Tweet tweet!"
	icon = 'icons/mob/birds.dmi'
	icon_state = "parrot-flap"
	item_state = null
	icon_living = "parrot-flap"
	icon_dead = "parrot-dead"

	pass_flags = PASSTABLE

	speak_chance = 5
	speak = list("Chirp!","Caw!","Screech!","Squawk!")
	speak_emote = list("chirps", "caws")
	emote_hear = list("chirps","caws")
	emote_see = list("shakes their head", "ruffles their feathers")

	holder_type = /obj/item/weapon/holder/bird

/mob/living/simple_animal/bird/kea
	name = "Kea"
	icon_state = "kea-flap"
	icon_living = "kea-flap"
	icon_dead = "kea-dead"

/mob/living/simple_animal/bird/eclectus
	name = "Eclectus"
	icon_state = "eclectus-flap"
	icon_living = "eclectus-flap"
	icon_dead = "eclectus-dead"

/mob/living/simple_animal/bird/eclectusf
	name = "Eclectus"
	icon_state = "eclectusf-flap"
	icon_living = "eclectusf-flap"
	icon_dead = "eclectusf-dead"

/mob/living/simple_animal/bird/greybird
	name = "Grey Bird"
	icon_state = "agrey-flap"
	icon_living = "agrey-flap"
	icon_dead = "agrey-dead"

/mob/living/simple_animal/bird/blue_caique
	name = "Blue Caique "
	icon_state = "bcaique-flap"
	icon_living = "bcaique-flap"
	icon_dead = "bcaique-dead"

/mob/living/simple_animal/bird/white_caique
	name = "White caique"
	icon_state = "wcaique-flap"
	icon_living = "wcaique-flap"
	icon_dead = "wcaique-dead"

/mob/living/simple_animal/bird/green_budgerigar
	name = "Green Budgerigar"
	icon_state = "gbudge-flap"
	icon_living = "gbudge-flap"
	icon_dead = "gbudge-dead"

/mob/living/simple_animal/bird/blue_Budgerigar
	name = "Blue Budgerigar"
	icon_state = "bbudge-flap"
	icon_living = "bbudge-flap"
	icon_dead = "bbudge-dead"

/mob/living/simple_animal/bird/bluegreen_Budgerigar
	name = "Bluegreen Budgerigar"
	icon_state = "bgbudge-flap"
	icon_living = "bgbudge-flap"
	icon_dead = "bgbudge-dead"

/mob/living/simple_animal/bird/commonblackbird
	name = "Black Bird"
	icon_state = "commonblackbird"
	icon_living = "commonblackbird"
	icon_dead = "commonblackbird-dead"

/mob/living/simple_animal/bird/azuretit
	name = "Azure Tit"
	icon_state = "azuretit"
	icon_living = "azuretit"
	icon_dead = "azuretit-dead"

/mob/living/simple_animal/bird/europeanrobin
	name = "European Robin"
	icon_state = "europeanrobin"
	icon_living = "europeanrobin"
	icon_dead = "europeanrobin-dead"

/mob/living/simple_animal/bird/goldcrest
	name = "Goldcrest"
	icon_state = "goldcrest"
	icon_living = "goldcrest"
	icon_dead = "goldcrest-dead"

/mob/living/simple_animal/bird/ringneckdove
	name = "Ringneck Dove"
	icon_state = "ringneckdove"
	icon_living = "ringneckdove"
	icon_dead = "ringneckdove-dead"

/mob/living/simple_animal/bird/cockatiel
	name = "Cockatiel"
	icon_state = "tiel-flap"
	icon_living = "tiel-flap"
	icon_dead = "tiel-dead"

/mob/living/simple_animal/bird/white_cockatiel
	name = "White Cockatiel"
	icon_state = "wtiel-flap"
	icon_living = "wtiel-flap"
	icon_dead = "wtiel-dead"

/mob/living/simple_animal/bird/yellowish_cockatiel
	name = "Yellowish Cockatiel"
	icon_state = "luttiel-flap"
	icon_living = "luttiel-flap"
	icon_dead = "luttiel-dead"

/mob/living/simple_animal/bird/grey_cockatiel
	name = "Grey Cockatiel"
	icon_state = "blutiel-flap"
	icon_living = "blutiel-flap"
	icon_dead = "blutiel-dead"

/mob/living/simple_animal/bird/too
	name = "Too"
	icon_state = "too-flap"
	icon_living = "too-flap"
	icon_dead = "too-dead"

/mob/living/simple_animal/bird/hooded_too
	name = "Utoo"
	icon_state = "utoo-flap"
	icon_living = "utoo-flap"
	icon_dead = "utoo-dead"

/mob/living/simple_animal/bird/pink_too
	name = "Mtoo"
	icon_state = "mtoo-flap"
	icon_living = "mtoo-flap"
	icon_dead = "mtoo-dead"

/obj/item/weapon/holder/bird
	name = "Bird"
	desc = "It's a bird!"
	icon_state = null
	item_icons = null
