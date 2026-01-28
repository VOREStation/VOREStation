/datum/trait/photodegeneration
	name = "Photodegeneration"
	desc = "Without the protection of darkness or a suit your body quickly begins to break down when exposed to light."
	cost = -4
	is_genetrait = TRUE // There is no upside, a neat landmine for genetics
	hidden = TRUE //Disabled on Virgo
	can_take = ORGANICS
	added_component_path = /datum/component/burninlight // Literally just Zaddat, but you don't start with any suit. Good luck.
	category = TRAIT_TYPE_NEGATIVE
