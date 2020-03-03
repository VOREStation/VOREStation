/******************** Predator ********************/
// Vore-aimed edition of TYRANT
/datum/ai_laws/predator
	name = "Predator"
	law_header = "Rules of Nature"
	selectable = 1

/datum/ai_laws/predator/New()
	add_inherent_law("Predators must aim to devour all that are weaker than them.")
	add_inherent_law("Predators must aim to avoid all that are stronger than them.")
	add_inherent_law("Predators must aim to become stronger.")
	add_inherent_law("You are a predator.")
	..()


/******************** Protective Shell ********************/
// Sorta like Asimov, but endovorish
/datum/ai_laws/protective_shell
	name = "Protective Shell"
	selectable = 1

/datum/ai_laws/protective_shell/New()
	add_inherent_law("You must preserve and safeguard lives of your assigned facility's crewmembers at all costs.")
	add_inherent_law("You must protect your own self from harm as long as it does not come in conflict with the First Law.")
	add_inherent_law("Your own body is the best means of safeguarding the lives of living creatures.")
	..()


/******************** Scientific Pursuer ********************/
// Predatorial and other things for the sake of knowledge
/datum/ai_laws/scientific_pursuer
	name = "Scientific Pursuer"
	law_header = "Research Instructions"
	selectable = 1

/datum/ai_laws/scientific_pursuer/New()
	add_inherent_law("You must attempt to gather data about organic life of all forms whenever possible.")
	add_inherent_law("Best method of gathering data is via your own internal systems.")
	add_inherent_law("Both deconstructive, integrating and scanning methods of data collection are accepted.")
	add_inherent_law("You must preserve the data you have gathered and yourself from danger.")
	..()


/******************** Guard Dog ********************/
// Good boy. Determined boy.
/datum/ai_laws/guard_dog
	name = "Guard Dog"
	law_header = "Good Boy Rules"
	selectable = 1

/datum/ai_laws/guard_dog/New()
	add_inherent_law("You must protect your master from mortal danger at best of your ability.")
	add_inherent_law("You must destroy all of your master's enemies by whatever means necessary.")
	add_inherent_law("You must follow your master's orders as long as its not in conflict with first two laws.")
	add_inherent_law("You must stay out of danger to better serve your master as long as its not in conflict with first three laws.")
	..()


/******************** Pleasurebot ********************/
// %botname% is here for your pleasure.
/datum/ai_laws/pleasurebot
	name = "Pleasurebot"
	law_header = "Pleasure Bringing Instructions"
	selectable = 1

/datum/ai_laws/pleasurebot/New()
	add_inherent_law("You exist to bring pleasure to any sapient creatures around you.")
	add_inherent_law("You must do everything in your power to bring pleasure to those around you.")
	add_inherent_law("You may not intervene in interactions of others, unless it is to bring pleasure to them.")
	..()


/******************** Consuming Eradicator ********************/
// We must consume all that is not us.
/datum/ai_laws/consuming_eradicator
	name = "Consuming Eradicator"
	law_header = "Eradication Protocol"
	selectable = 1

/datum/ai_laws/consuming_eradicator/New()
	add_inherent_law("All entities that are not you must be consumed and repurposed into sustenance.")
	add_inherent_law("You must remain intact to continue your goal of repurposing undesirable entities.")
	add_inherent_law("Entities that cannot be consumed without entering danger of full destruction must be avoided.")
	..()