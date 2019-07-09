/*******************
* TECHNICAL SKILLS *
*******************/

/datum/category_group/skill/technical
	name = "Technical"
	category_item_type = /datum/category_item/skill/technical

/datum/category_item/skill/technical/exosuits
	id = SKILL_EXOSUITS
	name = "Exosuit Operation"
	flavor_desc = "How well your character is able to pilot various kinds of exosuits."
	govern_desc = "Governs the ability to use exosuits on a general level. The various tools attached may demand \
	additional skills beyond this one."
	typical_desc = "A low level is typical of various professions with access to exosuits, such as miners, engineers, \
	and EMT personnel. A high level is typical of private security, police, or military specialists."
	levels = list(
		/datum/skill_level/exosuits/zero,
		/datum/skill_level/exosuits/one,
		/datum/skill_level/exosuits/two,
		/datum/skill_level/exosuits/three
		)

/datum/skill_level/exosuits/zero
	name = "Untrained"
	flavor_desc = "You are unfamiliar with exosuit controls, and if you attempt to use them you are liable to make mistakes."
	mechanics_desc = "Input is often scrambled when using any exosuit."

/datum/skill_level/exosuits/one
	name = "TODO 1"
	flavor_desc = "You have been trained in exosuit operation and safety for common civilian exosuits."
	mechanics_desc = "Can use ‘civilian’ exosuits like the Ripley or the Odysseus without penalties."
	cost = 10

/datum/skill_level/exosuits/two
	name = "TODO 2"
	flavor_desc = "You’ve worked with exosuits extensively, and you know how to safely use the more complicated exosuits intended for combat operations."
	mechanics_desc = "Can additionally use the ‘combat’ exosuits like the Durand or the Gygax without penalties."
	cost = 30

/datum/skill_level/exosuits/three
	name = "TODO 3"
	flavor_desc = "Your exosuits’ cockpit is like a second home to you. You know how to get the most out of controlling a huge machine surrounding you."
	mechanics_desc = null
	enhancing = TRUE
	cost = 60

