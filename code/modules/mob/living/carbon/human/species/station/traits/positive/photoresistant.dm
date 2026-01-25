/datum/trait/photoresistant
	name = "Photoresistant"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 20%"
	cost = 1
	var_changes = list("flash_mod" = 0.8)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/photoresistant_plus
	name = "Photoresistance, Major"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 50%."
	cost = 2
	var_changes = list("flash_mod" = 0.5)
	category = TRAIT_TYPE_POSITIVE
