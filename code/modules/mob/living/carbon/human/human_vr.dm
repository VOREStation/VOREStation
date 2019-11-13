//Crazy alternate human stuff
/mob/living/carbon/human/New()
	. = ..()

	var/animal = pick("cow","chicken_brown", "chicken_black", "chicken_white", "chick", "mouse_brown", "mouse_gray", "mouse_white", "lizard", "cat2", "goose", "penguin")
	var/image/img = image('icons/mob/animal.dmi', src, animal)
	img.override = TRUE
	add_alt_appearance("animals", img, displayTo = alt_farmanimals)


/mob/living/carbon/human/Destroy()
	alt_farmanimals -= src

	. = ..()

/mob/living/carbon/human
	var/emoteDanger = 1 // What the current danger for spamming emotes is - shared between different types of emotes to keep people from just
										// flip/snap/flip/snap.  Decays at a rate of 1 per second to a minimum of 1.