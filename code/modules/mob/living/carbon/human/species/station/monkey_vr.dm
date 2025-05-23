/datum/species/monkey/shark
	name = SPECIES_MONKEY_AKULA
	name_plural = "Sobaka"
	icobase = 'icons/mob/human_races/monkeys/r_sobaka_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sobaka_vr.dmi'
	tail = null //The tail is part of its body due to tail using the "icons/effects/species.dmi" file. It must be null, or they'll have a chimp tail.
	greater_form = SPECIES_AKULA
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
	greater_form = SPECIES_NEVREAN
	tail = null
	icobase = 'icons/mob/human_races/monkeys/r_sparra_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sparra_vr.dmi'
	default_language = LANGUAGE_BIRDSONG


/* Example from Polaris code
/datum/species/monkey/tajaran
	name = SPECIES_MONKEY_TAJ
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = SPECIES_TAJARAN
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

	greater_form = SPECIES_VULPKANIN
	default_language = LANGUAGE_CANILUNZT
	flesh_color = "#966464"
	base_color = "#000000"
	tail = null

//INSERT CODE HERE SO MONKEYS CAN BE SPAWNED.
//Also, M was added to the end of the spawn names to signify that it's a monkey, since some names were conflicting.

/mob/living/carbon/human/sharkm
	low_sorting_priority = TRUE

/mob/living/carbon/human/sharkm/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_AKULA)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)

/mob/living/carbon/human/sergallingm
	low_sorting_priority = TRUE

/mob/living/carbon/human/sergallingm/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_SERGAL)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)

/mob/living/carbon/human/sparram
	low_sorting_priority = TRUE

/mob/living/carbon/human/sparram/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_NEVREAN)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)

/mob/living/carbon/human/wolpin
	low_sorting_priority = TRUE

/mob/living/carbon/human/wolpin/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_VULPKANIN)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)
