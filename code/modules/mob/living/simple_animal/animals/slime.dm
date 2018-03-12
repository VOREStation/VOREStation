/mob/living/simple_animal/old_slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	tt_desc = "Amorphidae proteus"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	icon_living = "grey baby slime"
	icon_dead = "grey baby slime dead"

	maxHealth = 100
	health = 100

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	speak_chance = 1
	speak_emote = list("chirps")
	emote_see = list("jiggles", "bounces in place")

	var/colour = "grey"

/mob/living/simple_animal/old_slime/science
	name = "Kendrick"
	colour = "rainbow"
	icon_state = "rainbow baby slime"
	icon_living = "rainbow baby slime"
	icon_dead = "rainbow baby slime dead"

/mob/living/simple_animal/old_slime/science/initialize()
	. = ..()
	overlays.Cut()
	overlays += "aslime-:33"

/mob/living/simple_animal/adultslime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey adult slime"
	icon_living = "grey adult slime"
	icon_dead = "grey baby slime dead"

	maxHealth = 200
	health = 200

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	speak_chance = 1
	emote_see = list("jiggles", "bounces in place")

	var/colour = "grey"

/mob/living/simple_animal/adultslime/New()
	..()
	overlays += "aslime-:33"

/mob/living/simple_animal/adultslime/death()
	var/mob/living/simple_animal/old_slime/S1 = new /mob/living/simple_animal/old_slime (src.loc)
	S1.icon_state = "[src.colour] baby slime"
	S1.icon_living = "[src.colour] baby slime"
	S1.icon_dead = "[src.colour] baby slime dead"
	S1.colour = "[src.colour]"
	var/mob/living/simple_animal/old_slime/S2 = new /mob/living/simple_animal/old_slime (src.loc)
	S2.icon_state = "[src.colour] baby slime"
	S2.icon_living = "[src.colour] baby slime"
	S2.icon_dead = "[src.colour] baby slime dead"
	S2.colour = "[src.colour]"
	qdel(src)