/* Was disabled in setupgame.dm, likely nonfunctional
/datum/trait/disability_hallucinations
	name = "Disability: Hallucinations"
	desc = "..."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	mutation = mHallucination
	activation_message="Your mind says 'Hello'."
*/

/datum/trait/disability_epilepsy
	name = "Epilepsy"
	desc = "You experience periodic seizures."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You get a headache."
	primitive_expression_messages=list("shudders and twitches.")
	added_component_path = /datum/component/epilepsy_disability
	category = TRAIT_TYPE_NEGATIVE



/datum/trait/disability_cough
	name = "Coughing Fits"
	desc = "You can't stop yourself from coughing."
	cost = -1
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You start coughing."
	added_component_path = /datum/component/coughing_disability
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/disability_clumsy
	name = "Clumsy"
	desc = "You often make silly mistakes, or drop things."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel lightheaded."
	primitive_expression_messages=list("trips.")
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/disability_coprolalia
	name = "Coprolalia"
	desc = "You have periodic motor seizures, and cannot stop yourself from yelling profanity."
	cost = -2
	custom_only = FALSE

	is_genetrait = FALSE 	//VOREStation Note: TRAITGENETICS - Disabled on VS
	hidden = TRUE			//VOREStation Note: TRAITGENETICS - Disabled on VS

	activation_message="You twitch."
	primitive_expression_messages=list("twitches and chitters.")
	added_component_path = /datum/component/coprolalia_disability
	category = TRAIT_TYPE_NEGATIVE


/* Replaced by /datum/trait/blindness
/datum/trait/disability_blind
	name = "Blinded"
	desc = "You are unable to see anything."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	sdisability=BLIND
	activation_message="You can't seem to see anything."

/datum/trait/disability_blind/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		// In space, no one can hear you scream
*/

/datum/trait/disability_mute
	name = "Mute"
	desc = "You are unable to speak."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	sdisability=MUTE
	activation_message="Your throat feels strange..."
	primitive_expression_messages=list("screams without a sound.")
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/disability_mute/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		// In space, no one can hear you scream

/datum/trait/disability_deaf
	name = "Deaf"
	desc = "You are unable to hear anything."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	sdisability=DEAF
	activation_message="It's kinda quiet."
	primitive_expression_messages=list("stares blanky.")
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/disability_deaf/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		// In space, I can't hear shit

/datum/trait/disability_deaf/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	. = ..()
	H.ear_deaf = 1
	/* //Not used here, used downstream.
	if(H.stat != DEAD)
		H.deaf_loop.start(skip_start_sound = TRUE) // Ear Ringing/Deafness
	*/

/datum/trait/disability_deaf/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	H.ear_deaf = 0
	/* //Not used here, used downstream.
	H.deaf_loop.stop()
	*/

/datum/trait/disability_nearsighted
	name = "Nearsighted"
	desc = "You have difficulty seeing things far away."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=NEARSIGHTED
	activation_message="Your eyes feel weird..."
	primitive_expression_messages=list("squints and stares.")
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/disability_wingdings
	name = "Incomprehensible"
	desc = "You are unable to speak normally, everything you say comes out as insane gibberish."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=WINGDINGS
	activation_message="You feel a little... Ga-hoo!"
	primitive_expression_messages=list("zooks!","bloops!","boinks!")
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/disability_deteriorating
	name = "Rotting Genetics"
	desc = "Your body is slowly failing due to a chronic genetic disorder, expect to lose limbs or have organs shutdown randomly."
	cost = -4
	custom_only = FALSE

	is_genetrait = FALSE	//VOREStation Note: TRAITGENETICS - Disabled on VS
	hidden = TRUE			//VOREStation Note: TRAITGENETICS - Disabled on VS

	activation_message="You feel sore..."
	primitive_expression_messages=list("shudders.","gasps.","chokes.")
	added_component_path = /datum/component/rotting_disability
	category = TRAIT_TYPE_NEGATIVE



/datum/trait/disability_gibbing
	name = "Gibbingtons"
	desc = "Your body is on the edge of exploding, anything could set it off! A rare genetic disorder, only discovered with the invention of resleeving technology!"
	cost = -5
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = TRUE

	activation_message="You feel bloated..."
	primitive_expression_messages=list("shudders.","gasps.","chokes.")
	added_component_path = /datum/component/gibbing_disability
	category = TRAIT_TYPE_NEGATIVE



/datum/trait/disability_damagedspine
	name = "Lumbar Impairment"
	desc = "Due to neurological damage, you are unable to use your legs. Collapsing to the ground as soon as you try to stand. You should check the loadout menu for something to assist you."
	cost = -3
	custom_only = FALSE
	can_take = ORGANICS

	is_genetrait = TRUE
	hidden = FALSE
	activity_bounds = DNA_HARDER_BOUNDS // Shouldn't be easy for genetics to find this

	sdisability=SPINE
	activation_message="Your legs shake..."
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/ambulant_blood
	name = "Ambulant Blood"
	desc = "Your blood reacts to hostile stimulation such as burning when seperated from your body, as if it was its own creature. You WILL be mistaken for a changeling, you may want to document this in your medical records."
	var_changes = list("ambulant_blood" = TRUE)
	cost = 0
	can_take = ORGANICS

	is_genetrait = FALSE
	hidden = FALSE
	activity_bounds = DNA_HARDER_BOUNDS // Shouldn't be easy for genetics to find this

	activation_message="You feel like there are spiders in your veins..."
	category = TRAIT_TYPE_NEGATIVE
