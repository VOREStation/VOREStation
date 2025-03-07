/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/**
 * Color channel names; this is used in things like character setup, editors, etc.
 *
 * * The length of this is also used to sanitize color channel list lengths. This should never be longer than the
 *   maximum number of color channels possible across all sprite accessories.
 */
GLOBAL_LIST_INIT(fancy_sprite_accessory_color_channel_names, list("Primary", "Secondary", "Tertiary", "Quaternary"))

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name = "ERROR - FIXME" // the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species. Default to all species to avoid runtimes in character creator.
	var/list/species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJARAN, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN, SPECIES_LLEILL, SPECIES_HANNER, SPECIES_ZADDAT)

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1

	var/color_blend_mode = ICON_MULTIPLY	// If checked.

	// Ckey of person allowed to use this, if defined.
	var/list/ckeys_allowed = null

	/// Should this sprite block emissives?
	var/em_block = FALSE

	var/list/hide_body_parts = list() //Uses organ tag defines. Bodyparts in this list do not have their icons rendered, allowing for more spriter freedom when doing taur/digitigrade stuff.

/**
 * Gets the number of color channels we have.
 */
/datum/sprite_accessory/proc/get_color_channel_count()
	return do_colouration ? 1 : 0
