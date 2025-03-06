// This file contains any stuff related to admin-visible traits.
// There's likely more than a few traits missing from this file, do consult the `_traits.dm` file in this folder to see every global trait that exists.
// quirks have their own panel so we don't need them here.

GLOBAL_LIST_INIT(admin_visible_traits, list(
	// Nothing here yet. But here is an example of how it is structured later on:

	/*
	/obj = list(
		"TRAIT_CONTRABAND" = TRAIT_CONTRABAND,
		"TRAIT_SPEED_POTIONED" = TRAIT_SPEED_POTIONED,
	),
	/obj/item/bodypart = list(
		"TRAIT_PARALYSIS" = TRAIT_PARALYSIS,
	),
	/obj/item/card/id = list(
		"TRAIT_MAGNETIC_ID_CARD" = TRAIT_MAGNETIC_ID_CARD,
	),
	*/
))

/// value -> trait name, generated as needed for adminning.
GLOBAL_LIST(admin_trait_name_map)

/proc/generate_admin_trait_name_map()
	. = list()
	for(var/key in GLOB.admin_visible_traits)
		for(var/tname in GLOB.admin_visible_traits[key])
			var/val = GLOB.admin_visible_traits[key][tname]
			.[val] = tname

	return .
