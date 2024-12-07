/*
Slime definitions, Life and New live here.
*/
/mob/living/simple_mob/xeno/slime //Adult values are found here
	nameVar = "grey"		//When mutated, nameVar might change.
	desc = "A shifting, mass of goo."
	faction = FACTION_SLIME
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
	default_chems = list(REAGENT_ID_SLIMEJELLY = 5)
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

	chemreact = list(	REAGENT_ID_NUTRIMENT = list(XENO_CHEM_NUTRI = 0.5),
						REAGENT_ID_RADIUM = list(XENO_CHEM_TOXIC = 0.3, XENO_CHEM_MUT = 1),
						REAGENT_ID_MUTAGEN = list(XENO_CHEM_NUTRI = 0.4, XENO_CHEM_MUT = 2),
						REAGENT_ID_WATER = list(XENO_CHEM_NUTRI = -0.1),
						"milk" = list(XENO_CHEM_NUTRI = 0.3),
						REAGENT_ID_SACID = list(XENO_CHEM_TOXIC = 1),
						REAGENT_ID_PACID = list(XENO_CHEM_TOXIC = 2),
						REAGENT_ID_CHLORINE = list(XENO_CHEM_TOXIC = 0.5),
						REAGENT_ID_AMMONIA = list(XENO_CHEM_TOXIC = 0.5),
						"sodawater" = list(XENO_CHEM_TOXIC = 0.1, XENO_CHEM_NUTRI = -0.1),
						"beer" = list(XENO_CHEM_NUTRI = 0.6),
						REAGENT_ID_DIETHYLAMINE = list(XENO_CHEM_NUTRI = 0.9),
						REAGENT_ID_SUGAR = list(XENO_CHEM_TOXIC = 0.4, XENO_CHEM_NUTRI = 0.2),
						REAGENT_ID_EZNUTRIENT = list(XENO_CHEM_NUTRI = 0.8),
						"cryoxadone" = list(XENO_CHEM_TOXIC = 0.4),
						"flourine" = list(XENO_CHEM_TOXIC = 0.1),
						REAGENT_ID_ROBUSTHARVEST = list(XENO_CHEM_NUTRI = 1.5),
						"glucose" = list(XENO_CHEM_NUTRI = 0.5),
						REAGENT_ID_BLOOD = list(XENO_CHEM_NUTRI = 0.75, XENO_CHEM_TOXIC = 0.05, XENO_CHEM_MUT = 0.45),
						REAGENT_ID_FUEL = list(XENO_CHEM_TOXIC = 0.4),
						REAGENT_ID_TOXIN = list(XENO_CHEM_TOXIC = 0.5),
						REAGENT_ID_CARPOTOXIN = list(XENO_CHEM_TOXIC = 1, XENO_CHEM_MUT = 1.5),
						REAGENT_ID_PHORON = list(XENO_CHEM_TOXIC = 1.5, XENO_CHEM_MUT = 0.03),
						"virusfood" = list(XENO_CHEM_NUTRI = 1.5, XENO_CHEM_MUT = 0.32),
						REAGENT_ID_CYANIDE = list(XENO_CHEM_TOXIC = 3.5),
						REAGENT_ID_SLIMEJELLY = list(XENO_CHEM_NUTRI = 0.5),
						"amutationtoxin" = list(XENO_CHEM_TOXIC = 0.1, XENO_CHEM_HEAL = 1.5, XENO_CHEM_MUT = 3),
						REAGENT_ID_MUTATIONTOXIN = list(XENO_CHEM_TOXIC = 0.1, XENO_CHEM_HEAL = 1, XENO_CHEM_MUT = 1.5),
						REAGENT_ID_GOLD = list(XENO_CHEM_HEAL = 0.3, XENO_CHEM_NUTRI = 0.7, XENO_CHEM_MUT = 0.3),
						REAGENT_ID_URANIUM = list(XENO_CHEM_HEAL = 0.3, XENO_CHEM_TOXIC = 0.7, XENO_CHEM_MUT = 1.2),
						REAGENT_ID_GLYCEROL = list(XENO_CHEM_NUTRI = 0.6),
						REAGENT_ID_WOODPULP = list(XENO_CHEM_HEAL = 0.1, XENO_CHEM_NUTRI = 0.7),
						REAGENT_ID_MUTATIONTOXIN = list(XENO_CHEM_NUTRI = 0.3)	)

/mob/living/simple_mob/xeno/slime/New()
	..()
	for(var/datum/language/L in subtypesof(/datum/language))
		languages += L
	speak += "[station_name()]?"
	traitdat.source = "Slime"
	resistances[BURN] = 4
	resistances[BRUTE] = 0.2
	resistances[TOX] = 1.5
	GenerateChild()
	return 1
