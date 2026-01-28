/datum/trait/winged_flight
	name = "Winged Flight"
	desc = "Allows you to fly by using your wings. Don't forget to bring them!"
	cost = 0
	custom_only = FALSE
	has_preferences = list("flight_vore" = list(TRAIT_PREF_TYPE_BOOLEAN, "Flight Vore enabled on spawn", TRAIT_VAREDIT_TARGET_MOB, FALSE))
	category = TRAIT_TYPE_POSITIVE

/datum/trait/winged_flight/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/flying_toggle)
	add_verb(H, /mob/living/proc/flying_vore_toggle)
	add_verb(H, /mob/living/proc/start_wings_hovering)
