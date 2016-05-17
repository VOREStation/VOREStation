/datum/species/sergal
	name = "Sergal"
	name_plural = "Sergals"
	icobase = 'icons/mob/human_races/r_sergal.dmi'
	deform = 'icons/mob/human_races/r_def_sergal.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	//gluttonous = 1
	num_alternate_languages = 2
	secondary_langs = list("Sagaru")
	name_language = "Sagaru"
	color_mult = 1
	egg_type = "Sergal"

	min_age = 17
	max_age = 80

	blurb = "There are two subspecies of Sergal; Southern and Northern. Northern sergals are a highly aggressive race \
	that lives in the plains and tundra of their homeworld. They are characterized by long, fluffy fur bodies with cold colors; \
	usually with white abdomens, somewhat short ears, and thick faces. Southern sergals are much more docile and live in the \
	Gold Ring City and are scattered around the outskirts in rural areas and small towns. They usually have short, brown or yellow \
	(or other 'earthy' colors) fur, long ears, and a long, thin face. They are smaller than their Northern relatives. Both have strong \
	racial tensions which has resulted in more than a number of wars and outright attempts at genocide. Sergals have an incredibly long \
	lifespan, but due to their lust for violence, only a handful have ever survived beyond the age of 80, such as the infamous and \
	legendary General Rain Silves who is claimed to have lived to 5000."

	primitive_form = "Farwa" //POLARISTODO - Add other monkeytypes

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_SERGAL

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/akula
	name = "Akula"
	name_plural = "Akula"
	icobase = 'icons/mob/human_races/r_akula.dmi'
	deform = 'icons/mob/human_races/r_def_akula.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	//gluttonous = 1
	num_alternate_languages = 2
	secondary_langs = list("Skrellian")
	name_language = "Skrellian"
	color_mult = 1
	egg_type = "Akula"

	min_age = 17
	max_age = 80

	blurb = "The Akula are a species of amphibious humanoids like the Skrell, but have an appearance very similar to that of a shark. \
	They were first discovered as a primitive race of underwater dwelling tribal creatures by the Skrell. At first they were not believed \
	to be noteworthy, but the Akula proved to be such swift and clever learners that the Skrell reclassified them as sentients. Allegedly, \
	the Akula were also the first sentient life that the Skrell had ever encountered beside themselves, and thus the two species became swift \
	allies over the next few hundred years. With the help of Skrellean technology, the Akula had their genome modified to be capable of \
	surviving in open air for long periods of time. However, Akula even today still require a high humidity environment to avoid drying out \
	after a few days, which would make life on an arid world like Virgo-Prime nearly impossible if it were not for Skrellean technology to aid them."

	primitive_form = "Farwa" //POLARISTODO - Add other monkeytypes

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_AKULA

/datum/species/nevrean
	name = "Nevrean"
	name_plural = "Nevreans"
	icobase = 'icons/mob/human_races/r_nevrean.dmi'
	deform = 'icons/mob/human_races/r_def_nevrean.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	//gluttonous = 1
	num_alternate_languages = 2
	secondary_langs = list("Birdsong")
	name_language = "Birdsong"
	color_mult = 1
	egg_type = "Nevrean"

	min_age = 17
	max_age = 80

	blurb = "Nevreans are a race of avian and dinosaur-like creatures living on Tal. They belong to a group of races that hails from Eltus. "

	primitive_form = "Farwa" //POLARISTODO - Add other monkeytypes

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_SERGAL

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/hi_zoxxen
	name = "Highlander Zorren"
	name_plural = "Zorren"
	icobase = 'icons/mob/human_races/r_fox.dmi'
	deform = 'icons/mob/human_races/r_def_fox.dmi'
	tail = "tail"
	icobase_tail = 1
	//primitive_form = /mob/living/carbon/monkey/tajara //We don't have fennec-monkey sprites.
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	num_alternate_languages = 2
	secondary_langs = list("Siik'tajr")
	name_language = "Siik'tajr"
	egg_type = "Tajaran" //Placeholder.

	min_age = 17
	max_age = 80

	blurb = "The fox-like Zorren are native to Virgo-Prime, however there are two distinct varieties of Zorren one with large ears and shorter fur, and the other with longer fur that is a bit more vibrant.  \
	The long-eared, short-furred Zorren have come to be known as Flatland Zorren as that is where most of their settlements are located. \
	The Flatland Zorren are somewhat tribal and shamanistic as they have only recently started to be hired by the Trans-Stellar Corporations. \
	The other variety of Zorren are known as Highland Zorren as they frequently settle in hilly and/or mountainous areas, \
	they have a differing societal structure than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren, \
	the Highland Zorren have also only recently been hired by the Trans-Stellar Corporations, but thanks to the different social structure they seem to have adjusted better to their new lives. \
	Though similar fox-like beings have been seen they are different than the Zorren."
/* VOREStation Removal
	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80 //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000
*/
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	flesh_color = "#AFA59E"
	base_color = "#333333"
	color_mult = 1

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/fl_zorren
	name = "Flatland Zorren"
	name_plural = "Zorren"
	icobase = 'icons/mob/human_races/r_fennec.dmi'
	deform = 'icons/mob/human_races/r_def_fennec.dmi'
	tail = "tail"
	icobase_tail = 1
	//primitive_form = /mob/living/carbon/monkey/tajara //We don't have fennec-monkey sprites.
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	num_alternate_languages = 2
	secondary_langs = list("Siik'tajr")
	name_language = "Siik'tajr"
	egg_type = "Tajaran" //Placeholder.

	min_age = 17
	max_age = 80

	blurb = "The fox-like Zorren are native to Virgo-Prime, however there are two distinct varieties of Zorren one with large ears and shorter fur, and the other with longer fur that is a bit more vibrant.  \
	The long-eared, short-furred Zorren have come to be known as Flatland Zorren as that is where most of their settlements are located. \
	The Flatland Zorren are somewhat tribal and shamanistic as they have only recently started to be hired by the Trans-Stellar Corporations. \
	The other variety of Zorren are known as Highland Zorren as they frequently settle in hilly and/or mountainous areas, \
	they have a differing societal structure than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren, \
	the Highland Zorren have also only recently been hired by the Trans-Stellar Corporations, but thanks to the different social structure they seem to have adjusted better to their new lives. \
	Though similar fox-like beings have been seen they are different than the Zorren."
/* VOREStation Removal
	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 430 //Default 360 - Higher is better
	heat_level_2 = 500 //Default 400
	heat_level_3 = 1100 //Default 1000
*/
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"
	color_mult = 1

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)



/datum/species/unathi
	egg_type = "Unathi"

/datum/species/tajaran
	egg_type = "Tajaran"

/datum/species/skrell
	egg_type = "Skrell"

/datum/species/shapeshifter/promethean
	egg_type = "Slime"

/datum/species/human
	egg_type = "Human"