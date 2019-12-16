//Languages/species/whitelist.
GLOBAL_LIST_INIT(all_species, list())
GLOBAL_LIST_INIT(all_languages, list())
GLOBAL_LIST_INIT(language_keys, list())						// Table of say codes for all languages
GLOBAL_LIST_INIT(whitelisted_species, list(SPECIES_HUMAN))	// Species that require a whitelist check.
GLOBAL_LIST_INIT(playable_species, list(SPECIES_HUMAN))		// A list of ALL playable species, whitelisted, latejoin or otherwise.
