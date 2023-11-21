/datum/species/monkey/shark
	name = SPECIES_MONKEY_AKULA
	name_plural = "Sobaka"
	icobase = 'icons/mob/human_races/monkeys/r_sobaka_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sobaka_vr.dmi'
	tail = null //The tail is part of its body due to tail using the "icons/effects/species.dmi" file. It must be null, or they'll have a chimp tail.
	greater_form = "Akula"
	default_language = "Skrellian" //Closest we have.

/datum/species/monkey/sergal
	name = SPECIES_MONKEY_SERGAL
	greater_form = "Sergal"
	icobase = 'icons/mob/human_races/monkeys/r_sergaling_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sergaling_vr.dmi'
	tail = null
	default_language = LANGUAGE_SAGARU

/datum/species/monkey/sparra
	name = SPECIES_MONKEY_NEVREAN
	name_plural = "Sparra"
	greater_form = "Nevrean"
	tail = null
	icobase = 'icons/mob/human_races/monkeys/r_sparra_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sparra_vr.dmi'
	default_language = LANGUAGE_BIRDSONG


/* Example from Polaris code
/datum/species/monkey/tajaran
	name = "Farwa"
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = "Tajaran"
	default_language = "Farwa"
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"
*/

/datum/species/monkey/vulpkanin
	name = SPECIES_MONKEY_VULPKANIN
	name_plural = "Wolpin"

	icobase = 'icons/mob/human_races/monkeys/r_wolpin.dmi'
	deform = 'icons/mob/human_races/monkeys/r_wolpin.dmi'

	greater_form = "Vulpkanin"
	default_language = LANGUAGE_CANILUNZT
	flesh_color = "#966464"
	base_color = "#000000"
	tail = null

//INSERT CODE HERE SO MONKEYS CAN BE SPAWNED.
//Also, M was added to the end of the spawn names to signify that it's a monkey, since some names were conflicting.

/mob/living/carbon/human/sharkm
	low_sorting_priority = TRUE

/mob/living/carbon/human/sharkm/New(var/new_loc)
	..(new_loc, "Sobaka")

/mob/living/carbon/human/sergallingm
	low_sorting_priority = TRUE

/mob/living/carbon/human/sergallingm/New(var/new_loc)
	..(new_loc, "Saru")

/mob/living/carbon/human/sparram
	low_sorting_priority = TRUE

/mob/living/carbon/human/sparram/New(var/new_loc)
	..(new_loc, "Sparra")

/mob/living/carbon/human/wolpin
	low_sorting_priority = TRUE

/mob/living/carbon/human/wolpin/New(var/new_loc)
	..(new_loc, "Wolpin")