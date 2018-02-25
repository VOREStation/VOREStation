/*
Slime definitions, Life and New live here.
*/
/mob/living/simple_animal/xeno/slime //Adult values are found here
	nameVar = "grey"		//When mutated, nameVar might change.
	desc = "A shifting, mass of goo."
	faction = "slime"
	speak_emote = list("garbles", "chirps", "blurbles")
	colored = 1
	color = "#CACACA"
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime adult"
	icon_living = "slime adult"
	icon_dead = "slime adult dead"
	internal_vol = 200
	mut_max = 50
	mutable = COLORMUT
	var/is_child = 1
	var/cores = 3
	var/growthcounter = 0
	var/growthpoint = 25 //At what point they grow up.
	var/shiny = 0
	move_to_delay = 17 //Slimes shouldn't be able to go faster than humans.
	default_chems = list("slimejelly" = 5)
	attacktext = list("absorbed some of")
	response_help = "pats"
	response_disarm = "tries to stop"
	response_harm = "hits"

	var/emote_on = null

	maleable = MAX_MALEABLE

	//Slimes can speak all of the languages, oh no!
	universal_speak = 1
	speak_chance = 1
	speak = list("Hello?",
				"Where is this going?",
				"What is that?",
				"What is in the box?",
				"Cargo.",
				"Transport?",
				"Special?",
				"Slime?")

	//Overlay information
	var/overlay = 1 // 1 = normal lighting, 0 = shiny, 2 = too shiny, -1 = no overlay

	chemreact = list(	"nutriment" = list("nutr" = 0.5),
						"radium" = list("toxic" = 0.3, "mut" = 1),
						"mutagen" = list("nutr" = 0.4, "mut" = 2),
						"water" = list("nutr" = -0.1),
						"milk" = list("nutr" = 0.3),
						"sacid" = list("toxic" = 1),
						"pacid" = list("toxic" = 2),
						"chlorine" = list("toxic" = 0.5),
						"ammonia" = list("toxic" = 0.5),
						"sodawater" = list("toxic" = 0.1, "nutr" = -0.1),
						"beer" = list("nutr" = 0.6),
						"diethylamine" = list("nutr" = 0.9),
						"sugar" = list("toxic" = 0.4, "nutr" = 0.2),
						"eznutrient" = list("nutr" = 0.8),
						"cryoxadone" = list("toxic" = 0.4),
						"flourine" = list("toxic" = 0.1),
						"robustharvest" = list("nutr" = 1.5),
						"glucose" = list("nutr" = 0.5),
						"blood" = list("nutr" = 0.75, "toxic" = 0.05, "mut" = 0.45),
						"fuel" = list("toxic" = 0.4),
						"toxin" = list("toxic" = 0.5),
						"carpotoxin" = list("toxic" = 1, "mut" = 1.5),
						"phoron" = list("toxic" = 1.5, "mut" = 0.03),
						"virusfood" = list("nutr" = 1.5, "mut" = 0.32),
						"cyanide" = list("toxic" = 3.5),
						"slimejelly" = list("nutr" = 0.5),
						"amutationtoxin" = list("toxic" = 0.1, "heal" = 1.5, "mut" = 3),
						"mutationtoxin" = list("toxic" = 0.1, "heal" = 1, "mut" = 1.5),
						"gold" = list("heal" = 0.3, "nutr" = 0.7, "mut" = 0.3),
						"uranium" = list("heal" = 0.3, "toxic" = 0.7, "mut" = 1.2),
						"glycerol" = list("nutr" = 0.6),
						"woodpulp" = list("heal" = 0.1, "nutr" = 0.7),
						"docilitytoxin" = list("nutr" = 0.3)	)

/mob/living/simple_animal/xeno/slime/New()
	..()
	for(var/datum/language/L in (typesof(/datum/language) - /datum/language))
		languages += L
	speak += "[station_name()]?"
	traitdat.source = "Slime"
	resistances[BURN] = 4
	resistances[BRUTE] = 0.2
	resistances[TOX] = 1.5
	GenerateChild()
	return 1
