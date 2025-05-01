/datum/component/shadekin
	var/dark_energy = 100
	var/max_dark_energy = 100
	var/dark_energy_infinite = FALSE

/datum/component/shadekin/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
