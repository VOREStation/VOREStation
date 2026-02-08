// This file contains all of the "static" define strings that tie to a trait.
// WARNING: The sections here actually matter in this file as it's tested by CI. Please do not toy with the sections."

// BEGIN TRAIT DEFINES

/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

/// Trait given to a mob that is currently thinking (giving off the "thinking" icon), used in an IC context
#define TRAIT_THINKING_IN_CHARACTER "currently_thinking_IC"

/// Climbable trait, given and taken by the climbable element when added or removed. Exists to be easily checked via HAS_TRAIT().
#define TRAIT_CLIMBABLE "trait_climbable"

/// Prevents the affected object from opening a loot window via alt click. See atom/click_alt()
#define TRAIT_ALT_CLICK_BLOCKER "no_alt_click"

/// Unlucky trait. Given by the 'unlucky' trait in character select. Checked by various things to cause unlucky interactions.
#define TRAIT_UNLUCKY "trait_unlucky"

#define TRAIT_INCAPACITATED "incapacitated"

#define TRAIT_NOFIRE "nonflammable"
#define TRAIT_NOFIRE_SPREAD "no_fire_spreading"
/// Mobs that have this trait cannot be extinguished
#define TRAIT_NO_EXTINGUISH "no_extinguish"
/// Tells us that the mob urrently has the fire_handler/wet_stacks status effect
#define TRAIT_IS_WET "is_wet"
/// Mobs with this trait stay wet for longer and resist fire decaying wetness
#define TRAIT_WET_FOR_LONGER "wet_for_longer"
/// Mobs with this trait will be immune to slipping while also being slippery themselves when lying on the floor
#define TRAIT_SLIPPERY_WHEN_WET "slippery_when_wet"
/// Stops the mob from slipping on water, or banana peels, or pretty much anything that doesn't have [GALOSHES_DONT_HELP] set
#define TRAIT_NO_SLIP_WATER "noslip_water"
/// Owner will ignore any fire protection when calculating fire damage
#define TRAIT_IGNORE_FIRE_PROTECTION "ignore_fire_protection"
/// Owner will slam down heavily into the ground upon falling from a height!
#define TRAIT_HEAVY_LANDING "trait_heavy_landing"
/// Owner is immune to ingested toxins. (Any reagent/toxin subtype)
#define INGESTED_TOXIN_IMMUNE "ingested_toxin_immune"
/// If using melee, attacks will use the 'get_sparring_variant' if possible
#define TRAIT_NONLETHAL_BLOWS "trait_nonlethal_blows"
/// Are we immune to specifically tesla?
#define TRAIT_TESLA_SHOCKIMMUNE "tesla_shock_immunity"
/// Do we show up as a changeling / the wrong body-mind pair to sleevmates
#define UNIQUE_MINDSTRUCTURE "unique_mindstructure"
/// Owner is immune to hallucinations
#define TRAIT_MADNESS_IMMUNE "supermatter_madness_immune"
/// Owner will move faster when hands are empty.
#define UNUSUAL_RUNNING "unusual_running"
/// Owner is corrupted via redspace. Used downstream. SHOULD NOT BE USED LIGHTLY. HORROR THEMES.
#define TRAIT_REDSPACE_CORRUPTED "redspace_corrupted"
// allows draining of power cells for nutrition
#define TRAIT_ELECTROVORE "electrovore"
// allows draining or recharging of power cells via nutrition
#define TRAIT_ELECTROVORE_OBLIGATE "electrovore_obligate"
// adds wet stacks when licking someone
#define TRAIT_SLOBBER "slobber"
