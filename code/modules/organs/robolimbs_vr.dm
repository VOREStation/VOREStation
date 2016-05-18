/datum/robolimb
	var/unavailable_to_produce	//Makes robolimbs not listed in exosuit fabs. AKA you have to varedit them on or spawn them.
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.

/datum/robolimb/kitsuhana
	company = "Kitsuhana"
	desc = "This limb seems rather vulpine and fuzzy, with realistic-feeling flesh."
	icon = 'icons/mob/human_races/cyberlimbs/kitsuhana.dmi'
	includes_tail = 1
	unavailable_to_produce = 1
	unavailable_at_chargen = 1
