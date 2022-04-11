//Languages/species/whitelist.
GLOBAL_LIST_EMPTY_TYPED(all_species, /datum/species)
GLOBAL_LIST_EMPTY_TYPED(whitelisted_species, /datum/species)	// Species that require a whitelist check.
GLOBAL_LIST_EMPTY_TYPED(playable_species, /datum/species)		// A list of ALL playable species, whitelisted, latejoin or otherwise.

GLOBAL_LIST_EMPTY_TYPED(all_languages, /datum/language)
GLOBAL_LIST_INIT(language_name_conflicts, list())
GLOBAL_LIST_INIT(language_keys, list())						// Table of say codes for all languages
GLOBAL_LIST_INIT(language_key_conflicts, list())
