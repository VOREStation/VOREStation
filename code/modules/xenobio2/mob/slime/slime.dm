/*
Slime definitions, Life and New live here.
*/
/mob/living/simple_animal/xeno/slime //Adult values are found here
	nameVar = "grey"		//When mutated, nameVar might change.
	desc = "A shifting, mass of goo."
	speak_emote = list("garbles", "chirps", "blurbles")
	colored = 1
	color = "#CACACA"
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime adult"
	icon_living = "slime adult"
	icon_dead = "slime adult dead"
	internal_vol = 200
	mut_max = 200
	mutable = COLORMUT
	var/is_child = 1
	var/cores = 3
	var/growthcounter = 0
	var/growthpoint = 150 //At what point they grow up.
	var/shiny = 0
	move_to_delay = 17 //Slimes shouldn't be able to go faster than humans.
	default_chems = list("slimejelly" = 5)
	
	var/emote_on = null
	
	maleable = 2
	
	//Slimes can speak all of the languages, oh no!
	universal_speak = 1
	speak_chance = 10
	speak = list( 
				"Northern Star?",
				"Hello?",
				"Where's this going?",
				"What's that?",
				"What's in the box?",
				"The?",
				"Transport?",
				"Special?",
				"Slime?"
				)

	//Overlay information
	var/overlay = 1 // 1 = normal lighting, 0 = shiny, 2 = too shiny, -1 = no overlay
	
	chemreact = list(	"nutriment" = list("nutr" = 5),
						"radium" = list("toxic" = 3, "mut" = 10),
						"mutagen" = list("nutr" = 4, "mut" = 20),
						"water" = list("nutr" = -1),
						"milk" = list("nutr" = 3),
						"sacid" = list("toxic" = 10),
						"pacid" = list("toxic" = 20),
						"chlorine" = list("toxic" = 5),
						"ammonia" = list("toxic" = 5),
						"sodawater" = list("toxic" = 1, "nutr" = -1),
						"beer" = list("nutr" = 6),
						"diethylamine" = list("nutr" = 9),
						"sugar" = list("toxic" = 4, "nutr" = 2),
						"eznutrient" = list("nutr" = 8),
						"cryoxadone" = list("toxic" = 4),
						"flourine" = list("toxic" = 1),
						"robustharvest" = list("nutr" = 15),
						"glucose" = list("nutr" = 5),
						"blood" = list("nutr" = 7.5, "toxic" = 0.5, "mut" = 4.5),
						"fuel" = list("toxic" = 4),
						"toxin" = list("toxic" = 5),
						"carpotoxin" = list("toxic" = 10, "mut" = 15),
						"phoron" = list("toxic" = 15, "mut" = 0.3),
						"cyanide" = list("toxic" = 35),
						"slimejelly" = list("nutr" = 5),
						"amutationtoxin" = list("toxic" = 1, "heal" = 15, "mut" = 30),
						"mutationtoxin" = list("toxic" = 1, "heal" = 10, "mut" = 15),
						"gold" = list("heal" = 3, "nutr" = 7, "mut" = 3),
						"uranium" = list("heal" = 3, "toxic" = 7, "mut" = 12),
						"glycerol" = list("nutr" = 6),
						"woodpulp" = list("heal" = 1, "nutr" = 7),
						"docilitytoxin" = list("nutr" = 3)	)
	
/mob/living/simple_animal/xeno/slime/New()
	..()
	GenerateChild()
	return 1