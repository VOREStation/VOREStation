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