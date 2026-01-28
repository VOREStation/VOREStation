/datum/trait/bloodsucker
	name = "Bloodsucker, Obligate"
	desc = "Makes you unable to gain nutrition from anything but blood. To compenstate, you get fangs that can be used to drain blood from prey."
	tutorial = "This trait forces you to only consume blood - you cannot have normal food anymore. Vore is, of course, an exception! <br> \
		You can satisfy this by clicking bloodbags in your hand on harm intent, drinking from glasses, blood tomatoes \
		or finding a (un)willing donor for your appropriate appendage! <br><br> \
		Controls for taking blood from your victim can be changed at will by trying to drink from yourself. <br>\
		Intent-based control scheme: <br> \
		HELP - Loud, No Bleeding <br> \
		DISARM - Subtle, Causes bleeding <br> \
		GRAB - Subtle, No Bleeding <br> \
		HARM - Loud, Causes Bleeding"

	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("organic_food_coeff" = 0, "bloodsucker" = TRUE) //The verb is given in human.dm
	excludes = list(/datum/trait/bloodsucker_freeform)

/datum/trait/bloodsucker/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/bloodsuck)

/datum/trait/bloodsucker_freeform
	name = "Bloodsucker"
	desc = "You get fangs that can be used to drain blood from prey."
	tutorial = "This trait allows you to consume blood on top of normal food! <br> \
		You can do this by clicking bloodbags in your hand on harm intent, drinking from glasses, blood tomatoes \
		or finding a (un)willing donor for your appropriate appendage! <br><br> \
		Controls for taking blood from your victim can be changed at will by trying to drink from yourself. <br>\
		Intent-based control scheme: <br> \
		HELP - Loud, No Bleeding <br> \
		DISARM - Subtle, Causes bleeding <br> \
		GRAB - Subtle, No Bleeding <br> \
		HARM - Loud, Causes Bleeding"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("bloodsucker" = TRUE)
	excludes = list(/datum/trait/bloodsucker)

/datum/trait/bloodsucker_freeform/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/bloodsuck)
