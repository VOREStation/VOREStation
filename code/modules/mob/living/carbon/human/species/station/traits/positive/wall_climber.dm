
/datum/trait/wall_climber
	name = "Climber, Amateur"
	desc = "You can climb certain walls without tools! This is likely a personal skill you developed. You can also climb lattices and ladders a little bit faster than everyone else."
	tutorial = "You must approach a wall and right click it and select the \
	'climb wall' verb to climb it. You suffer from a movement delay of 1.5 with this trait.\n \
	Your total climb time is expected to be 17.5 seconds. Tools may reduce this. \n\n \
	This likewise allows descending walls, provided you're facing an empty space and standing on \
	a climbable wall. To climbe like so, use the verb 'Climb Down Wall' in IC tab!"
	cost = 1
	custom_only = FALSE
	banned_species = list(SPECIES_TAJARAN, SPECIES_VASILISSAN)	// They got unique climbing delay.
	var_changes = list("can_climb" = TRUE, "climb_mult" = 0.75)
	excludes = list(/datum/trait/wall_climber_pro, /datum/trait/wall_climber_natural)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/wall_climber_natural
	name = "Climber, Natural"
	desc = "You can climb certain walls without tools! This is likely due to the unique anatomy of your species. You can climb lattices and ladders slightly faster than everyone else. CUSTOM AND XENOCHIM ONLY"
	tutorial = "You must approach a wall and right click it and select the \
	'climb wall' verb to climb it. You suffer from a movement delay of 1.5 with this trait.\n \
	Your total climb time is expected to be 17.5 seconds. Tools may reduce this. \n\n \
	This likewise allows descending walls, provided you're facing an empty space and standing on \
	a climbable wall. To climbe like so, use the verb 'Climb Down Wall' in IC tab!"
	cost = 0
	custom_only = FALSE
	var_changes = list("can_climb" = TRUE, "climb_mult" = 0.75)
	allowed_species = list(SPECIES_XENOCHIMERA, SPECIES_CUSTOM)	//So that we avoid needless bloat for xenochim
	excludes = list(/datum/trait/wall_climber_pro, /datum/trait/wall_climber)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/wall_climber_pro
	name = "Climber, Professional"
	desc = "You can climb certain walls without tools! You are a professional rock climber at this, letting you climb almost twice as fast! You can also climb lattices and ladders a fair bit faster than everyone else!"
	tutorial = "You must approach a wall and right click it and select the \
	'climb wall' verb to climb it. Your movement delay is just 1.25 with this trait.\n \
	Your climb time is expected to be 9 seconds. Tools may reduce this. \n\n \
	This likewise allows descending walls, provided you're facing an empty space and standing on \
	a climbable wall. To climbe like so, use the verb 'Climb Down Wall' in IC tab!"
	cost = 2
	custom_only = FALSE
	var_changes = list("climbing_delay" = 1.25, "climb_mult" = 0.5)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/wall_climber,/datum/trait/wall_climber_natural)
	category = TRAIT_TYPE_POSITIVE

// This feels jank, but it's the cleanest way I could do TRAIT_VARCHANGE_LESS_BETTER while having a boolean var change
// Alternate would've been banned_species = list(SPECIES_TAJARAN, SPECIES_VASSILISIAN)
// Opted for this as it's "future proof"
/datum/trait/wall_climber_pro/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	S.can_climb = TRUE
