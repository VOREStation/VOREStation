/datum/trait/linguist
	name = "Linguist"
	desc = "Allows you to have more languages."
	cost = 1
	var_changes = list("num_alternate_languages" = 6)
	var_changes_pref = list("extra_languages" = 3)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER
	category = TRAIT_TYPE_POSITIVE

/datum/trait/linguist/master
	name = "Master Linguist"
	desc = "You are a master of languages! For whatever reason you might have, you are able to learn many more languages than others. Your language cap is 12 slots."
	cost = 2
	var_changes = list("num_alternate_languages" = 15)
	var_changes_pref = list("extra_languages" = 12)
	category = TRAIT_TYPE_POSITIVE
