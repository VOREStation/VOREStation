/datum/trait/negative
	category = TRAIT_TYPE_NEGATIVE

/* Was disabled in setupgame.dm, likely nonfunctional
/datum/trait/negative/disability_hallucinations
	name = "Disability: Hallucinations"
	desc = "..."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	mutation = mHallucination
	activation_message="Your mind says 'Hello'."
*/

/datum/trait/negative/disability_epilepsy
	name = "Epilepsy"
	desc = "You experience periodic seizures."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=EPILEPSY
	activation_message="You get a headache."
	primitive_expression_messages=list("shudders and twitches.")

/datum/trait/negative/disability_cough
	name = "Coughing Fits"
	desc = "You can't stop yourself from coughing."
	cost = -1
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=COUGHING
	activation_message="You start coughing."

/datum/trait/negative/disability_clumsy
	name = "Clumsy"
	desc = "You often make silly mistakes, or drop things."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	mutation=CLUMSY
	activation_message="You feel lightheaded."
	primitive_expression_messages=list("trips.")

/datum/trait/negative/disability_tourettes
	name = "Tourettes Syndrome"
	desc = "You have periodic motor seizures, and cannot stop yourself from yelling profanity."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=TOURETTES
	activation_message="You twitch."
	primitive_expression_messages=list("twitches and chitters.")

/datum/trait/negative/disability_anxiety
	name = "Anxiety Disorder"
	desc = "You have extreme anxiety, often stuttering words."
	cost = -1
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=NERVOUS
	activation_message="You feel nervous."
	primitive_expression_messages=list("anxiously chitters.")

/* Replaced by /datum/trait/negative/blindness
/datum/trait/negative/disability_blind
	name = "Blinded"
	desc = "You are unable to see anything."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	sdisability=BLIND
	activation_message="You can't seem to see anything."

/datum/trait/negative/disability_blind/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		// In space, no one can hear you scream
*/

/datum/trait/negative/disability_mute
	name = "Mute"
	desc = "You are unable to speak."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	sdisability=MUTE
	activation_message="Your throat feels strange..."
	primitive_expression_messages=list("screams without a sound.")

/datum/trait/negative/disability_mute/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		// In space, no one can hear you scream

/datum/trait/negative/disability_deaf
	name = "Deaf"
	desc = "You are unable to hear anything."
	cost = -3
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	sdisability=DEAF
	activation_message="It's kinda quiet."
	primitive_expression_messages=list("stares blanky.")

/datum/trait/negative/disability_deaf/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		// In space, I can't hear shit

/datum/trait/negative/disability_deaf/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	. = ..()
	H.ear_deaf = 1
	/* //Not used here, used downstream.
	if(H.stat != DEAD)
		H.deaf_loop.start(skip_start_sound = TRUE) // Ear Ringing/Deafness
	*/

/datum/trait/negative/disability_deaf/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	H.ear_deaf = 0
	/* //Not used here, used downstream.
	H.deaf_loop.stop()
	*/

/datum/trait/negative/disability_nearsighted
	name = "Nearsighted"
	desc = "You have difficulty seeing things far away."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=NEARSIGHTED
	activation_message="Your eyes feel weird..."
	primitive_expression_messages=list("squints and stares.")

/datum/trait/negative/disability_wingdings
	name = "Incomprehensible"
	desc = "You are unable to speak normally, everything you say comes out as insane gibberish."
	cost = -2
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=WINGDINGS
	activation_message="You feel a little... Ga-hoo!"
	primitive_expression_messages=list("zooks!","bloops!","boinks!")

/datum/trait/negative/disability_deteriorating
	name = "Rotting Genetics"
	desc = "Your body is slowly failing due to a chronic genetic disorder, expect to lose limbs or have organs shutdown randomly."
	cost = -4
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=DETERIORATE
	activation_message="You feel sore..."
	primitive_expression_messages=list("shudders.","gasps.","chokes.")

/datum/trait/negative/disability_gibbing
	name = "Gibbingtons"
	desc = "Your body is on the edge of exploding, anything could set it off! A rare genetic disorder, only discovered with the invention of resleeving technology!"
	cost = -5
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = TRUE

	disability=GIBBING
	activation_message="You feel bloated..."
	primitive_expression_messages=list("shudders.","gasps.","chokes.")

/datum/trait/negative/disability_censored
	name = "Censored"
	desc = "You are unable to speak profanity. To an excessive degree..."
	cost = -1
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=CENSORED
	activation_message="You feel less rude..."
	primitive_expression_messages=list("BEEPS!")

/datum/trait/negative/disability_damagedspine
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
