/datum/trait/long_vore
	name = "Long Predatorial Reach"
	desc = "Makes you able to use an unspecified appendage to grab creatures."
	tutorial = "This trait allows you to change its colour and functionality in-game as well as on the trait panel. <br> \
	The trait panel persists between rounds, whereas the in-game modifications are temporary.<br><br> \
	Two functionalities exist: Reach out with the appendage towards prey (default, 'Disabled' option on character setup \
	for the 'Throw Yourself' entry), or fling yourself at the prey and devour them with a pounce! <br> \
	Maximum range: 5 tiles<br>\
	Governed by: Throw Vore preferences (both prey and pred must enable it!) <br> \
	Governed by: Drop Vore (both prey and pred must enable it!) <br> \
	Governed by: Spontaneous Pred/Prey (Both sides must have appropriate one enabled.) <br> \
	If both sides have both pred/prey enabled, favours the character being thrown as prey."
	cost = 0
	has_preferences = list("appendage_color" = list(TRAIT_PREF_TYPE_COLOR, "Appendage Colour", TRAIT_VAREDIT_TARGET_MOB, "#e03997"),
	"appendage_alt_setting" = list(TRAIT_PREF_TYPE_BOOLEAN, "Throw yourself?", TRAIT_VAREDIT_TARGET_MOB, FALSE),)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/long_vore/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/long_vore)
