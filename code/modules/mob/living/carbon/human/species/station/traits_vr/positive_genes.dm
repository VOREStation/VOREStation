/datum/trait/positive/superpower_nobreathe
	name = "No Breathing"
	desc = "You do not need to breathe."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = TRUE // Cannot start with superpowers

	mutation = mNobreath
	activity_bounds = DNA_HARD_BOUNDS
	activation_message="You feel no need to breathe."

/*
/datum/trait/positive/superpower_remoteview
	name = "Remote Viewing"
	desc = "Remotely view other locations."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARDER_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = mRemote
	activation_message="Your mind expands."

/datum/trait/positive/superpower_remoteview/apply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/living/carbon/human/proc/remoteobserve)

/datum/trait/positive/superpower_remoteview/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	if(/mob/living/carbon/human/proc/remoteobserve in S.inherent_verbs)
		remove_verb(H, /mob/living/carbon/human/proc/remoteobserve)
*/

/datum/trait/positive/superpower_regenerate
	name = "Regenerate"
	desc = "Repairs wounds slowly, including internal bleeding."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARDER_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = mRegen
	activation_message="You feel better."
	primitive_expression_messages=list("'s skin shift's strangely.")

/* Replaced by /datum/trait/positive/speed_fast
/datum/trait/positive/superpower_increaserun
	name = "Super Speed"
	desc = "Remotely communicate"
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARDER_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = mRun
	activation_message="Your leg muscles pulsate."
*/

/datum/trait/positive/superpower_remotetalk
	name = "Telepathy"
	desc = "Remotely communicate"
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = TRUE // Cannot start with superpowers

	mutation = mRemotetalk
	activity_bounds = DNA_HARDER_BOUNDS
	activation_message="You expand your mind outwards."
	primitive_expression_messages=list("makes noises to itself.")

/datum/trait/positive/superpower_remotetalk/apply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/living/carbon/human/proc/remotesay)

/datum/trait/positive/superpower_remotetalk/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	if(!(/mob/living/carbon/human/proc/remotesay in S.inherent_verbs))
		remove_verb(H, /mob/living/carbon/human/proc/remotesay)

/datum/trait/positive/superpower_noprints
	name = "No Prints"
	desc = "Your hands leave no fingerprints behind."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = TRUE // Cannot start with superpowers

	mutation = mFingerprints
	activation_message="Your fingers feel numb."
	primitive_expression_messages=list("flexes its digits.")


/datum/trait/positive/superpower_xray //This is effectively thermals.
	name = "X-Ray Vision"
	desc = "You can see through walls."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARDER_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = XRAY
	activation_message="The walls suddenly disappear."
	primitive_expression_messages=list("stares at something it cannot see.")

/datum/trait/positive/superpower_tk
	name = "Telekenesis"
	desc = "You can move objects with your mind."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARD_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = TK
	activation_message="You feel smarter."
	primitive_expression_messages=list("grabs at something it cannot reach.")

/datum/trait/positive/superpower_laser
	name = "Laser Vision"
	desc = "You can blast lasers from your eyes."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARD_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = LASER
	activation_message="Your eyes feel strange..."

/datum/trait/positive/superpower_hulk
	name = "Hulk"
	desc = "UURGG SMASH TINY TESHARI"
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARD_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = HULK
	activation_message="Your muscles hurt."
	deactivation_message=span_warning("You suddenly feel very weak.")

/datum/trait/positive/superpower_hulk/handle_environment_special(mob/living/carbon/human/H)
	if(H.health <= 25)
		if(H.dna)
			H.dna.SetSEState(linked_gene.block, FALSE, FALSE) // Turn this thing off or so help me--
			domutcheck(H,null,MUTCHK_FORCED)
		H.mutations.Remove(HULK)
		H.Weaken(3)
		H.emote("collapse")

/datum/trait/positive/superpower_flashproof
	name = "Flash Resistance"
	desc = "Your eyes are protected against sudden flashes of intense light."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARDER_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	mutation = FLASHPROOF
	activation_message="Your eyes feel more robust, how nifty..."

/datum/trait/positive/superpower_morph
	name = "Morph"
	desc = "Allows complex bodily transformations."
	cost = 5
	custom_only = FALSE

	is_genetrait = TRUE
	activity_bounds = DNA_HARDER_BOUNDS
	hidden = TRUE // Cannot start with superpowers

	activation_message="You feel more fluid."
	primitive_expression_messages=list("twitches and distorts.")

/datum/trait/positive/superpower_morph/apply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/living/carbon/human/proc/shapeshfit_form)

/datum/trait/positive/superpower_morph/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	remove_verb(H, /mob/living/carbon/human/proc/shapeshfit_form)

/mob/living/carbon/human/proc/shapeshfit_form()
	set name = "Transform Shape"
	set category = "Abilities.Superpower"
	var/datum/tgui_module/appearance_changer/superpower/V = new(src, src)
	V.tgui_interact(src)
