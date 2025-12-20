// This file contains any stuff related to admin-visible traits.
// There's likely more than a few traits missing from this file, do consult the `_traits.dm` file in this folder to see every global trait that exists.
// quirks have their own panel so we don't need them here.

GLOBAL_LIST_INIT(admin_visible_traits, list(
	/mob = list(
		"TRAIT_NO_GLIDE" = TRAIT_NO_GLIDE,
	),
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
