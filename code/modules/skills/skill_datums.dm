GLOBAL_DATUM_INIT(skill_collection, /datum/category_collection/skill, new)

// This object holds everything together and is GLOB accessible.
/datum/category_collection/skill
	category_group_type = /datum/category_group/skill
	var/list/skills_by_id = list()

// These group skills into categorical groups.
// Note that these groups are not related to the skill_groups list for each skill, which is what is used for skill point discounts.
/datum/category_group/skill

// These are individual skills. They hold skill_level datums.
/datum/category_item/skill
	var/id = null					// A unique identifer for the skill. See code\__defines\skills.dm for definitions.
	var/flavor_desc = null			// General description of what the skill does.
	var/govern_desc = null			// Explaination for what the skill covers.
	var/typical_desc = null			// Descripes who generally has what level for this skill, in-universe.
	var/list/skill_groups = null	// Skills in the same group get a discount based on how heavily invested the character is in the group. This is a list.
	var/list/levels = null			// List of /datum/skill_level objects which are ordered from lowest to highest skilled.
									// The order of each one DOES matter. The first entry is the default selection.

// Instantiates all the paths inside levels list.
/datum/category_item/skill/New()
	..()
	build_skill_levels()
	var/datum/category_collection/skill/collection = category.collection
	collection.skills_by_id[id] = src

/datum/category_item/skill/proc/build_skill_levels()
	var/list/types_to_make = levels.Copy()
	levels.Cut()
	for(var/t in types_to_make)
		var/datum/skill_level/level = new t()
		levels += level

// These are held inside of skills, and denote each level of a skill.
/datum/skill_level
	var/name = null			// Flavor name for this level.
	var/flavor_desc = null	// Flavor description for this level.
	var/mechanics_desc		// Describes what this level will do mechanically (if that's enabled).
	var/cost = 0			// How many skill points this costs to hold. Note that discounts may also apply.
	var/enhancing = FALSE	// If true, is considered an 'enhancing' level. Used to forbid taking more than one, and to forbid the level if disallowed in the config.
