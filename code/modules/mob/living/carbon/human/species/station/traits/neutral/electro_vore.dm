/datum/trait/electrovore
	name = "Electrovore, Obligate"
	desc = "Makes you unable to gain nutrition from anything but electricity"
	tutorial = "HELP intent lets you consume nutrition to charge a Cell by clicking it in your hand.<br>\
	HARM intent drains battery charge and gives nutrition in exchange"

	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(/datum/trait/electrovore_freeform)

/datum/trait/electrovore/apply(var/datum/species/S, var/mob/living/carbon/human/human)
	..()
	ADD_TRAIT(human, TRAIT_ELECTROVORE, ROUNDSTART_TRAIT)
	ADD_TRAIT(human, TRAIT_ELECTROVORE_OBLIGATE, ROUNDSTART_TRAIT)

/datum/trait/electrovore_freeform
	name = "Electrovore"
	desc = "Allows you to drain power cells for nutrition."
	tutorial = "This trait allows you to consume electricity!<br>\
	Clicking a power cell in your hand on HARM intent drains its power for nutrition"

	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(/datum/trait/electrovore)

/datum/trait/electrovore_freeform/apply(var/datum/species/S, var/mob/living/carbon/human/human)
	..()
	ADD_TRAIT(human, TRAIT_ELECTROVORE, ROUNDSTART_TRAIT)
